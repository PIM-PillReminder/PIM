//
//  FirestoreManager.swift
//  PIM
//
//  Created by 장수민 on 2/24/24.
//

import Foundation
import FirebaseFirestore

class FireStoreManager: ObservableObject {
    var documentID: String? {
        get {
            return UserDefaults.standard.string(forKey: "documentID")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "documentID")
        }
    }
    @Published var isPillEaten: Bool?
    @Published var notificationTime: Date?
    
    init() {
    }
    
    //MARK: 파이어스토어에서 값 가져오는 함수
    func fetchData() {
        guard let documentID = self.documentID else {
            print("Document ID is nil")
            return
        }
        let db = Firestore.firestore()
        let docRef = db.collection("userData").document(documentID)
        docRef.getDocument { (document, error) in
            guard error == nil else {
                print("Error fetching document:", error ?? "")
                return
            }
            
            if let document = document, document.exists {
                let data = document.data()
                if let data = data {
                    if let notificationTimeTimestamp = data["notificationTime"] as? Timestamp {
                        self.notificationTime = notificationTimeTimestamp.dateValue()
                        print("Notification Time:", self.notificationTime ?? "N/A")
                    } else {
                        self.notificationTime = nil
                        print("Notification Time is nil")
                    }
                    self.isPillEaten = data["isPillEaten"] as? Bool
                    print("Is Pill Eaten:", self.isPillEaten ?? "N/A")
                }
            }
        }
    }

    
    
    func createData(notificationTime: Date, isPillEaten: Bool = false) async {
        let db = Firestore.firestore()
        do {
            let ref = try await db.collection("userData").addDocument(data: [
                "notificationTime": notificationTime,
                "isPillEaten": isPillEaten])
            // UserDefaults에 document ID 저장
            UserDefaults.standard.set(ref.documentID, forKey: "documentID")
            self.documentID = ref.documentID
            print("Document added with ID: \(ref.documentID)")
        } catch {
            print("Error adding document: \(error)")
        }
    }
    
    func updateIsPillEaten(isPillEaten: Bool) {
        guard let documentID = self.documentID else {
            print("Document ID is nil")
            return
        }
        
        let db = Firestore.firestore()
        let docRef = db.collection("userData").document(documentID)
        
        docRef.updateData([
            "isPillEaten": isPillEaten
        ]) { error in
            if let error = error {
                print("Error updating isPillEaten: \(error)")
            } else {
                print("isPillEaten successfully updated")
                // 업데이트가 성공했을 때 추가 작업을 수행할 수 있습니다.
            }
        }
    }
    
    func updateNotificationTime(notificationTime: Date) {
        guard let documentID = self.documentID else {
            print("Document ID is nil")
            return
        }
        
        let db = Firestore.firestore()
        let docRef = db.collection("userData").document(documentID)
        
        docRef.updateData([
            "notificationTime": notificationTime
        ]) { error in
            if let error = error {
                print("Error updating notificationTime: \(error)")
            } else {
                print("notificationTime successfully updated")
                // 업데이트가 성공했을 때 추가 작업을 수행할 수 있습니다.
            }
        }
    }
    
}
