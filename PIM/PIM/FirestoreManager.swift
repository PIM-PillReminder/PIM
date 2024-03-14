//
//  FirestoreManager.swift
//  PIM
//
//  Created by 장수민 on 2/24/24.
//

import Foundation
import FirebaseFirestore

class FireStoreManager: ObservableObject {
  @Published var userDataTime: Date = Date()
  @Published var userDataNumber: Int = 0
  @Published var userPillIsEaten: Bool = false
  
  
  init() {
  
  }
  
  func fetchData() {
    let db = Firestore.firestore()
    let docRef = db.collection("userData").document("lRzM9vSa8Roiszd76Ikh")
    docRef.getDocument { (document, error) in
      guard error == nil else {
        print("error", error ?? "")
        return
      }
      
      if let document = document, document.exists {
        let data = document.data()
        if let data = data {
          self.userDataTime = data["time"] as? Date ?? Date()
          self.userDataNumber = data["number"] as? Int ?? Int()
        }
      }
    }
  }
  
  func fetchPillEatenData() {
    let db = Firestore.firestore()
    let docRef = db.collection("userData").document("lRzM9vSa8Roiszd76Ikh")
    docRef.getDocument { (document, error) in
      guard error == nil else {
        print("error", error ?? "")
        return
      }
      
      if let document = document, document.exists {
        let data = document.data()
        if let data = data {
          self.userDataTime = data["time"] as? Date ?? Date()
          self.userDataNumber = data["number"] as? Int ?? Int()
        }
      }
    }
  }
  
  func createData(time: Date, number: Int = 0) async {
    let db = Firestore.firestore()
    do {
      let ref = try await db.collection("userData").addDocument(data: [
        "time": time,
        "number": number])
      // UserDefaults에 document ID 저장
      UserDefaults.standard.set(ref.documentID, forKey: "documentID")
      print("Document added with ID: \(ref.documentID)")
    } catch {
      print("Error adding document: \(error)")
    }
  }
}
