//
//  Note.swift
//  RemindMe
//
//  Created by Xcode User on 2020-03-14.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit

class Note: NSObject {
    var id : Int?
    var content : String?
    
    override init() {
        super.init()
    }

    init(content: String) {
        self.content = content
    }
    
    init(row: Int, content: String) {
        self.id = row
        self.content = content
    }
}
