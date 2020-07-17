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
    @EnvironmentObject var audioPlayer: AudioPlayer
    @State var showRecordingModal = false
    @State var showPlayer = false
    @State var showRename = false
    
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
                                self.dataSource.currentAudioComment = audioComment
                                self.audioPlayer.loadAudio(url: audioComment.url)
                                self.audioPlayer.play()
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
                    PlayerView(showRename: $showRename)
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
                if showRename {
                    ZStack {
                        Color.black.opacity(0.6)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                self.showRename = false
                        }
                        RenameView()
                    }
                }
            }
            .navigationBarTitle("Audio Comments")
        }
    }
}


// MARK: - Player View

struct PlayerView: View {

    @Binding var showRename: Bool
    @EnvironmentObject var dataSource: AudioDataSource
    @EnvironmentObject var audioPlayer: AudioPlayer

    var body: some View {
        VStack {
            Spacer()
            VStack {
                Button(action: {
                    self.showRename = true
                }) {
                    Text(dataSource.currentAudioComment.title)
                    .foregroundColor(Color(.secondarySystemBackground))
                    .padding(.top, 30)
                }

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


// MARK: - Rename View

struct RenameView: View {

    @EnvironmentObject var dataSource: AudioDataSource

    var body: some View {
        VStack {
            Spacer()
                .frame(height: 150)
            VStack {
                Text("Rename:")
                TextField("New recording name", text: $dataSource.currentAudioComment.title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onAppear {
                        UITextField.appearance().clearButtonMode = .whileEditing
                }
            }
            .frame(width: 250)
            .background(
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .foregroundColor(Color(.systemBackground))
                    .frame(width: 300, height: 200)
            )
            Spacer()
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
                    // TODO: rename to createNew(with: )
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


