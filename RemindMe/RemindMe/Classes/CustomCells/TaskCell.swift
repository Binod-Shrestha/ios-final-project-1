//
//  TaskCell.swift
//  RemindMe
//
//  Created by Xcode User on 2020-03-28.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    
    // Declare layout of the cell
    let lbTitle = UILabel()
    let lbPriority = UILabel()
    let lbTaskDueDate = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        // Set layout
        lbTitle.textAlignment = .left
        lbTitle.font = UIFont.boldSystemFont(ofSize: 25)
        lbTitle.font = UIFont(name: "MarkerFelt-Thin", size: 25)
        lbTitle.backgroundColor = .clear
        lbTitle.textColor = UIColor(red: CGFloat(0/255.0), green: CGFloat(32/255.0), blue: CGFloat(63/255.0), alpha: CGFloat(1.0))
        
        lbPriority.textAlignment = .left
        lbPriority.font = UIFont.boldSystemFont(ofSize: 15)
        lbPriority.backgroundColor = .clear
        lbPriority.textColor = .black
        
        lbTaskDueDate.textAlignment = .left
        lbTaskDueDate.font = UIFont.boldSystemFont(ofSize: 15)
        lbTaskDueDate.backgroundColor = .clear
        lbTaskDueDate.textColor = .black
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Add control elements to table cell
        contentView.addSubview(lbTitle)
        contentView.addSubview(lbPriority)
        contentView.addSubview(lbTaskDueDate)
    }
    
    // Set positions for control elements
    override func layoutSubviews() {
        lbTitle.frame = CGRect(x: 5, y: 5, width: 550, height: 30)
        lbPriority.frame = CGRect(x:5, y: 40, width: 550, height: 20)
        lbTaskDueDate.frame = CGRect(x: 5, y: 65, width: 550, height: 20)
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
