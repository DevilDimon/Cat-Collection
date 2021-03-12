import Foundation

private enum Constants {
	static let baseURLString = "https://api.thecatapi.com/v1/"
	static let apiKey = "" // Put your own key there
}

final class CatAPIService: ICatAPIService {
	private let urlSession = URLSession(configuration: .default)

	func fetchCatBreeds(by name: String, completion: @escaping (Result<[CatBreed], CatAPIServiceError>) -> Void) {
		guard var urlComponents = URLComponents(string: Constants.baseURLString + "breeds/search") else {
			completion(.failure(.invalidURL))
			return
		}

		let searchQueryItem = URLQueryItem(name: "q", value: name)
		let apiKeyItem = makeAPIKeyQueryItem()
		urlComponents.queryItems = [searchQueryItem, apiKeyItem]

		guard let url = urlComponents.url else {
			completion(.failure(.invalidURL))
			return
		}

		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		sendRequest(request, completion: completion)
	}

	func fetchCatImage(for id: String, completion: @escaping (Result<CatImage, CatAPIServiceError>) -> Void) {
		guard var urlComponents = URLComponents(string: Constants.baseURLString + "images/\(id)") else {
			completion(.failure(.invalidURL))
			return
		}

		urlComponents.queryItems = [makeAPIKeyQueryItem()]
		guard let url = urlComponents.url else {
			completion(.failure(.invalidURL))
			return
		}

		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		sendRequest(request, completion: completion)
	}

	private func sendRequest<T: Decodable>(
		_ request: URLRequest,
		completion: @escaping (Result<T, CatAPIServiceError>) -> Void
	) {
		urlSession.dataTask(with: request) { (data, _, error) in
			if error != nil {
				completion(.failure(.requestFailure))
				return
			} else if let data = data {
				do {
					let decodedResponse = try JSONDecoder().decode(T.self, from: data)
					completion(.success(decodedResponse))
					return
				} catch {
					completion(.failure(.decodingFailure))
					return
				}
			}
		}
		.resume()
	}

	private func makeAPIKeyQueryItem() -> URLQueryItem {
		URLQueryItem(name: "api_key", value: Constants.apiKey)
	}
}
