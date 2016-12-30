//
//  HotelListCellTableViewCell.swift
//  jiagexian_Swift
//
//  Created by Derexpan on 2016/12/29.
//  Copyright © 2016年 derex pan. All rights reserved.
//

import UIKit

class HotelListCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var img: UIWebView!
    @IBOutlet weak var hotelName: UILabel!
    @IBOutlet weak var hotelGrade: UILabel!
    @IBOutlet weak var hotelTel: UILabel!
    @IBOutlet weak var hotelAddress: UILabel!
    @IBOutlet weak var hotelPrice: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
