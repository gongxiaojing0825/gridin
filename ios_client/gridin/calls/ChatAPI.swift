//
//  ChatAPI.swift
//   gridin
//
//  Created by Liqing Pan on 2024-04-24.
//

import Foundation

class ChatAPI {
    static let shared = ChatAPI()
    private let url = URL(string: "https://f1733f6b-a7b2-4c7c-8e52-570e8d28573c-00-305owpuxjqvru.kirk.replit.dev/agent")!  // Replace with your API URL

    func sendMessage(_ message: String, conversationId: String? = nil, completion: @escaping (Result<PromptAnswer, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let promptRequest = PromptRequest(prompt: message, conversationId: conversationId)
        print(promptRequest)
        do {
            let jsonData = try JSONEncoder().encode(promptRequest)
            request.httpBody = jsonData
        } catch {

            completion(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(PromptAnswer.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
