//
//  MapModel.swift
//  GeographicalInfo
//
//  Created by Paresh Gorasva on 23/5/2022.
//

import Foundation
import CoreLocation

struct GeoDetails: Decodable {
    
    var typeId: Int?
    var departureTime: String?
    var route: String?
    var name: String?
    var latitude: Double?
    var longitude: Double?
    var hasMyKiTopUp: Bool?
    var isExpress: Bool?
    var location: CLLocationCoordinate2D? {
        CLLocationCoordinate2D(latitude: latitude ?? 0.0, longitude: longitude ?? 0.0)
    }
    var transportType: String? {
        return typeId == 0 ? "Train" : "Tram"
    }

}
