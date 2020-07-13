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
    @State var showingNewModal: Bool = false
    
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
                            NavigationLink(destination: RecordingView(title: audioComment.title)) {
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
                        VStack {
                            Text("hey")
                                .padding().padding().padding()
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .foregroundColor(.yellow)
                        )
                    }
                }
            }
            .navigationBarTitle("Audio Comments")
        }
    }
}

struct RecordingView: View {
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
