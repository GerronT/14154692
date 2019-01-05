//
//  DraggedImageView.swift
//  14154692_MBCoursework
//
//  Created by Gerron Tinoy on 16/11/2018.
//  Copyright © 2018 Gerron Tinoy. All rights reserved.
//

import UIKit

class DraggedImageView: UIImageView {
    
    var myDelegate: subviewDelegate?
    
    var startLocation: CGPoint?
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        startLocation = touches.first?.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let currentLocation = touches.first?.location(in: self)
        let dx = currentLocation!.x - startLocation!.x
        let dy = currentLocation!.y - startLocation!.y
        
        var newcenter = CGPoint(x: self.center.x+dx, y: self.center.y+dy)
        
        //Constrain movement into parent bounds
        let halfx = self.bounds.midX
        newcenter.x = max(halfx, newcenter.x);
        newcenter.x = min((self.superview?.bounds.size.width)! - halfx,newcenter.x);
        let halfy = self.bounds.midY
        newcenter.y = max(halfy, newcenter.y);
        newcenter.y = min((self.superview?.bounds.size.height)! - halfy,newcenter.y);
        
        // Set new location
        self.center = newcenter;
        
        self.myDelegate?.boatDragged()
    }
    
    //func getLocationPoints() -> UIEdgeInsets {
    //    return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    //}
    
    
    
}
