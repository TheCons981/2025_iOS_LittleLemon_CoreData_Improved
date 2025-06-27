import SwiftUI

struct LocationView: View {
  private var restaurant:LocationStruct
  
  init(_ restaurant:LocationStruct) {
    self.restaurant = restaurant
  }
  
  var body: some View {
    VStack (alignment: .leading, spacing:3){
      Text(restaurant.city)
        .font(.title2)
      
      HStack {
        Text(restaurant.neighborhood)
        Text("–")
        Text(restaurant.phoneNumber)
      }
      .font(.caption)
      .foregroundColor(.gray)

    }
  }
}

struct LocationView_Previews: PreviewProvider {
  static var previews: some View {
    let sampleRestaurant = LocationStruct(city: "Las Vegas", neighborhood: "Downtown", phoneNumber: "(702) 555-9898")
    LocationView(sampleRestaurant)
    
  }
  
}


