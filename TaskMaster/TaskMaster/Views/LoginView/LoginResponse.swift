//
//  LoginResponse.swift
//  TaskMaster
//
//  Created by Jared Wilson on 11/14/24.
//
import Foundation

struct LoginResponse: Decodable {
    let data: LoginResponseData
}

struct LoginResponseData: Decodable {
    let accessToken: String
    let refreshToken: String
}
