//
//  APIObject.swift
//  BookXpert
//
//  Created by APPLE on 26/04/25.
//

import Foundation

// Updated data model to handle inconsistencies
struct APIObject: Codable {
    let id: String
    let name: String
    let data: ItemData?
}

struct ItemData: Codable {
    let color: String?
    let capacity: String?
    let price: Double?
    let year: Int?
    let cpuModel: String?
    let hardDiskSize: String?
    let strapColor: String?
    let caseSize: String?
    let description: String?
    let screenSize: Double?
    let generation: String?

    enum CodingKeys: String, CodingKey {
        case color, Color
        case capacity, Capacity
        case price, Price
        case year, Year
        case cpuModel = "CPU model"
        case hardDiskSize = "Hard disk size"
        case strapColor = "Strap Colour"
        case caseSize = "Case Size"
        case description = "Description"
        case screenSize = "Screen size"
        case generation, Generation
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        color = try container.decodeIfPresent(String.self, forKey: .color)
            ?? container.decodeIfPresent(String.self, forKey: .Color)

        capacity = try container.decodeIfPresent(String.self, forKey: .capacity)
            ?? container.decodeIfPresent(String.self, forKey: .Capacity)
        
        if let decodedPrice = try? container.decodeIfPresent(Double.self, forKey: .price) {
            self.price = decodedPrice
        } else if let priceString = try? container.decodeIfPresent(String.self, forKey: .Price),
                  let converted = Double(priceString) {
            self.price = converted
        } else {
            self.price = nil
        }

        year = try container.decodeIfPresent(Int.self, forKey: .year)
            ?? container.decodeIfPresent(Int.self, forKey: .Year)

        generation = try container.decodeIfPresent(String.self, forKey: .generation)
            ?? container.decodeIfPresent(String.self, forKey: .Generation)

        cpuModel = try container.decodeIfPresent(String.self, forKey: .cpuModel)
        hardDiskSize = try container.decodeIfPresent(String.self, forKey: .hardDiskSize)
        strapColor = try container.decodeIfPresent(String.self, forKey: .strapColor)
        caseSize = try container.decodeIfPresent(String.self, forKey: .caseSize)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        screenSize = try container.decodeIfPresent(Double.self, forKey: .screenSize)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(color, forKey: .color)
        try container.encodeIfPresent(capacity, forKey: .capacity)
        try container.encodeIfPresent(price, forKey: .price)
        try container.encodeIfPresent(year, forKey: .year)
        try container.encodeIfPresent(cpuModel, forKey: .cpuModel)
        try container.encodeIfPresent(hardDiskSize, forKey: .hardDiskSize)
        try container.encodeIfPresent(strapColor, forKey: .strapColor)
        try container.encodeIfPresent(caseSize, forKey: .caseSize)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(screenSize, forKey: .screenSize)
        try container.encodeIfPresent(generation, forKey: .generation)
    }
}

