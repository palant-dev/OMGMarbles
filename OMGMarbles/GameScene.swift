//
//  GameScene.swift
//  OMGMarbles
//
//  Created by Antonio Palomba on 06/04/23.
//

import SpriteKit

//We can declare a class to use a shorter name for the Node containing each ball (sprite)
class Ball: SKSpriteNode { }

class GameScene: SKScene {

    var balls = ["ballBlue", "ballGreen", "ballPurple", "ballRed", "ballYellow"]

    override func didMove(to view: SKView) {
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
