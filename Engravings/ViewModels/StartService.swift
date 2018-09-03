//
//  StartService.swift
//  Engravings
//
//  Created by Anna Miksiuk on 24.07.2018.
//  Copyright © 2018 Anna Miksiuk. All rights reserved.
//

import Foundation

protocol StartServiceProtocol {
    func mainControllerFirstRun() -> Bool
    func mainControllerWasEvent()
    func scrapeControllerFirstRun() -> Bool
    func scrapeControllerWasEvent()
}

class StartService: StartServiceProtocol {
    
    private static let kStartServiceMainEvent = "kStartServiceMainEvent"
    private static let kStartServiceScrapeEvent = "kStartServiceScrapeEvent"
    
    private var mainEvent = false
    private var scrapeEvent = false
    
    init() {
        loadEvents()
    }
    
    // MARK: - Private
    
    func loadEvents() {
        let flagMain = UserDefaults.standard.value(forKey: StartService.kStartServiceMainEvent) as? Bool
        if flagMain != nil {
            mainEvent = flagMain!
        }
        let flagScrape = UserDefaults.standard.value(forKey: StartService.kStartServiceScrapeEvent) as? Bool
        if flagScrape != nil {
            scrapeEvent = flagScrape!
        }
    }
    
    
    // MARK: - StartServiceProtocol
    
    func mainControllerFirstRun() -> Bool {
        return !mainEvent
    }
    
    func mainControllerWasEvent() {
        mainEvent = true
        UserDefaults.standard.set(mainEvent, forKey: StartService.kStartServiceMainEvent)
    }
    
    func scrapeControllerFirstRun() -> Bool {
        return !scrapeEvent
    }
    
    func scrapeControllerWasEvent() {
        scrapeEvent = true
        UserDefaults.standard.set(scrapeEvent, forKey: StartService.kStartServiceScrapeEvent)
    }
}
