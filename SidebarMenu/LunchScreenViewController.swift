//
//  LunchScreenViewController.swift
//  SidebarMenu
//
//  Created by Pixster Studio on 17/12/15.
//  Copyright © 2015 AppCoda. All rights reserved.
//

import UIKit

class LunchScreenViewController: UIViewController {

    @IBOutlet var img: UIImageView!
    
    @IBOutlet var img1: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        img.alpha = 0.0
        leftToRight()
        fadeOut()
                //  sleep(4)
        //appDelegate.rootVC()
            }
    
    func fadeOut() {
        UIView.animateWithDuration(4.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.img.alpha = 1.0
            }, completion: { (success) -> Void in
                
                appDelegate.rootVC()
            }
)
    }
    
    func leftToRight()
    {
        UIView.animateWithDuration(4.0) { () -> Void in
            self.img1.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width - 120,0)
        }
    }
  
    
    

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
