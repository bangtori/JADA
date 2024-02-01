//
//  FirestoreService.swift
//  JADA
//
//  Created by 방유빈 on 2024/01/16.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

enum Collections {
    case users
    case diary
    
    var name: String {
        switch self {
        case .users:
            return "users"
        case .diary:
            return "diary"
        }
    }
}

final class FirestoreService {
    static let shared: FirestoreService = FirestoreService()
    
    let dbRef = Firestore.firestore()
    
    func saveDocument<T: Codable>(collectionId: Collections, documentId: String, data: T, completion: @escaping (Result<Bool, Error>) -> Void) {
        DispatchQueue.global().async {
            do {
                try self.dbRef.collection(collectionId.name).document(documentId).setData(from: data.self)
                completion(.success(true))
                
                print("Success to save new document at \(collectionId.name) \(documentId)")
            } catch {
                print("Error to save new document at \(collectionId.name) \(documentId) \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func loadDocument<T: Codable>(collectionId: Collections, documentId: String, dataType: T.Type, completion: @escaping (Result<T?, Error>) -> Void) {
        DispatchQueue.global().async {
            self.dbRef.collection(collectionId.name).document(documentId).getDocument { (snapshot, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let snapshot = snapshot, snapshot.exists {
                    do {
                        let documentData = try snapshot.data(as: dataType)
                        completion(.success(documentData))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.success(nil))
                }
            }
        }
    }
    
    func searchDocumentWithEqualField<T: Codable>(collectionId: Collections, field: String, compareWith: Any, dataType: T.Type, isDateOrder: Bool = true, completion: @escaping (Result<[T], Error>) -> Void) {
        DispatchQueue.global().async {
            var query = self.dbRef.collection(collectionId.name).whereField(field, isEqualTo: compareWith)
            if isDateOrder {
                query = query.order(by: "date", descending: true).order(by: "createdDate", descending: true)
            }
            query.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error in query: \(error)")
                    completion(.failure(error))
                    return
                }
                
                if let documents = querySnapshot?.documents {
                    if documents.isEmpty {
                        print("At \(collectionId.name) document is Empty")
                        completion(.success([]))
                        
                    } else {
                        var result: [T] = []
                        for document in documents {
                            if let temp = try? document.data(as: dataType) {
                                result.append(temp)
                            }
                        }
                        completion(.success(result))
                    }
                }
            }
        }
    }
    
    func loadDocuments<T: Codable>(collectionId: Collections, dataType: T.Type, completion: @escaping (Result<[T], Error>) -> Void) {
        
        let query = dbRef.collection(collectionId.name)
            .order(by: "createdDate", descending: true)
        
        DispatchQueue.global().async {
            query.getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error to load new document at \(collectionId.name) \(error)")
                    completion(.failure(error))
                    return
                }
                
                if let documents = querySnapshot?.documents {
                    var result: [T] = []
                    for document in documents {
                        if let temp = try? document.data(as: dataType) {
                            result.append(temp)
                        }
                    }
                    completion(.success(result))
                }
            }
        }
    }
    
    func updateDocument<T: Codable>(collectionId: Collections, documentId: String, field: String, data: T, completion: @escaping (Result<T, Error>) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            
            dbRef.collection(collectionId.name).document(documentId).updateData([field: data]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                    completion(.failure(err))
                    
                } else {
                    print("Document successfully updated")
                    completion(.success(data))
                }
            }
        }
    }
    
    
    func deleteDocument<T: Codable>(collectionId: Collections, field: String, isEqualto: T) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            dbRef.collection(collectionId.name).whereField(field, isEqualTo: isEqualto).getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("documents를 가져오는데 문제생김 \(error)")
                } else {
                    if let documents = querySnapshot?.documents {
                        for document in documents {
                            let documentID = document.documentID
                            
                            self.dbRef.collection(collectionId.name).document(documentID).delete { err in
                                if let err {
                                    print("deleteDocument \(err)")
                                } else {
                                    print("deleteDocument 제거 성공 ")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
   
    func deleteDocument(collectionId: Collections, documentId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            dbRef.collection(collectionId.name).document(documentId).delete { err in
                if let err {
                    print("Error updating document: \(err)")
                    completion(.failure(err))
                    
                } else {
                    print("Document successfully updated")
                    completion(.success(()))
                }
            }
        }
    }
}
