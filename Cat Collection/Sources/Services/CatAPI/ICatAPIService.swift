enum CatAPIServiceError: Error {
	case requestFailure
	case decodingFailure
	case invalidURL
}

protocol ICatAPIService {
	func fetchCatBreeds(by name: String, completion: @escaping (Result<[CatBreed], CatAPIServiceError>) -> Void)
	func fetchCatImage(for id: String, completion: @escaping (Result<CatImage, CatAPIServiceError>) -> Void)
}
