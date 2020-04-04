//
//  Category.swift
//  RemindMe
//
//  Created by Xcode User on 2020-03-24.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit

class Category: NSObject {
    var id : Int?
    var category_name: String?
    func initWithData(theRow i: Int, theCategoryName cn: String){
        id = i
        category_name = cn
    }
   
}
