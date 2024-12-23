//
//  NoticeContentView.swift
//  PIM
//
//  Created by Madeline on 12/1/24.
//

import SwiftUI

struct NoticeContentView: View {
    @Environment(\.presentationMode) var presentationMode
    let title: String
    let date: String
    let content: String
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.pretendard(.bold, size: 18))
                    .foregroundColor(.pimBlack)
                
                Text(date)
                    .font(.pretendard(.regular, size: 14))
                    .foregroundStyle(Color.gray06)
                    .padding(.vertical, 2)
                
                Text(content)
                    .font(.pretendard(.regular, size: 16))
                    .foregroundColor(.pimBlack)
                    .padding(.top, 32)
            }
            .padding(.horizontal, 18)
            .padding(.top, 20)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.pimBlack)
                        .font(.title3)
                }
            }
        }
    }
}
