//
//  CallViewModel.swift
//   gridin
//
//  Created by Liqing Pan on 2024-04-24.
//

import Foundation
import Speech

class ChatManager: ObservableObject {
    @Published var state: ChatState = .idle
    @Published var history = [ChatMessage]()
    @Published var conversationId: String?
    @Published var answer = ""
    
    func prompt(_ message: String) {
        state = .waiting
        ChatAPI.shared.sendMessage(message, conversationId: conversationId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let promptAnswer):
                        print("Received message: \(promptAnswer)")
                        self?.updateHistory(with: promptAnswer.history)
                        self?.conversationId = promptAnswer.conversationId
                        self?.answer = promptAnswer.answer
                        self?.state = .idle
                    case .failure(let error):
                        print("Failed to send message: \(error)")
                        self?.state = .error("Failed to send message")
                }
            }
        }
    }

    private func updateHistory(with history: [ChatMessage]) {
        self.history = history
    }

    func resetConversation() {
        DispatchQueue.main.async {
            self.history.removeAll()
            self.conversationId = nil
            self.answer = ""
            self.state = .idle
        }
        
    }
}
