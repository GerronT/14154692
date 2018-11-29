//
//  ViewController.swift
//  14154692_MBCoursework
//
//  Created by Gerron Tinoy on 08/11/2018.
//  Copyright © 2018 Gerron Tinoy. All rights reserved.
//

import UIKit

protocol subviewDelegate {
    func changeSomething()
    
    
    
}
class ViewController: UIViewController, subviewDelegate {
    var dynamicAnimator: UIDynamicAnimator!
    var dynamicItemBehavior: UIDynamicItemBehavior!
    var collisionBehavior: UICollisionBehavior!
    
    var backgroundImage: UIImageView!
    @IBOutlet weak var boatImage: DraggedImageView!
    @IBOutlet weak var rock: UIImageView!
    @IBOutlet weak var bounds: UILabel!
    
    func changeSomething() {
        bounds.text = "Bounds: " + CGRect(origin: CGPoint(x: boatImage.center.x, y: boatImage.center.y), size: boatImage.bounds.size).debugDescription
        collisionBehavior.removeAllBoundaries()
        collisionBehavior.addBoundary(withIdentifier: "boatRockCollisionPoint" as NSString, for: UIBezierPath(rect: CGRect(origin: CGPoint(x: boatImage.center.x, y: boatImage.center.y), size: boatImage.bounds.size)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        // boatImage.center.x
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        dynamicAnimator.addBehavior(collisionBehavior)
        
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

