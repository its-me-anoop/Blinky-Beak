//
//  CloudView.swift
//  Flappy Bird
//
//  Created by Anoop Jose on 04/06/2024.
//

// Importing SwiftUI framework for building user interfaces.
import SwiftUI

// CloudView struct defines the view for clouds in the game's environment.
struct CloudView: View {
    var position: CGPoint  // Position of the cloud on the screen.
    @ObservedObject var gameModel: GameModel

    // The body of the CloudView defines its visual structure.
    var body: some View {
        themeImage  // System image of a cloud filled with color.
            .resizable()  // Makes the cloud image resizable.
            .frame(width: 100, height: 100)  // Sets the size of the cloud image.
            .position(position)  // Sets the position of the cloud on the screen.
            .foregroundColor(.white)  // Sets the color of the cloud to white.
    }
    private var themeImage: Image {
        switch gameModel.theme {
        case "Earth":
            return Image(systemName: "cloud.fill")
        case "Outer Space":
            return Image("asteroid")
        default:
            return Image(systemName: "cloud.fill")// Default case to handle unexpected values
        }
    }
    
}

// SwiftUI Preview for CloudView
struct CloudView_Previews: PreviewProvider {
    static var previews: some View {
        CloudView(position: CGPoint(x: 100, y: 100), gameModel: GameModel())  // Preview the CloudView with specified position.
            .background(.blue)
    }
}




