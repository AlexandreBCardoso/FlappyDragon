//
//  GameViewController.swift
//  FlappyDragon
//
//  Created by Alexandre Cardoso on 01/05/20.
//  Copyright © 2020 Alexandre Cardoso. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

var stage: SKView!


class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		stage = view as? SKView
		stage.ignoresSiblingOrder = true
		
		presentScene()
    }
	
	// Metodo para mostrar a Scene
	// Cria o tamanho minimo da Scena (aparelho - iphone 5)
	// Configura a scene para aumentar caso o aparelho seja maior
	func presentScene() {
		let scene = GameScene(size: CGSize(width: 320, height: 568))
		scene.scaleMode = .aspectFill
		stage.presentScene(scene)
	}

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
