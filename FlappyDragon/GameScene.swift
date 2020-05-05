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
	var playerCategory: UInt32 = 1
	var enemyCategoty: UInt32 = 2
	var scoreCategory: UInt32 = 4
	var timer: Timer!
	weak var gameViewController: GameViewController?
	let scoreSound = SKAction.playSoundFileNamed("score.mp3", waitForCompletion: false)
	let gameOverSound = SKAction.playSoundFileNamed("hit.mp3", waitForCompletion: false)
	
    override func didMove(to view: SKView) {
		
		physicsWorld.contactDelegate = self
		
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
		invisibleFloor.physicsBody?.categoryBitMask = enemyCategoty
		invisibleFloor.physicsBody?.contactTestBitMask = playerCategory
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
		enemyTop.physicsBody?.categoryBitMask = enemyCategoty
		enemyTop.physicsBody?.contactTestBitMask = playerCategory
		
		enemyBottom.position = CGPoint(x: size.width + enemyWidth/2, y: enemyTop.position.y - enemyTop.size.height - enemyDistance)
		enemyBottom.zPosition = 1
		enemyBottom.physicsBody = SKPhysicsBody(rectangleOf: enemyBottom.size)
		enemyBottom.physicsBody?.isDynamic = false
		enemyBottom.physicsBody?.categoryBitMask = enemyCategoty
		enemyBottom.physicsBody?.contactTestBitMask = playerCategory
		
		// Criação de area de pontuação (entre os obstaculos)
		let laser = SKNode()
		laser.position = CGPoint(x: enemyTop.position.x + enemyWidth/2, y: enemyTop.position.y - enemyTop.size.height/2)
		laser.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: enemyDistance))
		laser.physicsBody?.isDynamic = false //a gravidade nao intefere nele
		laser.physicsBody?.categoryBitMask = scoreCategory
		
		// Aminação do enemy
		let distance 		= size.width + enemyWidth
		let duration 		= Double(distance)/velocity
		let moveAction 		= SKAction.moveBy(x: -distance, y: 0, duration: duration)
		let removeAction 	= SKAction.removeFromParent()
		let sequenceAction	= SKAction.sequence([moveAction, removeAction])
		
		enemyTop.run(sequenceAction)
		enemyBottom.run(sequenceAction)
		laser.run(sequenceAction)
		
		addChild(enemyTop)
		addChild(enemyBottom)
		addChild(laser)
	}
    
	func gameOver() {
		timer.invalidate()
		player.zRotation = 0
		player.texture = SKTexture(imageNamed: "playerDead")
		
		for node in self.children {
			node.removeAllActions()
		}
		player.physicsBody?.isDynamic = false
		gameFinished = true
		gameStarted = false
		
		Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { (timer) in
			let gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
			gameOverLabel.fontColor = .red
			gameOverLabel.fontSize = 40
			gameOverLabel.text = "Game Over"
			gameOverLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
			gameOverLabel.zPosition = 5
			self.addChild(gameOverLabel)
			self.restard = true
		}
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
				// Categoria de Bitmask
				player.physicsBody?.categoryBitMask = playerCategory
				// Detecção de Contato
				player.physicsBody?.contactTestBitMask = scoreCategory
				// Detecção de Colisão
				player.physicsBody?.collisionBitMask = enemyCategoty
				
				timer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { (timer) in
					self.spawEnemies()
				}
				
			} else {
				player.physicsBody?.velocity = CGVector.zero
				// Aplicação de impulso/força
				player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: flyForce))
			}
		} else {
			if restard {
				restard = false
				gameViewController?.presentScene()
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


// MARK: - Extensions

extension GameScene: SKPhysicsContactDelegate {
	
	func didBegin(_ contact: SKPhysicsContact) {
		if gameStarted {
			if contact.bodyA.categoryBitMask == scoreCategory || contact.bodyB.categoryBitMask == scoreCategory {
				score += 1
				scoreLabel.text = "\(score)"
				run(scoreSound)
			} else if contact.bodyA.categoryBitMask == enemyCategoty || contact.bodyB.categoryBitMask == enemyCategoty {
				gameOver()
				run(gameOverSound)
			}
		}
	}
	
}
