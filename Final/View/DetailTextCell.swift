//
//  DetailTextCell.swift
//  Final
//
//  Created by evyhsiao on 2021/12/29.
//

import UIKit

class DetailTextCell: UITableViewCell {
    
    @IBOutlet var descriptionLabel: UILabel!{
        didSet {
            descriptionLabel.numberOfLines = 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
