//
//  TestMainView.swift
//  13jo
//
//  Created by Damin on 6/15/24.
//

import SwiftUI
@Observable
class TempCardModel {
    var question: String
    var answer: String
    init(question: String, answer: String) {
        self.question = question
        self.answer = answer
    }
}

struct TestMainView: View {
    @State private var tempCardList: [TempCardModel] = [
        TempCardModel(question: "퀴즈1", answer: "답변1"), TempCardModel(question: "퀴즈2", answer: "답변2"), TempCardModel(question: "퀴즈3", answer: "답변3"), TempCardModel(question: "퀴즈4", answer: "답변4"), TempCardModel(question: "퀴즈4", answer: "답변4")
    ]
    
    @State private var isGuideShowing: Bool = false
    
    var body: some View {
        
        ZStack {
            Color(hex: "171717")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Spacer()
                    Image("guideComment")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250, height: 47)
                        .overlay {
                            Text("앱을 어떻게 사용해야 하나요?")
                                .foregroundStyle(.white)
                        }
                    Image("Info")
                }
                .padding(.top, 36)
                .padding(.trailing, 28)
                Spacer()
                TestCardView()

                Spacer()
            }
            
        }
    }
}

#Preview {
    TestMainView()
}
