//
//  FirebaseStorageManager.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 13/04/2022.
//

import Foundation
import FirebaseStorage

class FirebaseStorageManager {
    static let shared = FirebaseStorageManager()

    private var storage = Storage.storage (url: "gs://parking-meter-343901.appspot.com")

    private init() {

    }

    func uploadFile(data values: [String: Data?], handler: @escaping ((_ urls: [String: URL]) -> Void)) {
        guard !values.isEmpty else { handler([:]); return }

        var urls: [String: URL] = [:]
        var uploadCount = 0

        for data in values {
            if let value = data.value {
                let riversRef = storage.reference().child(data.key)
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                _ = riversRef.putData(value, metadata: metadata) { metadata, error in
                    riversRef.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            handler([:])
                            return
                        }
                        urls[data.key] = downloadURL
                        uploadCount += 1
                        debugPrint("Number of images successfully uploaded: \(uploadCount)")
                        if uploadCount == values.count {
                            debugPrint("All Images are uploaded successfully, uploadedImageUrlsArray: \(urls)")
                            handler(urls)
                        }
                    }
                }
            }
        }
    }


}
