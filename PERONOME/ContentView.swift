//
//  ContentView.swift
//  Peronome
//
//  Created by 佐川 晴海 on 2023/10/24.
//

import SwiftUI

struct ContentView: View {
    @State private var metronome = Metronome()
    @State private var isShowingSettings = false

    private var displayImageName: String {
        metronome.tickCount % 2 == 1 ? "img2" : "img1"
    }

    var body: some View {
        ZStack {
            Image(displayImageName)
                .resizable()
                .scaledToFill()

            VStack() {
                HStack {
                    Spacer()

                    Button(action: {
                        metronome.decrement()
                    }, label: {
                        Image("subButton")
                            .resizable()
                            .frame(width: 50, height: 50)
                    })

                    VStack(spacing: 0) {
                        Text(Int(metronome.tempo).description)
                            .font(.largeTitle)
                            .monospacedDigit()
                        Text(metronome.tempoMarking)
                            .font(.caption)
                    }
                    .frame(width: 100)

                    Button(action: {
                        metronome.increment()
                    }, label: {
                        Image("addButton")
                            .resizable()
                            .frame(width: 50, height: 50)
                    })

                    Button(action: {
                        isShowingSettings = true
                    }, label: {
                        Image(systemName: "gearshape.fill")
                            .font(.title)
                            .frame(width: 50, height: 50)
                    })
                }

                Slider(value: $metronome.tempo, in: Metronome.tempoRange, step: 1)
                    .padding(.horizontal)

                BeatIndicator(
                    beatsPerMeasure: metronome.beatsPerMeasure,
                    currentBeat: metronome.currentBeat,
                    isAccentEnabled: metronome.isAccentEnabled
                )
                .padding(.top, 8)

                Spacer()

                HStack(alignment: .bottom) {
                    Button(action: {
                        metronome.toggle()
                    }, label: {
                        Image(metronome.isPlaying ? "stop" : "start")
                            .resizable()
                            .frame(width: 150, height: 150)
                    })

                    Spacer()

                    VStack(spacing: 12) {
                        if let startDate = metronome.startDate {
                            ElapsedTimeView(startDate: startDate)
                        }

                        Button(action: {
                            metronome.tap()
                        }, label: {
                            Text("TAP")
                                .font(.title2.bold())
                                .frame(width: 100, height: 100)
                                .background(.ultraThinMaterial, in: Circle())
                        })
                    }
                }
            }
            .padding()
            .frame(width: UIScreen.main.bounds.width)
        }
        .sheet(isPresented: $isShowingSettings) {
            SettingsView(metronome: metronome)
                .presentationDetents([.medium])
        }
    }
}

private struct BeatIndicator: View {
    let beatsPerMeasure: Int
    let currentBeat: Int?
    let isAccentEnabled: Bool

    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<beatsPerMeasure, id: \.self) { beat in
                Circle()
                    .fill(color(for: beat))
                    .frame(width: 20, height: 20)
                    .scaleEffect(beat == currentBeat ? 1.3 : 1.0)
                    .animation(.easeOut(duration: 0.08), value: currentBeat)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(.ultraThinMaterial, in: Capsule())
    }

    private func color(for beat: Int) -> Color {
        guard beat == currentBeat else { return .gray.opacity(0.4) }
        return isAccentEnabled && beat == 0 && beatsPerMeasure > 1 ? .red : .orange
    }
}

private struct ElapsedTimeView: View {
    let startDate: Date

    var body: some View {
        TimelineView(.periodic(from: startDate, by: 1)) { context in
            let seconds = max(0, Int(context.date.timeIntervalSince(startDate)))
            Text(String(format: "%02d:%02d", seconds / 60, seconds % 60))
                .font(.title3.monospacedDigit())
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(.ultraThinMaterial, in: Capsule())
        }
    }
}

#Preview {
    ContentView()
}
