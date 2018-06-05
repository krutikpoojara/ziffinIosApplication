//
//  About_UsViewController.swift
//  SidebarMenu
//
//  Created by Developer on 15/12/15.
//  Copyright © 2015 AppCoda. All rights reserved.
//

import UIKit

class About_UsViewController: UIViewController {

   
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var aboutView: UIView!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
        self.automaticallyAdjustsScrollViewInsets = false
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = "revealToggle:"
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //txtView.contentInset = UIEdgeInsetsMake(-7.0,0.0,0,0.0);
        txtView.text = "         Are you sick and tired of eating outside and struggling for a homemade food ? Are you a bachelor living in hostel and looking for food that gives homely taste? We have brought a great solution for you! Yes, if you are bachelor living in PG or a hostel and craving for a homemade food then we have a great option for you. Many times you might have told your friends,Ghar ka khana Ghar ka hota hai! \n\n         This tempted us to start delicious Tiffin service right at your door step. The best thing is that you can place your order monthly or just a particular meal. We offer service which is convenient as per you.\n\n         We are a team of young passionate people who believe in providing hygienic food in the heart of Gujarat that is Ahmedabad. Our aim is to provide a reliable hygienic food service in Ahmedabad. We guarantee you tasty and healthy food according to your need! Nothing is more prior to us than quality"
        
        txtView.editable = false

        ViewCornor()
        // Do any additional setup after loading the view.
    }
    
    func ViewCornor()
    {
        aboutView.layer.cornerRadius = 5
        aboutView.layer.borderWidth = 0
        aboutView.layer.borderColor = UIColor.redColor().CGColor
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
