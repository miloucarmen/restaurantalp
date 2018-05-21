//
//  IntermediaryModels.swift
//  restaurantMenu
//
//  Created by Gebruiker on 16-05-18.
//  Copyright © 2018 Gebruiker. All rights reserved.
//

import Foundation


struct Categories: Codable {
    let categories: [String]
}

struct PreparationTime: Codable {
    let prepTime: Int

    enum CodingKeys: String, CodingKey {
        case prepTime = "preparation_time"
    }
}
