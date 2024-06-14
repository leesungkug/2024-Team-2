//
//  newCardView.swift
//  13jo
//
//  Created by Shim Hyeonhee on 6/15/24.
//


import SwiftUI
import SwiftData

@available(iOS 17.0, *)
struct newCardView: View {
    @Environment(\.modelContext) var modelContext 
    @State private var question = ""
    @State private var answer = ""
    let limitCount = 100
    
    @Query var newCards: [newCard]
    
    @State private var randomCard: newCard?

        
    var body: some View {
        VStack {
            Text("퀴즈를 \n 만들어 주세요!")
            HStack{
                Text("퀴즈문제 \(question) 입니다.")
                Spacer()
                Text("\(question.count) / \(limitCount)")
            }
            TextField("퀴즈문제", text: $question)
                .maxLength(text: $question, limitCount)
            HStack{
                Text("퀴즈정답 \(answer) 입니다.")
                Spacer()
                Text("\(answer.count) / \(limitCount)")
            }
            TextField("퀴즈정답", text: $answer)
                .maxLength(text: $answer, limitCount)
        }
        .padding(.leading, 40)
        Button {
            let newCard = newCard(question: question, answer: answer)
            modelContext.insert(newCard)
            
        } label: {
            Text("문제 추가하기")
                .fontWeight(.bold)
                       .frame(width: 354, height: 64)
                       .background(.blue)
                       .foregroundColor(.white)
                       .cornerRadius(10)
        }
        .padding(.vertical, 22)
        
        VStack{
            Text("테스트 / 읽기")
                .fontWeight(.bold)
            ForEach(newCards, id: \.self) { newCard in
                Text("질문 \(newCard.question)")
                Text("답변 \(newCard.answer)")
            }
        }
        Button {
           randomCard = newCards.randomElement()
        } label: {
            Text("랜덤추출하기")
                .fontWeight(.bold)
                       .frame(width: 354, height: 64)
                       .background(.blue)
                       .foregroundColor(.white)
                       .cornerRadius(10)
        }
        VStack {
            Text("테스트 / 랜덤뽑기")
                .fontWeight(.bold)
            if let randomCard = randomCard {
                           VStack{
                               Text("질문 \(randomCard.question)")
                               Text("답변 \(randomCard.answer)")
                           }
            }
        }
        Button {
            if let cardToDelete = randomCard {
                           modelContext.delete(cardToDelete)
                           randomCard = nil
                       }
        } label: {
            Text("지금 보는 데이터 삭제하기")
                .fontWeight(.bold)
                       .frame(width: 354, height: 64)
                       .background(.blue)
                       .foregroundColor(.white)
                       .cornerRadius(10)
        }

      
    }
}




