//
//  ContentView.swift
//  Peronome
//
//  Created by 佐川 晴海 on 2023/10/24.
//

import SwiftUI

struct ContentView: View {
    @State private var audioPlayer: AudioPlayer?
    @State private var tempo: Double = 120
    @State private var displayImageName: String = "img1"
    @State private var isPlay: Bool = false

    @State private var timer: Timer?

    var body: some View {
        ZStack {
            Image(displayImageName)
                .resizable()
                .scaledToFill()

            VStack() {
                HStack {
                    Slider(value: $tempo, in: 40...240)
                        .padding(.horizontal)

                    Button(action: {
                        if tempo > 40 {
                            tempo -= 1
                        }
                    }, label: {
                        Image("sub")
                            .resizable()
                            .frame(width: 50, height: 50)
                    })

                    Text(Int(tempo).description)
                        .font(.largeTitle)
                        .frame(width: 80)

                    Button(action: {
                        if tempo < 240 {
                            tempo += 1
                        }
                    }, label: {
                        Image("add")
                            .resizable()
                            .frame(width: 50, height: 50)
                    })
                }
                Spacer()

                HStack {
                    Button(action: {
                        isPlay.toggle()
                    }, label: {
                        Image(isPlay ? "stop" : "start")
                            .resizable()
                            .frame(width: 150, height: 150)
                    })

                    Spacer()
                }
            }
            .padding()
            .frame(width: UIScreen.main.bounds.width)
        }
        .onChange(of: tempo) {
            stop()
        }
        .onChange(of: isPlay) {
            isPlay ? start() : stop()
        }
    }

    private func start() {
        audioPlayer = AudioPlayer()
        audioPlayer?.loadAudio()
        self.timer = Timer.scheduledTimer(withTimeInterval: 60.0 / tempo, repeats: true, block: {_ in
            audioPlayer?.playAudio()
            toggleImage()
        })
    }

    private func stop() {
        isPlay = false
        audioPlayer?.stopAudio()
        audioPlayer = nil

        timer?.invalidate()
        timer = nil

        displayImageName = "img1"
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
