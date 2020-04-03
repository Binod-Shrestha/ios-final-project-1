//
//  NoteCell.swift
//  RemindMe
//
//  Created by Xcode User on 2020-03-04.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import UIKit

class DueDateCell: UITableViewCell {
    
    // instantiate the items
    let primaryLabel = UILabel()
    let secondaryLabel = UILabel()
    let thirdLabel = UILabel()
    let fourthLabel = UILabel()
    let fifthLabel = UILabel()
    let sixthLabel = UILabel()
    let seventhLabel = UILabel()
    let eighthLabel = UILabel()
    

    //let myImageView = UIImageView()
    
    //override the constructor
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        primaryLabel.textAlignment = .left
        primaryLabel.font = UIFont.boldSystemFont(ofSize: 20)
        primaryLabel.backgroundColor = .clear
        primaryLabel.textColor = .black
        
        secondaryLabel.textAlignment = .left
        secondaryLabel.font = UIFont.boldSystemFont(ofSize: 16)
        secondaryLabel.backgroundColor = .clear
        secondaryLabel.textColor = .blue
        
        thirdLabel.textAlignment = .left
        thirdLabel.font = UIFont.boldSystemFont(ofSize: 16)
        thirdLabel.backgroundColor = .clear
        thirdLabel.textColor = .blue
        
        fourthLabel.textAlignment = .left
        fourthLabel.font = UIFont.boldSystemFont(ofSize: 16)
        fourthLabel.backgroundColor = .clear
        fourthLabel.textColor = .blue
        
        fifthLabel.textAlignment = .left
        fifthLabel.font = UIFont.boldSystemFont(ofSize: 16)
        fifthLabel.backgroundColor = .clear
        fifthLabel.textColor = .blue
        
        sixthLabel.textAlignment = .left
        sixthLabel.font = UIFont.boldSystemFont(ofSize: 16)
        sixthLabel.backgroundColor = .clear
        sixthLabel.textColor = .blue
        
        seventhLabel.textAlignment = .left
        seventhLabel.font = UIFont.boldSystemFont(ofSize: 16)
        seventhLabel.backgroundColor = .clear
        seventhLabel.textColor = .blue
        
        eighthLabel.textAlignment = .left
        eighthLabel.font = UIFont.boldSystemFont(ofSize: 16)
        eighthLabel.backgroundColor = .clear
        eighthLabel.textColor = .blue
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //add images
        contentView.addSubview(primaryLabel)
        contentView.addSubview(secondaryLabel)
        contentView.addSubview(thirdLabel)
        contentView.addSubview(fourthLabel)
        contentView.addSubview(fifthLabel)
        contentView.addSubview(sixthLabel)
        contentView.addSubview(seventhLabel)
        contentView.addSubview(eighthLabel)

      //  contentView.addSubview(myImageView)
    }
    
    //location of the items
    override func layoutSubviews() {
        primaryLabel.frame = CGRect(x: 10, y: 5, width: 460, height: 20)
        secondaryLabel.frame = CGRect(x: 10, y: 25, width: 460, height: 20)
        thirdLabel.frame = CGRect(x: 10, y: 45, width: 460, height: 20)
        fourthLabel.frame = CGRect(x: 10, y: 65, width: 460, height: 20)
        fifthLabel.frame = CGRect(x: 10, y: 85, width: 460, height: 20)
        sixthLabel.frame = CGRect(x: 10, y: 105, width: 460, height: 20)
        seventhLabel.frame = CGRect(x: 10, y: 125, width: 460, height: 20)
        eighthLabel.frame = CGRect(x: 10, y: 145, width: 460, height: 20)

       // myImageView.frame = CGRect(x: 5, y: 5, width: 45, height: 45)
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
