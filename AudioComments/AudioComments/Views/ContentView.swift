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
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Button(action: {

                    }, label: {
                        Text("New")
                            .foregroundColor(.white)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    })
                    List {
                        ForEach(dataSource.audioComments) { audioComment in
                            Text(audioComment.title)
                        }
                    }
                }
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .foregroundColor(.yellow)
                    .frame(width: 300, height: 320, alignment: .center)
                    .overlay(VStack {
                        Text("hey")
                    })
            }
            .navigationBarTitle("Audio Comments")
        }
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
