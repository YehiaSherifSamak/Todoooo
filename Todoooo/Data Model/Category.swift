//
//  Category.swift
//  Todoooo
//
//  Created by Yehia Samak on 12/16/18.
//  Copyright © 2018 Yehia Samak. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object{
    
    @objc dynamic var name : String = "";
    let items = List<Item>();
    
}
