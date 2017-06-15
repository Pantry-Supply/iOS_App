//
//  ViewControllerTableViewCell.swift
//  customTableViewsExample
//
//  Created by Bill Boughton on 6/6/17.
//  Copyright © 2017 Bill Boughton. All rights reserved.
//

import UIKit

class ViewControllerTableViewCell: UITableViewCell {

    @IBOutlet weak var myImage: UIImageView!
    
    
    @IBOutlet weak var myQuantity: UILabel!
    @IBOutlet weak var colorBar: UIImageView!
    
    @IBOutlet weak var myLabel: UILabel!
    
    
    @IBOutlet weak var myBrandName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
