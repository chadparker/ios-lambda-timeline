//
//  ContentView.swift
//  AudioComments
//
//  Created by Chad Parker on 2020-07-12.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var dataSource: AudioDataSource
    @State var showingNewModal: Bool = true
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Button(action: {
                        self.showingNewModal = true
                    }, label: {
                        Text("New")
                            .foregroundColor(.white)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    })
                    List {
                        ForEach(dataSource.audioComments) { audioComment in
                            NavigationLink(destination: ExistingRecordingView(title: audioComment.title)) {
                                Text(audioComment.title)
                            }
                        }
                        HStack {
                            Spacer()
                            Text("\(dataSource.audioComments.count) audio comments")
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                    }
                }
                if showingNewModal {
                    ZStack {
                        Color.black.opacity(0.6)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                self.showingNewModal = false
                        }
                        NewRecordingView()
                    }
                }
            }
            .navigationBarTitle("Audio Comments")
        }
    }
}

struct NewRecordingView: View {
    @State var recording: Bool = false

    var body: some View {
        VStack {
            Button(action: {
                self.recording.toggle()
                if self.recording {

                } else {

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

struct ExistingRecordingView: View {
    var title: String

    var body: some View {
        Text(title)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            dataSource:
            AudioDataSource(withSampleData: true)
        )
    }
}


