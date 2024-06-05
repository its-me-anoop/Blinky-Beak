//
//  GroundView.swift
//  Flappy Bird
//
//  Created by Anoop Jose on 04/06/2024.
//

import SwiftUI
import RiveRuntime

struct GroundView: View {
    var isGameStarted : Bool
    var body: some View {
        if isGameStarted {
            RiveViewModel(fileName: "ground-6", animationName: "fly")
                .view()
                .frame(width: UIScreen.main.bounds.width, height: 300)
                
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height-175)
        }
        else {
            RiveViewModel(fileName: "ground-6", animationName: "Idle")
                .view()
                .frame(width: UIScreen.main.bounds.width, height: 300)
                
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height-175)
        }
        
            
            
           
    }
}


struct GroundView_Previews: PreviewProvider {
    static var previews: some View {
        GroundView(isGameStarted: true)
    }
}




