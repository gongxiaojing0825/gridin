//
//  HistoryView.swift
//   gridin
//
//  Created by Liqing Pan on 2024-04-23.
//

import SwiftUI
import LocalAuthentication

struct ConditionalIncidentView: View {
    var incident: Incident?
    var isAuthenticated: Bool

    var body: some View {
        if isAuthenticated, let incident = incident {
            IncidentView(incident: incident)
        } else {
            Text("Authentication required")
        }
    }
}

struct HistoryView: View {
    var incidents: [Incident]

    @State private var showCall = false
    @State private var selectedIncident: Incident?
    @State private var isNavigationActive = false

    var body: some View {
        NavigationStack {
            List(incidents) { incident in
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("ID:\(incident.id)  [\(incident.time)]")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        Text(incident.location)
                            .font(.subheadline)
                        Text(incident.targetName)
                            .font(.callout)
                        Text(incident.summary)
                            .font(.caption)
                    }
                    Spacer()
                    if isIncidentHighWarning(incident) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                            .font(.title)
                    } else if isIncidentLowWarning(incident) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.yellow)
                            .font(.title)
                    }
                }
                .padding()
                .contentShape(Rectangle())
                .onTapGesture {
                    self.selectedIncident = incident
                    self.isNavigationActive = true
                }
            }
            .navigationTitle("Incidents")
            .navigationDestination(isPresented: $isNavigationActive) {
                if let incident = selectedIncident {
                    IncidentView(incident: incident)
                } else {
                    Text("No incident selected")
                }
            }
            .navigationDestination(isPresented: $showCall) {
                IncomingCallView()
            }
        }
    }
}

private func authenticateUser(completion: @escaping (Bool) -> Void) {
    let context = LAContext()
    var error: NSError?
    let reason = "Please authenticate to proceed."

    // Check if the device supports biometric authentication
    if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
            DispatchQueue.main.async {
                if success {
                    // The user successfully authenticated
                    completion(true)
                } else {
                    // There was an error during authentication
                    completion(false)
                }
            }
        }
    } else {
        // No biometrics or other authentication methods are available
        DispatchQueue.main.async {
            completion(false)
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(incidents: sampleEvents)
    }
}
