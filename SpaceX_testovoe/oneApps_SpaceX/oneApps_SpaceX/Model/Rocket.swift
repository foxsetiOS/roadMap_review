struct Rocket: Decodable {
    let id: String
    let name: String
    let height: Height
    let diameter: Diameter
    let mass: Mass
    let payloadWeights: [PayloadWeight]?
    let firstFlight: String?
    let country: String
    let costPerLaunch: Double?
    let firstStage: FirstStage?
    let secondStage: SecondStage?
    let flickrImages: [String]?
    
    struct Height: Decodable {
        let meters: Double?
    }
    
    struct Diameter: Decodable {
        let meters: Double?
    }
    
    struct Mass: Decodable {
        let kg: Double
    }
    
    struct PayloadWeight: Decodable {
        let kg: Double?
    }
    
    struct FirstStage: Decodable {
        let engines: Int?
        let fuelAmountTons: Double?
        let burnTimeSec: Int?
    }
    
    struct SecondStage: Decodable {
        let engines: Int?
        let fuelAmountTons: Double?
        let burnTimeSec: Int?
    }
}
