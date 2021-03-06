//
//  GameScene.swift
//  TouchMenu
//
//  Created by SergeantSA on 8/11/15.
//  Copyright (c) 2015 SergeantSoft. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    let letterA = SKSpriteNode(imageNamed: "letterA")
    let letterB = SKSpriteNode(imageNamed: "letterB")
    let letterC = SKSpriteNode(imageNamed: "letterC")
    var selectedNode: SKSpriteNode?
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        let background = SKSpriteNode(imageNamed: "background")
        background.anchorPoint = CGPointZero
        self.addChild(background)
        letterC.position = CGPoint(x: 611.0, y: 412.0)
        letterC.name = "letter C"
        self.addChild(letterC)
        letterB.position = CGPoint(x: 444.0, y: 502.0)
        letterB.name = "letter B"
        self.addChild(letterB)
        letterA.position = CGPoint(x: 440.0, y: 388.0)
        letterA.name = "letter A"
        self.addChild(letterA)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let positionInScene = touch.locationInNode(self)
        selectNodeForTouch(positionInScene)
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let positionInScene = touch.locationInNode(self)
        let previousPosition = touch.previousLocationInNode(self)
        let translation = CGPoint(x: positionInScene.x - previousPosition.x, y: positionInScene.y - previousPosition.y)
        if translation != CGPointZero { selectedNode = nil }
        panForTranslation(translation)
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if selectedNode != nil {
            doTapAction()
        }
    }
    
    func selectNodeForTouch(touchLocation: CGPoint) {
        let touchedNode = self.nodeAtPoint(touchLocation)
        if touchedNode is SKSpriteNode {
            selectedNode = touchedNode as? SKSpriteNode
            if (selectedNode!.name == nil) {
                selectedNode = nil
            }
        }
    }
    
    func doTapAction() {
        if let tappedLetter = selectedNode {
            let alertController = UIAlertController(title: "Tap Letter", message: String(format: "You tap %@", tappedLetter.name!), preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alertController.addAction(okAction)
            if let vc = self.view?.window?.rootViewController {
                vc.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func panForTranslation(translation: CGPoint) {
        let aNewPosition = CGPoint(x: letterA.position.x + translation.x, y: letterA.position.y)
        let newAPosition = boundLayerPos(aNewPosition)
        let aNewTranslation = CGPoint(x: newAPosition.x - letterA.position.x, y: translation.y)
        letterA.position = newAPosition
        letterB.position = CGPoint(x: letterB.position.x + 0.7 * aNewTranslation.x, y: letterB.position.y)
        letterC.position = CGPoint(x: letterC.position.x + 0.5 * aNewTranslation.x, y: letterC.position.y)
    }
    
    func boundLayerPos(aNewPosition: CGPoint) -> CGPoint {
        let offsetLetterA = letterA.size.width / 2
        var retval = aNewPosition
        retval.x = CGFloat(max(retval.x, offsetLetterA))
        retval.x = CGFloat(min(retval.x, self.size.width - offsetLetterA))
        
        return retval
    }
}
