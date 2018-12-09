//
//  ViewController.swift
//  14154692_MBCoursework
//
//  Created by Gerron Tinoy on 08/11/2018.
//  Copyright © 2018 Gerron Tinoy. All rights reserved.
//

import UIKit

protocol subviewDelegate {
    func boatDragged()
}
class ViewController: UIViewController, subviewDelegate, UICollisionBehaviorDelegate {
    var dynamicAnimator: UIDynamicAnimator!
    var dynamicItemBehavior: UIDynamicItemBehavior!
    var collisionBehavior: UICollisionBehavior!
    
    var scoreTimer: Timer!
    var gameTimer: Timer!
    var objectAdder: Timer!
    
    var boat: DraggedImageView!
    var score = UILabel()
    
    var obstacleArray: [UIImageView]!
    var coinsArray: [UIImageView]!
    var boatUpdatedBounds: CGRect!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initialiseBackground()
        initialiseScores()
        initialiseAvatar()
        initialiseObsAndCoins()
        
        // Initializes the timer for the entire game (Finishes after 20 seconds)
        gameTimer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(ViewController.finishGame), userInfo: nil, repeats: true)
        
        objectAdder = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(ViewController.graduallyAddMoreObjects), userInfo: nil, repeats: true)
    }
    
    // ------------------------- INITIALISE METHODS -------------------------------//
    
    func initialiseBackground() {
        // Setup Background
        let seaView = UIImageView(image: UIImage(named: "Background.jpeg"))
        seaView.frame = UIScreen.main.bounds
        self.view.addSubview(seaView)
        
        //animation(viewAnimation: seaView, duration: 20)
    }
    
    private func animation(viewAnimation: UIView, duration: TimeInterval) {
        UIView.animate(withDuration: duration, animations: {
            viewAnimation.frame.origin.x = -viewAnimation.frame.width
        })
    }
    
    func initialiseScores() {
        // Create score label
        let scoreLabel = UILabel()
        scoreLabel.text = "Score:"
        scoreLabel.frame = CGRect(x:20, y: 20, width: 60, height: 20)
        scoreLabel.textColor = UIColor.white
        self.view.addSubview(scoreLabel)
        
        // Create and initialise score value
        score.text = "0"
        score.frame = CGRect(x:72, y: 20, width: 178, height: 20)
        score.textColor = UIColor.white
        self.view.addSubview(score)
        
        // Initializes the score value and upates them every 0.01 seconds.
        scoreTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(ViewController.updateScore), userInfo: nil, repeats: true)
    }
    
    func initialiseAvatar() {
        // Boat Animation and delegation
        boat = DraggedImageView(image: nil)
        boat.frame = CGRect(x:16, y: 276, width: 123, height: 79)
        boat.myDelegate = self
        var imageArray: [UIImage]!
        imageArray = [UIImage(named: "boat_1.png")!,
                      UIImage(named: "boat_2.png")!,
                      UIImage(named: "boat_3.png")!,
                      UIImage(named: "boat_4.png")!,
                      UIImage(named: "boat_5.png")!,
                      UIImage(named: "boat_6.png")!,
                      UIImage(named: "boat_7.png")!,
                      UIImage(named: "boat_8.png")!,
                      UIImage(named: "boat_9.png")!]
        boat.image = UIImage.animatedImage(with: imageArray, duration: 1)
        boat.isUserInteractionEnabled = true
        self.view.addSubview(boat)
        boatUpdatedBounds = getUpdatedObjectBoundary(object: boat)
    }
    
    func initialiseObsAndCoins() {
        // Initialise Obstacle Array
        obstacleArray = []
        
        // Initialise Coins Array
        coinsArray = []
        
        // Allows object bahaviours
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        
        // Enables the obstacles to be given a linear velocity
        dynamicItemBehavior = UIDynamicItemBehavior(items: [])
        dynamicItemBehavior.resistance = 0
        dynamicAnimator.addBehavior(dynamicItemBehavior)
        
        // Enables the obstacles to be given a collision behaviour
        collisionBehavior = UICollisionBehavior(items: [])
        collisionBehavior.collisionDelegate = self
        dynamicAnimator.addBehavior(collisionBehavior)
    }
    
    // ------------------------- Helper Methods -------------------------------//
    
    // Create x number of coins
    func addCoin() {
        let screenSize = UIScreen.main.bounds
        let randomXPos = CGFloat(screenSize.width)
        let randomYPos = CGFloat(arc4random_uniform(UInt32(screenSize.height)))
        
        let coin = UIImageView(image: nil)
        coin.image = UIImage(named: "coin.png")
        coin.frame = CGRect(x:randomXPos, y: randomYPos, width: 20, height: 20)
        coinsArray.append(coin)
        self.view.addSubview(coin)
        
        dynamicItemBehavior.addItem(coin)
        self.dynamicItemBehavior.addLinearVelocity(CGPoint(x: -75, y: 0), for: coin)
        collisionBehavior.addItem(coin)
        
    }
    
    // Create x number of obstacles
    func addObstacle() {
        let screenSize = self.view.bounds
        let randomXPos = CGFloat(screenSize.width)
        let randomYPos = CGFloat(arc4random_uniform(UInt32(screenSize.height)))

        let obstacle = UIImageView(image: nil)
        obstacle.image = UIImage(named: "rock.png")
        obstacle.frame = CGRect(x:randomXPos, y: randomYPos, width: 30, height: 30)
        obstacleArray.append(obstacle)
        self.view.addSubview(obstacle)
        
        dynamicItemBehavior.addItem(obstacle)
        self.dynamicItemBehavior.addLinearVelocity(CGPoint(x: -75, y: 0), for: obstacle)
        collisionBehavior.addItem(obstacle)
    }
    
    // Returns the obstacle boundary that corresponds to their current position
    func getUpdatedObjectBoundary(object: UIImageView) -> CGRect{
        let obstacleBoundary: CGRect!
        obstacleBoundary = CGRect(
            origin: CGPoint(x: object.center.x - (object.bounds.size.width/2),
                            y: object.center.y - (object.bounds.size.height/2)),
            size: object.bounds.size)
        return obstacleBoundary
    }
    
    // ------------------------- Automatically Called Methods ------------------------//
    
    // Updates Boat Boundaries upon dragging
    func boatDragged() {
        collisionBehavior.removeAllBoundaries()
        boatUpdatedBounds = getUpdatedObjectBoundary(object: boat)
        collisionBehavior.addBoundary(withIdentifier: "boatRockCollisionPoint" as NSString, for: UIBezierPath(rect: boatUpdatedBounds))
    }
    //
    func graduallyAddMoreObjects() {
        let num = arc4random_uniform(_:3)
        if num == 0 {
            addCoin()
        } else if num == 1 {
            addObstacle()
        } else if num == 2 {
            addCoin()
            addObstacle()
        }
    }
    
    // Updates the score every 0.01 seconds.
    func updateScore() {
        score.text = String(Int(score.text!)! + 73)
    }
    
    // Stops the game after 20 seconds and finalises the score.
    func finishGame() {
        scoreTimer.invalidate()
        gameTimer.invalidate()
        objectAdder.invalidate()
        // trigger game over screen
        callGameOverScreen()
    }
    
    func callGameOverScreen() {
        // Create score label
        // let gameOverScreen = self.storyboard?.instantiateViewController(withIdentifier: "GameOver")
        //let scoreGO = UILabel()
        //scoreGO.text = "Score: " + score.text!
        //scoreGO.frame = CGRect(x:80, y: 80, width: 100, height: 50)
        //gameOverScreen?.view.addSubview(scoreGO)
        //performSegue(withIdentifier: "GameOver", sender: self)
        
        //ADD REPLAY
        
    }
    
    // Triggered by boat collision on objects
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        let deductScore = 940 // can change
        let increaseScore = 1200 // can change
        let itemObject = item as! UIImageView
        
        // deduct score if boat has collided with an obstacle
        if obstacleArray.contains(itemObject) {
            if Int(score.text!)! > deductScore {
                score.text = String(Int(score.text!)! - deductScore)
            }
            // Change color of avatar
            boat.tintColor = UIColor.red
        }
        
        // increase score if the boat has collided with a coin
        if coinsArray.contains(itemObject) {
            score.text = String(Int(score.text!)! + increaseScore)
            (item as! UIImageView).image = nil
            coinsArray.remove(at: coinsArray.index(of: item as! UIImageView)!)
        }
        
    }

    // ------------------------- EXTRA Methods -------------------------------//
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

