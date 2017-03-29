import Vapor
import VaporPostgreSQL

let drop = Droplet()

try drop.addProvider(VaporPostgreSQL.Provider.self)
drop.preparations += Pet.self

drop.get { req in
    return try drop.view.make("welcome", [
    	"message": drop.localization[req.lang, "welcome", "title"]
    ])
}

drop.get("seed") { request in
    
    var fluffy = Pet(name: "Fluffy",
                     age: 17,
                     gender: "F",
                     breed: "Angola"
                     ,species: "Cat")
    try fluffy.save()
    
    var dylan = Pet(name: "Dylan",
                    age: 3,
                    gender: "M",
                    breed: "Border Collie"
                    ,species: "Dog")
    try dylan.save()
    
    var cookie = Pet(name: "Cookie",
                     age: 7,
                     gender: "F",
                     breed: "Yorkshire Terrier"
                     ,species: "Dog")
    try cookie.save()
    
    return "Success"
}

drop.get("pets") { request in
    
    let pets = try Pet.all()
    
    let petsNode = try ["pets": pets.makeNode()]
    
    return try JSON(node: petsNode)
    
}

drop.post("pet") { request in
    
    var pet = try Pet(node: request.json)
    
    try pet.save()
    
    return try pet.makeJSON()
}

drop.get("pet", Int.self) { request, id in
    
    guard let pet = try Pet.find(id) else {
        throw Abort.notFound
    }
    
    return try pet.makeJSON()
}

drop.post("pets") { request in
    var counter = 0
    guard let requestJSON = request.json else {
        print("problem with req json")
        throw Abort.notFound
    }
    guard let pets = requestJSON["pets"]?.makeNode() else {throw Abort.notFound}
    guard let petsArray = pets.nodeArray else {throw Abort.notFound}
    try petsArray.forEach({
        var pet = try Pet(node: $0)
        try pet.save()
        counter += 1
    })
    let response = try ["success": counter.makeNode()]
    return try JSON(node: response.makeNode())
}

drop.get("api") { request in
    
    return try drop.view.make("api")
}

drop.resource("posts", PostController())

drop.run()
