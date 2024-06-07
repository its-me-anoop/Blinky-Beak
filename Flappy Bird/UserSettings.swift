//
//  UserSettings.swift
//  Flappy Bird
//
//  Created by Anoop Jose on 06/06/2024.
//

import Foundation

class UserSettings: ObservableObject {
    static let shared = UserSettings()
    
    @Published var hapticsEnabled: Bool {
        didSet {
            UserDefaults.standard.set(hapticsEnabled, forKey: "hapticsEnabled")
        }
    }

    @Published var soundEffectsEnabled: Bool {
        didSet {
            UserDefaults.standard.set(soundEffectsEnabled, forKey: "soundEffectsEnabled")
            SoundManager.shared.updateSoundEffectsSettings() // Ensure sound settings are applied immediately
        }
    }
    
    @Published var musicEnabled: Bool {
        didSet {
            UserDefaults.standard.set(musicEnabled, forKey: "musicEnabled")
            SoundManager.shared.updateMusicSettings() // Ensure sound settings are applied immediately
        }
    }
    @Published var gameDifficulty: String = UserDefaults.standard.string(forKey: "gameDifficulty") ?? "Easy" {
        didSet {
            UserDefaults.standard.set(gameDifficulty, forKey: "gameDifficulty")
            notifyDifficultyChange()  // Ensure this method sends a notification.
        }
    }
    
    @Published var gameTheme: String {
            didSet {
                UserDefaults.standard.set(gameTheme, forKey: "gameTheme")
                NotificationCenter.default.post(name: Notification.Name("GameThemeChanged"), object: nil)
            }
        }
    

    init() {
        // Load the soundEnabled state from UserDefaults, default to true if not set
        self.soundEffectsEnabled = UserDefaults.standard.object(forKey: "soundEffectsEnabled") as? Bool ?? true
        
        self.musicEnabled = UserDefaults.standard.object(forKey: "musicEnabled") as? Bool ?? true
        
        self.hapticsEnabled = UserDefaults.standard.object(forKey: "hapticsEnabled") as? Bool ?? true
        
        gameTheme = UserDefaults.standard.string(forKey: "gameTheme") ?? "Earth" // Default theme
        
    }
}

extension UserSettings {
    func notifyDifficultyChange() {
        NotificationCenter.default.post(name: NSNotification.Name("GameDifficultyChanged"), object: nil)
    }
}

