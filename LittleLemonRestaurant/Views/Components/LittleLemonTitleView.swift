//
//  LittleLemonTitleView.swift
//  LittleLemonRestaurant
//
//  Created by Andrea Consorti on 09/06/25.
//

import SwiftUI

struct LittleLemonTitleView: View {
    
    let title: String;
    
    var body: some View {
        Text (title)
         .padding([.leading, .trailing], 40)
         .padding([.top, .bottom], 6)
         .background(Color("approvedYellow"))
         .cornerRadius(20)
    }
}

struct LittleLemonTitleView_Previews: PreviewProvider {
    static var previews: some View {
        LittleLemonTitleView(title: "Locations")
    }
}

