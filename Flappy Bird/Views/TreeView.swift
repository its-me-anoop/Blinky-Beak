//
//  TreeView.swift
//  Flappy Bird
//
//  Created by Anoop Jose on 06/06/2024.
//

import SwiftUI

/// TreeView struct defines the view for trees in the game's environment.
struct TreeView: View {
    var position: CGPoint  // Position of the tree on the screen.
    @ObservedObject var gameModel: GameModel
    var body: some View {
        Image(themeImageName)  // Placeholder for the tree image.
            .resizable()
            .frame(width: 100, height: 200)
            .position(position)
            .foregroundColor(.green)
    }
    private var themeImageName: String {
        switch gameModel.theme {
        case "Earth":
            return "tree"
        case "Outer Space":
            return "asteroid"
        default:
            return "tree" // Default case to handle unexpected values
        }
    }
}

// SwiftUI Preview for TreeView
struct TreeView_Previews: PreviewProvider {
    static var previews: some View {
        TreeView(position: CGPoint(x: 100, y: UIScreen.main.bounds.height - 180), gameModel: GameModel())  // Preview with base on the ground.
    }
}


