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

    func setMessage(message: MessageModel?, failure: FailureHandler) {
        guard let _messagesFireStoreReference = self.messagesFireStoreReference, let _message = message, let _id = _message.id else { failure?("Server Error"); return }

        _messagesFireStoreReference.document(_id).setData(_message.getDictionary()) { error in
            if let _error = error {
                failure?(_error.localizedDescription)
                return
            }
            // Added Message
            failure?(nil)
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

    func getAllMessagesToAuth(senderID: String?, result: ResultMessagesHandler) {
        guard let _messagesFireStoreReference = self.messagesFireStoreReference else { result?([], "Server Error"); return }

        _messagesFireStoreReference.getDocuments { snapshot, error in
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
