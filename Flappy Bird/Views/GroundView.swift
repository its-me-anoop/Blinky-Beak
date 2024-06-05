//
//  GroundView.swift
//  Flappy Bird
//
//  Created by Anoop Jose on 04/06/2024.
//

import SwiftUI

struct GroundView: View {
    var body: some View {
        Image("ground")
            .resizable()
            .scaledToFill()
            .frame(width: UIScreen.main.bounds.width, height: 300)
            .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 250)
            
           
    }
}

struct GroundView_Previews: PreviewProvider {
    static var previews: some View {
        GroundView()
    }
}




