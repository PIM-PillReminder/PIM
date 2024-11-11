//
//  MailView.swift
//  PIM
//
//  Created by Madeline on 11/10/24.
//

import SwiftUI
import MessageUI

struct MailContentView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    
    let toRecipients: [String]
    let subject: String
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = context.coordinator
        
        // 받는 사람 이메일 설정
        mailComposer.setToRecipients(toRecipients)
        // 제목 설정
        mailComposer.setSubject(subject)
        
        return mailComposer
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailContentView
        
        init(_ parent: MailContentView) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController,
                                 didFinishWith result: MFMailComposeResult,
                                 error: Error?) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
