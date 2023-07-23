//
//  Reachability.swift
//  lab04hw
//
//  Created by Никита Зорин on 07.07.2023.
//

import Network

class Reachability {
    static let shared = Reachability()
    private let monitor = NWPathMonitor()
    private var isReachable = true
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isReachable = path.status == .satisfied
        }
        let queue = DispatchQueue(label: "ReachabilityQueue")
        monitor.start(queue: queue)
    }
    
    func isConnectedToNetwork() -> Bool {
        return isReachable
    }
}
