//
//  URL+Extension.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 04/12/2024.
//

import Foundation
import MobileCoreServices

extension URL {
    func mimeType() -> String {
        let pathExtension = self.pathExtension
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as CFString, nil)?.takeRetainedValue(),
           let mimeType = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue()
        {
            return mimeType as String
        }
        return "application/octet-stream"
    }
}
