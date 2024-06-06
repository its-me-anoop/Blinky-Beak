//
//  ContentView.swift
//  Flappy Bird
//
//  Created by Anoop Jose on 04/06/2024.
//

import SwiftUI
import Combine

/// ContentView provides the main interface for the Flappy Bird-style game, handling user interactions and displaying game elements.
struct ContentView: View {
    @ObservedObject var gameModel = GameModel()  // Observes changes in the game model to update the view.

    /// The body property defines the structure of the view.
    var body: some View {
        ZStack {
            // Background layer
            backgroundView()

            // Main content including game elements and controls
            gameContentView()

            // Overlay for game over with controls
            if gameModel.isGameOver {
                gameOverOverlay()
            }

            // Ground view shows moving or static ground based on game state
            GroundView(isGameStarted: gameModel.isGameStarted)
        }
        .onTapGesture {
            handleTap()
        }
        .sensoryFeedback(.impact, trigger: gameModel.flapToggle)
        .sensoryFeedback(.error, trigger: gameModel.isGameOver)
        .sensoryFeedback(.impact, trigger: gameModel.score)
    }

    /// Displays the blue background extending to the edges of the display.
    private func backgroundView() -> some View {
        Color.blue.edgesIgnoringSafeArea(.all)
    }

    /// Handles all game content display including scores and the bird.
    private func gameContentView() -> some View {
        VStack {
            scoreView()
            Spacer()
            birdAndObstaclesView()
            Spacer()
        }
    }

    /// Displays current and highest scores.
    private func scoreView() -> some View {
        VStack(alignment: .center) {
            Text(gameModel.isGameOver ? "Game Over" : "Flappy Bird")
                .font(.largeTitle).fontWeight(.bold).foregroundColor(gameModel.isGameOver ? .red : .white)
            Text("Highest Score: \(gameModel.highestScore)")
                .font(.title).fontWeight(.bold).foregroundColor(.white)
            Text("Score: \(gameModel.score)")
                .font(.title).fontWeight(.bold).foregroundColor(.white)
        }
        .padding().frame(maxWidth: .infinity, alignment: .top)
        .background(Color.green).shadow(color: .indigo, radius: 50)
    }

    /// Displays the bird and obstacles using their respective views.
    private func birdAndObstaclesView() -> some View {
        ZStack {
            BirdView(position: gameModel.birdPosition)
            ForEach(gameModel.obstacles, id: \.self) { obstacle in
                CloudView(position: CGPoint(x: obstacle.x, y: obstacle.y))
            }
        }
    }

    /// Displays game over controls allowing game restart.
    private func gameOverOverlay() -> some View {
        Button(action: {
            gameModel.startGame()
        }) {
            Text(gameModel.score == 0 ? "Start" : "Restart")
                .font(.title).fontWeight(.bold)
                .padding().background(Color.green).cornerRadius(10)
                .foregroundColor(.white).shadow(radius: 20)
        }
    }

    /// Handles tap gestures, allowing the bird to flap if the game is not over.
    private func handleTap() {
        if !gameModel.isGameOver {
            gameModel.flap()
            gameModel.flapToggle.toggle()
        }
    }
}

/// Provides a preview of ContentView in Xcode's canvas for design and layout testing.
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
