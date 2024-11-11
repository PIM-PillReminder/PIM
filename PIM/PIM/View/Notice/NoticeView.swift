//
//  NoticeView.swift
//  PIM
//
//  Created by Madeline on 11/10/24.
//

import SwiftUI

struct NoticeData {
    static let noticeList: [(title: String, date: String)] = [
        ("PIM 오픈 베타 서비스 시작", "2025.03.20"),
        ("2024년 1월 업데이트 안내", "2025.01.15"),
        ("간편한 복약 관리, PIM과 함께해요", "2024.12.25"),
        ("알림 설정 기능이 추가되었습니다", "2024.11.30"),
        ("PIM 클로즈드 베타 테스트 안내", "2024.11.01")
    ]
}

struct NoticeView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var hasVisitedNotice: Bool
    
    var body: some View {
        
        VStack(spacing: 0) {
            List {
                ForEach(NoticeData.noticeList, id: \.title) { notice in
                    NoticeRow(title: notice.title, date: notice.date)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.backgroundGray)
                }
            }
            // .padding(.top, 26)
            .listStyle(PlainListStyle())
            .background(Color.backgroundGray)
        }
        .onAppear {
            hasVisitedNotice = true  // 뷰가 나타날 때 방문 표시
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
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading, spacing: 4) {
                
                Text(title)
                    .font(.pretendard(.medium, size: 18))
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
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .padding(.trailing, 19)
        }
        .listRowInsets(EdgeInsets(top: 13, leading: 18, bottom: 0, trailing: 18))
        .cornerRadius(16)
        .background(Color.white)
        .cornerRadius(16)
    }
}

//struct NoticeView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            NoticeView()
//        }
//    }
//}
