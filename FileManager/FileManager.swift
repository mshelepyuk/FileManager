//
//  FileStorage.swift
//  FileStorage
//
//  Created by Maxim Shelepyuk on 24/03/2019.
//  Copyright © 2019 Maxim Shelepyuk. All rights reserved.
//

import Foundation

class FileStorage {
    
    private let fileManager: FileManager
    private let directory: FileManager.SearchPathDirectory
    
    init(fileManager: FileManager = .default, directory: FileManager.SearchPathDirectory) {
        self.fileManager = fileManager
        self.directory = directory
    }
}

extension FileStorage {
    
    func isExist(_ url: URL) -> Bool {
        if let path = try? directoryURL(for: url).path {
            return fileManager.fileExists(atPath: path)
        }
        return false
    }

    func write(_ data: Data, to url: URL) throws {
        let isFolder = url.pathComponents.count > 1
        let writeURL = try directoryURL(for: url)
        
        if isFolder {
            try fileManager.createDirectory(at: writeURL.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
        }
        try data.write(to: writeURL)
    }
    
    func obtain(from url: URL) throws -> Data? {
        if isExist(url) {
            let url = try directoryURL(for: url)
            return fileManager.contents(atPath: url.path)
        } else {
            throw FileStorage.Error.notExist
        }
    }
    
    func remove(at url: URL) throws {
        if isExist(url) {
            let url = try directoryURL(for: url)
            try fileManager.removeItem(at: url)
        } else {
            throw Error.notExist
        }
    }
}

extension FileStorage {
    
    func directoryURL(for url: URL) throws -> URL {
        var directoryURL = try fileManager.url(for: directory, in: .userDomainMask, appropriateFor: nil, create: false)
        directoryURL.appendPathComponent(from: url)
        return directoryURL
    }
}

extension URL {
    
    mutating func appendPathComponent(from anotherURL: URL) {
        let path = anotherURL.path.trimmingCharacters(in: ["/"])
        appendPathComponent(path)
    }
}
