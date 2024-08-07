//
//  TestS2TView.swift
//   gridin
//
//  Created by Liqing Pan on 2024-04-26.
//

import SwiftUI
import Combine

struct TestS2TView: View {
    @ObservedObject private var speechManager = SpeechToTextManager()
    @State private var isRecording = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Speech to Text Demo")
                .font(.largeTitle)

            Text(speechManager.transcription)
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)
                .font(.title2)
                .frame(minHeight: 100)

            Text(displayState(speechManager.state))
                .foregroundColor(.red)
                .font(.headline)

            Button(isRecording ? "Stop Recording" : "Start Recording") {
                if self.isRecording {
                    self.speechManager.stop()
                } else {
                    self.speechManager.start()
                }
                self.isRecording.toggle()
            }
            .foregroundColor(.white)
            .padding()
            .background(isRecording ? Color.red : Color.green)
            .cornerRadius(8)
            .font(.headline)
        }
        .padding()
    }

    private func displayState(_ state: S2TState) -> String {
        switch state {
        case .transcribing:
            return "Transcribing..."
        case .idle:
            return "Idle"
        case .error(let message):
            return "Error: \(message)"
        }
    }
}

struct TestS2TView_Previews: PreviewProvider {
    static var previews: some View {
        TestS2TView()
    }
}
