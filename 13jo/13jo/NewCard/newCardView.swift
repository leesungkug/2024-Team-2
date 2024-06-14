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
    let buttonColor = Color(r: 83, g: 231, b: 251)
    let textfieldColor = Color(r: 35, g: 35, b: 35)
    
    @Query var newCards: [newCard]
    
    @State private var randomCard: newCard?

        
    var body: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
                 
            VStack{
                VStack(alignment:.leading) {
                   
                        Text("퀴즈를\n")
                            .foregroundColor(buttonColor)
                            .font(.system(size: 40))
                            .fontWeight(.bold)
                        Text("만들어주세요!")
                            .foregroundColor(.white)
                            .font(.system(size: 40))
                            .fontWeight(.bold)
                    Spacer()
                        .frame(height: 38)
                   
                    HStack{
                        Text("퀴즈문제 \(question) 입니다.")
                        Spacer()
                        Text("\(question.count) / \(limitCount)자")
                    }
                    TextField("퀴즈문제", text: $question)
                        .maxLength(text: $question, limitCount)
                        .background(textfieldColor)
                    Spacer()
                        .frame(height: 24)
                    HStack{
                        Text("퀴즈정답 \(answer) 입니다.")
                        Spacer()
                        Text("\(answer.count) / \(limitCount)자")
                    }
                    TextField("퀴즈정답", text: $answer)
                        .maxLength(text: $answer, limitCount)
                        .background(textfieldColor)
                    
                }
                .foregroundColor(.white)
                .padding(.vertical, 40)
                Button {
                    let newCard = newCard(question: question, answer: answer)
                    modelContext.insert(newCard)
                    
                } label: {
                    Text("문제 추가하기")
                        .fontWeight(.bold)
                        .frame(width: 354, height: 64)
                        .background(buttonColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.vertical, 22)
            }
        }
       
           
        /*
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
             
             */
            
        
      
    }
}




