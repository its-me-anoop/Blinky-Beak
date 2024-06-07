//
//  BirdView.swift
//  Flappy Bird
//
//  Created by Anoop Jose on 04/06/2024.
//

// Importing SwiftUI for UI components and RiveRuntime for handling animations.
import SwiftUI
import RiveRuntime

// BirdView struct defines the view for the bird in the game.
struct BirdView: View {
    var position: CGPoint  // Position of the bird on the screen.
    @ObservedObject var gameModel: GameModel

    // The body of the BirdView defines its visual structure.
    var body: some View {
        VStack {  // Vertical stack to organize views.
            // Rive animation model for the bird, showing it as flying.
            if gameModel.theme == "Earth"{
                RiveViewModel(fileName: "flying_bird").view()
                    .frame(height: 50)  // Sets the height of the frame for the bird's view.
                    .position(position)  // Positions the bird according to the CGPoint provided.
            }
            if gameModel.theme == "Outer Space"{
                ZStack {
                    Image("bubble")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .position(position)
                    RiveViewModel(fileName: "flying_bird").view()
                        .frame(height: 50)  // Sets the height of the frame for the bird's view.
                    .position(position)
                    
                }  // Positions the bird according to the CGPoint provided.
            }
            
    
        }
    }
}

// SwiftUI Preview for BirdView
struct BirdView_Previews: PreviewProvider {
    static var previews: some View {
        BirdView(position: CGPoint(x: 100, y: 300), gameModel: GameModel())
            .background(.black)
    }
}







