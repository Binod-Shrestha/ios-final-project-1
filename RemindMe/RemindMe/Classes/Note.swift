//
//  Note.swift
//  RemindMe
//
//  Created by Xcode User on 2020-03-14.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit

class Note: NSObject {
    var content : String?
    var images : NSMutableArray?
    
    init(content: String) {
        self.content = content
    }
}
