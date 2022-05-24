//
//  MessageManager.swift
//  Meter Card and Smart Parking Meter
//
//  Created by Mohammed Skaik on 14/05/2022.
//

import Foundation
import FirebaseFirestore

class MessageManager {

    static let shared = MessageManager()

    private let db = Firestore.firestore()
    private var messagesFireStoreReference: CollectionReference?

    typealias ResultMessageHandler = ((_ message: MessageModel?, _ errorMessage: String?) -> Void)?
    typealias ResultMessagesHandler = ((_ messages: [MessageModel], _ errorMessage: String?) -> Void)?

    private init() {
        self.messagesFireStoreReference = db.collection("messages")
    }

    func setMessage(message: MessageModel?, imageData: Data?, failure: FailureHandler) {
        guard let _messagesFireStoreReference = self.messagesFireStoreReference, let _message = message, let _id = _message.id, let newMessage = _message.messages.last, let sentDate = newMessage?.sentDate else { failure?("Server Error"); return }
        var data: [String: Data?] = [:]
        let path = "Messages/\(_id)/image/\(sentDate).jpeg"
        if let _imageData = imageData {
            data[path] = _imageData
        } 
        FirebaseStorageManager.shared.uploadFile(data: data) { urls in
            if let _ = imageData, urls.isEmpty { failure?("Error Internet"); return }
            if urls.first?.key == path {
                newMessage?.imageURL = urls.first?.value.absoluteString
            }
            _messagesFireStoreReference.document(_id).setData(_message.getDictionary()) { error in
                if let _error = error {
                    failure?(_error.localizedDescription)
                    return
                }
                // Added Message
                failure?(nil)
            }
        }
    }

    func getMessage(senderID: String?, receiverID: String?, result: ResultMessageHandler) {
        guard let _messagesFireStoreReference = self.messagesFireStoreReference else { result?(nil, "Server Error"); return }

        _messagesFireStoreReference.addSnapshotListener { snapshot, error in
            if let _error = error {
                result?(nil, _error.localizedDescription)
                return
            }
            var messageModel: MessageModel?

            for message in snapshot?.documents ?? [] {
                if let _message = MessageModel.init(id: message.documentID, dictionary: message.data()), (_message.receiverID == receiverID || _message.receiverID == senderID), (_message.senderID == senderID || _message.senderID == receiverID) {
                    messageModel = _message
                }
            }
            messageModel?.sorted()
            result?(messageModel, nil)
        }
    }

    func getAllMessagesToAuth(isShowIndicator: Bool, senderID: String?, result: ResultMessagesHandler) {
        guard let _messagesFireStoreReference = self.messagesFireStoreReference else { result?([], "Server Error"); return }
        Helper.showIndicator(isShowIndicator)
        _messagesFireStoreReference.getDocuments { snapshot, error in
            Helper.dismissIndicator(isShowIndicator)
            if let _error = error {
                result?([], _error.localizedDescription)
                return
            }
            var messages: [MessageModel] = []

            for message in snapshot?.documents ?? [] {
                if let _message = MessageModel.init(id: message.documentID, dictionary: message.data()), (_message.senderID == senderID || _message.receiverID == senderID) {
                    _message.sorted()
                    messages.append(_message)
                }
            }
            result?(messages, nil)
        }
    }

}
