//
//  Topic.swift
//  Engravings
//
//  Created by Anna Miksiuk on 24.07.2018.
//  Copyright © 2018 Anna Miksiuk. All rights reserved.
//

class Topic {
    var name: String
    var active = false
    var countPictures = 0
    var pictures = [Picture]()
    
    init(name: String, countPictures: Int) {
        self.name = name
        self.countPictures = countPictures
    }
}
