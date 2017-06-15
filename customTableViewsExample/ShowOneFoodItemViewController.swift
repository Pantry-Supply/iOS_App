//
//  ShowOneFoodItemViewController.swift
//  customTableViewsExample
//
//  Created by Bill Boughton on 6/7/17.
//  Copyright © 2017 Bill Boughton. All rights reserved.
//

import UIKit
import Alamofire


class ShowOneFoodItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var dateInStatic: UILabel!
    @IBOutlet weak var dateOutStatic: UILabel!
    

    @IBOutlet weak var quantityDisplay: UILabel!
    @IBOutlet weak var textNameDisplay: UILabel!
    @IBOutlet weak var textItemDisplay: UILabel!
    @IBOutlet weak var aveDay: UILabel!

    @IBOutlet weak var tableView: UITableView!
    
    var indexOfItem = 0
    var idHolder = ""
    var arrayDateIN = [NSArray]()
    var arrayDateOUT = [NSArray]()
    var difference = [NSArray]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red:0.94, green:0.96, blue:0.96, alpha:1.0)

        idHolder = SharedData.items[indexOfItem]["item_id"] as! String
        getMoreFoodData(idHolder: idHolder)
        textItemDisplay.text = SharedData.items[indexOfItem]["brand_item"] as? String
        textNameDisplay.text = SharedData.items[indexOfItem]["item_name"] as? String
        textNameDisplay.textColor = UIColor(red:0.23, green:0.21, blue:0.42, alpha:1.0)
        textItemDisplay.textColor = UIColor(red:0.23, green:0.21, blue:0.42, alpha:1.0)

        quantityDisplay.text = String(describing: SharedData.items[indexOfItem]["quantity"]!!)
        dateInStatic.text = "IN"
        dateOutStatic.text = "OUT"
        
    }

    func getMoreFoodData(idHolder: String){
        Alamofire.request("https://pantrysupply.herokuapp.com/getone/\(idHolder)").responseJSON { response in
            
            if let JSON = response.result.value as AnyObject?{
//                                print("JSON: \(JSON)")
                self.arrayDateIN = (JSON["date_added"] as! NSArray) as! [NSArray]
                ShareArray.datesIn = (JSON["date_added"] as! NSArray) as! [Any]
                ShareArray.datesOut = (JSON["date_removed"] as! NSArray) as! [Any]
                ShareArray.difference = (JSON["difference"] as! NSArray) as! [Any]
                self.aveDay.text = String(describing: JSON["ave_day"]!!)
                self.tableView.reloadData()
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
            return ShareArray.datesIn.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let datecell = tableView.dequeueReusableCell(withIdentifier: "datecell", for: indexPath) as! DateDisplayTableViewCell
        
        let str = ShareArray.datesIn[((ShareArray.datesIn.count - indexPath.row) - 1)] as? String
        let shortStr = String(str!.characters.dropLast(4))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE, dd MM yyyy HH:mm:ss"
        let ns_date1 = dateFormatter.date(from: shortStr)
        dateFormatter.dateFormat = "EE, MMM d"
        let shorterDate = dateFormatter.string(from: ns_date1!)
        
        datecell.labelDateIn.text = shorterDate
        datecell.backgroundColor = UIColor(red:1.00, green:0.98, blue:0.87, alpha:1.0)

        
        if (indexPath.row < (ShareArray.datesIn.count - ShareArray.datesOut.count)) {
            
            datecell.labelDateOut.text = "-"
            datecell.backgroundColor = UIColor(red:1.00, green:0.98, blue:0.87, alpha:1.0)

            
        } else {
            
            let longDateOut = ShareArray.datesOut[((ShareArray.datesIn.count - indexPath.row) - 1)] as? String
            let shortDateOut = String(longDateOut!.characters.dropLast(4))
            
            let dateFormatterOUT = DateFormatter()
            dateFormatterOUT.dateFormat = "EE, dd MM yyyy HH:mm:ss"
            
            let ns_date2 = dateFormatterOUT.date(from: shortDateOut)
            dateFormatterOUT.dateFormat = "EE, MMM d"
            
            let shorterDateOUT = dateFormatterOUT.string(from: ns_date2!)
            
            datecell.labelDateOut.text = shorterDateOUT
            datecell.backgroundColor = UIColor(red:1.00, green:0.98, blue:0.87, alpha:1.0)

        }
        
        
        return datecell
    }
    
    @IBAction func increaseQuantity(_ sender: Any) {

        let currentDisplayQuantity = quantityDisplay.text
        let increasedDisplayHolder = Int(currentDisplayQuantity!)! + 1
        quantityDisplay.text = String(describing: increasedDisplayHolder)
        
        let strDate = String(describing: Date())
        let updateOUT = DateFormatter()
        updateOUT.dateFormat = "yyyy-MM-dd HH:mm:ssZZZZ"
        let ns_date3 = updateOUT.date(from: strDate)
        updateOUT.dateFormat = "EE, dd MMM yyyy HH:mm:ss ZZZZ"
        let longDate = updateOUT.string(from: ns_date3!)
        let shortDate = String(longDate.characters.dropLast(6))
        ShareArray.datesIn.append(shortDate)
        self.tableView.reloadData()
        
        Alamofire.request("https://pantrysupply.herokuapp.com/adjustup/\(idHolder)").responseJSON { responseUp in
            if let dataFromAdjustUp = responseUp.result.value as AnyObject?{
                print("JSON: \(dataFromAdjustUp)")
            }
            self.tableView.reloadData()
        }
        
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
                }
            }
            
        }

        
        
    }
    @IBAction func decreaseQuantity(_ sender: Any) {
        
        if quantityDisplay.text == "0" {
            print("Item is already at zero")
        } else {
            let currentDisplayQuantity = quantityDisplay.text
            let decreasedDisplayHolder = Int(currentDisplayQuantity!)! - 1
            quantityDisplay.text = String(describing: decreasedDisplayHolder)
            
            let strDate = String(describing: Date())
            let updateOUT = DateFormatter()
            updateOUT.dateFormat = "yyyy-MM-dd HH:mm:ssZZZZ"
            let ns_date3 = updateOUT.date(from: strDate)
            updateOUT.dateFormat = "EE, dd MMM yyyy HH:mm:ss ZZZZ"
            let longDate = updateOUT.string(from: ns_date3!)
            let shortDate = String(longDate.characters.dropLast(6))
            ShareArray.datesOut.append(shortDate)
            self.tableView.reloadData()

            
            Alamofire.request("https://pantrysupply.herokuapp.com/adjustdown/\(idHolder)").responseJSON { responseDown in
                if let dataFromAdjustDown = responseDown.result.value as Any?{
                    print("JSON: \(dataFromAdjustDown)")
                }
                self.tableView.reloadData()
            }
            
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
                    }
                }
                
            }

        }
        
    }
    
    @IBAction func removeItem(_ sender: Any) {
        let refreshAlert = UIAlertController(title: "Delete", message: "Are you sure you want to completely remove this item?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            print("send delete request and move back to main page")
            let sendToDelete: Parameters = ["item_id":self.idHolder]
            print(sendToDelete)
            
            Alamofire.request("https://pantrysupply.herokuapp.com/delete/\(self.idHolder)", method: .delete).responseJSON { response in
                print(response.request!)
            }
            
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
                    }
                }
                
            }
            
            self.navigationController!.popViewController(animated: true)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
