import SwiftUI
import Combine
import UIKit

struct Obstacle: Hashable {
    var x: CGFloat
    var y: CGFloat
}

class GameModel: ObservableObject {
    @Published var birdPosition = CGPoint(x: 100, y: 300)
    @Published var obstacles = [Obstacle]()
    @Published var isGameOver = true
    @Published var score = 0
    @Published var highestScore = 0
    @Published var x = (UIScreen.main.bounds.width) / 2
    @Published var isGameStarted = false // Added property to track game start
    @Published var flapToggle = false

    var gravity: CGFloat = 2.5
    var flapHeight: CGFloat = 20.0
    var birdVelocity: CGFloat = 0.0
    var obstacleSpeed: CGFloat = 3.0
    var groundBounceVelocity: CGFloat = 0 // Set to zero to stop the bird at the ground level
    var timer: AnyCancellable?
    let fallSpeed: CGFloat = 2.5

    func startGame() {
        SoundManager.shared.playButtonSound()
        SoundManager.shared.playBackgroundMusic()
        birdPosition = CGPoint(x: 100, y: 300)
        obstacles = [Obstacle(x: 400, y: 200), Obstacle(x: 700, y: 100)]
        isGameOver = false
        birdVelocity = 0.0
        score = 0
        isGameStarted = true // Set isGameStarted to true when the game starts

        timer = Timer.publish(every: 0.03, on: .main, in: .common).autoconnect()
            .sink { _ in self.updateGame() }

        // Trigger haptic feedback when the game starts
        
    }

    func updateGame() {
        birdVelocity += gravity
        birdPosition.y += birdVelocity

        for i in 0..<obstacles.count {
            obstacles[i].x -= obstacleSpeed
            if obstacles[i].x < -50 {
                obstacles[i].x = 400
                obstacles[i].y = CGFloat.random(in: 100...500)
                score += 1
                if score > highestScore {
                    highestScore = score
                }
            }
        }

        checkForCollisions()
    }

    func flap() {
        birdVelocity = -flapHeight
        SoundManager.shared.playFlapSound()
    }

    func checkForCollisions() {
        let screenHeight = UIScreen.main.bounds.height
        let groundHeight: CGFloat = 300

        // Prevent bird from falling below the ground and end the game
        if birdPosition.y >= screenHeight - groundHeight {
            birdPosition.y = screenHeight - groundHeight
            gameOver()
        }

        // Check if the bird hits the top of the screen
        if birdPosition.y < 0 {
            gameOver()
        }

        // Check for collisions with obstacles
        for obstacle in obstacles {
            if abs(birdPosition.x - obstacle.x) < 30 && abs(birdPosition.y - obstacle.y) < 50 {
                birdPosition.y = screenHeight - groundHeight
                gameOver()
            }
        }
    }
    
   

    func gameOver() {
        isGameOver = true
        isGameStarted = false // Set isGameStarted to false when the game ends
        timer?.cancel()
        SoundManager.shared.playGameOverSound()
        SoundManager.shared.stopBackgroundMusic()
    }
}
