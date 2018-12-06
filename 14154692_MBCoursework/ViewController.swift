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
class ViewController: UIViewController, subviewDelegate {
    var dynamicAnimator: UIDynamicAnimator!
    var dynamicItemBehavior: UIDynamicItemBehavior!
    var collisionBehavior: UICollisionBehavior!
    
    var scoreValue: Int!
    var scoreTimer: Timer!
    var collisionTimer: Timer!
    var gameTimer: Timer!
    
    @IBOutlet weak var boatImage: DraggedImageView!
    @IBOutlet weak var rock: UIImageView!
    @IBOutlet weak var rock2: UIImageView!
    @IBOutlet weak var rock3: UIImageView!
    @IBOutlet weak var score: UILabel!
    
    var backgroundImage: UIImageView!
    
    var obstacleArray: [UIImageView]!
    var boatUpdatedBounds: CGRect!
    
    var collided: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Initializes the score value and upates them every 0.01 seconds.
        scoreValue = 0
        scoreTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(ViewController.updateScore), userInfo: nil, repeats: true)
        
        // Checks if boat has collided every second
        collisionTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.boatCollides), userInfo: nil, repeats: true)
        
        // Initializes the timer for the entire game (Finishes after 20 seconds)
        gameTimer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(ViewController.finishGame), userInfo: nil, repeats: true)
        
        
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
        boatUpdatedBounds = CGRect(origin: CGPoint(x: boatImage.center.x - (boatImage.bounds.width/2), y: boatImage.center.y - (boatImage.bounds.height/2)), size: boatImage.bounds.size)
        
        // Initialize array of obstacles
        obstacleArray = [rock, rock2, rock3]
        
        // Enables obstacles to be given a behaviour
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        
        // Enables the obstacles to be given a linear velocity
        dynamicItemBehavior = UIDynamicItemBehavior(items: obstacleArray)
        addObstacleMovements()
        dynamicAnimator.addBehavior(dynamicItemBehavior)

        // Enables the obstacles to be given a collision behaviour
        collisionBehavior = UICollisionBehavior(items: obstacleArray)
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        dynamicAnimator.addBehavior(collisionBehavior)
    }
    
    // Executes this method everytime the boat is dragged to update its boundaries
    func boatDragged() {
        collisionBehavior.removeAllBoundaries()
        boatUpdatedBounds = CGRect(origin: CGPoint(x: boatImage.center.x - (boatImage.bounds.width/2), y: boatImage.center.y - (boatImage.bounds.height/2)), size: boatImage.bounds.size)
        collisionBehavior.addBoundary(withIdentifier: "boatRockCollisionPoint" as NSString, for: UIBezierPath(rect: boatUpdatedBounds))
    }
    
    // Gives linear velocity to an array of obstacles
    func addObstacleMovements() {
        for ob in obstacleArray {
            self.dynamicItemBehavior.addLinearVelocity(CGPoint(x: -50, y: 0), for: ob)
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
        collisionTimer.invalidate()
        score.text = "Final Score: " + score.text!
        gameTimer.invalidate()
    }
    
    // Check if the boat has collided with any of the obstacles every second
    func boatCollides() {
        for ob in obstacleArray {
            if boatUpdatedBounds.intersects(getObstacleBounds(obstacle: ob)) {
                scoreValue = scoreValue - 9402
                ob.removeFromSuperview()
                obstacleArray.remove(at: obstacleArray.index(of: ob)!)
            }
        }
    }
    
    // Returns the obstacle boundary that corresponds to their current position
    func getObstacleBounds(obstacle: UIImageView) -> CGRect{
        let obstacleBoundary: CGRect!
        obstacleBoundary = CGRect(
            origin: CGPoint(x: obstacle.center.x - (obstacle.bounds.size.width/2),
                            y: obstacle.center.y - (obstacle.bounds.size.height/2)),
            size: obstacle.bounds.size)
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

