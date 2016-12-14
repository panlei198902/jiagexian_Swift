//
//  ViewController.swift
//  jiagexian_Swfit
//
//  Created by derex pan on 2016/12/6.
//  Copyright © 2016年 derex pan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var selectCity: UIButton!
    @IBOutlet weak var selectKey: UIButton!
    @IBOutlet weak var priceRange: UIButton!
    @IBOutlet weak var checkinDate: UIButton!
    @IBOutlet weak var checkoutDate: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        
        return true
    }
    
}

