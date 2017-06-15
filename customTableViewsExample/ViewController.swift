//
//  ViewController.swift
//  customTableViewsExample
//
//  Created by Bill Boughton on 6/6/17.
//  Copyright © 2017 Bill Boughton. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let colorsArray = ["green_rz", "yellow_rz", "blue_rz", "orange_rz", "green_rz", "yellow_rz", "blue_rz", "orange_rz", "green_rz", "yellow_rz", "blue_rz", "orange_rz", "green_rz", "yellow_rz", "blue_rz", "orange_rz"]
    
    private let refreshControl = UIRefreshControl()

    @IBOutlet weak var tableView: UITableView!
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        getFoodData()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getFoodData()

        
        refreshControl.addTarget(self, action: #selector(ViewController.refreshData(sender:)), for: .valueChanged)
        
        // Add to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
    }
    
    func refreshData(sender: UIRefreshControl){
        getFoodData()
    }
    
    func getFoodData() {
        Alamofire.request("https://pantrysupply.herokuapp.com/getall").responseJSON { response in
            
            if let JSON = response.result.value as AnyObject?{
                //                print("JSON: \(JSON)")
                if let nextArray = JSON["result"] as! NSArray?{
                    SharedData.items.removeAll()
                    for i in 0..<nextArray.count{
                        var someDict = [String: AnyObject]()
                        let nextTempHolder = nextArray[i] as AnyObject?
                        let finalHolder = nextTempHolder?["quantity"] as! Int
                        let idHolder = nextTempHolder?["item_id"] as! String?
                        let brandNameHolder = nextTempHolder?["brand_name"] as! String?
                        let itemName = nextTempHolder?["item_name"] as! String?
                        someDict["brand_item"] = brandNameHolder! as AnyObject
                        someDict["item_name"] = itemName as AnyObject
                        someDict["item_id"] = idHolder as AnyObject
                        someDict["quantity"] = finalHolder as AnyObject
                        SharedData.items.append(someDict as AnyObject)
                    }
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()

                }
            }
            
        }
    

        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SharedData.items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        


        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        cell.myQuantity.text = String(describing: SharedData.items[indexPath.row]["quantity"]!!)
        cell.myLabel.text = SharedData.items[indexPath.row]["item_name"] as? String
        cell.myBrandName.text = SharedData.items[indexPath.row]["brand_item"] as? String
        cell.myQuantity.textColor = UIColor(red:0.23, green:0.21, blue:0.42, alpha:1.0)
        cell.myBrandName.textColor = UIColor(red:0.23, green:0.21, blue:0.42, alpha:1.0)
        cell.myLabel.textColor = UIColor(red:0.23, green:0.21, blue:0.42, alpha:1.0)
        cell.backgroundColor = UIColor(red:0.94, green:0.96, blue:0.96, alpha:1.0)
        
        cell.colorBar.image = UIImage(named: (colorsArray[indexPath.row] + ".png"))
        
        
        if (String(describing: SharedData.items[indexPath.row]["quantity"]!!) == "0") {
            cell.myQuantity.textColor = UIColor.red
            cell.myBrandName.textColor = UIColor.red
            cell.myLabel.textColor = UIColor.red
            cell.backgroundColor = UIColor(red:0.89, green:0.91, blue:0.91, alpha:1.0)
            cell.colorBar.image = UIImage(named: "red_rz.png")

        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexClicked = indexPath.row
        performSegue(withIdentifier: "moveSegue", sender: indexClicked)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "moveSegue"){
            let showOne = segue.destination as! ShowOneFoodItemViewController
            showOne.indexOfItem = sender as! Int
            
        } else if (segue.identifier == "manualEntry") {
            segue.destination as! ManAddViewController
        }

    }
    
    @IBAction func addNewItem(_ sender: Any) {
        performSegue(withIdentifier: "manualEntry", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

