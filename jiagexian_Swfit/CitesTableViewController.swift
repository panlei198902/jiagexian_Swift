
//
//  CitesTableViewController.swift
//  jiagexian_Swift
//
//  Created by derex pan on 2016/12/13.
//  Copyright © 2016年 derex pan. All rights reserved.
//

import UIKit

protocol CitesTableViewControllerDelegate {
    func closeCitiesView(info: NSDictionary)
}

class CitesTableViewController: UITableViewController {

    var delegate:CitesTableViewControllerDelegate?
    var cities = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let cityPist = Bundle.main.path(forResource: "cities", ofType: "plist") {
            //排序
            let citiesNeedToSort = NSArray.init(contentsOfFile: cityPist)!
            let bySpell = NSSortDescriptor.init(key: "spell", ascending: true)
            self.cities = citiesNeedToSort.sortedArray(using: [bySpell]) as NSArray
            
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.cities.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
        
        let dict = self.cities[indexPath.row] as! NSDictionary
        let labelTitle = dict.object(forKey: "name") as? String
        let labelSubtitle = dict.object(forKey: "spell") as? String
        if labelTitle != nil {
            cell.textLabel?.text = labelTitle!
        }
        if labelSubtitle != nil {
            cell.detailTextLabel?.text = labelSubtitle
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = self.cities[indexPath.row] as! NSDictionary
        self.delegate?.closeCitiesView(info: dict)

        
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
