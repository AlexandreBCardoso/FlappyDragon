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
import AVFoundation

class GameViewController: UIViewController {
	
	var stage: SKView!
	var musicPlayer: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
		stage = view as? SKView
		stage.ignoresSiblingOrder = true
		
		presentScene()
		playMusic()
    }
	
	// Metodo para mostrar a Scene
	// Cria o tamanho minimo da Scena (aparelho - iphone 5)
	// Configura a scene para aumentar caso o aparelho seja maior
	func presentScene() {
		let scene = GameScene(size: CGSize(width: 320, height: 568))
		scene.gameViewController = self
		scene.scaleMode = .aspectFill
		stage.presentScene(scene, transition: .doorsCloseVertical(withDuration: 0.5))
	}
	
	func playMusic() {
		if let musicURL = Bundle.main.url(forResource: "music", withExtension: "m4a") {
			musicPlayer = try! AVAudioPlayer(contentsOf: musicURL)
			musicPlayer.numberOfLoops = -1
			musicPlayer.volume = 0.4
			musicPlayer.play()
		}
	}

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
