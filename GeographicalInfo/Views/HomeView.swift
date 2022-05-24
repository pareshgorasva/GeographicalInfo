//
//  HomeView.swift
//  GeographicalInfo
//
//  Created by Paresh Gorasva on 23/5/2022.
//

import SwiftUI
import MapKit

struct HomeView: View {
    
    @StateObject private var viewModel = MapViewModel()
    
    @State private var transportType = false
    
    var body: some View {

        NavigationView {
            MapView()
                .environmentObject(viewModel)
                .onAppear() {
                    viewModel.getData(fileName: "data.json")
                }
            .navigationTitle("Geographical Location")
            .navigationBarTitleDisplayMode(.inline)
        }
        ZStack {
            VStack {
                filterView
                .padding()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


extension HomeView {
    
    //MARK: - Filter View
    var filterView: some View {
        VStack (spacing: 10) {
            HStack {
                Text("Transport Type")
                    .frame(width: 120, alignment: .leading)
                Picker("",selection: $viewModel.transportType) {
                    ForEach(viewModel.transportArray, id: \.self) {
                        Text($0)
                        .onChange(of: viewModel.transportType) { transportType in
                            if transportType == "Train" {
                                viewModel.getTranportType(transportType, array: viewModel.geoDetails)
                                viewModel.getExpressType(viewModel.expressType, array: viewModel.filterGeoDetails)
                            }else if transportType == "Tram" {
                                viewModel.getTranportType(transportType, array: viewModel.geoDetails)
                                viewModel.getMyKiTopUpAvailable(viewModel.hasMyKiTopUpType, array: viewModel.filterGeoDetails)
                            }else {
                                viewModel.getTranportType(transportType, array: viewModel.geoDetails)
                                viewModel.getExpressType(viewModel.expressType, array: viewModel.filterGeoDetails)
                                viewModel.getMyKiTopUpAvailable(viewModel.hasMyKiTopUpType, array: viewModel.filterGeoDetails)
                            }
                            viewModel.addAnnotationPin()
                        }
                    }
                }
                .pickerStyle(.segmented)
            }
            HStack {
                if viewModel.transportType == "All" || viewModel.transportType == "Train" {
                    Text("Express")
                        .frame(width: 120, alignment: .leading)
                    Picker("", selection: $viewModel.expressType) {
                        ForEach(viewModel.expressArray, id: \.self) {
                            Text($0)
                            .onChange(of: viewModel.expressType) { expressType in
                                viewModel.getExpressType(expressType, array: viewModel.geoDetails)
                                viewModel.getTranportType(viewModel.transportType, array: viewModel.filterGeoDetails)
                                viewModel.addAnnotationPin()
                            }
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            HStack {
                if viewModel.transportType == "All" || viewModel.transportType == "Tram" {
                    Text("Myki Topup")
                        .frame(width: 120, alignment: .leading)

                    Picker("", selection: $viewModel.hasMyKiTopUpType) {
                        ForEach(viewModel.myKiTopUpArray, id: \.self) {
                            Text($0)
                            .onChange(of: viewModel.hasMyKiTopUpType) { mykiTopUpType in
                                viewModel.getMyKiTopUpAvailable(mykiTopUpType, array: viewModel.geoDetails)
                                viewModel.getTranportType(viewModel.transportType, array: viewModel.filterGeoDetails)
                                viewModel.addAnnotationPin()
                            }
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
        }
    }
}

