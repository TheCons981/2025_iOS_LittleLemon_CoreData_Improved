//
//  NetworkMonitor.swift
//  LittleLemonRestaurant
//
//  Created by Andrea Consorti on 11/06/25.
//

import Network
import Foundation

final class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    @Published private(set) var isConnected: Bool = true
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
    
    /// Check current connection synchronously (snapshot)
    var isCurrentlyConnected: Bool {
        monitor.currentPath.status == .satisfied
    }
}
