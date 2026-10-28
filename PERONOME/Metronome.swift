//
//  Metronome.swift
//  Peronome
//

import Foundation
import Observation
import UIKit

@MainActor
@Observable
final class Metronome {
    static let tempoRange: ClosedRange<Double> = 40...240
    static let beatsRange: ClosedRange<Int> = 1...12

    var tempo: Double {
        didSet {
            defaults.set(tempo, forKey: Keys.tempo)
            if isPlaying, oldValue != tempo { reschedule() }
        }
    }
    var beatsPerMeasure: Int {
        didSet {
            defaults.set(beatsPerMeasure, forKey: Keys.beats)
            if let currentBeat, currentBeat >= beatsPerMeasure { self.currentBeat = nil }
        }
    }
    var isAccentEnabled: Bool {
        didSet { defaults.set(isAccentEnabled, forKey: Keys.accent) }
    }
    var volume: Double {
        didSet { defaults.set(volume, forKey: Keys.volume) }
    }
    var isHapticsEnabled: Bool {
        didSet { defaults.set(isHapticsEnabled, forKey: Keys.haptics) }
    }

    private(set) var isPlaying = false
    /// 再生中の拍（0始まり）。停止中は nil
    private(set) var currentBeat: Int?
    private(set) var tickCount = 0
    private(set) var startDate: Date?

    private let defaults = UserDefaults.standard
    private let audioPlayer = AudioPlayer()
    private let accentHaptic = UIImpactFeedbackGenerator(style: .heavy)
    private let beatHaptic = UIImpactFeedbackGenerator(style: .light)
    private var timer: DispatchSourceTimer?
    private var lastTickTime: DispatchTime?
    private var tapTimes: [Date] = []

    private enum Keys {
        static let tempo = "tempo"
        static let beats = "beatsPerMeasure"
        static let accent = "isAccentEnabled"
        static let volume = "volume"
        static let haptics = "isHapticsEnabled"
    }

    init() {
        defaults.register(defaults: [
            Keys.tempo: 120.0,
            Keys.beats: 4,
            Keys.accent: true,
            Keys.volume: 1.0,
            Keys.haptics: false,
        ])
        tempo = defaults.double(forKey: Keys.tempo)
        beatsPerMeasure = defaults.integer(forKey: Keys.beats)
        isAccentEnabled = defaults.bool(forKey: Keys.accent)
        volume = defaults.double(forKey: Keys.volume)
        isHapticsEnabled = defaults.bool(forKey: Keys.haptics)
    }

    var tempoMarking: String {
        switch tempo {
        case ..<60: "Largo"
        case ..<66: "Larghetto"
        case ..<76: "Adagio"
        case ..<108: "Andante"
        case ..<120: "Moderato"
        case ..<168: "Allegro"
        case ..<200: "Presto"
        default: "Prestissimo"
        }
    }

    private var interval: Double { 60.0 / tempo }

    func toggle() {
        isPlaying ? stop() : start()
    }

    func start() {
        guard !isPlaying else { return }
        audioPlayer.loadAudio()
        accentHaptic.prepare()
        beatHaptic.prepare()
        isPlaying = true
        startDate = Date()
        tickCount = 0
        currentBeat = nil
        UIApplication.shared.isIdleTimerDisabled = true
        schedule(firstFireAt: .now())
    }

    func stop() {
        guard isPlaying else { return }
        timer?.cancel()
        timer = nil
        lastTickTime = nil
        audioPlayer.stopAudio()
        isPlaying = false
        currentBeat = nil
        startDate = nil
        UIApplication.shared.isIdleTimerDisabled = false
    }

    func increment() { setTempo(tempo + 1) }
    func decrement() { setTempo(tempo - 1) }

    private func setTempo(_ value: Double) {
        tempo = min(max(value.rounded(), Self.tempoRange.lowerBound), Self.tempoRange.upperBound)
    }

    /// タップの間隔からテンポを算出する（直近4回の平均）
    func tap() {
        let now = Date()
        if let last = tapTimes.last, now.timeIntervalSince(last) > 2 {
            tapTimes.removeAll()
        }
        tapTimes.append(now)
        tapTimes = Array(tapTimes.suffix(5))
        guard tapTimes.count >= 2, let first = tapTimes.first else { return }
        let average = now.timeIntervalSince(first) / Double(tapTimes.count - 1)
        setTempo(60.0 / average)
    }

    private func schedule(firstFireAt deadline: DispatchTime) {
        timer?.cancel()
        let timer = DispatchSource.makeTimerSource(queue: .main)
        timer.schedule(deadline: deadline, repeating: interval, leeway: .milliseconds(1))
        timer.setEventHandler { [weak self] in
            MainActor.assumeIsolated { self?.tick() }
        }
        timer.resume()
        self.timer = timer
    }

    /// 再生を止めずに新しいテンポへ切り替える
    private func reschedule() {
        let base = lastTickTime ?? .now()
        let next = max(base + interval, .now())
        schedule(firstFireAt: next)
    }

    private func tick() {
        lastTickTime = .now()
        let beat = ((currentBeat ?? -1) + 1) % beatsPerMeasure
        currentBeat = beat
        tickCount += 1

        let isAccent = isAccentEnabled && beat == 0 && beatsPerMeasure > 1
        audioPlayer.playAudio(volume: Float(isAccent ? volume : volume * 0.45))

        if isHapticsEnabled {
            isAccent ? accentHaptic.impactOccurred() : beatHaptic.impactOccurred()
        }
    }
}
