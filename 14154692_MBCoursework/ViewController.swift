//
//  ViewController.swift
//  14154692_MBCoursework
//
//  Created by Gerron Tinoy on 08/11/2018.
//  Copyright © 2018 Gerron Tinoy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var boatImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Do any additional setup after loading the view, typically from a nib.
        
        //Animation of walking
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
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

