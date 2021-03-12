import UIKit

final class CatDetailsViewModel {
	var titleText: String {
		model.name
	}

	var fullText: String {
		originText + "\n\n" +
		(model.infoDescription ?? "") + "\n\n" +
		temperamentText
	}

	var linkText: String {
		guard let wikipediaLink = model.wikipediaURL?.absoluteString else {
			return NSLocalizedString("details.wikilink.unavailable", comment: "")
		}

		return String(format: NSLocalizedString("details.wikilink", comment: ""), wikipediaLink)
	}

	private var originText: String {
		guard let countryCode = model.countryCode, countryCode.isEmpty == false else {
			return NSLocalizedString("details.origin.unknown", comment: "")
		}

		return String(
			format: NSLocalizedString("details.origin", comment: ""),
			StringUtils.emojiFlag(from: countryCode)
		)
	}

	private var temperamentText: String {
		String(format: NSLocalizedString("details.temperament", comment: ""), model.temperament)
	}

	private let model: CatBreed

	init(model: CatBreed) {
		self.model = model
	}

	func wikilinkTapped() {
		guard let url = model.wikipediaURL, UIApplication.shared.canOpenURL(url) else { return }

		UIApplication.shared.open(url)
	}
}
