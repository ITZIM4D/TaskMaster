//
//  LoginRequest.swift
//  TaskMaster
//
//  Created by Jared Wilson on 11/14/24.
//

import Foundation

struct LoginRequest: Encodable {
    let username: String
    let passwordHash: String
}
