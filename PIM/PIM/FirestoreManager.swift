//
//  FirestoreManager.swift
//  PIM
//
//  Created by 장수민 on 2/24/24.
//

import Foundation
import FirebaseFirestore

class FireStoreManager: ObservableObject {
    @Published var pillStatusList: [PillStatus] = []
    @Published var notificationTime: String?
    
    var documentID: String? {
        get {
            return UserDefaults.standard.string(forKey: "documentID")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "documentID")
        }
    }
    
    func createData(notificationTime: String, pillStatus: PillStatus) async throws {
        let db = Firestore.firestore()
        
        do {
            // 새로운 문서 생성
            let ref = try await db.collection("userData").addDocument(data: [
                "notificationTime": notificationTime,
                "pillDataArray": [pillStatus.toDictionary()]
            ])
            
            // 생성된 documentID를 UserDefaults에 저장
            UserDefaults.standard.set(ref.documentID, forKey: "documentID")
            self.documentID = ref.documentID
            print("Document created with ID: \(ref.documentID)")
            
        } catch {
            print("Error creating document: \(error)")
            throw error
        }
    }
   
    // Firestore에서 데이터를 가져오는 함수
    func fetchData() {
        guard let documentID = self.documentID else {
            print("Document ID is nil")
            completion(false)
            return
        }
        let db = Firestore.firestore()
        let docRef = db.collection("userData").document(documentID)
        
        docRef.getDocument { (document, error) in
            guard error == nil else {
                print("Error fetching document:", error ?? "")
                completion(false)
                return
            }
            
            if let document = document, document.exists {
                let data = document.data()
                
                // Firestore에서 가져온 pillDataArray 배열을 변환
                if let pillDataArray = data?["pillDataArray"] as? [[String: Any]] {
                    self.pillStatusList = pillDataArray.map { dict in
                        let isPillEaten = dict["isPillEaten"] as? Bool ?? false
                        let pillDate = dict["pillDate"] as? String ?? ""
                        return PillStatus(isPillEaten: isPillEaten, pillDate: pillDate)
                    }
                }
                
                // Firestore에서 가져온 notificationTime을 변환
                if let notificationTime = data?["notificationTime"] as? String {
                    self.notificationTime = notificationTime
                }
                completion(true)
            }
            completion(false)
        }
    }

    // Firestore에 PillStatus 배열 저장하는 함수
    func savePillStatus(pillStatus: PillStatus) {
        guard let documentID = self.documentID else {
            print("Document ID is nil")
            return
        }
        
        let db = Firestore.firestore()
        let docRef = db.collection("userData").document(documentID)
        
        let pillStatusData = pillStatus.toDictionary()

        // 기존 날짜와 동일한 데이터를 삭제 (arrayRemove)
        docRef.getDocument { (document, error) in
            guard let document = document, document.exists else {
                print("Document does not exist.")
                return
            }
            
            if let data = document.data(), let pillDataArray = data["pillDataArray"] as? [[String: Any]] {
                // 동일한 날짜의 데이터가 있는지 확인
                if let existingPillData = pillDataArray.first(where: { $0["pillDate"] as? String == pillStatus.pillDate }) {
                    // 동일한 날짜의 데이터를 arrayRemove로 삭제
                    docRef.updateData([
                        "pillDataArray": FieldValue.arrayRemove([existingPillData])
                    ]) { error in
                        if let error = error {
                            print("Error removing existing pill status: \(error)")
                        } else {
                            print("Existing pill status successfully removed.")
                            // 삭제 후 새 데이터를 arrayUnion으로 추가
                            docRef.updateData([
                                "pillDataArray": FieldValue.arrayUnion([pillStatusData])
                            ]) { error in
                                if let error = error {
                                    print("Error updating pill status: \(error)")
                                } else {
                                    print("Pill status successfully updated.")
                                }
                            }
                        }
                    }
                } else {
                    // 동일한 날짜의 데이터가 없으면 바로 추가
                    docRef.updateData([
                        "pillDataArray": FieldValue.arrayUnion([pillStatusData])
                    ]) { error in
                        if let error = error {
                            print("Error adding pill status: \(error)")
                        } else {
                            print("Pill status successfully added.")
                        }
                    }
                }
            }
        }
    }


    // Firestore에 알림 시간을 저장하는 함수
    func updateNotificationTime(notificationTime: Date) {
        guard let documentID = self.documentID else {
            print("Document ID is nil")
            return
        }
        
        let db = Firestore.firestore()
        let docRef = db.collection("userData").document(documentID)
        
        // Firestore에 Date 타입으로 저장
        docRef.updateData([
            "notificationTime": notificationTime
        ]) { error in
            if let error = error {
                print("Error updating notification time: \(error)")
            } else {
                print("Notification time successfully updated")
            }
        }
    }
}
