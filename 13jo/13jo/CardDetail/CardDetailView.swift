//
//  CardDetailView.swift
//  13jo
//
//  Created by sungkug_apple_developer_ac on 6/15/24.
//

import SwiftUI

struct CardDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) var modelContext
    @StateObject private var motionManager = MotionManager()
    @State var quizModel: String = "나는 누굴까요?"
    @State private var showAlert = false
    @State var currentIndex = 0
    var shuffledCardList: [newCard] = [newCard(question: "1", answer: "1a"), newCard(question: "2", answer: "2a"), newCard(question: "3", answer: "3a"), newCard(question: "4", answer: "4a")]
    @State var isLastQuiz = false

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
                                print("뒤로가기")
                                //                    self.presentationMode.wrappedValue.dismiss()
                            }, label: {
                                Image("Close")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
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
            if !motionManager.isDeviceFlipped {
                Button(action: {
                    if currentIndex < shuffledCardList.count - 1{
                        currentIndex += 1
                    } else {
                        isLastQuiz = true
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
            HStack{
                Text(motionManager.isDeviceFlipped ? "A" : "Q")
                    .font(.system(size: 50))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.black)
                    .padding(20)
                Spacer()
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
                            .frame(width: 24, height: 24)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("퀴즈 삭제"),
                            message: Text("현재 퀴즈를 삭제하시겠습니까?"),
                            primaryButton: .destructive(Text("삭제"), action: {
                                print("삭제 버튼 클릭됨")
                            }),
                            secondaryButton: .cancel(Text("취소"), action: {
                                print("취소 버튼 클릭됨")
                                self.showAlert = false
                                
                            })                        
                        )
                    }
                }
                .padding()
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

#Preview {
    CardDetailView()
}

