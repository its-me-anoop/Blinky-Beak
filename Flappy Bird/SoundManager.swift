//
//  SoundManager.swift
//  Flappy Bird
//
//  Created by Anoop Jose on 05/06/2024.
//

import AVFoundation

class SoundManager {
    static let shared = SoundManager()

    private var flapSoundPlayer: AVAudioPlayer?
    private var buttonSoundPlayer: AVAudioPlayer?
    private var gameOverSoundPlayer: AVAudioPlayer?
    private var backgroundMusicPlayer: AVAudioPlayer?

    private init() {
        loadSounds()
        loadBackgroundMusic()
    }

    private func loadSounds() {
        // Load sound files
        if let flapSoundURL = Bundle.main.url(forResource: "crawler_jump", withExtension: "wav") {
            flapSoundPlayer = try? AVAudioPlayer(contentsOf: flapSoundURL)
            flapSoundPlayer?.prepareToPlay()
        }
        
        if let buttonSoundURL = Bundle.main.url(forResource: "button", withExtension: "wav") {
            buttonSoundPlayer = try? AVAudioPlayer(contentsOf: buttonSoundURL)
            buttonSoundPlayer?.prepareToPlay()
        }

        if let gameOverSoundURL = Bundle.main.url(forResource: "flyerdie", withExtension: "wav") {
            gameOverSoundPlayer = try? AVAudioPlayer(contentsOf: gameOverSoundURL)
            gameOverSoundPlayer?.prepareToPlay()
        }
    }
    
    private func loadBackgroundMusic() {
            // Load background music file
            if let backgroundMusicURL = Bundle.main.url(forResource: "bgm", withExtension: "mp3") {
                backgroundMusicPlayer = try? AVAudioPlayer(contentsOf: backgroundMusicURL)
                backgroundMusicPlayer?.numberOfLoops = -1 // Loop indefinitely
                backgroundMusicPlayer?.prepareToPlay()
            }
    }

        

    func playFlapSound() {
        flapSoundPlayer?.play()
    }

    func playButtonSound() {
        buttonSoundPlayer?.play()
    }

    func playGameOverSound() {
        gameOverSoundPlayer?.play()
    }
    
    func playBackgroundMusic() {
        backgroundMusicPlayer?.play()
    }

    func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
    }
}

