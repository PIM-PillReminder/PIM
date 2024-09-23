import Foundation
import FirebaseFirestore

class FireStoreManager: ObservableObject {
    @Published var pillStatusList: [PillStatus] = []
    @Published var notificationTime: Date?
    
    var documentID: String? {
        get {
            return UserDefaults.standard.string(forKey: "documentID")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "documentID")
        }
    }
    
    func createData(notificationTime: Date, pillStatus: PillStatus) async throws {
        let db = Firestore.firestore()
        
        do {
            
            let ref = try await db.collection("userData").addDocument(data: [
                "notificationTime": Timestamp(date: notificationTime),
                "pillDataArray": [pillStatus.toDictionary()]
            ])
            
            UserDefaults.standard.set(ref.documentID, forKey: "documentID")
            self.documentID = ref.documentID
            print("Document created with ID: \(ref.documentID)")
            
        } catch {
            print("Error creating document: \(error)")
            throw error
        }
    }
  
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
                
                if let pillDataArray = data?["pillDataArray"] as? [[String: Any]] {
                    self.pillStatusList = pillDataArray.map { dict in
                        let isPillEaten = dict["isPillEaten"] as? Bool ?? false
                        if let timestamp = dict["pillDate"] as? Timestamp {
                            let pillDate = timestamp.dateValue()
                            return PillStatus(isPillEaten: isPillEaten, pillDate: pillDate)
                        }
                        return PillStatus(isPillEaten: isPillEaten, pillDate: Date())
                    }
                }
                
                if let notificationTimestamp = data?["notificationTime"] as? Timestamp {
                    self.notificationTime = notificationTimestamp.dateValue()
                }
                completion(true)
            }
            completion(false)
        }
    }

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
                if let existingPillData = pillDataArray.first(where: {
                    if let existingTimestamp = $0["pillDate"] as? Timestamp {
                        return existingTimestamp.dateValue() == pillStatus.pillDate
                    }
                    return false
                }) {
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
        
        docRef.updateData([
            "notificationTime": Timestamp(date: notificationTime)
        ]) { error in
            if let error = error {
                print("Error updating notification time: \(error)")
            } else {
                print("Notification time successfully updated")
            }
        }
    }
}
