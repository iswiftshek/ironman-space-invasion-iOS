//
//  GameOverScene.swift
//  SpaceInvasion
//
//  Created by Abhishek Sansanwal on 11/01/19.
//  Copyright © 2019 Verved. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    let restartLabel = SKLabelNode(fontNamed: "theboldfont")
    
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let gameOverLabel = SKLabelNode(fontNamed: "theboldfont")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 200
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.7)
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)
        
        let scoreLabel = SKLabelNode(fontNamed: "theboldfont")
        scoreLabel.text = "Score: \(gameScore)"
        scoreLabel.fontSize = 125
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.55)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
        let defaults = UserDefaults()
        var highScoreNumber = defaults.integer(forKey: "highScoreSaved")
        
        if gameScore > highScoreNumber {
            highScoreNumber = gameScore
            defaults.set(highScoreNumber, forKey: "highScoreSaved")
        }
        
        let highscoreLabel = SKLabelNode(fontNamed: "theboldfont")
        highscoreLabel.text = "High Score: \(highScoreNumber)"
        highscoreLabel.fontSize = 125
        highscoreLabel.fontColor = SKColor.white
        highscoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.45)
        highscoreLabel.zPosition = 1
        self.addChild(highscoreLabel)
        
       
        restartLabel.text = "Restart"
        restartLabel.fontSize = 90
        restartLabel.fontColor = SKColor.white
        restartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.30)
        restartLabel.zPosition = 1
        self.addChild(restartLabel)
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            if restartLabel.contains(pointOfTouch){
                
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                
            }
            
        }
        
        
    }
    
    
    
    
    
    
    
}
