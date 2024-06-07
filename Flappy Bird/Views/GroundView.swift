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

    var body: some View {
        GeometryReader { geometry in
            Image("ground")
                .resizable()
                .ignoresSafeArea()
                .frame(width: geometry.size.width * 2, height: 350)  // Make the width twice the screen size for seamless tiling.
                
                .offset(x: groundOffset, y: geometry.size.height - 350)
                // Position at the bottom.
                .animation(nil, value: groundOffset)  // Disable implicit animations.
                
        }
    }
}

// SwiftUI Preview for GroundView
struct GroundView_Previews: PreviewProvider {
    static var previews: some View {
        GroundView(groundOffset: .constant(0))
    }
}






