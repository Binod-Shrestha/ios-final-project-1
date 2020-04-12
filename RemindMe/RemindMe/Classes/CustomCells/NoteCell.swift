//
//  NoteCell.swift
//  RemindMe
//
//  Created by Quynh Dinh on 2020-03-30.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {
    
    // Declare layout of the cell
    let lbContent = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        // Set layout
        lbContent.textAlignment = .left
        lbContent.font = UIFont.boldSystemFont(ofSize: 25)
        lbContent.font = UIFont(name: "MarkerFelt-Thin", size: 25)
        lbContent.backgroundColor = .clear
        lbContent.textColor = .black
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Add control elements to table cell
        contentView.addSubview(lbContent)
    }
    
    // Set positions for control elements
    override func layoutSubviews() {
        lbContent.frame = CGRect(x: 5, y: 5, width: 600, height: 20)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
