//
//  SettingsView.swift
//  Flappy Bird
//
//  Created by Anoop Jose on 06/06/2024.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings = UserSettings.shared
    var body: some View {
        VStack {
            Text("Settings")
                .font(Font.custom("Super Boys", size: 40.0))
                .foregroundColor(.white)
                .fontWeight(.bold)
                .padding()
            Form {
                Section(header: Text("Theme")) {
                                    Picker("Game Theme", selection: $settings.gameTheme) {
                                        Text("Earth").tag("Earth")
                                            .foregroundColor(.black)
                                        Text("Outer Space").tag("OuterSpace")
                                            .foregroundColor(.black)
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                                }
                .listItemTint(.orange)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .font(Font.custom("December Show", size: 20.0))
                .listRowBackground(LinearGradient(colors: [
                    .orange, .yellow], startPoint: .top, endPoint: .bottom))
                    
                Section(header: Text("Sound and Haptics").font(Font.custom("Ambery Garden", size: 20.0))) {
                        Toggle("Sound Effects", systemImage: "music.note.list" ,isOn: $settings.soundEffectsEnabled)
                            .padding()
                            .foregroundColor(.black)
                        Toggle("Music", systemImage: "music.note", isOn: $settings.musicEnabled)
                            .padding()
                            .foregroundColor(.black)
                        Toggle("Haptics", systemImage: "iphone.radiowaves.left.and.right", isOn: $settings.hapticsEnabled)
                            .padding()
                            .foregroundColor(.black)
                    }
                    .listItemTint(.orange)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(Font.custom("December Show", size: 20.0))
                    .listRowBackground(LinearGradient(colors: [
                        .orange, .yellow], startPoint: .top, endPoint: .bottom))
                    
                Section(header: Text("Game Difficulty").font(Font.custom("Ambery Garden", size: 20.0))) {
                      //Difficulty Picker goes here
                    Picker("Difficulty", selection: $settings.gameDifficulty) {
                                            Text("Easy").tag("Easy")
                            .foregroundColor(.black)
                                            Text("Medium").tag("Medium")
                            .foregroundColor(.black)
                                            Text("Hard").tag("Hard")
                            .foregroundColor(.black)
                                        }
                                        .pickerStyle(SegmentedPickerStyle())
                                        .padding()
                    }
                    .listItemTint(.orange)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(Font.custom("December Show", size: 20.0))
                    .listRowBackground(LinearGradient(colors: [
                        .orange, .yellow], startPoint: .top, endPoint: .bottom))
                }
                .scrollContentBackground(.hidden)
                .background(.clear)
            .foregroundColor(.white)
        }
        .background(RadialGradient(colors: [.indigo, .purple], center: .top, startRadius: 800.0, endRadius: 10.0))
        
    }
}

// SwiftUI Preview Provider
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}



