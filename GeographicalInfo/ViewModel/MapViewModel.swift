//
//  MapViewModel.swift
//  GeographicalInfo
//
//  Created by Paresh Gorasva on 23/5/2022.
//

import SwiftUI
import MapKit

class MapViewModel: NSObject, ObservableObject {
    
    @Published var mapView = MKMapView()
    
    @Published var region = MKCoordinateRegion(center: MapDetails.defaultLocation,
                                               span: MapDetails.defaultSpan)
    
    @Published var geoDetails: [GeoDetails] = []
    @Published var filterGeoDetails: [GeoDetails] = []
    
    @Published var transportType = "All"
    @Published var expressType = "All"
    @Published var hasMyKiTopUpType = "All"

    @Published var transportArray = ["All", "Train", "Tram"]
    @Published var expressArray = ["All", "Yes", "No"]
    @Published var myKiTopUpArray = ["All", "Yes", "No"]
    
    
    //MARK: - Add annotation pin
    func addAnnotationPin() {
        mapView.removeAnnotations(mapView.annotations)
        for geoData in filterGeoDetails {
            let annotation = MKPointAnnotation()
            if let coordinate = geoData.location {
                annotation.coordinate = coordinate
                if let name = geoData.name {
                    if let tranportType = geoData.transportType {
                        annotation.title = name + " (\(tranportType))"
                    }else {
                        annotation.title = name
                    }
                }
                if let departureTime = geoData.departureTime {
                    annotation.subtitle = convertDate(departureTime)
                }
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    //MARK: - get filter transport
    func getTranportType(_ transportType: String, array: [GeoDetails]) {
        if transportType == "Train" {
            filterGeoDetails = array.filter({$0.typeId == 0})
        }else if transportType == "Tram" {
            filterGeoDetails = array.filter({$0.typeId == 1})
        }else {
            filterGeoDetails = array
        }
        self.transportType = transportType
    }
    
    //MARK: - get filter express
    func getExpressType(_ expressType: String, array: [GeoDetails]) {
        if expressType == "Yes" {
            filterGeoDetails = array.filter({$0.isExpress == true})
        }else if expressType == "No" {
            filterGeoDetails = array.filter({$0.isExpress == false})
        }else {
            filterGeoDetails = array
        }
        self.expressType = expressType
    }
    
    //MARK: - get filter myki topup
    func getMyKiTopUpAvailable(_ hasMyKiTopUp: String, array: [GeoDetails]) {
        if hasMyKiTopUp == "Yes" {
            filterGeoDetails = array.filter({$0.hasMyKiTopUp == true})
        }else if hasMyKiTopUp == "No" {
            filterGeoDetails = array.filter({$0.hasMyKiTopUp == false})
        } else {
            filterGeoDetails = array
        }
        self.hasMyKiTopUpType = hasMyKiTopUp
    }
    
    //MARK: - Get data from file
    func getData(fileName: String) {
        Service.shared.getDataFromFile(fileName: fileName, expecting: [GeoDetails].self) { result in
            switch result {
            case .success(let data):
                self.geoDetails = data
                self.filterGeoDetails = self.geoDetails
                if let geoDetail = self.geoDetails.first {
                    self.region = MKCoordinateRegion(center: geoDetail.location ?? MapDetails.defaultLocation, span: MapDetails.defaultSpan)
                    self.mapView.setRegion(self.region, animated: true)
                }
                self.addAnnotationPin()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension MapViewModel {
    
    //MARK: - convert date
    func convertDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "d"
            var day = dateFormatter.string(from: date)
            switch (day) {
                case "1" , "21" , "31":
                    day.append("st ")
                case "2" , "22":
                    day.append("nd ")
                case "3" ,"23":
                    day.append("rd ")
                default:
                    day.append("th ")
                }
            dateFormatter.dateFormat = "MMM YYYY, h:mm a"
            return day + dateFormatter.string(from: date)
        }
        return ""
    }
}
