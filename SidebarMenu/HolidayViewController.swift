//
//  HolidayViewController.swift
//  SidebarMenu
//
//  Created by Developer on 29/12/15.
//  Copyright © 2015 AppCoda. All rights reserved.
//

import UIKit
import SwiftyJSON

class HolidayViewController: UIViewController {

    @IBOutlet weak var img: UIImageView!
    var loadingNotification : MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let netReach = Reachability.reachabilityForInternetConnection()
        let networkstatus = netReach.currentReachabilityStatus()
        if networkstatus == NotReachable
        {
            exit(0)
        }
        else
        {
        loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Please Wait Loading"

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            let json = JSON(data: NSData(contentsOfURL: NSURL(string: "http://shreehariconsultant.com/cooker_webservice/fatch_holiday.php")!)!)
            let tbl_holiday = json["tbl_holiday"]
            
            let holiday_img = tbl_holiday[0]["holiday_img"].stringValue
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                
                self.img?.image = UIImage(named: holiday_img)

                self.loadingNotification.hide(true)
                print("Finish")
            }
        }
        }

    }

    @IBAction func btnDimiss(sender: AnyObject) {
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
