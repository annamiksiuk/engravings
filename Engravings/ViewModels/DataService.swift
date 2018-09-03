//
//  DataService.swift
//  Engravings
//
//  Created by Anna Miksiuk on 21.07.2018.
//  Copyright © 2018 Anna Miksiuk. All rights reserved.
//

import Foundation
import UIKit

protocol DataServiceProtocol {
    func reloadData()
    func saveValueForTopic(name: String)
    func saveValueForPicture(name: String)
}

class DataService: DataServiceProtocol {
    
    private static let kDataServiceBaseTopic = "kDataServiceBaseTopic"
    private static let kDataServiceBasePicture = "kDataServiceBasePicture"
    
    private let purchaseService = PurchaseService()
    
    var topics = [Topic]()
    
    init() {
        let categories = ["Flowers",
                     "Butterflies",
                     "Berries",
                     "Animals",
                     "Birds",
                     "Vegetables",
                     "Fruits",
                     "Dresses"]
        
        for name in categories {
            let topic = Topic(name: name, countPictures: 0)
            
            if purchaseService.isFullVersion() {
                topic.active = true
            } else {
                if name == "Animals" || name == "Butterflies" || name == "Flowers" {
                    topic.active = true
                }
            }
            topics.append(topic)
        }
        
        for topic in topics {
            var indexPicture = 1
            while true {
                guard let image = UIImage(named: "\(topic.name)\(indexPicture)") else { break }
                let picture = Picture(name: "\(topic.name)\(indexPicture)", image: image)
                topic.pictures.append(picture)
                indexPicture += 1
            }
            topic.countPictures = topic.pictures.count
        }
        
        updateData()
    }

    // MARK: - Private
    
    private func keyFor(base: String, andName name: String) -> String {
        return base + name
    }
    
    private func updateData() {
        for topic in topics {
            let flagTopic = UserDefaults.standard.value(forKey: keyFor(base: DataService.kDataServiceBaseTopic, andName: topic.name)) as? Bool
            if flagTopic != nil {
                topic.active = flagTopic!
            }
            
            for picture in topic.pictures {
                let flagPicture = UserDefaults.standard.value(forKey: keyFor(base: DataService.kDataServiceBasePicture, andName: picture.name)) as? Bool
                if flagPicture != nil {
                    picture.visible = flagPicture!
                }
            }
        }
    }
    
    // MARK: - DataServiceProtocol
    
    func saveValueForTopic(name: String) {
        UserDefaults.standard.set(true, forKey: keyFor(base: DataService.kDataServiceBaseTopic, andName: name))
    }
    
    func saveValueForPicture(name: String) {
        UserDefaults.standard.set(true, forKey: keyFor(base: DataService.kDataServiceBasePicture, andName: name))
    }
    
    func reloadData() {
        updateData()
    }
    
}
