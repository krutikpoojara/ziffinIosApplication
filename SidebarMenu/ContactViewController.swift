//
//  ContactViewController.swift
//  SidebarMenu
//
//  Created by Developer on 15/12/15.
//  Copyright © 2015 AppCoda. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {

    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnTwitter: UIButton!
    @IBOutlet weak var btnFb: UIButton!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = "revealToggle:"
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        ButtonCornor()
        // Do any additional setup after loading the view.
    }

    func ButtonCornor()
    {
        btnGoogle.layer.cornerRadius = 5
        btnGoogle.layer.borderWidth = 0
        btnGoogle.layer.borderColor = UIColor.whiteColor().CGColor
        
        btnTwitter.layer.cornerRadius = 5
        btnTwitter.layer.borderWidth = 0
        btnTwitter.layer.borderColor = UIColor.whiteColor().CGColor
        
        btnFb.layer.cornerRadius = 5
        btnFb.layer.borderWidth = 0
        btnFb.layer.borderColor = UIColor.whiteColor().CGColor
        
        contactView.layer.cornerRadius = 5
        contactView.layer.borderWidth = 0
        contactView.layer.borderColor = UIColor.redColor().CGColor

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
