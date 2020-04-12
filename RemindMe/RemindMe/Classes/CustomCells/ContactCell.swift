//
//  SiteCell.swift
//  Exam_Assignment1
//
//  Created by Brian Holmes on 2020-04-01.
//  Copyright © 2020 BBQs. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    
    let nameLabel = UILabel()
    let organizationLabel = UILabel()
    let phoneLabel = UILabel()
    let emailLabel = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.boldSystemFont(ofSize: 30)
        nameLabel.backgroundColor = .clear //allows for a background image to be seen
        nameLabel.textColor = .black
        
        organizationLabel.textAlignment = .left
        organizationLabel.font = UIFont.boldSystemFont(ofSize: 12)
        organizationLabel.backgroundColor = .clear
        organizationLabel.textColor = .black
        
        phoneLabel.textAlignment = .left
        phoneLabel.font = UIFont.boldSystemFont(ofSize: 12)
        phoneLabel.backgroundColor = .clear
        phoneLabel.textColor = .black
        
        emailLabel.textAlignment = .left
        emailLabel.font = UIFont.boldSystemFont(ofSize: 16)
        emailLabel.backgroundColor = .clear
        emailLabel.textColor = .blue
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(organizationLabel)
        contentView.addSubview(phoneLabel)
        contentView.addSubview(emailLabel)
    }
    
    override func layoutSubviews()
    {
        nameLabel.frame = CGRect(x: 10, y: 5, width: 460, height: 30)
        organizationLabel.frame = CGRect(x: 10, y: 30, width: 460, height: 20)
        phoneLabel.frame = CGRect(x: 10, y: 45, width: 460, height: 20)
        emailLabel.frame = CGRect(x: 10, y: 65, width: 460, height: 20)
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
