//
//  MainMenuScene.swift
//  SpaceInvasion
//
//  Created by Abhishek Sansanwal on 11/01/19.
//  Copyright © 2019 Verved. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene {
    
    let startGame = SKLabelNode(fontNamed: "theboldfont")
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background12")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        background.size = self.size
        self.addChild(background)
        
        let gameBy = SKLabelNode(fontNamed: "theboldfont")
        gameBy.text = "Verved's"
        gameBy.fontSize = 50
        gameBy.fontColor = SKColor.white
        gameBy.position = CGPoint(x: self.size.width/2, y: self.size.height*0.78)
        gameBy.zPosition = 1
        self.addChild(gameBy)
        
        let gameName1 = SKLabelNode(fontNamed: "theboldfont")
        gameName1.text = "Space"
        gameName1.fontSize = 200
        gameName1.fontColor = SKColor.white
        gameName1.position = CGPoint(x: self.size.width/2, y: self.size.height*0.7)
        gameName1.zPosition = 1
        self.addChild(gameName1)
        
        let gameName2 = SKLabelNode(fontNamed: "theboldfont")
        gameName2.text = "Invasion"
        gameName2.fontSize = 200
        gameName2.fontColor = SKColor.white
        gameName2.position = CGPoint(x: self.size.width/2, y: self.size.height*0.625)
        gameName2.zPosition = 1
        self.addChild(gameName2)
        
        
        startGame.text = "Start Game"
        startGame.fontSize = 100
        startGame.fontColor = SKColor.white
        startGame.position = CGPoint(x: self.size.width/2, y: self.size.height*0.45)
        startGame.zPosition = 1
        startGame.name = "startButton"
        self.addChild(startGame)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            if startGame.contains(pointOfTouch){
                
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                
            }
            
        }
        
    }
    
    
    
}
