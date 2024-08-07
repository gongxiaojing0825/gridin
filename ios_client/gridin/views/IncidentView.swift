//
//  IncidentView.swift
//   gridin
//
//  Created by Liqing Pan on 2024-04-23.
//

import SwiftUI
import MapKit
import AVKit
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

struct YouTubeView: View {
    var videoID: String  // YouTube video ID

    var body: some View {
        WebView(url: URL(string: "https://www.youtube.com/embed/\(videoID)?playsinline=1")!)
            .frame(height: 300)  // Set the height of the video player
    }
}

struct MapAnnotationItem: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

class MapViewModel: ObservableObject {
    @Published var annotations: [MapAnnotationItem]

    init(annotations: [MapAnnotationItem] = [MapAnnotationItem(coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194))]) {
        self.annotations = annotations
    }
}

struct IncidentView: View {
    var incident: Incident
    @State private var region: MKCoordinateRegion
    @State private var showConversationView = false
    
    init(incident: Incident) {
        self.incident = incident
        let coordinate = CLLocationCoordinate2D(latitude: incident.latitude, longitude: incident.longitude)
        
        self._region = State(initialValue: MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        ))
    }
    
    private func determineButtonColor() -> Color {
        let numHighWarnings = numHighWarnings(incident)
        let numLowWarnings = numLowWarnings(incident)
        if numHighWarnings > 0 {
            return .red
        } else if numLowWarnings > 0 {
            return .yellow
        } else {
            return .green
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                
                
                // Video Player
                VStack {
                    Text("FOOTAGE").font(.headline).padding()
                    YouTubeView(videoID: incident.videoLink)
                }
                .cornerRadius(12)
                .padding()

                // Map View
                Map {
                    Marker("Incident", coordinate: region.center)
                        .tint(.red) // Changed the tint color to red
                    Annotation("Incident Annotation", coordinate: region.center) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.red)
                        }
                    }
                }
                .frame(height: 200)
                .cornerRadius(12)
                .padding()

                // Comprehensive Description
                Text(incident.description)
                    .padding()

                // Warning Button
                Button(action: {
                    showConversationView = true
                }) {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(determineButtonColor())
                        Text("View Conversations")
                            .foregroundColor(determineButtonColor())
                            .bold()
                    }
                }
                .padding()
            }
        }
        .navigationTitle("ID: \(incident.id)")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showConversationView) {
            ConversationView(incident: incident)
        }
    }
}

struct IncidentView_Previews: PreviewProvider {
    static var previews: some View {
        IncidentView(incident: sampleEvents[0])
    }
}
