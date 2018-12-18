//
//  Item.swift
//  Todoooo
//
//  Created by Yehia Samak on 12/16/18.
//  Copyright © 2018 Yehia Samak. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object{
    
    @objc dynamic var title : String  = "";
    @objc dynamic var done : Bool = false;
    @objc dynamic var dateCreated : Date = Date();
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items");
    
}
