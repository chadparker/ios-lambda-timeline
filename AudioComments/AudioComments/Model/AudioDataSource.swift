//
//  AudioDataSource.swift
//  AudioComments
//
//  Created by Chad Parker on 2020-07-12.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import Foundation

class AudioDataSource: ObservableObject {
    
    @Published var audioComments = [AudioComment]()
    
    convenience init(withSampleData: Bool) {
        self.init()
        
        if withSampleData {
            audioComments = [
                AudioComment(title: "one"),
                AudioComment(title: "two"),
            ]
        }
    }

    func newRecording(at url: URL?) {
        guard let url = url else { return }

        let title = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: .withInternetDateTime)
        let newAudioComment = AudioComment(title: title, url: url)
        audioComments.insert(newAudioComment, at: 0)
    }
}
