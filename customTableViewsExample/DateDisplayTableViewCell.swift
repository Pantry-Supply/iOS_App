//
//  DateDisplayTableViewCell.swift
//  customTableViewsExample
//
//  Created by Bill Boughton on 6/7/17.
//  Copyright © 2017 Bill Boughton. All rights reserved.
//

import UIKit

class DateDisplayTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var labelDateIn: UILabel!
    
    @IBOutlet weak var labelDateOut: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
