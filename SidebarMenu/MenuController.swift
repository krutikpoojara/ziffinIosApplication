//
//  MenuController.swift
//  SidebarMenu
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit
//import MBProgressHUD

class MenuController: UITableViewController {

    
    var arrName1 = ["Home","Login","About Us","Contact Us","Feedback"]
    var arrImg1 = ["ic_home","ic_people","aboutus","contactus","feddback"]
    
    var arrName2 = ["Home","Today Orders","Your Orders","About Us","Contact Us","Feedback","Logout"]
    var arrImg2 = ["profile","ic_home","todayorderlist","orderlist","aboutus","contactus","feddback","logout"]
    
    var defaults : NSUserDefaults!
    var success : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        defaults = NSUserDefaults.standardUserDefaults()
        success = defaults?.boolForKey("Login")
        
        tableView.backgroundColor = appDelegate.colorWithHexString("#B3FF3333")
        tableView.separatorColor = UIColor.blackColor()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if success == true
        {
         return arrName2.count + 1
        }
        else
        {
         return arrName1.count
        }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! DetailTableViewCell
        
        cell.backgroundColor = appDelegate.colorWithHexString("#B3FF3333")
        
        if success == true
        {
         if indexPath.row == 0
         {
          let defaults = NSUserDefaults.standardUserDefaults().objectForKey("name") as! String
          cell.lblName.text = defaults
         }
         else
         {
          cell.lblName.text = arrName2[indexPath.row - 1]
         }
          cell.imgIcon.image = UIImage(named: arrImg2[indexPath.row])
        }
        else
        {
         cell.lblName.text = arrName1[indexPath.row]
         cell.imgIcon.image = UIImage(named: arrImg1[indexPath.row])
        }
        
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.redColor()
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        let revealController = revealViewController()
        if success == true
        {
          if indexPath.row == 0
          {
            let front = story.instantiateViewControllerWithIdentifier("profile") as! ProfileViewController
            let nav = UINavigationController(rootViewController: front)
            revealController.pushFrontViewController(nav, animated: true)
          }
          else if indexPath.row == 1
          {
            let front = story.instantiateViewControllerWithIdentifier("home") as! HomeViewController
            let nav = UINavigationController(rootViewController: front)
            revealController.pushFrontViewController(nav, animated: true)
          }
          else if indexPath.row == 2
          {
            let front = story.instantiateViewControllerWithIdentifier("todayOrder") as! TodayOrderListViewController
            let nav = UINavigationController(rootViewController: front)
            revealController.pushFrontViewController(nav, animated: true)
          }
          else if indexPath.row == 3
          {
            let front = story.instantiateViewControllerWithIdentifier("currentOrder") as! CurrentOrderViewController
            let nav = UINavigationController(rootViewController: front)
            revealController.pushFrontViewController(nav, animated: true)
          }
          else if indexPath.row == 4
          {
            let front = story.instantiateViewControllerWithIdentifier("about") as! About_UsViewController
            let nav = UINavigationController(rootViewController: front)
            revealController.pushFrontViewController(nav, animated: true)
          }
          else if indexPath.row == 5
          {
            let front = story.instantiateViewControllerWithIdentifier("contact") as! ContactViewController
            let nav = UINavigationController(rootViewController: front)
            revealController.pushFrontViewController(nav, animated: true)
          }
          else if indexPath.row == 6
          {
            let front = story.instantiateViewControllerWithIdentifier("feedback") as! FeedbackViewController
            let nav = UINavigationController(rootViewController: front)
            revealController.pushFrontViewController(nav, animated: true)
          }
          else if indexPath.row == 7
          {
           defaults.removeObjectForKey("Login")
           defaults.removeObjectForKey("u_id")
           defaults.removeObjectForKey("email")
           defaults.removeObjectForKey("name")
            
           appDelegate.rootVC()
          }
        }
        else
        {
        if indexPath.row == 0
        {
            let front = story.instantiateViewControllerWithIdentifier("home") as! HomeViewController
            let nav = UINavigationController(rootViewController: front)
            revealController.pushFrontViewController(nav, animated: true)
        }
        else if indexPath.row == 1
        {
            let front = story.instantiateViewControllerWithIdentifier("login") as! LoginViewController
            let nav = UINavigationController(rootViewController: front)
            revealController.pushFrontViewController(nav, animated: true)
        }
        else if indexPath.row == 2
        {
            let front = story.instantiateViewControllerWithIdentifier("about") as! About_UsViewController
            let nav = UINavigationController(rootViewController: front)
            revealController.pushFrontViewController(nav, animated: true)
        }
        else if indexPath.row == 3
        {
            let front = story.instantiateViewControllerWithIdentifier("contact") as! ContactViewController
            let nav = UINavigationController(rootViewController: front)
            revealController.pushFrontViewController(nav, animated: true)
        }
        else if indexPath.row == 4
        {
            let front = story.instantiateViewControllerWithIdentifier("feedback") as! FeedbackViewController
            let nav = UINavigationController(rootViewController: front)
            revealController.pushFrontViewController(nav, animated: true)
        }
        }


    }
    override func viewDidLayoutSubviews() {
        tableView.scrollEnabled = false
    }
   override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
