//
//  Enum.swift
//  GeographicalInfo
//
//  Created by Paresh Gorasva on 23/5/2022.
//

import Foundation
import MapKit

enum Response<Success, Failure: Error> {
    case success(Success)
    case failure(Failure)
}

enum ServiceError: String, Error {
    
    case invalidURL = "Invalid URL!!. Please Check URL."
    case invalidResponse = "Invalid Response."
    case invalidData = "The data recieved from the server was invalid."
    case errorMessage = "Something went wrong please try again after sometime "
    case fileError = "Couldn't load file in bundle"
    case fileInvalidData = "Couldn't load file data from main bundle"
    case fileInvalidJson = "The data recieved from file was invalid."
}


enum ApiURL {
    static let getGeographicalInformation = "https://github.com/elementengineering/Mobile-App-Coding-Challenge/blob/master/data/data.json"
}


enum HttpMethod {
    static let post = "POST"
    static let get = "GET"
    static let delete = "DELETE"
    static let put = "PUT"
}

enum MapDetails {
    static let defaultLocation = CLLocationCoordinate2D(latitude: -37.9701478, longitude: 144.4913467)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.8, longitudeDelta: 0.8)
}
