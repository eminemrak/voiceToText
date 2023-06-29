//
//  Document.swift
//  voiceText
//
//  Created by Eminko on 24.06.2023.
//

import Foundation

struct Document {
    var projectNamee : String
    var documentContent : String
    var mediaURL : String
    var mediaName : String
    
    init(projectNamee: String, documentContent: String, mediaURL: String, mediaName: String) {
        self.projectNamee = projectNamee
        self.documentContent = documentContent
        self.mediaURL = mediaURL
        self.mediaName = mediaName
    }
    
}
