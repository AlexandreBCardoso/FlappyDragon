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
    
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
}
