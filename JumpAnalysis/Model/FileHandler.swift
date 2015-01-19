//
//  JsonFileHandler.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 19.01.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import Foundation

class FileHandler {
    private class func getDocumentDirectoryPath() -> String {
        //get the documents directory:
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true);
        let documentsDirectory: String? = paths.first as? String
        return documentsDirectory!
    }
    
    private class func getFilePathForFileName(fileName: String) -> String {
        return FileHandler.getDocumentDirectoryPath() + fileName
    }
    
    class func writeToFile(fileName: String, content: String) {
        content.writeToFile(FileHandler.getFilePathForFileName(fileName), atomically: false, encoding: NSUTF8StringEncoding, error: nil)
    }
    
    class func readFromFile(fileName: String) -> String {
        let fileContent = NSString(contentsOfFile: FileHandler.getFilePathForFileName(fileName), encoding: NSUTF8StringEncoding, error: nil)
        return fileContent!
    }
}
