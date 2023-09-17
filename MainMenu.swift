import SwiftUI

struct MainMenu: View {
    var body: some View {
        Text("Fast Maths")
        
        NavigationLink(destination: GameView()){
            HStack{
                Image(systemName: "play.circle")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Text("Start")
                    .font(.title)
            }
            .frame(width: 250, height: 50, alignment: .center)
            .background(.cyan)
            .cornerRadius(25)
            .foregroundColor(.white)
            .navigationBarHidden(true)
        }
    }
}
