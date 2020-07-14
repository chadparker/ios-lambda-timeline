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
            audioComments.append(contentsOf: [
                AudioComment(title: "one"),
                AudioComment(title: "two"),
            ])
        }
    }

    func createNewRecording() {
        
    }
}
