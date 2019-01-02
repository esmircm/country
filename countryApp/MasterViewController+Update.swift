//
//  MasterViewController+Update.swift
//  countryApp
//
//  Created by Esmir Cabrera on 24/11/18.
//  Copyright © 2018 Esmir Cabrera. All rights reserved.
//

import UIKit

extension MasterViewController {
    
    internal func updateCountries(_ newCountries: [Country]) {
        
        let news = newCountries.sorted { (x, y) -> Bool in // comparando para ordenar la lista de manera alfabatica
            x.name.localizedCompare(y.name) == .orderedAscending
        }
        
        var indexOld = 0
        var indexNew = 0
        
        var toDelete: [IndexPath] = []
        var toInsert: [IndexPath] = []
        
        while indexOld < (countries?.count ?? 0) && indexNew < news.count {
            let oldCountry = countries![indexOld]
            let newCountry = news[indexNew]
            
            switch oldCountry.name.localizedCompare(newCountry.name) {
                
            case .orderedSame:
                indexOld += 1
                indexNew += 1
                
            case .orderedAscending:
                let ip = IndexPath(row: indexOld, section: 0)
                toDelete.append(ip)
                indexOld += 1
                
            case .orderedDescending:
                let ip = IndexPath(row: indexNew, section: 0)
                toInsert.append(ip)
                indexNew += 1
            }
            
        }
        
        while indexOld < (countries?.count ?? 0) {
            let ip = IndexPath(row: indexOld, section: 0)
            toDelete.append(ip)
            indexOld += 1
        }
        
        while indexNew < news.count {
            let ip = IndexPath(row: indexNew, section: 0)
            toInsert.append(ip)
            indexNew += 1
        }
        
        DispatchQueue.main.async {
            self.countries = news
            if toDelete.count > 0 {
                self.tableView.deleteRows(at: toDelete, with: .automatic)
            }
            
            if toInsert.count > 0 {
                self.tableView.insertRows(at: toInsert, with: .automatic)
            }
        }
        
    }
    
}
