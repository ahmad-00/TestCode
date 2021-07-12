//
//  TestCodeTests.swift
//  TestCodeTests
//
//  Created by Ahmad Mohammadi on 6/8/21.
//

import XCTest
@testable import TestCode
import Combine
import CoreData

class TestCodeTests: XCTestCase {

    private var cancelable : Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancelable = []
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPokomonApi() throws {
        let expectation = self.expectation(description: "pokomonExp")
        var error : ApiError?
        var pokomons: Pokomons?
        
        
        NetworkManager.shared.getPokomonList(offset: 0, limit: 10)
            .subscribe(on: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { (_result) in
                
                switch _result {
                case .failure(let _error):
                    error = _error
                case .finished:
                    break
                }
                
            } receiveValue: { _pokomons in
                pokomons = _pokomons.results
                expectation.fulfill()
            }.store(in: &cancelable)
        
        waitForExpectations(timeout: 10)
        XCTAssertNil(error)
        XCTAssertNotNil(pokomons)
        XCTAssertTrue(pokomons?.count == 10)
        
    }
    
    func testPokomonDetailApi() throws {
        let expectation = self.expectation(description: "pokomonDetailExp")
        var error : ApiError?
        var pokomon: PokomonDetail?
        
        let randId = Int.random(in: Range(1...100))
        
        
        NetworkManager.shared.getPokomonDetail(url: (BaseNetworkManager.Endpoint.pokomonList.url.appendingPathComponent(String(randId)).absoluteString))
            .subscribe(on: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { (_result) in
                
                switch _result {
                case .failure(let _error):
                    error = _error
                case .finished:
                    break
                }
                
            } receiveValue: { _pokomon in
                pokomon = _pokomon
                expectation.fulfill()
            }.store(in: &cancelable)
        
        waitForExpectations(timeout: 10)
        XCTAssertNil(error)
        XCTAssertNotNil(pokomon)
        XCTAssertTrue(pokomon?.id == randId)
    }
    
    func testCoreDataWrite() throws {
        
        let item = PokomonEntity(context: PersistenceManager.shared.context)
        item.name = "Test"
        item.ability = "aaa,bbb,ccc"
        item.image = "someimagename"
        item.id = 10
        
        do {
            try PersistenceManager.shared.context.save()
        } catch {
            XCTAssertTrue(false)
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PokomonEntity")
        request.predicate = NSPredicate(format:"name == %@", "Test")
        guard let data = try? PersistenceManager.shared.context.fetch(request) as? [PokomonEntity] else {
            XCTAssertTrue(false)
            return
        }
        
        XCTAssertTrue(data.count == 1)
        XCTAssertEqual(data[0].name, item.name)
        XCTAssertEqual(data[0].ability, item.ability)
        XCTAssertEqual(data[0].image, item.image)
        XCTAssertEqual(data[0].id, item.id)
        
        PersistenceManager.shared.context.delete(data[0])
        try! PersistenceManager.shared.context.save()
        
    }
    
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
