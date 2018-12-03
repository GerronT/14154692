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
    var scoreTimer: Timer!
    var gameTimer: Timer!
    
    var backgroundImage: UIImageView!
    @IBOutlet weak var boatImage: DraggedImageView!
    @IBOutlet weak var rock: UIImageView!
    @IBOutlet weak var score: UILabel!
    
    var boatUpdatedBounds: CGRect!
    var scoreValue: Int!
    
    func boatDragged() {
        collisionBehavior.removeAllBoundaries()
        boatUpdatedBounds = CGRect(origin: CGPoint(x: boatImage.center.x - (boatImage.bounds.width/2), y: boatImage.center.y - (boatImage.bounds.height/2)), size: boatImage.bounds.size)
        collisionBehavior.addBoundary(withIdentifier: "boatRockCollisionPoint" as NSString, for: UIBezierPath(rect: boatUpdatedBounds))
        
        if (boatCollides()) {
            scoreValue = scoreValue - 9402
            rock.removeFromSuperview()
            rock = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreValue = 0
        scoreTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(ViewController.updateScore), userInfo: nil, repeats: true)
        gameTimer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(ViewController.finishGame), userInfo: nil, repeats: true)
        boatImage.myDelegate = self
        // Do any additional setup after loading the view, typically from a nib.
        self.backgroundImage = UIImageView(image: UIImage(named: "Background.jpeg"))
        self.backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(self.backgroundImage, at: 0)
        
        //Boat Animation
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
        
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        
        dynamicItemBehavior = UIDynamicItemBehavior(items: [rock])
        self.dynamicItemBehavior.addLinearVelocity(CGPoint(x: -50, y: 0), for: rock)
        dynamicAnimator.addBehavior(dynamicItemBehavior)

        collisionBehavior = UICollisionBehavior(items: [rock])
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        dynamicAnimator.addBehavior(collisionBehavior)
    }
    
    func boatCollides() -> Bool {
        if (rock != nil && boatUpdatedBounds.intersects(CGRect(origin: CGPoint(x: rock.center.x - (rock.bounds.size.width/2), y: rock.center.y - (rock.bounds.size.height/2)), size: rock.bounds.size))) {
            return true
        }
        return false
    }
    
    func updateScore() {
        // fired once a second
        scoreValue = scoreValue + 73
        score.text = String(scoreValue)
    }
    
    func finishGame() {
        scoreTimer.invalidate()
        score.text = "Final Score: " + score.text!
        gameTimer.invalidate()
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

