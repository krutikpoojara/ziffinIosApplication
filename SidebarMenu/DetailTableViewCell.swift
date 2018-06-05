//
//  DetailTableViewCell.swift
//  SidebarMenu
//
//  Created by Pixster Studio on 16/12/15.
//  Copyright © 2015 AppCoda. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var btnExtra: UIButton!
    @IBOutlet weak var ExtraView: UIView!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    
    @IBOutlet var imgIcon: UIImageView!
    @IBOutlet var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
        // Configure the view for the selected state
    }

}
