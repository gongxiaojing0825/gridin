//
//  model.swift
//   gridin
//
//  Created by Liqing Pan on 2024-04-23.
//

import Foundation
import MapKit

struct Incident: Identifiable {
    let id: String
    let time: String
    let location: String
    let targetName: String
    let summary: String
    let description: String
    let warningFlag: Bool
    let latitude: Double
    let longitude: Double
    let videoLink: String
    var conversations: [Conversation]
    
    init(time: String, location: String, targetName: String, summary: String, description: String, warningFlag: Bool, latitude: Double, longitude: Double, videoLink: String, conversations: [Conversation]) {
        self.id = String((0..<8).map{ _ in "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".randomElement()! })
        self.time = time
        self.location = location
        self.targetName = targetName
        self.summary = summary
        self.description = description
        self.warningFlag = warningFlag
        self.latitude = latitude
        self.longitude = longitude
        self.videoLink = videoLink
        self.conversations = conversations
    }
}

struct Conversation {
    let role: String
    let message: String
    let warningType: WarningType
    let level: WarningLevel
}

enum WarningType: String {
    case None = "No warning needed"
    case UseOfForce = "Use of physical force potentially inappropriate"
    case SearchAndSeizure = "Potential violation of search and seizure rights"
    case RightToDueProcess = "Infringement on rights to due process"
    case ArrestProcedures = "Improper arrest procedures"
    case DiscriminationAndBias = "Possible discrimination or bias in conduct"
    case Privacy = "Privacy concerns in interaction"
    case InteractionsWithVulnerablePopulations = "Sensitive interaction with vulnerable populations"
    case PublicAccountability = "Issues with public accountability"
    case CivilLiability = "Potential for civil liability"
}

enum WarningLevel: String {
    case Low = "Low"
    case High = "High"
}

class CustomAnnotation: NSObject, MKAnnotation, Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?

    init(coordinate: CLLocationCoordinate2D, title: String? = nil, subtitle: String? = nil) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}


struct ChatMessage: Codable {
    let message: String
    let role: Role
}

enum Role: String, Codable {
    case human = "Human"
    case ai = "AI"
}

struct PromptRequest: Codable {
    let prompt: String
    var conversationId: String?
}

struct PromptAnswer: Codable {
    let answer: String
    let conversationId: String
    let history: [ChatMessage]
}



enum ChatState: Equatable {
    case idle
    case waiting
    case error(String)
    func errorValue() -> String? {
        if case .error(let message) = self {
            return message
        }
        return nil
    }
}

enum S2TState: Equatable {
    case transcribing
    case idle
    case error(String)
    func errorValue() -> String? {
        if case .error(let message) = self {
            return message
        }
        return nil
    }
}

enum T2SState : Equatable{
    case idle
    case synthesizing
    case playing
    case paused
    case error(String)
    func errorValue() -> String? {
        if case .error(let message) = self {
            return message
        }
        return nil
    }
}

enum CallState: Equatable {
    case idle
    case listening
    case processing
    case speaking
    case error(String)

}
