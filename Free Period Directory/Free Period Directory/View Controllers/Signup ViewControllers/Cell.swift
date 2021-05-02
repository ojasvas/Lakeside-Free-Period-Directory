//
//  CourseCell.swift
//  Free Period Directory
//
//  Created by Allise Thurman on 4/6/21.
//

import UIKit

class Cell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
