//
//  AudioPlayer.swift
//  AudioComments
//
//  Created by Chad Parker on 2020-07-14.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import Foundation
import AVFoundation
import Combine

class AudioPlayer: NSObject, ObservableObject {
    
    // MARK: - Properties
    
    @Published var isPlaying = false
    @Published var elapsedTimeString = ""
    @Published var remainingTimeString = ""
    
    var audioPlayer: AVAudioPlayer? {
        didSet {
            guard let audioPlayer = audioPlayer else { return }
            
            audioPlayer.delegate = self
            updateProperties()
        }
    }
    
    private lazy var timeIntervalFormatter: DateComponentsFormatter = {
        // NOTE: DateComponentFormatter is good for minutes/hours/seconds
        // DateComponentsFormatter is not good for milliseconds, use DateFormatter instead)
        
        let formatting = DateComponentsFormatter()
        formatting.unitsStyle = .positional // 00:00  mm:ss
        formatting.zeroFormattingBehavior = .pad
        formatting.allowedUnits = [.minute, .second]
        return formatting
    }()
    
    private func updateProperties() {
        isPlaying = audioPlayer?.isPlaying ?? false
        
        let elapsedTime = audioPlayer?.currentTime ?? 0
        let duration = audioPlayer?.duration ?? 0
        let timeRemaining = duration.rounded() - elapsedTime
        
        elapsedTimeString = timeIntervalFormatter.string(from: elapsedTime)!
        
        //timeSlider.minimumValue = 0
        //timeSlider.maximumValue = Float(duration)
        //timeSlider.value = Float(elapsedTime)
        
        remainingTimeString = "-" + timeIntervalFormatter.string(from: timeRemaining)!
    }

    
    // MARK: - View Lifecycle
    
    override init() {
        super.init()
        
        loadAudio()
    }
    
    deinit {
        //timer?.invalidate()
    }
    
    
    // MARK: - Playback
    
    private func loadAudio() {
        let songURL = Bundle.main.url(forResource: "piano", withExtension: "mp3")!
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: songURL)
        } catch {
            preconditionFailure("Failure to load audio file: \(error)")
        }
    }
    
    private func prepareAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, options: [.defaultToSpeaker])
        try session.setActive(true, options: []) // can fail if on a phone call, for instance
    }
    
    func play() {
        do {
            try prepareAudioSession()
            audioPlayer?.play()
            updateProperties()
            //startTimer()
        } catch {
            print("Cannot play audio: \(error)")
        }
    }
    
    func pause() {
        audioPlayer?.pause()
        updateProperties()
        //cancelTimer()
    }

    func togglePlayback() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
}


// MARK: - Delegates

extension AudioPlayer: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        updateProperties()
        //cancelTimer()
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print("Audio Player Error: \(error)")
        }
    }
}
