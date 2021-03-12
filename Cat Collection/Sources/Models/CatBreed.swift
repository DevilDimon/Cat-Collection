import struct Foundation.URL

struct CatBreed: Codable {
	let id: String
	let name: String
	let temperament: String
	let infoDescription: String?
	let wikipediaURL: URL?
	let energyLevel: Int?
	let imageID: String?
	let countryCode: String?

	enum CodingKeys: String, CodingKey {
		case id
		case name
		case temperament
		case infoDescription = "description"
		case wikipediaURL = "wikipedia_url"
		case energyLevel = "energy_level"
		case imageID = "reference_image_id"
		case countryCode = "country_code"
	}
}
