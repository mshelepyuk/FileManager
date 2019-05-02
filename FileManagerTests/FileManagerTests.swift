//
//  FileManagerTests.swift
//  FileManagerTests
//
//  Created by Maxim Shelepyuk on 24/03/2019.
//  Copyright © 2019 Maxim Shelepyuk. All rights reserved.
//

import XCTest
@testable import FileManager

class FileStorageTests: XCTestCase {
    
    var fileStorage: FileStorage!
    
    let manager = FileManager()
    
    override func setUp() {
        fileStorage = FileStorage(fileManager: manager, directory: .documentDirectory)
        
        super.setUp()
    }
    
    override func tearDown() {
        let file = FileMock()
        do {
            try fileStorage.remove(at: file.url)
        } catch {
            debugPrint(error)
        }
        
        super.tearDown()
    }
    
    func testSaveFileWithoutFolder() {
        // given
        let file = FileMock(path: "filename.jpg")
        let path = url(for: file.url).path
        XCTAssertFalse(manager.fileExists(atPath: path))
        let imageData = self.data(from: firstImage())
        
        // when
        do {
            try fileStorage.write(imageData, to: file.url)
        } catch {
            XCTAssert(false)
        }
        
        // then
        XCTAssertTrue(manager.fileExists(atPath: path))
        XCTAssertTrue(fileStorage.isExist(file.url))
        
        // clean up
        try! fileStorage.remove(at: file.url)
        XCTAssertFalse(manager.fileExists(atPath: path))
    }
    
    func testSaveFile() {
        // given
        let file = FileMock()
        let path = url(for: file.url).path
        XCTAssertFalse(manager.fileExists(atPath: path))
        let imageData = self.data(from: firstImage())
        
        // when
        do {
            try fileStorage.write(imageData, to: file.url)
        } catch {
            XCTAssert(false)
        }
        
        // then
        XCTAssertTrue(manager.fileExists(atPath: path))
        XCTAssertTrue(fileStorage.isExist(file.url))
    }
    
    func testObtain() {
        // given
        let file = FileMock()
        XCTAssertFalse(manager.fileExists(atPath: file.url.path))
        let imageData = self.data(from: firstImage())
        try! fileStorage.write(imageData, to: file.url)
        
        // when
        let data = try! fileStorage.obtain(from: file.url)
        
        // then
        XCTAssertNotNil(data)
        XCTAssertEqual(data, imageData)
    }
    
    func testObtainNotExistFile() {
        // given
        let file = FileMock()
        let path = url(for: file.url).path
        XCTAssertFalse(manager.fileExists(atPath: path))
        
        // when
        do {
            let data = try fileStorage.obtain(from: file.url)
            XCTAssertNil(data)
        } catch {
            XCTAssertTrue(error.localizedDescription == FileStorage.Error.notExist.localizedDescription)
        }
    }
    
    func testRemove() {
        // given
        let file = FileMock()
        let path = url(for: file.url).path
        XCTAssertFalse(manager.fileExists(atPath: path))
        let imageData = self.data(from: firstImage())
        
        // when
        try! fileStorage.write(imageData, to: file.url)
        XCTAssertTrue(fileStorage.isExist(file.url))
        try! fileStorage.remove(at: file.url)
        
        // then
        XCTAssertFalse(fileStorage.isExist(file.url))
    }
    
    func testReWriteFile() {
        // given
        let file = FileMock()
        let path = url(for: file.url).path
        XCTAssertFalse(manager.fileExists(atPath: path))
        let firstImageData = data(from: firstImage())
        let secondImageData = data(from: secondImage())
        
        // when
        try! fileStorage.write(firstImageData, to: file.url)
        XCTAssertTrue(fileStorage.isExist(file.url))
        
        let resultDataOfFirstImage = try! fileStorage.obtain(from: file.url)
        XCTAssertEqual(resultDataOfFirstImage, firstImageData)
        
        try! fileStorage.write(secondImageData, to: file.url)
        let resultDataOfSecondFile = try! fileStorage.obtain(from: file.url)
        XCTAssertEqual(resultDataOfSecondFile, secondImageData)
    }
}

extension FileStorageTests {
    
    struct FileMock {
        let url: URL
        
        init(path: String = "/thumbnail/filename.jpg") {
            url = URL(fileURLWithPath: path)
        }
    }
}

extension FileStorageTests {
    
    func url(for fileURL: URL) -> URL {
        return try! manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(fileURL.path)
    }
    
    func firstImage() -> UIImage {
        let bundle = Bundle(for: FileStorageTests.self)
        return UIImage(named: "first.jpg", in: bundle, compatibleWith: nil)!
    }
    
    func secondImage() -> UIImage {
        let bundle = Bundle(for: FileStorageTests.self)
        return UIImage(named: "second.jpg", in: bundle, compatibleWith: nil)!
    }
    
    func data(from image: UIImage) -> Data {
        return image.jpegData(compressionQuality: 0.1)!
    }
}
