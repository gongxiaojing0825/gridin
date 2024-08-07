//
//  CallView.swift
//   gridin
//
//  Created by Liqing Pan on 2024-04-24.
//

import SwiftUI

struct IncomingCallView: View {
    @State private var callAccepted = false  // State to track call acceptance
    @State private var showHistory = false   // State to control navigation to HistoryView
    
    var body: some View {
        VStack(spacing: 20) {
            // App logo
            Image("gridin")  // Use your custom logo image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
            
            // Caller name and status
            VStack {
                Text("Open Gridin.AI")  // Caller name
                    .font(.title)
                    .fontWeight(.medium)
                
                if callAccepted {
                    Text("Call in progress...")  // Status update on accept
                        .font(.subheadline)
                        .foregroundColor(.green)
                } else {
                    Text("Incoming Voice Call")  // Initial incoming call text
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            // Call action buttons
            HStack(spacing: 50) {
                if !callAccepted {
                    Button(action: {
                        showHistory = true
                    }) {
                        Text("Decline")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .clipShape(Capsule())
                    }
                }
                
                Button(action: {
                    if callAccepted {
                        // Navigate to HistoryView
                        showHistory = true
                    } else {
                        // Accept the call
                        callAccepted = true
                    }
                }) {
                    Text(callAccepted ? "End Call" : "Accept")  // Button text changes upon acceptance
                        .foregroundColor(.white)
                        .padding()
                        .background(callAccepted ? Color.red : Color.green)
                        .clipShape(Capsule())
                }
            }
            .navigationDestination(isPresented: $showHistory) {
                HistoryView(incidents: sampleEvents)
            }
        }
        .padding()
        .navigationBarHidden(true)
        .onAppear {
            // Reset the state each time this view appears
            callAccepted = false
            showHistory = false
        }
    }
    
}

struct IncomingCallView_Previews: PreviewProvider {
    static var previews: some View {
        IncomingCallView()    }
}
