//
//  RandomPerson.swift
//  Dinter
//
//  Created by Luis Segoviano on 15/08/21.
//

import Foundation

// MARK: - RandomPerson

struct RandomPerson: Codable {
    let results: [Persona]
    let info: Info
}

// MARK: - Info
struct Info: Codable {
    let seed: String
    let results, page: Int
    let version: String
}

// MARK: - Result
struct Persona: Codable {
    let gender: String
    let name: Name
    let location: Location
    let email: String
    let login: Login
    let dob, registered: Dob
    let phone, cell: String
    let id: IDRandomPerson
    let picture: Picture
    let nat: String
}

// MARK: - Dob
struct Dob: Codable {
    let date: String?
    let age: Int?
}

// MARK: - ID
struct IDRandomPerson: Codable {
    let name, value: String?
}

// MARK: - Location
struct Location: Codable {
    let street: Street
    let city, state, country: String
    //let postcode: Int?
    let coordinates: Coordinates?
    let timezone: Timezone?
}

// MARK: - Coordinates
struct Coordinates: Codable {
    let latitude, longitude: String?
}

// MARK: - Street
struct Street: Codable {
    let number: Int?
    let name: String?
}

// MARK: - Timezone
struct Timezone: Codable {
    let offset, description: String?
}

// MARK: - Login
struct Login: Codable {
    let uuid, username, password, salt: String
    let md5, sha1, sha256: String
}

// MARK: - Name
struct Name: Codable {
    let title, first, last: String?
}

// MARK: - Picture
struct Picture: Codable {
    let large, medium, thumbnail: String?
}
