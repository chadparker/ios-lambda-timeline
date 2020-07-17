//
//  AudioComment.swift
//  AudioComments
//
//  Created by Chad Parker on 2020-07-12.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import Foundation

struct AudioComment: Identifiable {
    
    let id = UUID()
    let title: String
    var url: URL = Bundle.main.url(forResource: "piano", withExtension: "mp3")!

    static var empty: AudioComment {
        .init(title: "")
    }
}
