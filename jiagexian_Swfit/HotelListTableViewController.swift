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
    var roomList = NSArray() //房间查询结果
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        NotificationCenter.default.addObserver(self, selector: #selector(queryHotelFinished(not:)), name: NSNotification.Name(rawValue: BLQueryRoomFinishedNotification), object: nil)
    }
    
    func queryHotelFinished(not:Notification) {
        let resList = not.object as! Array<Any>
        self.roomList.addingObjects(from: resList)
        self.tableView.reloadData()
//        NSArray *resList = not.object;
//        if ([resList count] < 20) {
//            self.loadViewCell.hidden = YES;
//        } else {
//            self.loadViewCell.hidden = NO;
//        }
//        
//        if (currentPage == 1) {
//            self.list = [NSMutableArray new];
//        }
//        
//        [self.list addObjectsFromArray:resList];
//        [self.tableView reloadData];
    }
    
    //查询房间信息成功
    func queryRoomFinished(not:NSNotification) {
        self.roomList = not.object as! NSArray
        if self.roomList.count == 0 {
            let alert = UIAlertController.init(title: "出错信息", message: "没数据", preferredStyle: .alert)
            let alertButton = UIAlertAction.init(title: "ok", style: .cancel, handler: nil)
            alert.addAction(alertButton)
            self.present(alert, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "showRoomList", sender: nil)
        }
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
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showRoomList" {
            let qkey = NSMutableDictionary()
            qkey.setValue(self.queryKey.object(forKey: "Checkin"), forKey:  "Checkin")
            qkey.setValue(self.queryKey.object(forKey: "Checkout"), forKey: "Checkout")
            
            let indexPath = self.tableView.indexPathForSelectedRow
            let dict = self.roomList.object(at: indexPath!.row) as! NSDictionary
            qkey.setValue(dict.object(forKey: "id"), forKey: "hotelId")
            
            self.queryRoomKey = qkey
            RoomBL.sharedInstance.queryRoom(keyInfo: self.queryRoomKey)
            
            
        }
        return true
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRoomList" {
            let roomListViewController = segue.destination as! RoomsListTableViewController
            roomListViewController.roomList = self.roomList as! NSMutableArray
        }
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
