//
//  documentsTableViewCell.swift
//  voiceText
//
//  Created by Eminko on 27.06.2023.
//

import UIKit

class documentsTableViewCell: UITableViewCell {

    @IBOutlet weak var uiView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = UIColor(named: "backgraund")
        dateLabel.textColor = UIColor(named: "backgraund")
        
        titleLabel.font = UIFont(name: "Chalkboard SE", size: 30)
        dateLabel.font = UIFont(name: "Chalkboard SE", size: 14)
        
        
        
        uiView.layer.cornerRadius = 20
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
