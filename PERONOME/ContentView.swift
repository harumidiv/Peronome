//
//  ContentView.swift
//  Peronome
//
//  Created by 佐川 晴海 on 2023/10/24.
//

import SwiftUI

struct ContentView: View {
    let audioPlayer = AudioPlayer(tempo: 60)
    @State private var tempo: Int = 60
    @State private var displayImageName: String = "img1"
    @State private var isPlay: Bool = false

    @State private var timer: Timer?

    var body: some View {
        VStack {
            Image(displayImageName)
                .resizable()
                .scaledToFit()

            HStack {
                Button("add") {
                    tempo += 1
                }
                Text(tempo.description)

                Button("sub") {
                    tempo -= 1
                }
            }

            Button(isPlay ? "ストップ" : "スタート") {
                isPlay.toggle()
            }
        }
        .onChange(of: isPlay) {
            if isPlay {
                self.timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(60/tempo), repeats: true, block: {_ in
                    toggleImage()
                })
            } else {
                timer?.invalidate()
                timer = nil
                displayImageName = "img1"
            }
        }
    }

    private func toggleImage() {
        if displayImageName == "img1" {
            displayImageName = "img2"
        } else {
            displayImageName = "img1"
        }
    }
}

#Preview {
    ContentView()
}
