//
//  KeysTableViewController.swift
//  jiagexian_Swift
//
//  Created by derex pan on 2016/12/13.
//  Copyright © 2016年 derex pan. All rights reserved.
//

import UIKit

protocol KeysTableViewControllerDelegate {
    
    func closeKeysCtroller(info: NSDictionary)
}
class KeysTableViewController: UITableViewController {
    
    var delegate: KeysTableViewControllerDelegate?
    var keyTypeList = NSArray()
    var keyDict = NSDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.keyTypeList = self.keyDict.allKeys as NSArray
        
//        let backgroundView =  UIImageView(image: UIImage.init(named: "BackgroundSearch"))
//        backgroundView.frame(forAlignmentRect: self.tableView.frame)
//        self.tableView.backgroundView = backgroundView
//        
//        let navigationBar = self.navigationController?.navigationBar
//        navigationBar?.barTintColor = UIColor(colorLiteralRed: 112.0/255, green: 89.0/255, blue: 181.0/255, alpha: 1.0)
//        navigationBar?.tintColor = UIColor(colorLiteralRed: 112.0/255, green: 180.0/255, blue: 255.0/255, alpha: 1.0)
//        
//        if let navbarTitleTextAttributes = NSDictionary(object: UIColor.white, forKey: NSForegroundColorAttributeName as NSCopying) as? Dictionary<String, Any> {
//            navigationBar?.titleTextAttributes = navbarTitleTextAttributes
//        }
//        
//        //设置表视图标题栏颜色
//        UITableViewHeaderFooterView.appearance().tintColor = UIColor(colorLiteralRed: 112.0/255, green: 180.0/255, blue: 255.0/255, alpha: 1.0)
//        self.clearsSelectionOnViewWillAppear = false
//        
//        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
//        self.keyTypeList = [self.keyDict allKeys];
//        
//        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundSearch"]];
//        [backgroundView setFrame:self.tableView.frame];
//        self.tableView.backgroundView = backgroundView;
//        
//        UINavigationBar* navigationBar = self.navigationController.navigationBar;
//        navigationBar.barTintColor = [UIColor colorWithRed:48.0/255 green:89.0/255 blue:181.0/255 alpha:1.0];
//        navigationBar.tintColor = [UIColor colorWithRed:112.0/255 green:180.0/255 blue:255.0/255 alpha:1.0];
//        
//        NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
//        navigationBar.titleTextAttributes = navbarTitleTextAttributes;
//        
//        //设置表视图标题栏颜色
//        [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor colorWithRed:112.0/255 green:180.0/255 blue:255.0/255 alpha:1.0]];
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.keyDict.count

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let keyName = self.keyTypeList.object(at: section) as! String
//        let keyList = self.keyDict.object(forKey: keyName)
        return 10
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let keyName = self.keyTypeList.object(at: indexPath.section) as! String
        let keyList = self.keyDict.object(forKey: keyName) as! NSArray
        let valueArray = keyList.object(at: indexPath.row) as! NSArray
        cell.textLabel?.text = valueArray.value(forKey: "key") as? String


        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
