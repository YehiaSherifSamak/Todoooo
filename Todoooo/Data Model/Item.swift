//
//  Item.swift
//  Todoooo
//
//  Created by Yehia Samak on 12/9/18.
//  Copyright © 2018 Yehia Samak. All rights reserved.
//

import Foundation

class Item: Encodable, Decodable
{
    var title : String;
    var  done : Bool = false
    
    init(itemTitle: String)
    {
        title = itemTitle;
    }
    
    init() {
        title = ""
    }
}
