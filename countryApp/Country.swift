//
//  Country.swift
//  countryApp
//
//  Created by Esmir Cabrera on 24/11/18.
//  Copyright © 2018 Esmir Cabrera. All rights reserved.
//

import Foundation

struct Country: Codable {
    let name: String
    let code: String
    
    var imageFileName: String {
        return code.lowercased() + ".png"
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "fullname"
        case code = "ianacode"
    }
}
