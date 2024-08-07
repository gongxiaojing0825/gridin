//
//  util.swift
//   gridin
//
//  Created by Liqing Pan on 2024-04-23.
//

import Foundation


func numHighWarnings(_ incident: Incident) -> Int {
    return incident.conversations.filter { $0.role == AI && $0.warningType != .None && $0.level == .High }.count
}


func numLowWarnings(_ incident: Incident) -> Int {
    return incident.conversations.filter { $0.role == AI && $0.warningType != .None && $0.level == .Low }.count
}

func isIncidentLowWarning(_ incident: Incident) -> Bool{
    return numHighWarnings(incident) == 0 && numLowWarnings(incident) >= 3
}

func isIncidentHighWarning(_ incident: Incident) -> Bool{
    return numHighWarnings(incident) > 0
}
