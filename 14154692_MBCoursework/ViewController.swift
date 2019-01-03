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
        
        // Gradually add more coins, obstacles and seafloor objects every second
        objectAdder = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.graduallyAddMoreObjects), userInfo: nil, repeats: true)
    }
    
    // ------------------------- INITIALISE METHODS -------------------------------//
    
    func initialiseBackground() {
        // Setup Background
        self.view.backgroundColor = UIColor.blue
        let seaView = UIImageView(image: UIImage(named: "underwaterBack.png"))
        seaView.frame = CGRect(x:0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        let seaFloor = UIImageView(image: UIImage(named: "seafloor.png"))
        seaFloor.frame = CGRect(x:0, y: 350, width: (UIScreen.main.bounds.width), height: 65)
        
        animateOb(ob: seaView, duration: 3)
        animateOb(ob: seaFloor, duration: 5)

    }
    func animateOb(ob: UIImageView, duration: TimeInterval) {
        let obA = UIImageView(image: ob.image)
        let obB = UIImageView(image: ob.image)
        obA.frame = ob.frame
        obB.frame = ob.frame
        obB.frame.origin.x = ob.frame.width
        
        self.view.addSubview(obA)
        self.view.addSubview(obB)
        
        UIImageView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear,.repeat], animations: {
            obA.frame.origin.x = -obA.frame.width
            obB.frame.origin.x = 0
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
        imageArray = [UIImage(named: "submarine1.png")!,
                      UIImage(named: "submarine2.png")!,
                      UIImage(named: "submarine3.png")!,
                      UIImage(named: "submarine4.png")!,
                      UIImage(named: "submarine5.png")!,]
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
        
        var cnsArray: [UIImage]!
        cnsArray = [UIImage(named: "coin1.png")!,
                    UIImage(named: "coin2.png")!,
                    UIImage(named: "coin3.png")!,
                    UIImage(named: "coin4.png")!,
                    UIImage(named: "coin5.png")!,]
        coin.image = UIImage.animatedImage(with: cnsArray, duration: 1)
        
        coin.frame = CGRect(x:randomXPos, y: randomYPos, width: 20, height: 20)
        coinsArray.append(coin)
        self.view.addSubview(coin)
        
        dynamicItemBehavior.addItem(coin)
        self.dynamicItemBehavior.addLinearVelocity(CGPoint(x: -200, y: 0), for: coin)
        collisionBehavior.addItem(coin)
        
    }
    
    // Create x number of obstacles
    func addObstacle() {
        let screenSize = self.view.bounds
        let randomXPos = CGFloat(screenSize.width)
        let randomYPos = CGFloat(arc4random_uniform(UInt32(screenSize.height)-75))

        let obstacle = UIImageView(image: nil)
        
        var obsArray: [UIImage]!
        obsArray = [UIImage(named: "shark1.png")!,
                      UIImage(named: "shark2.png")!,
                      UIImage(named: "shark3.png")!,
                      UIImage(named: "shark4.png")!,
                      UIImage(named: "shark5.png")!,]
        obstacle.image = UIImage.animatedImage(with: obsArray, duration: 1)
        
        obstacle.frame = CGRect(x:randomXPos, y: randomYPos, width: 130, height: 50)
        obstacleArray.append(obstacle)
        self.view.addSubview(obstacle)
        
        dynamicItemBehavior.addItem(obstacle)
        self.dynamicItemBehavior.addLinearVelocity(CGPoint(x: -200, y: 0), for: obstacle)
        collisionBehavior.addItem(obstacle)
    }
    
    func addFloorObject() {
        let screenSize = UIScreen.main.bounds
        let randomXPos = CGFloat(screenSize.width)
        
        let floorObjects = [
            ["bigStone1.png", 90, 90, 270],
            ["bigStone2.png", 90, 90, 280],
            ["bWeed1.png", 35, 45, 315],
            ["bWeed2.png", 35, 45, 315],
            ["bWeed3.png", 35, 45, 315],
            ["coral1.png", 90, 80, 310],
            ["coral2.png", 90, 80, 305],
            ["crab1.png", 30, 30, 340],
            ["crab2.png", 30, 30, 340],
            ["stone1.png", 45, 45, 320],
            ["stone2.png", 45, 45, 315],
            ["stone3.png", 45, 45, 330],
            ["weed1.png", 40, 50, 315],
            ["weed2.png", 40, 50, 315],
            ["weed3.png", 40, 50, 315]]
        
        let fOb = UIImageView(image: nil)
        let ran = arc4random_uniform(UInt32(floorObjects.count - 1))
        fOb.image = UIImage(named: floorObjects[Int(ran)][0] as! String)
        fOb.frame = CGRect(
            x:randomXPos,
            y: CGFloat(floorObjects[Int(ran)][3] as! Int),
            width: CGFloat(floorObjects[Int(ran)][1] as! Int),
            height: CGFloat(floorObjects[Int(ran)][2] as! Int)
        )
        self.view.addSubview(fOb)
        self.view.bringSubview(toFront: fOb)

        dynamicItemBehavior.addItem(fOb)
        self.dynamicItemBehavior.addLinearVelocity(CGPoint(x: -200, y: 0), for: fOb)
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
    
    // Updates Boat Boundaries upon dragging (uses Delegation from DraggedImageView)
    func boatDragged() {
        collisionBehavior.removeAllBoundaries()
        boatUpdatedBounds = getUpdatedObjectBoundary(object: boat)
        collisionBehavior.addBoundary(withIdentifier: "boatRockCollisionPoint" as NSString, for: UIBezierPath(rect: boatUpdatedBounds))
    }
    
    // Adds coins and obstacles randomly every second (uses Timer)
    func graduallyAddMoreObjects() {
        let num = arc4random_uniform(_:3)
        // will sometimes add coin, sometimes add obstacle, sometimes add both, sometimes add none
        if num == 0 || num == 1 {
            addCoin()
        } else if num == 2 {
            addObstacle()
        }
        
        addFloorObject()
    }
    
    // Updates the score every 0.01 seconds. (uses Timer)
    func updateScore() {
        score.text = String(Int(score.text!)! + 73)
    }
    
    // Stops the game after 20 seconds and finalises the score. (uses Timer)
    func finishGame() {
        scoreTimer.invalidate()
        gameTimer.invalidate()
        objectAdder.invalidate()
        // trigger game over screen
        callGameOverScreen()
    }
    
    // Triggers a segue to switch to game over scene
    func callGameOverScreen() {
        // BRING UP GAMEOVER SCREEN
        let gameOver = UIImageView()
        gameOver.frame = UIScreen.main.bounds
        gameOver.backgroundColor = UIColor.darkGray
        
        let gameOverLabel = UILabel()
        gameOverLabel.frame = CGRect(x: 310, y: 50, width: 300, height: 200)
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.textColor = UIColor.white
        
        let scoreGO = UILabel()
        scoreGO.frame = CGRect(x: 285, y:162, width:200, height:50)
        scoreGO.text = "Final Score: " + score.text!
        scoreGO.textColor = UIColor.white
        
        let replayBtn = UIButton(frame: CGRect(x: 315, y: 210, width: 100, height: 50))
        replayBtn.backgroundColor = .green
        replayBtn.setTitle("Replay", for: .normal)
        replayBtn.addTarget(self, action: #selector(viewDidLoad), for: .touchUpInside)
        
        self.view.addSubview(gameOver)
        self.view.addSubview(gameOverLabel)
        self.view.addSubview(scoreGO)
        self.view.addSubview(replayBtn)
        
        // SHOW FINAL SCORE
        // ADD REPLAY
    }
    
    // Triggered by boat colliding with objects
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        let deductScore = 200 // can change
        let increaseScore = 500 // can change
        let itemObject = item as! UIImageView
        
        if identifier.unsafelyUnwrapped as! String == "boatRockCollisionPoint" {
            // deduct score if boat has collided with an obstacle
            if obstacleArray.contains(itemObject) {
                var runShark: [UIImage]!
                runShark = [UIImage(named: "shark1.png")!.withHorizontallyFlippedOrientation(),
                            UIImage(named: "shark2.png")!.withHorizontallyFlippedOrientation(),
                            UIImage(named: "shark3.png")!.withHorizontallyFlippedOrientation(),
                            UIImage(named: "shark4.png")!.withHorizontallyFlippedOrientation(),
                            UIImage(named: "shark5.png")!.withHorizontallyFlippedOrientation(),]
                itemObject.image = UIImage.animatedImage(with: runShark, duration: 1)
                self.dynamicItemBehavior.addLinearVelocity(CGPoint(x: 200, y: 0), for: itemObject)
                if Int(score.text!)! > deductScore {
                    score.text = String(Int(score.text!)! - deductScore)
                }
                // Change color of avatar
                boat.tintColor = UIColor.red
            }
        
            // increase score if the boat has collided with a coin
            if coinsArray.contains(itemObject) {
                score.text = String(Int(score.text!)! + increaseScore)
                itemObject.image = nil
                coinsArray.remove(at: coinsArray.index(of: itemObject)!)
            }
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

