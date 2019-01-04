//
//  ViewControllerLaunch.swift
//  14154692_MBCoursework
//
//  Created by Gerron Tinoy on 04/01/2019.
//  Copyright © 2019 Gerron Tinoy. All rights reserved.
//

import UIKit

class ViewControllerLaunch: UIViewController {

    @IBOutlet weak var PlayButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        PlayButton.addTarget(self, action: #selector(viewDidLoad), for: .touchUpInside)
    }
    
    func playGame() {
        let newGame = ViewController()
        newGame.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
