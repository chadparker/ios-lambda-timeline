//
//  ContentView.swift
//  AudioComments
//
//  Created by Chad Parker on 2020-07-12.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import SwiftUI

// MARK: - Audio Comments View

struct ContentView: View {
    @EnvironmentObject var dataSource: AudioDataSource
    @State var showRecordingModal = false
    @State var showPlayer = true
    @State var currentAudioComment = AudioComment(title: "")
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Button(action: {
                        self.showRecordingModal = true
                    }, label: {
                        Text("New")
                            .foregroundColor(.white)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    })
                        .padding(.top)
                    List {
                        ForEach(dataSource.audioComments) { audioComment in
                            Button(action: {
                                self.showPlayer = true
                                self.currentAudioComment = audioComment
                            }) {
                                Text(audioComment.title)
                            }
                        }
                        HStack {
                            Spacer()
                            Text("\(dataSource.audioComments.count) audio comments")
                                .font(.callout)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                    }
                }
                if showPlayer {
                    PlayerView(audioComment: $currentAudioComment)
                }
                if showRecordingModal {
                    ZStack {
                        Color.black.opacity(0.6)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                self.showRecordingModal = false
                        }
                        NewRecordingView()
                    }
                }
            }
            .navigationBarTitle("Audio Comments")
        }
    }
}


// MARK: - Player View

struct PlayerView: View {
    @Binding var audioComment: AudioComment
    @EnvironmentObject var audioPlayer: AudioPlayer

    var body: some View {
        VStack {
            Spacer()
            VStack {
                Text(audioComment.title)
                    .foregroundColor(Color(.secondarySystemBackground))
                    .padding(.top, 30)
                HStack {
                    Spacer()
                    Button(action: {
                        self.audioPlayer.togglePlayback()
                    }) {
                        Image(systemName: self.audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                            .font(.headline)
                            .foregroundColor(Color(.systemBlue))
                            .padding()
                    }
                    Spacer()
                }
                .padding(.top)
            }
            .background(
                Rectangle()
                    .foregroundColor(Color(.label))
                    .edgesIgnoringSafeArea(.bottom)
            )
        }
    }
}


// MARK: - Recording View

struct NewRecordingView: View {
    @EnvironmentObject var dataSource: AudioDataSource
    @State var recording: Bool = false

    var body: some View {
        VStack {
            Button(action: {
                self.recording.toggle()
                if self.recording {
                    
                } else {
                    self.dataSource.createNewRecording()
                }
            }) {
                VStack {
                    if recording {
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 150, height: 150)
                            .padding()
                        Text("Stop")
                    } else {
                        Circle()
                            .frame(width: 150, height: 150)
                            .padding()
                        Text("Record")
                    }
                }
                .foregroundColor(recording ? Color(.gray) : Color(.systemRed))
                .padding()
            }
            HStack {
                Text("Recording...")
                    .opacity(recording ? 1 : 0)
                    .padding()
                Text("0:00")
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundColor(Color(.systemBackground))
                .frame(width: 300, height: 300)
        )
    }
}


// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AudioDataSource(withSampleData: true))
            .environmentObject(AudioPlayer())
    }
}


