//
//  CardDetailView.swift
//  13jo
//
//  Created by sungkug_apple_developer_ac on 6/15/24.
//

import SwiftUI
import SwiftData

struct CardDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) var modelContext
    @Query var newCards: [newCard]
    @StateObject private var motionManager = MotionManager()
    @State var quizModel: String = "나는 누굴까요?"
    @State private var showAlert = false
    @State var currentIndex = 0
    @State var isLastQuiz = false
    @State var shuffledCardList: [newCard] = Array(repeating: newCard(question: "", answer: ""), count: 100)

    var body: some View {
        VStack {

            Spacer()
            if !motionManager.isDeviceFlipped{
                ZStack{
                    Spacer()
                    Image("arrow")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 106, height: 106)
                        .padding(.bottom, 20)
                    Spacer()
                    HStack{
                        Spacer()
                        VStack{
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                            }, label: {
                                Image(isLastQuiz ? "Activeclose" : "Close")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 35, height: 35)
                            })
                            Spacer()
                        }
                    }
                }
                Text(isLastQuiz ? "모든 퀴즈가 끝났습니다" : "고개를 들어서 정답을 확인")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(isLastQuiz ? Color("MainColor") :.white)
                    .padding(.bottom, 20)
                    
            }
            card
                .padding(.bottom, 55)
                .animation(.easeInOut, value: motionManager.isDeviceFlipped)
//                .sheet(isPresented: $showAlert) {
//                     DeleteConfirmationView(showSheet: $showAlert, deleteAction: deleteCard)
//                 }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("퀴즈 삭제"),
                        message: Text("현재 퀴즈를 삭제하시겠습니까?"),
                        primaryButton: .destructive(Text("삭제"), action: {
                            print("삭제 버튼 클릭됨")
                            deleteCard()
                            print("디버그2", shuffledCardList, "index", currentIndex)
                        }),
                        secondaryButton: .cancel(Text("취소"))
                    )
                }
            if !motionManager.isDeviceFlipped {
                Button(action: {
                    if currentIndex < shuffledCardList.count - 1{
                        currentIndex += 1
                        if currentIndex == shuffledCardList.count - 1{
                            isLastQuiz = true
                        }
                    }
                }, label: {
                    HStack{
                        Spacer()
                        Text("다음")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.black)
                        Spacer()
                    }
                    .frame(height: 64)
                    .background(isLastQuiz ? Color("DisabledColor") : Color("MainColor"))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.bottom, 50)
                })
                .disabled(isLastQuiz)
            } else if !motionManager.isDeviceFlippedFor5Seconds{
                VStack{
                    Text("정답 확인하기")
                        .font(.system(size: 41, weight: .bold))
                        .padding(.bottom, 15)
                    Text("퀴즈의 정답 확인을 위해\n고개를 든 상태로 유지해주세요.")
                        .font(.system(size: 20, weight: .semibold))
                        .multilineTextAlignment(.center)
                }
                .padding(.bottom, 70)
            } else {
                VStack{
                    Text("돌아가서 퀴즈를 확인")
                        .font(.system(size: 20, weight: .bold))
                        .padding(.bottom, 15)
                    Image("arrow")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 106, height: 106)
                        .rotationEffect(.degrees(180.0))
                }
            }
        }
        .padding()
        .background(.black)
        .navigationBarBackButtonHidden(true)
        .onAppear(perform: {
            if shuffledCardList.count == 1{
                isLastQuiz = true
            }
        })
        
    }
    
    var card: some View {
        
        ZStack{
            Rectangle()
                .foregroundStyle(.gray.opacity(0.4))
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                .rotationEffect(.degrees(10))
                .offset(x: motionManager.isDeviceFlipped ? 60 :-40, y: motionManager.isDeviceFlipped ? -50 : 20)
            Rectangle()
                .foregroundStyle(motionManager.isDeviceFlipped ? Color("MainColor") : .white)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                .shadow(color: .black, radius: 10, x: 0, y: 5)
            if motionManager.isDeviceFlipped && !motionManager.isDeviceFlippedFor5Seconds{
                ProgressRingView(progress: $motionManager.timeIntervalSince)
            } else {
                quiz
            }
        }
        .frame(width: 315, height: 424)
    }
    
    var quiz: some View {
        VStack{
            HStack(alignment: .top){
                Text(motionManager.isDeviceFlipped ? "A" : "Q")
                    .font(.system(size: 50))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.black)
                    .padding(20)
                Spacer()
                Text("\(currentIndex + 1)/\(shuffledCardList.count)개")
                    .font(.system(size: 15))
                    .fontWeight(.regular)
                    .foregroundStyle(.black)
                    .padding()
            }
            Text("\(motionManager.isDeviceFlipped ? shuffledCardList[currentIndex].answer : shuffledCardList[currentIndex].question)")
                .font(.system(size: 40))
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .foregroundStyle(.black)
            Spacer()
            if motionManager.isDeviceFlippedFor5Seconds{
                HStack{
                    Spacer()
                    Button {
                        self.showAlert = true
                    } label: {
                        Image("Trash")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 36, height: 36)
                    }
                }
                .padding()
            }
        }
 
    }
    
    private func deleteCard(){
        for card in newCards{
            if card.id == shuffledCardList[currentIndex].id{
                modelContext.delete(card)
            }
        }
    }
}


struct ProgressRingView: View {
    @Binding var progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Color(.gray))
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress / 5, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(.white)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear, value: progress / 5)
            Text(String(format: "%.0f", min(progress, 5.0)))
                .font(.system(size: 100, weight: .black))
                .foregroundColor(Color.white)
        }
        .padding(40)
    }
}

struct DeleteConfirmationView: View {
    @Binding var showSheet: Bool
    var deleteAction: () -> Void
    
    var body: some View {
        VStack {
            Text("퀴즈 삭제")
                .font(.headline)
                .padding()
            
            Text("현재 퀴즈를 삭제하시겠습니까?")
                .padding()
            
            HStack {
                Button(action: {
                    deleteAction()
                    showSheet = false
                }) {
                    Text("삭제")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Spacer().frame(width: 20)
                
                Button(action: {
                    showSheet = false
                }) {
                    Text("취소")
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    CardDetailView()
}

