import UIKit

final class CatCollectionCellViewModel {
	var imageURLDidLoad: (() -> Void)?

	var name: String {
		model.name
	}

	let model: CatBreed

	var imageURL: URL? {
		guard let imageID = model.imageID else { return nil }
		return Self.imageURLCache.object(forKey: imageID as NSString) as URL?
	}

	private let catAPIService: ICatAPIService
	private static let imageURLCache = NSCache<NSString, NSURL>()

	init(model: CatBreed, catAPIService: ICatAPIService) {
		self.model = model
		self.catAPIService = catAPIService
	}

	func fetchImageURL() {
		guard let imageID = model.imageID else { return }
		catAPIService.fetchCatImage(for: imageID) { result in
			switch result {
				case .success(let catImage):
					DispatchQueue.main.async { [weak self] in
						guard let self = self else { return }
						Self.imageURLCache.setObject(catImage.url as NSURL, forKey: imageID as NSString)
						self.imageURLDidLoad?()
					}
				case .failure: break
			}
		}
	}
}
