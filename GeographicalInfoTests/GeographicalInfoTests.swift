//
//  GeographicalInfoTests.swift
//  GeographicalInfoTests
//
//  Created by Paresh Gorasva on 24/5/2022.
//

import XCTest
@testable import GeographicalInfo

class GeographicalInfoTests: XCTestCase {

    let service = Service()
    let viewModel = MapViewModel()
    let transportArray = ["All", "Train", "Tram"]
    let expressArray = ["All", "Yes", "No"]
    let myKiTopUpArray = ["All", "Yes", "No"]
    
    func testGetFileJsonIsSucess() {
        let expectation = expectation(description: "")
        service.getDataFromFile(fileName: "data.json", expecting: [GeoDetails].self) { result in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
            case.failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2)
    }
    
    func testCheckDefaultFilterType() {
        XCTAssertEqual(viewModel.transportType, "All")
        XCTAssertEqual(viewModel.expressType, "All")
        XCTAssertEqual(viewModel.hasMyKiTopUpType, "All")
    }
    
    func testChecFiltetPicker() {
        XCTAssertEqual(viewModel.transportArray, transportArray)
        XCTAssertEqual(viewModel.expressArray, expressArray)
        XCTAssertEqual(viewModel.myKiTopUpArray, myKiTopUpArray)
    }
    
    func testConvertDate() {
        XCTAssertEqual(viewModel.convertDate("2021-07-03T09:10:00.000Z"), "3rd Jul 2021, 7:10 pm")
    }
    
}
