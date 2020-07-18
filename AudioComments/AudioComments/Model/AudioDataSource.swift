//
//  AudioDataSource.swift
//  AudioComments
//
//  Created by Chad Parker on 2020-07-12.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import Foundation

class AudioDataSource: ObservableObject {
    
    @Published private(set) var audioComments = [AudioComment]()
    @Published var currentAudioComment = AudioComment.empty {
        didSet {
            // renaming
            if oldValue.id == currentAudioComment.id {
                guard let index = audioComments.firstIndex(where: { $0.id == currentAudioComment.id }) else { return }
                audioComments[index] = currentAudioComment
            }
        }
    }
    
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
    
    func delete(at offsets: IndexSet) {
        audioComments.remove(atOffsets: offsets)
        // TODO: delete audio file as well
    }
}
