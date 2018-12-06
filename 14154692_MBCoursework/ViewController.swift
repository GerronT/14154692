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
    
    var scoreValue: Int!
    var scoreTimer: Timer!
    var gameTimer: Timer!
    
    @IBOutlet weak var boatImage: DraggedImageView!
    @IBOutlet weak var score: UILabel!
    
    var backgroundImage: UIImageView!
    
    var obstacleArray: [UIImageView]!
    var coinsArray: [UIImageView]!
    var boatUpdatedBounds: CGRect!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Initializes the score value and upates them every 0.01 seconds.
        scoreValue = 0
        scoreTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(ViewController.updateScore), userInfo: nil, repeats: true)
        
        // Initializes the timer for the entire game (Finishes after 20 seconds)
        gameTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(ViewController.finishGame), userInfo: nil, repeats: true)
        
        
        // Setups the background for the game
        self.backgroundImage = UIImageView(image: UIImage(named: "Background.jpeg"))
        self.backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(self.backgroundImage, at: 0)
        
        // Boat Animation and delegation
        boatImage.myDelegate = self
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
        boatImage.image = UIImage.animatedImage(with: imageArray, duration: 1)
        boatUpdatedBounds = getUpdatedObjectBoundary(object: boatImage)
        
        // Create obstacles and add to array
        obstacleArray = []
        createObstacles(num: 5)
        
        // Create coins and add to array
        coinsArray = []
        createCoins(num: 3)
        
        // Allows object bahaviours
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        
        // Enables the obstacles to be given a linear velocity
        dynamicItemBehavior = UIDynamicItemBehavior(items: obstacleArray + coinsArray)
        addObjectVelocity()
        dynamicAnimator.addBehavior(dynamicItemBehavior)

        // Enables the obstacles to be given a collision behaviour
        collisionBehavior = UICollisionBehavior(items: obstacleArray + coinsArray)
        collisionBehavior.collisionDelegate = self
        dynamicAnimator.addBehavior(collisionBehavior)
    }
    
    func createCoins(num: Int) {
        let screenSize = UIScreen.main.bounds
        var count = num
        while count > 0 {
            let randomXPos = CGFloat(arc4random_uniform(UInt32(screenSize.width)))
            let randomYPos = CGFloat(arc4random_uniform(UInt32(screenSize.height)))
            let coin = UIImageView(image: nil)
            coin.image = UIImage(named: "coin.png")
            coin.frame = CGRect(x:randomXPos, y: randomYPos, width: 20, height: 20)
            coinsArray.append(coin)
            self.view.addSubview(coin)
            count = count-1
        }
    }
    
    func createObstacles(num: Int) {
        let screenSize = UIScreen.main.bounds
        var count = num
        while count > 0 {
            let randomXPos = CGFloat(arc4random_uniform(UInt32(screenSize.width)))
            let randomYPos = CGFloat(arc4random_uniform(UInt32(screenSize.height)))
            let obstacle = UIImageView(image: nil)
            obstacle.image = UIImage(named: "rock.png")
            obstacle.frame = CGRect(x:randomXPos, y: randomYPos, width: 30, height: 30)
            obstacleArray.append(obstacle)
            self.view.addSubview(obstacle)
            count = count-1
        }
    }
    
    // Executes this method everytime the boat is dragged to update its boundaries
    func boatDragged() {
        collisionBehavior.removeAllBoundaries()
        boatUpdatedBounds = getUpdatedObjectBoundary(object: boatImage)
        collisionBehavior.addBoundary(withIdentifier: "boatRockCollisionPoint" as NSString, for: UIBezierPath(rect: boatUpdatedBounds))
    }
    
    // Gives linear velocity to an array of obstacles
    func addObjectVelocity() {
        for ob in obstacleArray {
            self.dynamicItemBehavior.addLinearVelocity(CGPoint(x: -75, y: 0), for: ob)
        }
        
        for coin in coinsArray {
            self.dynamicItemBehavior.addLinearVelocity(CGPoint(x: -75, y: 0), for: coin)
        }
        
    }
    
    // Updates the score every 0.01 seconds. Also checks if the boat has collided
    // with any of the obstacles in the array.
    func updateScore() {
        // fired once a second
        scoreValue = scoreValue + 73
        score.text = String(scoreValue)
    }
    
    // Stops the game after 20 seconds and finalises the score.
    func finishGame() {
        scoreTimer.invalidate()
        score.text = "Final Score: " + score.text!
        gameTimer.invalidate()
    }
    
    // Check if the boat has collided with any of the obstacles
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        let deductScore = 940
        let increaseScore = 1200
        if obstacleArray.contains(item as! UIImageView) {
            if scoreValue > deductScore {
                scoreValue = scoreValue - deductScore
            }
            // Change color of avatar
            boatImage.tintColor = UIColor.red
        }
        
        if coinsArray.contains(item as! UIImageView) {
            scoreValue = scoreValue + increaseScore
            (item as! UIImageView).image = nil
            coinsArray.remove(at: coinsArray.index(of: item as! UIImageView)!)
        }
        
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
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.backgroundImage.frame = self.view.bounds
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

