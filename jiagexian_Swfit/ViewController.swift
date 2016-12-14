//
//  ViewController.swift
//  jiagexian_Swfit
//
//  Created by derex pan on 2016/12/6.
//  Copyright © 2016年 derex pan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CitesTableViewControllerDelegate {
    @IBOutlet weak var selectCity: UIButton!
    @IBOutlet weak var selectKey: UIButton!
    @IBOutlet weak var priceRange: UIButton!
    @IBOutlet weak var checkinDate: UIButton!
    @IBOutlet weak var checkoutDate: UIButton!
    
    var cityInfo = NSDictionary()
    
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
    
    func closeCitiesView(info: NSDictionary) {
        
        //        self.cityInfo = info;
        //        [self dismissViewControllerAnimated:NO completion:nil];
        //        NSString* cityname = info[@"name"];
        //        [self.selectCity setTitle:cityname forState:UIControlStateNormal];
        self.cityInfo = info
        self.dismiss(animated: false, completion: nil)
        if let cityname = info["name"] as? String {
            self.selectCity.setTitle(cityname, for: .normal)
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showcities"{
            let nvgViewController = segue.destination as! UINavigationController
            let topViewController = nvgViewController.topViewController as! CitesTableViewController
            topViewController.delegate = self
            
        }
    }
}

