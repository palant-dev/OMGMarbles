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

    let scoreLabel = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
    var matchedBalls  = Set<Ball>()

    var score = 0 {
        didSet {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            // We are gonna use the nihil cohalescing because otherwise we get a warning of possible nil value for scoreLabel.text
            let formattedScore = formatter.string(from: score as NSNumber) ?? "0"
            scoreLabel.text = "SCORE: \(formattedScore)"
        }
    }

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "checkerboard")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.alpha = 0.2
        background.zPosition = -1
        addChild(background)

        scoreLabel.fontSize = 72
        scoreLabel.position = CGPoint(x: 20, y: 20)
        scoreLabel.text = "SCORE: 0"
        scoreLabel.zPosition = 100
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)

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
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
        }
    }

    func getMatches(from node: Ball) {
        for body in node.physicsBody!.allContactedBodies() {
            // This is a check for being sure that the elements touched is a Ball (SKSpriteNode)
            guard let ball = body.node as? Ball else { continue }
            // This is for checking if the ball touched has the same name (colour)
            guard ball.name == node.name else { continue }

            if !matchedBalls.contains(ball) {
                matchedBalls.insert(ball)
                getMatches(from: ball)
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        // If for any reason we cannot understand where the tap happens, ignore it
        guard let position = touches.first?.location(in: self) else { return }

        // We need to be sure if the thing tapped is the ball
        guard let tappedBall = nodes(at: position).first(where: { $0 is Ball }) as? Ball else { return }

        // This is for not adding any more ball when removing
        matchedBalls.removeAll(keepingCapacity: true)

        getMatches(from: tappedBall)

        // This is for not letting the user tap and remove even isolated balls
        if matchedBalls.count >= 3 {
            for ball in matchedBalls {
                ball.removeFromParent()
            }
        }
    }

}
