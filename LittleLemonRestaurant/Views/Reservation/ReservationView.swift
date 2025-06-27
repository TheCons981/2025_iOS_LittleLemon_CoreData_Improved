import SwiftUI

struct ReservationView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var reservationViewModel:ReservationViewModel
    
    var body: some View {
        // you can create variables inside body
        // to help you reduce code repetition
        let restaurant = reservationViewModel.reservation.restaurant
        NavigationView {
            
            
            ScrollView {
                VStack {
                    LittleLemonLogoView()
                    LittleLemonTitleView(title: "Your Reservation")
                }
                
                VStack {
                    
                    
                    if restaurant.city.isEmpty {
                        
                        VStack {
                            // if city is empty no reservation has been
                            // selected yet, so, show the following message
                            Text("No reservation yet")
                                .foregroundColor(.gray)
                            
                        }
                        .frame(maxHeight:.infinity)
                        
                        
                    } else {
                        
                        HStack {
                            VStack (alignment: .leading) {
                                Text("Restaurant")
                                    .font(.subheadline)
                                    .padding(.bottom, 5)
                                LocationView(restaurant)
                            }
                            Spacer()
                        }
                        .frame(maxWidth:.infinity)
                        .padding(.bottom, 20)
                        
                        Divider()
                            .padding(.bottom, 20)
                        
                        
                        VStack {
                            HStack {
                                Text("Name: ")
                                    .foregroundColor(.gray)
                                    .font(.subheadline)
                                
                                Text(reservationViewModel.reservation.customerName)
                                Spacer()
                            }
                            
                            HStack {
                                Text("E-mail: ")
                                    .foregroundColor(.gray)
                                    .font(.subheadline)
                                
                                Text(reservationViewModel.reservation.customerEmail)
                                Spacer()
                            }
                            
                            HStack {
                                Text("Phone: ")
                                    .foregroundColor(.gray)
                                    .font(.subheadline)
                                
                                Text(reservationViewModel.reservation.customerPhoneNumber)
                                Spacer()
                            }
                            
                        }
                        .padding(.bottom, 20)
                        
                        
                        HStack {
                            Text("Party: ")
                                .foregroundColor(.gray)
                            
                                .font(.subheadline)
                            
                            Text("\(reservationViewModel.reservation.party)")
                            Spacer()
                        }
                        .padding(.bottom, 20)
                        
                        VStack {
                            HStack {
                                Text("Date: ")
                                    .foregroundColor(.gray)
                                    .font(.subheadline)
                                
                                Text(reservationViewModel.reservation.reservationDate, style: .date)
                                Spacer()
                            }
                            
                            HStack {
                                Text("Time: ")
                                    .foregroundColor(.gray)
                                    .font(.subheadline)
                                
                                Text(reservationViewModel.reservation.reservationDate, style: .time)
                                Spacer()
                            }
                        }
                        .padding(.bottom, 20)
                        
                        HStack {
                            VStack (alignment: .leading) {
                                Text("Special Requests:")
                                    .foregroundColor(.gray)
                                    .font(.subheadline)
                                Text(reservationViewModel.reservation.specialRequests)
                            }
                            Spacer()
                        }
                        .frame(maxWidth:.infinity)
                        .padding(.bottom, 20)
                        
                        
                        HStack {
                            Button(role: .destructive) {
                                Task {
                                    await reservationViewModel.deleteReservation(viewContext)
                                }
                                
                            } label: {
                                Text("Delete reservation")
                                
                            }
                            .buttonStyle(.borderedProminent)
                            .cornerRadius(20)
                            Spacer()
                        }
                        
                    }
                }
                .padding()
            }
        }
        .task {
            await reservationViewModel.getReservations(viewContext)
        }
    }
}

struct ReservationView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationView()
            .environmentObject(ReservationViewModel())
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}






