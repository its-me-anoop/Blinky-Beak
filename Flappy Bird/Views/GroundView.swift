//
//  GroundView.swift
//  Flappy Bird
//
//  Created by Anoop Jose on 04/06/2024.
//

import SwiftUI

/// GroundView struct defines the view for a continuously moving ground in the game.
struct GroundView: View {
    @Binding var groundOffset: CGFloat  // Binding to the ground offset in the GameModel.
    @ObservedObject var gameModel: GameModel

    var body: some View {
        GeometryReader { geometry in
            Image(themeImageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: geometry.size.width * 2, height: 85, alignment: .top)
                
                
                
                 // Make the width twice the screen size for seamless tiling.
                .offset(x: groundOffset, y: geometry.size.height - 85) // Position at the bottom.
                .ignoresSafeArea()
                .animation(nil, value: groundOffset) // Disable implicit animations.
        }
    }

    // Computed property to select the correct image based on the theme
    private var themeImageName: String {
        switch gameModel.theme {
        case "Earth":
            return "ground"
        case "Outer Space":
            return "surface"
        default:
            return "ground" // Default case to handle unexpected values
        }
    }
}

// SwiftUI Preview for GroundView
struct GroundView_Previews: PreviewProvider {
    static var previews: some View {
        GroundView(groundOffset: .constant(0), gameModel: GameModel())
    }
}






