//
//  TestCallView.swift
//   gridin
//
//  Created by Liqing Pan on 2024-04-26.
//

import SwiftUI

struct TestCallView: View {
    @ObservedObject var callManager: CallManager
    
    @State private var isRecording = false
    
    var body: some View {
        VStack {
            Text("Transcript: \(callManager.getTranscription())")
                .padding()
            
            Text("Bot Answer: \(callManager.getAnswer())")
                .padding()
            
            if case .error(let errorMessage) = callManager.state {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            }
            
            Button(action: {
                self.isRecording.toggle()
                if self.isRecording {
                    self.callManager.start()
                } else {
                    self.callManager.stop()
                }
            }, label: {
                Text(self.isRecording ? "Recording..." : "Start Recording")
                    .padding()
            })
            .background(self.isRecording ? Color.blue : Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding()
            .onLongPressGesture(minimumDuration: 0.5) {
                self.isRecording = true
                self.callManager.start()
            }
            .onLongPressGesture(minimumDuration: 0.1, maximumDistance: 10, pressing: { pressing in
                self.isRecording = pressing
                if pressing {
                    self.callManager.start()
                } else {
                    self.callManager.stop()
                }
            }, perform: {})
        }
        .padding()
    }
}

struct TestCallView_Previews: PreviewProvider {
    static var previews: some View {
        TestCallView(callManager: CallManager())
    }
}
