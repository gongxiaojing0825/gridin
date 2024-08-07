//
//  APIView.swift
//   gridin
//
//  Created by Liqing Pan on 2024-04-24.
//

import SwiftUI

struct ChatView: View {
    @StateObject private var chat = ChatManager()
    @State private var promptText = ""

    var body: some View {
        NavigationView {
            VStack {
                // Display chat history
                List {
                    ForEach(chat.history, id: \.message) { chatMessage in
                        HStack {
                            if chatMessage.role == .human {
                                Spacer()
                                Text(chatMessage.message)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .clipShape(Capsule())
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            } else {
                                Text(chatMessage.message)
                                    .padding()
                                    .background(Color.gray)
                                    .foregroundColor(.white)
                                    .clipShape(Capsule())
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Spacer()
                            }
                        }
                    }
                }

                // Input field and button
                HStack {
                    TextField("Enter message", text: $promptText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button("Send") {
                        chat.prompt(promptText)
                        promptText = ""
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                }

                Button("Reset Conversation") {
                    chat.resetConversation()
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.red)
                .clipShape(Capsule())
            }
            .navigationBarTitle("Chat", displayMode: .inline)
        }
    }
}


struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
