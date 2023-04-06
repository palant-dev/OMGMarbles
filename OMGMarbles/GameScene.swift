//
//  GameScene.swift
//  OMGMarbles
//
//  Created by Antonio Palomba on 06/04/23.
//

import CoreMotion
import SpriteKit

//We can declare a class to use a shorter name for the Node containing each ball (sprite)
class Ball: SKSpriteNode { }

class GameScene: SKScene {

    var balls = ["ballBlue", "ballGreen", "ballPurple", "ballRed", "ballYellow"]
    // If we do not put the optional to motionManager we will have to initialise it
    var motionManager: CMMotionManager?

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "checkerboard")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.alpha = 0.2
        background.zPosition = -1
        addChild(background)

        // Here we are creating the ball element with its radius
        let ball = SKSpriteNode(imageNamed: "ballBlue")
        let ballRadius = ball.frame.width / 2.0

        // This is a for loop for creating a matrix in which display the balls
        for i in stride(from: ballRadius, to: view.bounds.width - ballRadius, by: ball.frame.width) {
            for j in stride(from: 100, to: view.bounds.height - ballRadius, by: ball.frame.height) {
                // We add the force unwrap here to avoid and error at let ball = Ball(imageNamed: ballType)
                let ballType = balls.randomElement()!
                let ball = Ball(imageNamed: ballType)
                ball.position = CGPoint(x: i, y: j)
                ball.name = ballType


                /// Adding physic property to the balls:
                ///     - circleOfRadius: set the dimensions of the collision box
                ///     - restitution: set the bounciness of the balls
                ///     - friction: how smooth the contatct between the balls should be
                ball.physicsBody = SKPhysicsBody(circleOfRadius: ballRadius)
                ball.physicsBody?.allowsRotation = false
                ball.physicsBody?.restitution = 0
                ball.physicsBody?.friction = 0

                addChild(ball)
            }
        }

        /// This will add a constrint to the ball in order to not fall off the view
        ///     - top: regulates the ammount of space used by the HUD
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame.inset(by: UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)))

        motionManager = CMMotionManager()
        motionManager?.startAccelerometerUpdates()
    }

    override func update(_ currentTime: TimeInterval) {
        if let accelerometerData = motionManager?.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * -50)
        }
    }
}
