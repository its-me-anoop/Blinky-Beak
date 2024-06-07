import SwiftUI
import Combine
import UIKit

/// Represents an obstacle in the game, consisting of a position characterized by x and y coordinates.
enum ObstacleType: String, Hashable {
    case cloud, tree
}

enum Difficulty: String, Hashable {
    case easy, medium, hard
}

struct Obstacle: Hashable {
    var x: CGFloat  // The x-coordinate of the obstacle.
    var y: CGFloat  // The y-coordinate of the obstacle.
    var type: ObstacleType  // Type of the obstacle.
}

/// Manages the game state and logic for a Flappy Bird-style game.
class GameModel: ObservableObject {
    // MARK: - Published Properties
    @Published var birdPosition: CGPoint
    @Published var obstacles: [Obstacle]
    @Published var isGameOver: Bool
    @Published var score: Int
    @Published var highestScore: Int
    @Published var isGameStarted: Bool
    @Published var flapToggle: Bool = false
    @Published var theme: String = "Earth"
    @Published var groundOffset: CGFloat = 0  // Offset for the ground.

    // MARK: - Game Physics Properties
    var gravity: CGFloat
    var flapHeight: CGFloat
    var birdVelocity: CGFloat
    var obstacleSpeed: CGFloat
    var groundSpeed: CGFloat = 6.0  // Speed for the ground.
    var timer: AnyCancellable?
    var hasCollided: Bool = false
    var bounceDamping: CGFloat = 0.5

    let groundHeight: CGFloat = 300

    /// Initializes a new instance of the game model with default values.
    init() {
        birdPosition = CGPoint(x: UIScreen.main.bounds.width / 2 , y: UIScreen.main.bounds.height / 2)
        obstacles = []
        isGameOver = false
        score = 0
        highestScore = 0
        isGameStarted = false
        gravity = 2.5
        flapHeight = 20.0
        birdVelocity = 0.0
        obstacleSpeed = groundSpeed
        NotificationCenter.default.addObserver(self, selector: #selector(updateForTheme), name: NSNotification.Name("GameThemeChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDifficultyChange), name: NSNotification.Name("GameDifficultyChanged"), object: nil)
        updateForTheme()
        updateGameDifficulty() // Set initial difficulty
        resetGame()
    }
    
    @objc func handleDifficultyChange() {
        updateGameDifficulty()
        // Optionally reset or adjust the game state based on new settings
    }
    
    @objc func updateForTheme() {
            switch UserSettings.shared.gameTheme {
            case "Earth":
                theme = "Earth"
                break
            case "OuterSpace":
                theme = "Outer Space"
                break
            default:
                break
            }
        }
    
    func updateGameDifficulty() {
            switch UserSettings.shared.gameDifficulty {
            case "Easy":
                groundSpeed = 3.0
                obstacleSpeed = 3.0
                // Adjust other parameters for easy difficulty.
            case "Medium":
                groundSpeed = 6.0
                obstacleSpeed = 6.0
                // Adjust for medium difficulty.
            case "Hard":
                groundSpeed = 9.0
                obstacleSpeed = 9.0
                // Adjust for hard difficulty.
            default:
                break
            }
        }

    /// Starts or restarts the game, resetting all parameters and starting background music.
    func startGame() {
        resetGame()
        isGameOver = false
        isGameStarted = true
        hasCollided = false
        SoundManager.shared.playButtonSound()
        SoundManager.shared.playBackgroundMusic()
        timer = Timer.publish(every: 0.03, on: .main, in: .common).autoconnect()
            .sink { [weak self] _ in self?.updateGame() }
    }

    /// Resets the game to initial conditions, preparing for a new game or restart.
    private func resetGame() {
        birdPosition = CGPoint(x: UIScreen.main.bounds.width / 2 , y: UIScreen.main.bounds.height - 550)
        obstacles = [
            Obstacle(x: 400, y: 200, type: .cloud),
            Obstacle(x: 700, y: 100, type: .cloud),
            Obstacle(x: 900, y: UIScreen.main.bounds.height - groundHeight - 45, type: .tree)
        ]
        groundOffset = 0  // Reset ground offset.
        score = 0
        birdVelocity = 0.0
    }

    /// Updates the game state, including bird position, obstacle movements, and ground movement.
    func updateGame() {
        if hasCollided {
            updateCollisionFall()
        } else {
            updateBirdPosition()
            updateObstacles()
            updateGround()
            checkForCollisions()
        }
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

    /// Updates the ground's position to create a scrolling effect.
    private func updateGround() {
        groundOffset -= groundSpeed
        if groundOffset <= -UIScreen.main.bounds.width {
            groundOffset = 0  // Reset ground offset to create a seamless loop.
        }
    }

    /// Resets an obstacle when it moves off-screen, randomizing its new position and updating the score.
    /// - Parameter index: The index of the obstacle to reset.
    private func resetObstacle(index: Int) {
        let obstacleType: ObstacleType = Bool.random() ? .cloud : .tree
        let yPosition: CGFloat
        if obstacleType == .cloud {
            yPosition = CGFloat.random(in: 100...500)
        } else {
            yPosition = UIScreen.main.bounds.height - groundHeight - 45
        }
        obstacles[index] = Obstacle(
            x: UIScreen.main.bounds.width + 50,
            y: yPosition,
            type: obstacleType
        )
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
            let obstacleSize = obstacle.type == .cloud ? CGSize(width: 60, height: 60) : CGSize(width: 60, height: 80)
            let reducedObstacleSize = CGSize(width: obstacleSize.width - 20, height: obstacleSize.height - 20)
            let obstacleRect = CGRect(x: obstacle.x + (obstacleSize.width - reducedObstacleSize.width) / 2,
                                      y: obstacle.y + (obstacleSize.height - reducedObstacleSize.height) / 2,
                                      width: reducedObstacleSize.width,
                                      height: reducedObstacleSize.height)
            if birdRect.intersects(obstacleRect) {
                hasCollided = true
                birdVelocity = 0
                return
            }
        }
    }

    /// Checks for collisions with the ground and top of the screen, ending the game if detected.
    private func checkForBoundaryCollisions() {
        let screenHeight = UIScreen.main.bounds.height

        if birdPosition.y >= screenHeight - groundHeight {
            birdPosition.y = screenHeight - groundHeight
            hasCollided = true
            birdVelocity = -birdVelocity * bounceDamping
            if abs(birdVelocity) < 1 {
                gameOver()
            }
        } else if birdPosition.y < 0 {
            gameOver()
        }
    }

    /// Updates bird position and velocity to simulate falling and bouncing after a collision.
    private func updateCollisionFall() {
        birdVelocity += gravity
        birdPosition.y += birdVelocity
        if birdPosition.y >= UIScreen.main.bounds.height - groundHeight {
            birdPosition.y = UIScreen.main.bounds.height - groundHeight
            birdVelocity = -birdVelocity * bounceDamping
            if abs(birdVelocity) < 1 {
                gameOver()
            }
        }
    }

    /// Causes the bird to flap, moving upwards and playing a flap sound.
    func flap() {
        guard !hasCollided else { return }
        birdVelocity = -flapHeight
        SoundManager.shared.playFlapSound()
    }

    /// Ends the game, stopping the timer and playing end-game sound effects.
    func gameOver() {
        isGameOver = true
        timer?.cancel()
        SoundManager.shared.playGameOverSound()
        SoundManager.shared.stopBackgroundMusic()
    }
}
