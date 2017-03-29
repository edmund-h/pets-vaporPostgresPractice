//
//  Pet.swift
//  Pets
//
//  Created by Edmund Holderbaum on 3/22/17.
//
//

import Foundation
import Vapor

final class Pet: Model, NodeInitializable, NodeRepresentable{
    let name: String
    let age: Int
    let gender: String
    let species: String
    let breed: String
    
    //conformance to Model Protocol
    var id: Node?
    var exists: Bool = false
    
    init(name: String, age: Int, gender: String, breed: String, species: String){
        self.name = name
        self.age = age
        self.gender = gender
        self.breed = breed
        self.species = species
    }
    
    init(node: Node, in context: Context) throws{
        
        id = try node.extract("id")
        
        name = try node.extract("name")
        
        age = try node.extract("age")
        
        gender = try node.extract("gender")
        
        breed = try node.extract("breed")
        
        species = try node.extract("species")
    }
    
    func makeNode(context: Context) throws -> Node {
        
        return try Node(node: [
            "id": id,
            "name": name,
            "age":age,
            "gender": gender,
            "breed": breed,
            "species": species
            ])
        
    }
    
    static func prepare(_ database: Database) throws{
        
        try database.create("pets") {pets in
            
            pets.id()
            
            pets.string("name")
            
            pets.string("gender")
            
            pets.int("age")
            
            pets.string("breed")
            
            pets.string("species")
        }
        
    }
        
    static func revert(_ database: Database) throws {
        
        try database.delete("pets")
    }
    
}

extension Pet: CustomStringConvertible{
    var description: String {
        return "\(name) (\(gender)), \(breed) \(species): \(age) years old."
    }
}
