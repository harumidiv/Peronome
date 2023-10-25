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
                        withAnimation {
                            isPlay.toggle()
                        }
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
        .onChange(of: isPlay) {
            if isPlay {
                audioPlayer = AudioPlayer()
                audioPlayer?.loadAudio()
                let timeInterval = 60.0 / tempo
                print("interval: \(timeInterval)")
                self.timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: {_ in
                    print("😄")
                    audioPlayer?.playAudio()
                    toggleImage()
                })


            } else {
                audioPlayer?.stopAudio()
                audioPlayer = nil

                timer?.invalidate()
                timer = nil

                displayImageName = "img1"
            }
        }
    }

    private func toggleImage() {
        print("call!")
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
