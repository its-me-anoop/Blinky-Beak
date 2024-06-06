//
//  GroundView.swift
//  Flappy Bird
//
//  Created by Anoop Jose on 04/06/2024.
//

// Importing SwiftUI for UI components and RiveRuntime for animations.
import SwiftUI
import RiveRuntime

// GroundView struct defines the visual representation of the ground in the game.
struct GroundView: View {
    var isGameStarted: Bool  // Boolean indicating if the game has started.

    // The body of the GroundView defines its visual structure.
    var body: some View {
        if isGameStarted {
            // Rive animation for the ground when the game is active.
            RiveViewModel(fileName: "ground-6", animationName: "fly")
                .view()  // Creates the view for the Rive model.
                .frame(width: UIScreen.main.bounds.width, height: 300)  // Sets the frame size.
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 175)  // Positions the view.
        } else {
            // Rive animation for the ground when the game is not active.
            RiveViewModel(fileName: "ground-6", animationName: "Idle")
                .view()
                .frame(width: UIScreen.main.bounds.width, height: 300)
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 175)
        }
    }
}

// SwiftUI Preview for GroundView
struct GroundView_Previews: PreviewProvider {
    static var previews: some View {
        GroundView(isGameStarted: true)  // Preview the GroundView with the game started state.
    }
}





