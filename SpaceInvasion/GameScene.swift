//
//  GameScene.swift
//  SpaceInvasion
//
//  Created by Abhishek Sansanwal on 10/01/19.
//  Copyright © 2019 Verved. All rights reserved.
//

import SpriteKit
var gameScore = 0

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let tapToStartLabel = SKLabelNode(fontNamed:"theboldfont")
    
    let scoreLabel = SKLabelNode(fontNamed:"theboldfont")
    
    var levelNumber = 0
    
    var livesNumber = 3
    let livesLabel = SKLabelNode(fontNamed:"theboldfont")
    
    
   // var scroller: InfiniteScrollingBackground?
    let player = SKSpriteNode(imageNamed: "playership")
    let bulletSound = SKAction.playSoundFileNamed("bulletSound.wav", waitForCompletion: false)
    let explosionSound = SKAction.playSoundFileNamed("explosionSound.wav", waitForCompletion: false)
    
    enum gameState{
         case preGame
         case inGame
         case afterGame
    }
    
    var currentGameState = gameState.preGame
    
    var gameArea: CGRect
    
    
    struct PhysicsCategories {
        static let None: UInt32 = 0
        static let Player: UInt32 = 0b1
        static let Bullet: UInt32 = 0b10
        static let Enemy: UInt32 = 0b100
    }
    
    
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        //return random() * (max-min) + min
        
        return CGFloat(arc4random_uniform(UInt32(max - min)) + UInt32(min))
        
    }
    
    override init(size: CGSize) {
        
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height/maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        super.init(size: size)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


    
    override func didMove(to view: SKView) {
       /*
        let images = [
            UIImage(named: "background")!, UIImage(named: "background")!
        ]
        
        // Initializing InfiniteScrollingBackground's Instance:
        scroller = InfiniteScrollingBackground(images: images, scene: self, scrollDirection: .bottom, transitionSpeed: 3)
        
        // Using it:
        scroller?.scroll()
        
        // (Optional) Changing the instance's zPosition:
        scroller?.zPosition = 0
        */
    
        self.physicsWorld.contactDelegate = self
        
        for i in 0...1{
        
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.name = "Background"
        background.anchorPoint = CGPoint(x: 0.5, y: 0)
        background.position = CGPoint(x: self.size.width/2, y: self.size.height*CGFloat(i))
        background.zPosition = 0
        self.addChild(background)
        }
        
        
        player.setScale(0.7)
        player.position = CGPoint(x: self.size.width/2, y: 0 - player.size.height)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        
        self.addChild(player)
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 70
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width*0.15, y: self.size.height + scoreLabel.frame.size.height)
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)
        
        livesLabel.text = "Lives: 3"
        livesLabel.fontSize = 70
        livesLabel.fontColor = SKColor.white
        livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        livesLabel.position = CGPoint(x: self.size.width*0.85, y: self.size.height + livesLabel.frame.size.height)
        livesLabel.zPosition = 100
        self.addChild(livesLabel)
        
        let moveOnToScreenAction = SKAction.moveTo(y: self.size.height*0.9, duration: 0.3)
        
        scoreLabel.run(moveOnToScreenAction)
        livesLabel.run(moveOnToScreenAction)
        
        tapToStartLabel.text = "Tap to Begin"
        tapToStartLabel.fontSize = 100
        tapToStartLabel.fontColor = SKColor.white
        tapToStartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        tapToStartLabel.zPosition = 1
        tapToStartLabel.alpha = 0
        self.addChild(tapToStartLabel)
        
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        tapToStartLabel.run(fadeInAction)
        
        gameScore = 0
     
        
    }
    
    var lastUpdateTime: TimeInterval = 0
    var deltaFrameTime: TimeInterval = 0
    var amountToMovePerSecond: CGFloat = 600.0
    
    
    override func update(_ currentTime: TimeInterval) {
        
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        }
        else{
            deltaFrameTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
        }
        
        let amountToMoveBackground = amountToMovePerSecond*CGFloat(deltaFrameTime)
        
        self.enumerateChildNodes(withName: "Background"){
            background, stop in
            
            if self.currentGameState == gameState.inGame{
                background.position.y -= amountToMoveBackground}
            if background.position.y < -self.size.height{
                background.position.y += self.size.height*2
            }
        }
        
    }
    
    
    
    func startGame(){
        
        currentGameState = .inGame
        
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteAction = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([fadeOutAction,deleteAction])
        tapToStartLabel.run(deleteSequence)
        
        
        let moveShipOnToScreenAction = SKAction.moveTo(y: self.size.height*0.2, duration: 0.5)
        let startLevelAction = SKAction.run(startNewLevel)
        let startGameSequence = SKAction.sequence([moveShipOnToScreenAction,startLevelAction])
        player.run(startGameSequence)
        
        
    }
    
    
    
    func loseALife(){
        
        livesNumber -= 1
        livesLabel.text = "Lives: \(livesNumber)"
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp,scaleDown])
        livesLabel.run(scaleSequence)
        
        if livesNumber == 0 {
            runGameOver()
        }
        
    }
    
    
    
    func addScore(){
        
        gameScore += 1
        scoreLabel.text = "Score: \(gameScore)"
        
        if gameScore == 10 || gameScore == 20 || gameScore == 30{
            startNewLevel()
        }
        
        
    }
    
    
    
    func runGameOver(){
        
        currentGameState = .afterGame
        
        self.removeAllActions()
        self.enumerateChildNodes(withName: "Bullet"){
            bullet, stop in
            bullet.removeAllActions()
        }
        
        self.enumerateChildNodes(withName: "Enemy"){
            enemy, stop in
            enemy.removeAllActions()
        }
        
        let changeSceneAction = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene,changeSceneAction])
        self.run(changeSceneSequence)
        
    }
    
    
    func changeScene(){
        
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
        
    }
    
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else{
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Enemy{
            //player hits the enemy
            
            if body1.node != nil {
                
                spawnExplosion(spawnPosition: body1.node!.position)
                
            }
            
            if body2.node != nil {
                
                spawnExplosion(spawnPosition: body2.node!.position)
                
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
            runGameOver()
            
        }
        
        if body1.categoryBitMask == PhysicsCategories.Bullet && body2.categoryBitMask == PhysicsCategories.Enemy && (body2.node?.position.y)! < self.size.height {
            //player hits the enemy
            
            if body2.node != nil {
                
                addScore()
                
                 spawnExplosion(spawnPosition: body2.node!.position)
                
            }
           
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
        }
        
        
    }
    
    
    func spawnExplosion(spawnPosition: CGPoint){
        
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
        
        let scaleIn = SKAction.scale(to: 0.3, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        
        let explosionSequence = SKAction.sequence([explosionSound,scaleIn,fadeOut,delete])
        explosion.run(explosionSequence)
        
    }
    
    
    
    
    func fireBullet(){
        
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.name = "Bullet"
        bullet.setScale(1)
        bullet.position = player.position
        bullet.zPosition = 1
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = PhysicsCategories.Bullet
        bullet.physicsBody!.collisionBitMask = PhysicsCategories.None
        bullet.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(bullet)
        
        let moveAction = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1.5)
        let deleteBullete = SKAction.removeFromParent()
        
        let bulletSequence = SKAction.sequence([bulletSound,moveAction,deleteBullete])
        bullet.run(bulletSequence)

        
    }
    
    
    func spawnEnemy(){
        
        let randomXStart = random(min: gameArea.minX, max: gameArea.maxX)
        let randomXEnd = random(min: gameArea.minX, max: gameArea.maxX)
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        let enemy = SKSpriteNode(imageNamed: "enemyShip")
        enemy.name = "Enemy"
        enemy.setScale(0.3)
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
        self.addChild(enemy)
        
        let moveEnemy = SKAction.move(to: endPoint, duration: 2)
        let deleteEnemy = SKAction.removeFromParent()
        let loseALifeAction = SKAction.run(loseALife)
        let enemySequence = SKAction.sequence([moveEnemy,deleteEnemy,loseALifeAction])
        
        if currentGameState == .inGame{
            enemy.run(enemySequence)
        }
        
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amountToRotate = atan2(dy,dx)
        enemy.zRotation = amountToRotate
        
    }
    
    
    func startNewLevel(){
        
        levelNumber += 1
        
        if (self.action(forKey: "spawningEnemies") != nil){
            self.removeAction(forKey: "spawningEnemies")
        }
        
        var levelDuration = TimeInterval()
        
        switch levelNumber {
        case 1: levelDuration = 1.2
        case 2: levelDuration  = 1
        case 3: levelDuration = 0.8
        case 4: levelDuration = 0.5
        default:
            levelDuration = 0.5
            print("Cannot find level info")
        }
        
        let spawn = SKAction.run(spawnEnemy)
        let waitToSpawn = SKAction.wait(forDuration: levelDuration)
        
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        
        self.run(spawnForever, withKey: "spawningEnemies")
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if currentGameState == .preGame{
            startGame()
        }
        
        else if currentGameState == .inGame{
            fireBullet()
        }
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            
            if currentGameState == .inGame{
                player.position.x += amountDragged
            }
            
            if player.position.x > gameArea.maxX - player.size.width/2 {
                player.position.x = gameArea.maxX - player.size.width/2
            }
            if player.position.x < gameArea.minX + player.size.width/2 {
                player.position.x = gameArea.minX + player.size.width/2
            }
            
            let amountDragged2 = pointOfTouch.y - previousPointOfTouch.y
            player.position.y += amountDragged2
            
            if player.position.y > gameArea.maxY - player.size.height/2 {
                player.position.y = gameArea.maxY - player.size.height/2
            }
            if player.position.y < gameArea.minY + player.size.height/2 {
                player.position.y = gameArea.minY + player.size.height/2
            }
            
            
            
        }
        
    }
    
    
    
    
    
  
}
