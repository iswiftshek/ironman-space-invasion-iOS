//
//  GameViewController.swift
//  SpaceInvasion
//
//  Created by Abhishek Sansanwal on 10/01/19.
//  Copyright © 2019 Verved. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController {
    
    var backingAudio = AVAudioPlayer()

    override func viewDidLoad() {
        
        let filePath = Bundle.main.url(forResource: "backingAudio", withExtension: "mp3")
        
        do {
            backingAudio = try AVAudioPlayer(contentsOf: filePath!)
        }
        catch{
            return print("Cannot find the audio")
        }
        
        backingAudio.numberOfLoops = -1
        backingAudio.play() 
        
        
        super.viewDidLoad()
        
        let scene = MainMenuScene(size: CGSize(width: 1536, height: 2048))
        //this makes the game universal
        
        let view = self.view as! SKView
          
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
                
        // Present the scene
        view.presentScene(scene)
        
        view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true
        
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
