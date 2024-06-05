//
//  ContentView.swift
//  Flappy Bird
//
//  Created by Anoop Jose on 04/06/2024.
//

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var gameModel = GameModel()
    
    var body: some View {
        ZStack {
            Color.blue
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                
                VStack(alignment: .center) {
                    Text(gameModel.isGameOver ? "Game Over" : "Flappy Bird")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(gameModel.isGameOver ? .red : .white)
                    Text("Highest Score: \(gameModel.highestScore)")
                            .font(.title)
                            .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text("Score: \(gameModel.score)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                       
                }
                
                .ignoresSafeArea()
                .padding()
                .frame(
                      minWidth: 0,
                      maxWidth: .infinity,
                      alignment: .top
                    )
            
                .background(.green)
                .shadow(color: .indigo ,radius: 50)
                
                
                
                Spacer()
                
                ZStack {
                    BirdView(position: gameModel.birdPosition)
                    
                    ForEach(gameModel.obstacles, id: \.self) { obstacle in
                        CloudView(position: CGPoint(x: obstacle.x, y: obstacle.y))
                    }
                }
                
                Spacer()
                
                
                
                
            
                

            }
            if gameModel.isGameOver {
                Button(action: {
                    gameModel.startGame()
                }) {
                    Text(gameModel.score == 0 ? "Start" : "Restart")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .shadow(radius: 20)
                }
            }
            GroundView(isGameStarted: gameModel.isGameStarted)
                   
        }
        .onTapGesture {
            if !gameModel.isGameOver {
                gameModel.flap()
                gameModel.flapToggle.toggle()
                
                    
            }
                
        }
        .sensoryFeedback(.impact, trigger: gameModel.flapToggle)
        .sensoryFeedback(.error, trigger: gameModel.isGameOver)
        .sensoryFeedback(.impact, trigger: gameModel.score)
        
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}





