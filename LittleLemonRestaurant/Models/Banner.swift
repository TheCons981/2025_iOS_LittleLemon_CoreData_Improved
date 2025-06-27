//
//  Banner.swift
//  LittleLemonRestaurant
//
//  Created by Andrea Consorti on 11/06/25.
//

import SwiftUICore

struct Banner: Decodable {
    var message: String = ""
    var color: String = ""
    var show: Bool = false
    
    var colorScheme: Color {
        switch color {
        case "red": return .red
        case "green": return .green
        default: return .gray
        }
    }
}
