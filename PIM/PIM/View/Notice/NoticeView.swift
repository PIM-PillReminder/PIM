//
//  NoticeView.swift
//  PIM
//
//  Created by Madeline on 11/10/24.
//

import SwiftUI

struct NoticeView: View {
   @Environment(\.presentationMode) var presentationMode
   @Binding var hasVisitedNotice: Bool
   
   var body: some View {
       VStack(spacing: 0) {
           List {
               ForEach(NoticeData.noticeList, id: \.title) { notice in
                   NoticeRow(title: notice.title, date: notice.date, content: notice.content)
                       .listRowSeparator(.hidden)
                       .listRowBackground(Color.clear)
                       .padding(.vertical, 4)
               }
           }
           .listStyle(PlainListStyle())
       }
       .background(Color("Excpt2-12"))
       .onAppear {
           hasVisitedNotice = true
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
           ToolbarItem(placement: .principal) {
               Text("피미네 소식")
                   .font(.pretendard(.bold, size: 18))
           }
       }
   }
}

struct NoticeRow: View {
    let title: String
    let date: String
    let content: String
    
    @Environment(\.presentationMode) var presentationMode
    @State private var isNavigating = false // 화면 전환 상태 관리
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.pretendard(.medium, size: 16))
                    .foregroundColor(.pimBlack)
                    .padding(.top, 28)
                    .padding(.leading, 26)
                
                Text(date)
                    .font(.pretendard(.regular, size: 11))
                    .foregroundColor(.gray)
                    .padding(.top, 7)
                    .padding(.bottom, 22)
                    .padding(.leading, 26)
            }
            
            Spacer()
        }
        .contentShape(Rectangle()) // 터치 영역 확장
        .onTapGesture {
            isNavigating = true
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("ExcptWhite11"))
        )
        .listRowInsets(EdgeInsets(top: 4, leading: 18, bottom: 4, trailing: 18))
        .background(
            NavigationLink(destination: NoticeContentView(title: title, date: date, content: content), isActive: $isNavigating) {
                EmptyView()
            }
            .hidden() // NavigationLink 자체를 숨김
        )
    }
}

