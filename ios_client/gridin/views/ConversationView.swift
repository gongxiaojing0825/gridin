//
//  ConversationView.swift
//   gridin
//
//  Created by Liqing Pan on 2024-04-23.
//

import SwiftUI

struct ConversationView: View {
    var incident: Incident
    
    private let bubbleCornerRadius: CGFloat = 5
    private let bubblePadding: EdgeInsets = EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
    private let bubbleSpacing: CGFloat = 0 // Reduced gap between bubbles

    var body: some View {
            NavigationView {
                List(incident.conversations, id: \.message) { conversation in
                    // Customizing cell appearance based on the role of the speaker
                    if conversation.role == AI {
                        officerBubble(conversation: conversation)
                            .frame(maxWidth: .infinity, alignment: .trailing) // Right-align the officer's bubble
                            .listRowSeparator(.hidden)
                    } else {
                        targetBubble(conversation: conversation)
                            .frame(maxWidth: .infinity, alignment: .leading) // Left-align the target's bubble
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain) // Ensures the list uses the full width of the device
                .navigationTitle("Transcription (\(incident.id))")
                .navigationBarTitleDisplayMode(.inline)
            }
        }

    @ViewBuilder
    private func officerBubble(conversation: Conversation) -> some View {
        HStack {
            Spacer()
            VStack(alignment: .trailing) {
                Text(conversation.role.uppercased())
                    .font(.caption2)
                    .bold()
                    .foregroundColor(Color(white:0.8))
                Text(conversation.message)
                    .padding(bubblePadding)
                    .foregroundColor(Color.white)
                    .background(warningBubbleColor(for: conversation.warningType, level: conversation.level)) // Dynamic background color based on warning level
                    .cornerRadius(bubbleCornerRadius)
                if conversation.warningType != .None {
                    HStack(spacing: 3) { // Adjust spacing to your preference
                        Image(systemName: "exclamationmark.triangle.fill") // System icon for warning
                            .foregroundColor(warningTextColor(for: conversation.warningType, level: conversation.level)) // Use dynamic color for the icon as well
                        Text("\(conversation.warningType.rawValue)")
                            .font(.caption)
                            .foregroundColor(warningTextColor(for: conversation.warningType, level: conversation.level))
                    }
                }
            }
        }
        .padding(.horizontal, bubbleSpacing) // Consistent horizontal padding for alignment
    }

    
    @ViewBuilder
    private func targetBubble(conversation: Conversation) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(conversation.role.uppercased())
                    .font(.caption2)
                    .bold()
                    .foregroundColor(Color(white:0.8))
                Text(conversation.message)
                    .padding(bubblePadding)
                    .foregroundColor(Color.black)
                    .background(Color.gray.opacity(0.2)) // Target's bubble color
                    .cornerRadius(bubbleCornerRadius)
                    .overlay(
                        RoundedRectangle(cornerRadius: bubbleCornerRadius)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
            }
            Spacer()
        }
        .padding(.horizontal, bubbleSpacing) // Consistent horizontal padding for alignment
    }
}
let yellow = Color(red: 200/255, green: 202/255, blue: 1/255)

private func warningBubbleColor(for type: WarningType, level: WarningLevel) -> Color {
    switch (type, level) {
        case (.None, _):
            return .green
        case (_, .High):
            return .red
        case (_, .Low):
            return yellow
    }
}

private func warningTextColor(for type: WarningType, level: WarningLevel) -> Color {
    switch (type, level) {
        case (_, .High):
            return .red
        case (_, .Low):
            return yellow
    }
}

struct ConversationView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationView(incident: sampleEvents[0])
    }
}
