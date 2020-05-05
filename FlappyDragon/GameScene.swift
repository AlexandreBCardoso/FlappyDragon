//
//  GameScene.swift
//  FlappyDragon
//
//  Created by Alexandre Cardoso on 01/05/20.
//  Copyright © 2020 Alexandre Cardoso. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
	var floor: SKSpriteNode!
	var intro: SKSpriteNode!
	var player: SKSpriteNode!
	var gameArea: CGFloat = 410.0
	var velocity: Double = 100.0
	var gameFinished: Bool = false
	var gameStarted: Bool = false
	var restard = false
	var scoreLabel: SKLabelNode!
	var score: Int = 0
	var flyForce: CGFloat = 30.0
	
    override func didMove(to view: SKView) {
		addBackground()
		addFloor()
		addIntro()
		addPlayer()
		moveFloor()
    }
	
	
	// MARK: - Métodos Node
	
	// Adiciona uma Imagem no Background da Scene
	func addBackground() {
		let background 			= SKSpriteNode(imageNamed: "background")
		background.position		= CGPoint(x: self.size.width/2, y: self.size.height/2)
		background.zPosition	= 0
		addChild(background)
	}
	
	// Adiciona o chão na Scene
	func addFloor() {
		floor 			= SKSpriteNode(imageNamed: "floor")
		floor.zPosition	= 2
		floor.position 	= CGPoint(x: floor.size.width/2, y: size.height - gameArea - floor.size.height/2)
		addChild(floor)
		
		let invisibleFloor = SKNode()
		invisibleFloor.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: 1))
		invisibleFloor.physicsBody?.isDynamic = false
		invisibleFloor.position = CGPoint(x: size.width/2, y: size.height - gameArea)
		invisibleFloor.zPosition = 2
		addChild(invisibleFloor)
		
		let invisibleRoof = SKNode()
		invisibleRoof.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: 1))
		invisibleRoof.physicsBody?.isDynamic = false
		invisibleRoof.position = CGPoint(x: size.width/2, y: size.height)
		invisibleRoof.zPosition = 2
		addChild(invisibleRoof)
	}
	
	// Adiciona o imagem de Introdução
	func addIntro() {
		intro 			= SKSpriteNode(imageNamed: "intro")
		intro.zPosition	= 3
		intro.position 	= CGPoint(x: size.width/2, y: size.height - 210)
		addChild(intro)
	}
	
	// Adiciona o Player na Scene
	func addPlayer() {
		player 				= SKSpriteNode(imageNamed: "player1")
		player.zPosition	= 4
		player.position 	= CGPoint(x: 60, y: size.height - gameArea/2)
		animatePlayer()
		addChild(player)
	}
	
	// Método para Animação do Player
	func animatePlayer() {
		var playerTexture = [SKTexture]()
		for player in 1...4 {
			playerTexture.append(SKTexture(imageNamed: "player\(player)"))
		}
		let animationAction = SKAction.animate(with: playerTexture, timePerFrame: 0.09)
		let repeatAction = SKAction.repeatForever(animationAction)
		player.run(repeatAction)
	}
	
	// Método para Animar o Chão
	func moveFloor() {
		let duration = Double(floor.size.width/2) / velocity
		let moveFloorAction = SKAction.moveBy(x: -floor.size.width/2, y: 0, duration: duration)
		let resetXAction = SKAction.moveBy(x: floor.size.width/2, y: 0, duration: 0)
		let sequenciAction = SKAction.sequence([moveFloorAction, resetXAction])
		let repeatAction = SKAction.repeatForever(sequenciAction)
		floor.run(repeatAction)
	}
	
	func addScore() {
		scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
		scoreLabel.fontSize = 94
		scoreLabel.text = "\(score)"
		scoreLabel.zPosition = 5
		scoreLabel.position = CGPoint(x: size.width/2, y: size.height - 100)
		scoreLabel.alpha = 0.8
		addChild(scoreLabel)
	}
	
	func spawEnemies() {
		let initialPosition	= CGFloat(arc4random_uniform(132) + 74)
		let enemyNumber 	= Int(arc4random_uniform(4) + 1)
		let enemyDistance 	= self.player.size.height * 2.5
		let enemyTop 		= SKSpriteNode(imageNamed: "enemytop\(enemyNumber)")
		let enemyBottom 	= SKSpriteNode(imageNamed: "enemybottom\(enemyNumber)")
		let enemyWidth 		= enemyTop.size.width
		let enemyHeight 	= enemyTop.size.height
		
		enemyTop.position = CGPoint(x: size.width + enemyWidth/2, y: size.height - initialPosition + enemyHeight/2)
		enemyTop.zPosition = 1
		enemyTop.physicsBody = SKPhysicsBody(rectangleOf: enemyTop.size)
		enemyTop.physicsBody?.isDynamic = false
		
		enemyBottom.position = CGPoint(x: size.width + enemyWidth/2, y: enemyTop.position.y - enemyTop.size.height - enemyDistance)
		enemyBottom.zPosition = 1
		enemyBottom.physicsBody = SKPhysicsBody(rectangleOf: enemyBottom.size)
		enemyBottom.physicsBody?.isDynamic = false
		
		// Aminação do enemy
		let distance 		= size.width + enemyWidth
		let duration 		= Double(distance)/velocity
		let moveAction 		= SKAction.moveBy(x: -distance, y: 0, duration: duration)
		let removeAction 	= SKAction.removeFromParent()
		let sequenceAction	= SKAction.sequence([moveAction, removeAction])
		
		enemyTop.run(sequenceAction)
		enemyBottom.run(sequenceAction)
		
		addChild(enemyTop)
		addChild(enemyBottom)
		
		
	}
    
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		if !gameFinished {
			if !gameStarted {
				intro.removeFromParent()
				addScore()
				gameStarted = true
				
				// Criação de um Corpo Físico
				player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2 - 10)
				// Adicionando gravidade
				player.physicsBody?.isDynamic = true
				// Adicionando opção para rotacionar
				player.physicsBody?.allowsRotation = true
				// Aplicação de impulso/força
				player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: flyForce))
				
				Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { (timer) in
					self.spawEnemies()
				}
				
			} else {
				player.physicsBody?.velocity = CGVector.zero
				// Aplicação de impulso/força
				player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: flyForce))
			}
		}
    }
    
    override func update(_ currentTime: TimeInterval) {
		if gameStarted {
			let yVelocity = player.physicsBody!.velocity.dy * 0.001 as CGFloat
			player.zRotation = yVelocity
		}
    }
}
