//
//  SettingsView.swift
//  Peronome
//

import SwiftUI

struct SettingsView: View {
    @Bindable var metronome: Metronome
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("リズム") {
                    Stepper(value: $metronome.beatsPerMeasure, in: Metronome.beatsRange) {
                        Text("拍子: \(metronome.beatsPerMeasure)拍")
                    }
                    Toggle("1拍目にアクセント", isOn: $metronome.isAccentEnabled)
                }

                Section("サウンド") {
                    HStack {
                        Image(systemName: "speaker.fill")
                        Slider(value: $metronome.volume, in: 0...1)
                        Image(systemName: "speaker.wave.3.fill")
                    }
                    Toggle("振動で拍を知らせる", isOn: $metronome.isHapticsEnabled)
                }
            }
            .navigationTitle("設定")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完了") { dismiss() }
                }
            }
        }
    }
}
