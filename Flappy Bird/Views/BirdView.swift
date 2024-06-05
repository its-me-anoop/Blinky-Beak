//
//  BirdView.swift
//  Flappy Bird
//
//  Created by Anoop Jose on 04/06/2024.
//

import SwiftUI
import RiveRuntime

struct BirdView: View {
    var position: CGPoint
    
    var body: some View {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Container@*/VStack/*@END_MENU_TOKEN@*/ {
            RiveViewModel(fileName: "flying_bird").view()
                .frame(height: 50)
                .position(position)
        }
    }
}

struct BirdView_Previews: PreviewProvider {
    static var previews: some View {
        BirdView(position: CGPoint(x: 100, y: 300))
    }
}






