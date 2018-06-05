//
//  AppDelegate.swift
//  SidebarMenu
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        let networkReach = Reachability.reachabilityForInternetConnection()
        let networkstatus = networkReach.currentReachabilityStatus()
        
        sleep(1)
        
        UINavigationBar.appearance().barTintColor = UIColor(patternImage: UIImage(named: "actionbarbg.png")!)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        IQKeyboardManager.sharedManager().enable = true
        
        return true
    }
    
    func rootVC()
    {
   
        let story = UIStoryboard(name: "Main", bundle: nil)
        let menu = story.instantiateViewControllerWithIdentifier("menu")
        
        let front = story.instantiateViewControllerWithIdentifier("home")
        
        //let menvNav = UINavigationController(rootViewController: menu)
        
        let frontNav = UINavigationController(rootViewController: front)
        
        let revealController = SWRevealViewController(rearViewController: menu, frontViewController: frontNav)
        self.window?.rootViewController = revealController
        

    }

    func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.grayColor()
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    func applicationWillResignActive(application: UIApplication) {
 
    }

    func applicationDidEnterBackground(application: UIApplication) {
       
    }

    func applicationWillEnterForeground(application: UIApplication) {
        
    }

    func applicationDidBecomeActive(application: UIApplication) {
      
    }

    func applicationWillTerminate(application: UIApplication) {
       
    }

    
}

