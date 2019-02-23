//
//  AudioPlayer.swift
//  Casino
//
//  Created by Admin on 1/16/19.
//  Copyright © 2019 ACA. All rights reserved.
//

import Foundation
import AVFoundation

class AudioPlayer {
    static let sharedInstance = AudioPlayer()
    private var mainMusicPlayer: AVAudioPlayer!
    private var winnerMusicPlayer: AVAudioPlayer!
    private var coinSoundPlayer: AVAudioPlayer!
    private var rollSoundPlayer: AVAudioPlayer!
    
     func mainMusicPlay() {
        let sound = URL(fileURLWithPath: Bundle.main.path(forResource: "ambience_casino", ofType: "mp3")!)
        do {
            mainMusicPlayer = try AVAudioPlayer(contentsOf: sound)
            mainMusicPlayer.numberOfLoops = -1
            mainMusicPlayer.volume = 0.3
            mainMusicPlayer.prepareToPlay()
            mainMusicPlayer.play()
        } catch {
            print("Cannot play the file")
        }
    }
    
    func  mainMusicStop() {
        mainMusicPlayer.stop()
    }
    
    func winnewSoundPlay() {
            let sound = URL(fileURLWithPath: Bundle.main.path(forResource: "winning-sound", ofType: "mp3")!)
            do {
                winnerMusicPlayer = try AVAudioPlayer(contentsOf: sound)
                winnerMusicPlayer.prepareToPlay()
                winnerMusicPlayer.play()
            } catch {
                print("Cannot play the file")
            }
        
    }
    
    func coinSoundPlay() {
            let sound = URL(fileURLWithPath: Bundle.main.path(forResource: "insert-coin", ofType: "mp3")!)
            do {
                coinSoundPlayer = try AVAudioPlayer(contentsOf: sound)
                coinSoundPlayer.prepareToPlay()
                coinSoundPlayer.play()
            } catch {
                print("Cannot play the file")
            }
        }
    
    
    func rollSoundPlay() {
            let sound = URL(fileURLWithPath: Bundle.main.path(forResource: "roll", ofType: "mp3")!)
            do {
                rollSoundPlayer = try AVAudioPlayer(contentsOf: sound)
                rollSoundPlayer.numberOfLoops = 1
                rollSoundPlayer.prepareToPlay()
                rollSoundPlayer.play()
            } catch {
                print("Cannot play the file")
            }
        }
    
    
    func rollSoundStop() {
        rollSoundPlayer.stop()
    }

}
