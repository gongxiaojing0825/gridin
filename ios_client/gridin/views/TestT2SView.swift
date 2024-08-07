//
//  TestT2SView.swift
//   gridin
//
//  Created by Liqing Pan on 2024-04-26.
//

import SwiftUI

struct TextToSpeechTestView: View {
    @ObservedObject var speechManager = TextToSpeechManager()
    @State private var inputText: String = "Hello, how are you today?"

    var body: some View {
        VStack(spacing: 20) {
            TextField("Enter text to synthesize", text: $inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Synthesize Speech") {
                speechManager.synthesizeSpeech(from: inputText)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            HStack(spacing: 20) {
                Button("Pause") {
                    speechManager.pauseSpeech()
                }
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(10)

                Button("Resume") {
                    speechManager.resumeSpeech()
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)

                Button("Stop") {
                    speechManager.stopSpeech()
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)

                Button("Restart") {
                    speechManager.restartSpeech()
                }
                .padding()
                .background(Color.purple)
                .foregroundColor(.white)
                .cornerRadius(10)
            }

            Text(currentStateText())
                .padding()
                .foregroundColor(stateColor())
        }
        .padding()
    }

    private func currentStateText() -> String {
        switch speechManager.state {
        case .idle:
            return "Idle"
        case .synthesizing:
            return "Synthesizing..."
        case .playing:
            return "Playing..."
        case .paused:
            return "Paused"
        case .error(let errorMessage):
            return "Error: \(errorMessage)"
        }
    }

    private func stateColor() -> Color {
        switch speechManager.state {
        case .idle:
            return .green
        case .synthesizing, .playing:
            return .blue
        case .paused:
            return .orange
        case .error:
            return .red
        }
    }
}

struct TextToSpeechTestView_Previews: PreviewProvider {
    static var previews: some View {
        TextToSpeechTestView()
    }
}

