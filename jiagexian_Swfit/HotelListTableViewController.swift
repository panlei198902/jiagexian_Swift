//
//  HotelListTableViewController.swift
//  jiagexian_Swift
//
//  Created by derex pan on 2016/12/13.
//  Copyright © 2016年 derex pan. All rights reserved.
//

import UIKit

class HotelListTableViewController: UITableViewController {
    
    var currentPage = 1 //当前页数
    var hotelList:Any? = nil //酒店查询结果
    var queryKey = NSMutableDictionary()   //酒店查询条件
    var roomList:Any? = nil //房间查询结果
    var queryRoomKey = NSMutableDictionary() //房间查询条件
    var hotellistDict = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        hotellistDict = hotelList as! NSMutableArray
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.hotellistDict.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HotelListCellTableViewCell
        let dict = self.hotellistDict.object(at: indexPath.row) as! Dictionary<String, String>
        cell.hotelName.text = dict["name"]
        cell.hotelTel.text = dict["phone"]
        cell.hotelGrade.text = dict["grade"]
        cell.hotelPrice.text = dict["lowprice"]
        cell.hotelAddress.text = dict["address"]
        
        let htmlPath = Bundle.main.path(forResource: "myIndex", ofType: "html")
        do {
            let html = try String(contentsOfFile: htmlPath!, encoding: String.Encoding.utf8)
            let range = html.range(of: "####")
            if range?.isEmpty != false {
                let scr = dict["img"]
                let newHtml = html.replacingCharacters(in: range!, with: scr!)
                cell.img.loadHTMLString(newHtml, baseURL: nil)
            }
        } catch {
            print(error)
        }
        
        // Configure the cell...

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
