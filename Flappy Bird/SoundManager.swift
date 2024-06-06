//
//  SoundManager.swift
//  Flappy Bird
//
//  Created by Anoop Jose on 05/06/2024.
//

import AVFoundation

/// Manages all audio functionalities for the application, including sound effects and background music.
class SoundManager {
    static let shared = SoundManager()  // Singleton instance for global access.

    // Private properties for different audio players.
    private var flapSoundPlayer: AVAudioPlayer?
    private var buttonSoundPlayer: AVAudioPlayer?
    private var gameOverSoundPlayer: AVAudioPlayer?
    private var backgroundMusicPlayer: AVAudioPlayer?

    /// Initializes the sound manager by loading all necessary sounds.
    private init() {
        loadSounds()
        loadBackgroundMusic()
    }

    /// Loads sound effects into their respective AVAudioPlayer properties.
    private func loadSounds() {
        loadSoundEffect(&flapSoundPlayer, resource: "crawler_jump", type: "wav")
        loadSoundEffect(&buttonSoundPlayer, resource: "button", type: "wav")
        loadSoundEffect(&gameOverSoundPlayer, resource: "flyerdie", type: "wav")
    }

    /// Helper function to load a sound effect from a file into an AVAudioPlayer.
    /// - Parameters:
    ///   - player: A reference to the AVAudioPlayer to initialize.
    ///   - resource: The name of the resource file.
    ///   - type: The file type (extension).
    private func loadSoundEffect(_ player: inout AVAudioPlayer?, resource: String, type: String) {
        if let url = Bundle.main.url(forResource: resource, withExtension: type) {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.prepareToPlay()
            } catch {
                print("Error loading \(resource) sound: \(error)")
            }
        } else {
            print("\(resource).\(type) file not found.")
        }
    }

    /// Loads and prepares the background music player.
    private func loadBackgroundMusic() {
        if let url = Bundle.main.url(forResource: "bgm", withExtension: "mp3") {
            do {
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
                backgroundMusicPlayer?.numberOfLoops = -1
                backgroundMusicPlayer?.prepareToPlay()
            } catch {
                print("Error loading background music: \(error)")
            }
        } else {
            print("bgm.mp3 file not found.")
        }
    }

    /// Plays the flap sound effect.
    func playFlapSound() {
        flapSoundPlayer?.play()
    }

    /// Plays the button click sound effect.
    func playButtonSound() {
        buttonSoundPlayer?.play()
    }

    /// Plays the game over sound effect.
    func playGameOverSound() {
        gameOverSoundPlayer?.play()
    }

    /// Starts playing the background music if it is not already playing.
    func playBackgroundMusic() {
        if !(backgroundMusicPlayer?.isPlaying ?? true) {
            backgroundMusicPlayer?.play()
        }
    }

    /// Stops the background music.
    func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
    }
}
