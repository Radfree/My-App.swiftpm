import SwiftUI
import UIKit

class Score: ObservableObject {
    @Published var score: Int = 0
}

struct GameView: View {
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())]
    
    let operators: [String] = ["plus.circle", "minus.circle","multiply.circle"]
    
    let timer = Timer.publish(every: 1, on: .main, in:.common).autoconnect()
    
    @State private var operatorID: Int = 0
    @State private var currentValue: Int = 0
    @State private var goalValue: Int = Int.random(in: 1...30)
    @State private var isGameOver = false
    @State private var timeRemaining = 30
    @State private var setup: [String] = ["\(Int.random(in:1...9)).circle",
                                          "\(Int.random(in:1...9)).circle",
                                          "\(Int.random(in:1...9)).circle",
                                          "\(Int.random(in:1...9)).circle",
                                          "plus.circle",
                                          "\(Int.random(in:1...9)).circle",
                                          "\(Int.random(in:1...9)).circle",
                                          "\(Int.random(in:1...9)).circle",
                                          "\(Int.random(in:1...9)).circle",
    ]
    @ObservedObject var score = Score()
    var body: some View
    {
        GeometryReader { geometry in 
            VStack{
                Spacer()
                VStack{
                    Text("Timer: \(timeRemaining)")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .onReceive(timer, perform: { _ in
                            updateTimer()
                        })
                    HStack{
                        Text("Goal: \(goalValue)")
                            .font(.body)
                            .foregroundColor(.white)
                            .padding()
                            .background(.indigo)
                            .cornerRadius(25, antialiased: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                        
                        
                        HStack{
                            Text("Current: \(currentValue)")
                                .font(.body)
                                .foregroundColor(.white)
                                .padding()
                                .background(.indigo)
                                .cornerRadius(25, antialiased: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                            
                        }
                    }
                    .padding(/*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                }
                
                LazyVGrid(columns: columns, spacing: 5){
                    ForEach(0..<9, id: \.self) {i in 
                        ZStack{
                            Circle()
                                .foregroundColor(.cyan)
                                .frame(width: geometry.size.width/3 - 15, height: geometry.size.width/3 - 15, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            if i != 4{
                                Image(systemName: setup[i])
                                    .resizable()
                                    .frame(width: 120, height: 120, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .foregroundColor(.white)
                            }
                            else{
                                Image(systemName: operators[operatorID])
                                    .resizable()
                                    .frame(width: 120, height: 120, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .foregroundColor(.indigo)
                                    .onTapGesture {
                                        selectOperator()
                                    }
                            }
                        }
                        .onTapGesture {
                            let haptic = UIImpactFeedbackGenerator(style: .rigid)
                            haptic.impactOccurred()
                            let numberLabel = setup[i]
                            let numberValue = numberLabel.first?.wholeNumberValue
                            
                            guard numberValue != nil else {return}
                            performOperation(numberValue)
                            setup[i] = ""
                            winCondition()
                        }
                    }
                }
                .padding(.top)
                Text("Score: \(score.score)")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                
                .padding(.bottom)
                
                HStack{
                    Text("Restart")
                        .font(.body)
                        .foregroundColor(.white)
                        .padding()
                        .background(.indigo)
                        .cornerRadius(25, antialiased: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                        .onTapGesture {
                            let haptic1 = UIImpactFeedbackGenerator(style: .rigid)
                            haptic1.impactOccurred()
                            restartGame()
                        }
                }
                
            }
        
        }
    }
    func restartGame(){
        score.score = 0
        timeRemaining = 30
        goalValue = Int.random(in: 20...40)
        currentValue = 0
        operatorID = 0
        
        setup = ["\(Int.random(in:1...9)).circle",
                 "\(Int.random(in:1...9)).circle",
                 "\(Int.random(in:1...9)).circle",
                 "\(Int.random(in:1...9)).circle",
                 "plus.circle",
                 "\(Int.random(in:1...9)).circle",
                 "\(Int.random(in:1...9)).circle",
                 "\(Int.random(in:1...9)).circle",
                 "\(Int.random(in:1...9)).circle",
        ]
    }
    func countRemainingNumber(){
        var count = 0
        for i in setup{
            if i.isEmpty {
                count += 1
            }
            if count == 8 && currentValue != goalValue{
                timeRemaining = 0
            }
        }
    }
    func winCondition(){
        if goalValue == currentValue{
            score.score += 1
            timeRemaining += 5
            goalValue = Int.random(in: 20...40)
            currentValue = 0
            operatorID = 0
            
            setup = ["\(Int.random(in:1...9)).circle",
                     "\(Int.random(in:1...9)).circle",
                     "\(Int.random(in:1...9)).circle",
                     "\(Int.random(in:1...9)).circle",
                     "plus.circle",
                     "\(Int.random(in:1...9)).circle",
                     "\(Int.random(in:1...9)).circle",
                     "\(Int.random(in:1...9)).circle",
                     "\(Int.random(in:1...9)).circle",
            ]
        }
    }
    
    func performOperation(_ numberValue: Int?){
        if operatorID == 0{
            currentValue += numberValue!
        } else if operatorID == 1{
            currentValue -= numberValue!
        } else if operatorID == 2{
            currentValue *= numberValue!
        }
    }
    func selectOperator(){
        let haptic = UIImpactFeedbackGenerator(style: .rigid)
        haptic.impactOccurred()
        operatorID+=1
        if operatorID > 2{
            operatorID = 0
        }
    }
    func updateTimer(){
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else if timeRemaining <= 0{
            isGameOver = true
        }
    }
}
