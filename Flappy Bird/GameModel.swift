import SwiftUI
import Combine
import UIKit

/// Represents an obstacle in the game, consisting of a position characterized by x and y coordinates.
struct Obstacle: Hashable {
    var x: CGFloat  // The x-coordinate of the obstacle.
    var y: CGFloat  // The y-coordinate of the obstacle.
}

/// Manages the game state and logic for a Flappy Bird-style game.
class GameModel: ObservableObject {
    // MARK: - Published Properties

    /// The current position of the bird on the screen.
    @Published var birdPosition: CGPoint
    
    /// A list of obstacles in the game, represented by their positions.
    @Published var obstacles: [Obstacle]
    
    /// Indicates whether the game is currently over.
    @Published var isGameOver: Bool
    
    /// The current score of the player.
    @Published var score: Int
    
    /// The highest score achieved in the game.
    @Published var highestScore: Int
    
    /// Indicates whether the game has started.
    @Published var isGameStarted: Bool
    
    /// Used to trigger haptic feedback for a flap action.
    @Published var flapToggle: Bool = false

    // MARK: - Game Physics Properties

    /// Gravity affecting the bird's vertical movement.
    var gravity: CGFloat
    
    /// The vertical distance the bird moves upon flapping.
    var flapHeight: CGFloat
    
    /// The current vertical velocity of the bird.
    var birdVelocity: CGFloat
    
    /// The horizontal speed at which obstacles move.
    var obstacleSpeed: CGFloat
    
    /// Timer to update game state at regular intervals.
    var timer: AnyCancellable?

    /// Initializes a new instance of the game model with default values.
    init() {
        birdPosition = CGPoint(x: 100, y: 300)
        obstacles = []
        isGameOver = true
        score = 0
        highestScore = 0
        isGameStarted = false
        gravity = 2.5
        flapHeight = 20.0
        birdVelocity = 0.0
        obstacleSpeed = 3.0
        resetGame()
    }

    /// Starts or restarts the game, resetting all parameters and starting background music.
    func startGame() {
        resetGame()
        isGameOver = false
        isGameStarted = true
        SoundManager.shared.playButtonSound()
        SoundManager.shared.playBackgroundMusic()
        timer = Timer.publish(every: 0.03, on: .main, in: .common).autoconnect()
            .sink { [weak self] _ in self?.updateGame() }
    }

    /// Resets the game to initial conditions, preparing for a new game or restart.
    private func resetGame() {
        birdPosition = CGPoint(x: 100, y: 300)
        obstacles = [Obstacle(x: 400, y: 200), Obstacle(x: 700, y: 100)]
        score = 0
        birdVelocity = 0.0
    }

    /// Updates the game state, including bird position and obstacle movements.
    func updateGame() {
        updateBirdPosition()
        updateObstacles()
        checkForCollisions()
    }

    /// Updates the bird's position based on its current velocity and gravity.
    private func updateBirdPosition() {
        birdVelocity += gravity
        birdPosition.y += birdVelocity
        checkForBoundaryCollisions()
    }

    /// Updates positions of obstacles, checking for out-of-bounds and scoring.
    private func updateObstacles() {
        obstacles.indices.forEach { index in
            obstacles[index].x -= obstacleSpeed
            if obstacles[index].x < -50 {
                resetObstacle(index: index)
            }
        }
    }

    /// Resets an obstacle when it moves off-screen, randomizing its new position and updating the score.
    /// - Parameter index: The index of the obstacle to reset.
    private func resetObstacle(index: Int) {
        obstacles[index].x = UIScreen.main.bounds.width + 50
        obstacles[index].y = CGFloat.random(in: 100...500)
        score += 1
        if score > highestScore {
            highestScore = score
        }
    }

    /// Checks for collisions between the bird and obstacles.
    private func checkForCollisions() {
        let birdSize = CGSize(width: 50, height: 50)
        let birdRect = CGRect(origin: birdPosition, size: birdSize)
        for obstacle in obstacles {
            let obstacleRect = CGRect(x: obstacle.x, y: obstacle.y, width: 50, height: 30)
            if birdRect.intersects(obstacleRect) {
                gameOver()
                break
            }
        }
    }

    /// Checks for collisions with the ground and top of the screen, ending the game if detected.
        private func checkForBoundaryCollisions() {
            let screenHeight = UIScreen.main.bounds.height
            let groundHeight: CGFloat = 300

            if birdPosition.y >= screenHeight - groundHeight || birdPosition.y < 0 {
                gameOver()
            }
        }

        /// Causes the bird to flap, moving upwards and playing a flap sound.
        func flap() {
            birdVelocity = -flapHeight
            SoundManager.shared.playFlapSound()
        }

        /// Ends the game, stopping the timer and playing end-game sound effects.
        func gameOver() {
            isGameOver = true
            isGameStarted = false
            timer?.cancel()
            SoundManager.shared.playGameOverSound()
            SoundManager.shared.stopBackgroundMusic()
        }
    }
