//
//  Assignment_AllianzTests.swift
//  Assignment AllianzTests
//
//  Created by Firman Aminuddin on 3/18/22.
//

import XCTest
import UIKit
@testable import Assignment_Allianz

class Assignment_AllianzTests: XCTestCase {
    
    // UI Func
    func testPresenter(){
        UserPresenter.downloadImage("") { image in
            if let image = image {
                DispatchQueue.main.async {
                    XCTAssertNotNil(image)
                }
            }
        }
    }
    
}
