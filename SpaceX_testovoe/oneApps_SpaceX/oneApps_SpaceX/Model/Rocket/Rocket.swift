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
}
