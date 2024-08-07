import SwiftUI

struct PinnaView: View {
    @State private var isListening = false
    @State private var buttonText = "Tap to start"
    @State private var scaleOuter = 1.0
    @State private var scaleMiddle = 1.0
    @State private var scaleInner = 1.0
    
    @State private var showLabel = false
    
    let logoPositionPercentage: CGFloat = 0.3
    let spacerHeight: CGFloat = 30

    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    // Updated gradient colors for a more environmental theme
    let outerGradient = RadialGradient(
        gradient: Gradient(colors: [
            Color(red: 144/255, green: 238/255, blue: 144/255, opacity: 0.6), // Light Green
            Color(red: 34/255, green: 139/255, blue: 34/255, opacity: 0.6) // Forest Green
        ]),
        center: .center, startRadius: 0, endRadius: 90
    )
    let middleGradient = RadialGradient(
        gradient: Gradient(colors: [
            Color(red: 144/255, green: 238/255, blue: 144/255, opacity: 0.7), // Light Green
            Color(red: 34/255, green: 139/255, blue: 34/255, opacity: 0.7) // Forest Green
        ]),
        center: .center, startRadius: 0, endRadius: 75
    )
    let innerGradient = RadialGradient(
        gradient: Gradient(colors: [
            Color(red: 144/255, green: 238/255, blue: 144/255), // Light Green
            Color(red: 34/255, green: 139/255, blue: 34/255) // Forest Green
        ]),
        center: .center, startRadius: 0, endRadius: 60
    )

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Color(red: 240/255, green: 248/255, blue: 255/255).edgesIgnoringSafeArea(.all) // Light blue background for harmony

                    VStack {
                        Spacer().frame(height: geometry.size.height * logoPositionPercentage - 50)

                        Button(action: toggleListening) {
                            ZStack {
                                Circle()
                                    .fill(outerGradient)
                                    .scaleEffect(scaleOuter)
                                    .frame(width: 180, height: 180)
                                
                                Circle()
                                    .fill(middleGradient)
                                    .scaleEffect(scaleMiddle)
                                    .frame(width: 150, height: 150)
                                
                                Circle()
                                    .fill(innerGradient)
                                    .scaleEffect(scaleInner)
                                    .frame(width: 120, height: 120)
                                
//                                Image("pinna_transparent")
//                                    .resizable()
//                                    .frame(width: 100, height: 100)
//                                    .background(Color.clear)
//                                    .aspectRatio(contentMode: .fit)
                            }
                        }
                        .foregroundColor(.white)
                        .animation(.default)
                        
                        Spacer().frame(height: spacerHeight)
                        Text(buttonText.uppercased())
                            .foregroundColor(.gray)
                            .font(.title2.bold())
                        if showLabel {
                            HStack {
                                Image(systemName: "leaf.fill")
                                    .foregroundColor(.green)
                                    .padding(.top, 2)
                                Text("Environmental Protection Information")
                                    .lineLimit(nil)
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding(.vertical)
                            .padding(.horizontal, 10)
                            .frame(width: UIScreen.main.bounds.width * 0.9)
                            .background(Color(red: 220/255, green: 248/255, blue: 220/255))
                            .cornerRadius(5)
                            .transition(.opacity)
                            .animation(.easeInOut)
                        }
                        
                        Spacer()

                        Button("Environmental Info") {
                            withAnimation {
                                showLabel.toggle()
                            }
                        }
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)

                        NavigationLink(destination: HistoryView(incidents: sampleEvents)) {
                            Text("View History")
                                .foregroundColor(.green)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.green, lineWidth: 2)
                                )
                        }
                        .padding(.bottom)
                    }
                }
                .onReceive(timer) { _ in
                    updateScales()
                }
            }
        }
    }

    private func toggleListening() {
        isListening.toggle()
        buttonText = isListening ? "Listening..." : "Tap to start"
        if !isListening {
            scaleOuter = 1.0
            scaleMiddle = 1.0
            scaleInner = 1.0
        }
    }

    private func updateScales() {
        guard isListening else { return }
        let currentTime = CACurrentMediaTime()
        scaleOuter = 1.0 + 0.25 * cos(currentTime)
        scaleMiddle = 1.0 + 0.20 * cos(currentTime)
        scaleInner = 1.0 + 0.15 * cos(currentTime)
    }
}

struct PinnaView_Previews: PreviewProvider {
    static var previews: some View {
        PinnaView()
    }
}
