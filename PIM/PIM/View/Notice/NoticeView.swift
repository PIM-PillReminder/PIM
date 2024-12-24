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
                   NoticeRow(title: notice.title, date: notice.date, content: notice.content, hasVisitedNotice: $hasVisitedNotice)
                       .listRowSeparator(.hidden)
                       .listRowBackground(Color.clear)
                       .padding(.vertical, 4)
               }
           }
           .listStyle(PlainListStyle())
           .padding(.top, 16)
       }
       .background(Color.excpt212)
       .onDisappear() {
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
    @Binding var hasVisitedNotice: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            HStack {
                Text(title)
                    .font(.pretendard(.medium, size: 16))
                    .foregroundColor(.pimBlack)
                    .padding(.leading, 18)
                
                Spacer()
                
                if !hasVisitedNotice {
                    Text("New")
                        .font(.pretendard(.bold, size: 12))
                        .foregroundColor(.pimWhite)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 7)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.redwarning)
                        )
                        .padding(.trailing, 18)
                }
            }
            .padding(.top, 18)
            
            Text(date)
                .font(.pretendard(.regular, size: 14))
                .foregroundColor(.gray)
                .padding(.top, 4)
                .padding(.bottom, 18)
                .padding(.leading, 18)
        }
        .contentShape(Rectangle()) // 터치 영역 확장
        .onTapGesture {
            isNavigating = true
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.excpt11)
        )
        .background(
            NavigationLink(destination: NoticeContentView(title: title, date: date, content: content), isActive: $isNavigating) {
                EmptyView()
            }
            .hidden() // NavigationLink 자체를 숨김
        )
    }
}

