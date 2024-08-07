//
//  ContentView.swift
//   gridin
//
//  Created by Liqing Pan on 2024-04-23.
//

import SwiftUI

struct CallView: View {
    var callerName: String = "John Doe"
    var callStatus: String = "Ringing..."
    
    var body: some View {
        VStack {
            Spacer()
            
            // Profile image
            Image("profileImage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .shadow(radius: 10)
            
            // Caller name
            Text(callerName)
                .font(.title)
                .padding(.top, 20)
            
            // Call status
            Text(callStatus)
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.top, 8)
            
            Spacer()
            
            // Action buttons
            HStack {
                // Reject or end call button
                Button(action: {
                    // Implement call rejection or ending functionality
                }) {
                    Image(systemName: "phone.down.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(20)
                        .background(Color.red)
                        .clipShape(Circle())
                }
                
                // Accept call button (visible if incoming call)
                Button(action: {
                    // Implement call acceptance functionality
                }) {
                    Image(systemName: "phone.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(20)
                        .background(Color.green)
                        .clipShape(Circle())
                }
            }
            .padding()
            
            Spacer()
        }
        .padding()
    }
}

struct CallView_Previews: PreviewProvider {
    static var previews: some View {
        CallView()
    }
}
