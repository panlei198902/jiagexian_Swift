//
//  KeysTableViewController.swift
//  jiagexian_Swift
//
//  Created by derex pan on 2016/12/13.
//  Copyright © 2016年 derex pan. All rights reserved.
//

import UIKit

protocol KeysTableViewControllerDelegate {
    
    func closeKeysCtroller(info: String)
}
class KeysTableViewController: UITableViewController {
    
    var delegate: KeysTableViewControllerDelegate?
    var keyTypeList = NSArray()
    var keyDict = NSDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.keyTypeList = self.keyDict.allKeys as NSArray
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
        let keyName = self.keyTypeList.object(at: section) as! String
        let keyList = self.keyDict.object(forKey: keyName) as! NSArray
        return keyList.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let keyName = self.keyTypeList.object(at: indexPath.section) as! String
        let keyList = self.keyDict.object(forKey: keyName) as! NSArray
        let valueArray = keyList.object(at: indexPath.row) as! NSDictionary
        cell.textLabel?.text = valueArray.value(forKey: "key") as? String


        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let keyName = self.keyTypeList.object(at: indexPath.section) as! String
        let keyList = self.keyDict.object(forKey: keyName) as! NSArray
        let valueArray = keyList.object(at: indexPath.row) as! NSDictionary
        self.delegate?.closeKeysCtroller(info:valueArray.object(forKey: "key") as! String)
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
