import Foundation

final class CatCollectionViewModel {
	private(set) var items: [CatCollectionCellViewModel] = [] {
		didSet {
			itemsDidChange?()
		}
	}
	var itemsDidChange: (() -> Void)?

	private let catAPIService: ICatAPIService

	private var searchWorkItem: DispatchWorkItem?

	init(catAPIService: ICatAPIService) {
		self.catAPIService = catAPIService
	}

	func searchQueryTyped(_ query: String) {
		searchWorkItem?.cancel()

		if query.isEmpty {
			items = []
			return
		}

		var workItem: DispatchWorkItem?
		workItem = DispatchWorkItem(qos: .userInitiated) { [weak self] in
			self?.catAPIService.fetchCatBreeds(by: query) { result in
				guard let self = self else { return }
				switch result {
					case .success(let response):
						DispatchQueue.main.async {
							if workItem?.isCancelled == true { return }
							self.items = response.map {
								CatCollectionCellViewModel(model: $0, catAPIService: self.catAPIService)
							}
						}
					case .failure:
						break
				}
			}
		}
		self.searchWorkItem = workItem
		workItem?.perform()
	}
}
