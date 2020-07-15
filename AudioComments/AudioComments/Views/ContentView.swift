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
    @State var showRecordingModal = true
    @State var showPlayer = false
    @State var currentAudioComment = AudioComment.empty
    
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
                        NewRecordingView(showing: $showRecordingModal)
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
                    Text(audioPlayer.elapsedTimeString)
                        .font(.callout)
                        .padding()
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
                    Text(audioPlayer.remainingTimeString)
                    .font(.callout)
                    .padding()
                }
                .foregroundColor(Color(.systemGray))
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

    @Binding var showing: Bool
    @EnvironmentObject var dataSource: AudioDataSource
    @EnvironmentObject var audioRecorder: AudioRecorder

    var body: some View {
        VStack {
            Button(action: {
                self.audioRecorder.toggleRecording()
                if self.audioRecorder.isRecording {
                    // let it record
                } else {
                    self.dataSource.newRecording(at: self.audioRecorder.recordingURL)
                    self.showing = false
                }
            }) {
                VStack {
                    if audioRecorder.isRecording {
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 110, height: 110)
                            .padding(.top)
                            .padding(20)
                        Text("Stop")
                    } else {
                        Circle()
                            .frame(width: 150, height: 150)
                            .padding(.top)
                        Text("Record")
                    }
                }
                .foregroundColor(audioRecorder.isRecording ? Color(.label) : Color(.systemRed))
            }
            .padding(.all, 40)
            HStack {
                Text("Recording...")
                    .padding()
                Spacer()
                Text(audioRecorder.elapsedTimeString)
                    .padding()
            }
            .opacity(audioRecorder.isRecording ? 1 : 0)
            .frame(width: 250)
        }
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundColor(Color(.systemBackground))
                .frame(width: 300, height: 400)
        )
    }
}


// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
            .environmentObject(AudioDataSource(withSampleData: true))
            .environmentObject(AudioPlayer())
            .environmentObject(AudioRecorder())
    }
}


