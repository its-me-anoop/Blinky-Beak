//
//  CloudView.swift
//  Flappy Bird
//
//  Created by Anoop Jose on 04/06/2024.
//

import SwiftUI

struct CloudView: View {
    var position: CGPoint
    
    var body: some View {
        Image(systemName: "cloud.fill")
            .resizable()
            .frame(width: 80, height: 50)
            .position(position)
            .foregroundColor(.white)
    }
}

struct CloudView_Previews: PreviewProvider {
    static var previews: some View {
        CloudView(position: CGPoint(x: 100, y: 100))
    }
}



