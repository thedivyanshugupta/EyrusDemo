//
//  HTTPAuth.swift
//  EyrusDemo
//
//  Created by Roro on 9/26/22.
//

import Foundation
import SwiftUI
import Combine

struct ServerMessage: Decodable {
    let loginStatus: Int    
}

struct ServerMessageRefresh: Decodable {
    let jsonWebToken: JSONWebToken
}

struct JSONWebToken: Codable {
    var accessToken: String?
    var refreshToken: String?
}

struct WorkerProjectsAttributes: Codable {
    var firstName: String?
    var lastName: String?
    var companyName: String?
    var telephone: String?
}

struct UserDetails: Codable {
    var workerProjectsAttributes: [WorkerProjectsAttributes]
}

