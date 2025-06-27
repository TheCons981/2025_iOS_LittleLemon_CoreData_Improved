//
//  ReservationViewModel.swift
//  LittleLemonRestaurant
//
//  Created by Andrea Consorti on 10/06/25.
//

import Foundation
import CoreData


@MainActor
class ReservationViewModel: ObservableObject {
    
    @Published var reservation = ReservationStruct()
    
    func getReservations(_ coreDataContext:NSManagedObjectContext) async -> Void {
        let dbReservations = Reservation.readAll(coreDataContext)
        if let reservations = dbReservations {
            reservation = reservations.first.map { res in
                let location = Location.mapToLocationStruct(location: res.fromLocation!)
                return ReservationStruct(restaurant: location, customerName: res.customerName!, customerEmail: res.customerEmail!, customerPhoneNumber: res.customerPhoneNumber!, reservationDate: res.reservationDate!, party: Int(res.party), specialRequests: res.reservationNotes!)
            } ?? ReservationStruct()
        }
    }
    
    func saveReservation(_ coreDataContext:NSManagedObjectContext, reservationRequest: ReservationStruct) async -> Void {
        
        Reservation.deleteAll(coreDataContext);
        
        let location = Location.with(coreDataContext, city: reservationRequest.restaurant.city, phoneNumber: reservationRequest.restaurant.phoneNumber) ??
        {
            let newLocation = Location(context: coreDataContext)
            newLocation.city = reservationRequest.restaurant.city
            newLocation.neighborhood = reservationRequest.restaurant.neighborhood
            newLocation.phoneNumber = reservationRequest.restaurant.phoneNumber
            return newLocation
        }()
        
        let reservation = Reservation(context: coreDataContext)
        reservation.fromLocation = location
        reservation.customerEmail = reservationRequest.customerEmail
        reservation.customerName = reservationRequest.customerName
        reservation.customerPhoneNumber = reservationRequest.customerPhoneNumber
        reservation.party = Int16(reservationRequest.party)
        reservation.reservationDate = reservationRequest.reservationDate
        reservation.reservationNotes = reservationRequest.specialRequests
        reservation.id = reservationRequest.id
        
        Reservation.save(coreDataContext)
        
        await getReservations(coreDataContext);
        
    }
    
    func deleteReservation(_ coreDataContext: NSManagedObjectContext) async -> Void {
        Reservation.deleteAll(coreDataContext)
        reservation = ReservationStruct();
    }
    
}




