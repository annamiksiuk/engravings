//
//  Picture.swift
//  Engravings
//
//  Created by Anna Miksiuk on 24.07.2018.
//  Copyright © 2018 Anna Miksiuk. All rights reserved.
//

import UIKit

class Picture {
    var name: String
    var image: UIImage
    var showPoints = [CGPoint]()
    var visible = false
    
    init(name: String, image: UIImage) {
        self.name = name
        self.image = image
    }
}
