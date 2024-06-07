import AVFoundation

/// Manages all audio functionalities for the application, including sound effects and background music.
class SoundManager {
    static let shared = SoundManager()  // Singleton instance for global access.

    // Private properties for different audio players.
    private var flapSoundPlayer: AVAudioPlayer?
    private var buttonSoundPlayer: AVAudioPlayer?
    private var gameOverSoundPlayer: AVAudioPlayer?
    private var collisionSoundPlayer: AVAudioPlayer?
    private var backgroundMusicPlayer: AVAudioPlayer?

    private var soundEffectsEnabled: Bool {
        UserDefaults.standard.bool(forKey: "soundEffectsEnabled")
    }
    
    private var musicEnabled: Bool {
        UserDefaults.standard.bool(forKey: "musicEnabled")
    }

    /// Initializes the sound manager by loading all necessary sounds.
    private init() {
        loadSounds()
        loadBackgroundMusic()
        UserDefaults.standard.register(defaults: ["soundEffectsEnabled": true])
        UserDefaults.standard.register(defaults: ["musicEnabled": true])// Ensures default setting is true.
    }

    /// Loads sound effects into their respective AVAudioPlayer properties.
    private func loadSounds() {
        loadSoundEffect(&flapSoundPlayer, resource: "crawler_jump", type: "wav")
        loadSoundEffect(&buttonSoundPlayer, resource: "button", type: "wav")
        loadSoundEffect(&gameOverSoundPlayer, resource: "flyerdie", type: "wav")
        loadSoundEffect(&collisionSoundPlayer, resource: "bounce", type: "wav")
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
    
    func updateSoundEffectsSettings() {
            if soundEffectsEnabled {
                // Allow sounds to play
                prepareAllSounds()
            } else {
                // Stop and reset all sounds
                stopAllSounds()
            }
        }
    
    private func prepareAllSounds() {
            [flapSoundPlayer, buttonSoundPlayer, gameOverSoundPlayer, collisionSoundPlayer, backgroundMusicPlayer].forEach { player in
                player?.prepareToPlay()
            }
        }

        private func stopAllSounds() {
            [flapSoundPlayer, buttonSoundPlayer, gameOverSoundPlayer, collisionSoundPlayer, backgroundMusicPlayer].forEach { player in
                player?.stop()
                player?.currentTime = 0
            }
        }
    
    func updateMusicSettings() {
            if musicEnabled {
                // Allow sounds to play
                prepareMusic()
            } else {
                // Stop and reset all sounds
                stopMusic()
            }
        }
    
    private func prepareMusic() {
            [backgroundMusicPlayer].forEach { player in
                player?.prepareToPlay()
            }
        }

        private func stopMusic() {
            [backgroundMusicPlayer].forEach { player in
                player?.stop()
                player?.currentTime = 0
            }
        }

    /// Plays the flap sound effect.
    func playFlapSound() {
        playSoundEffects(player: flapSoundPlayer)
    }

    /// Plays the button click sound effect.
    func playButtonSound() {
        playSoundEffects(player: buttonSoundPlayer)
    }

    /// Plays the game over sound effect.
    func playGameOverSound() {
        playSoundEffects(player: gameOverSoundPlayer)
    }

    /// Plays the collision sound effect.
    func playCollisionSound() {
        playSoundEffects(player: collisionSoundPlayer)
    }

    /// Starts playing the background music if it is not already playing.
    func playBackgroundMusic() {
        if musicEnabled && !(backgroundMusicPlayer?.isPlaying ?? true) {
            backgroundMusicPlayer?.play()
        }
    }

    /// Stops the background music.
    func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
    }

    /// Plays a given sound if the sound setting is enabled.
    private func playSoundEffects(player: AVAudioPlayer?) {
        if soundEffectsEnabled {
            player?.play()
        }
    }
}
