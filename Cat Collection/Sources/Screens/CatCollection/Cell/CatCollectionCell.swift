import Kingfisher
import UIKit

private enum Constants {
	static let imageTransitionTimeInterval: TimeInterval = 0.5
}

final class CatCollectionCell: UICollectionViewCell {
	static let reuseIdentifier = String(describing: self)

	var viewModel: CatCollectionCellViewModel? {
		didSet {
			viewModelDidChange()
		}
	}

	private let catImageView: UIImageView = {
		let view = UIImageView()
		view.contentMode = .scaleAspectFit
		view.kf.indicatorType = .activity
		return view
	}()

	private let nameLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 1
		label.font = .preferredFont(forTextStyle: .footnote)
		label.textAlignment = .center
		return label
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		contentView.backgroundColor = .secondarySystemBackground

		// Deliberately not using a mask here as cornerRadius is now Metal-accelerated.
		// Back in iOS 11 using this in a cell would have caused a massive FPS drop, but not today.
		contentView.layer.cornerRadius = 8
		contentView.layer.cornerCurve = .continuous

		contentView.addSubview(catImageView)
		catImageView.snp.makeConstraints { make in
			make.leading.top.equalToSuperview().offset(8)
			make.trailing.equalToSuperview().offset(-8)
		}

		contentView.addSubview(nameLabel)
		nameLabel.snp.makeConstraints { make in
			make.top.equalTo(catImageView.snp.bottom).offset(8)
			make.leading.equalToSuperview().offset(8)
			make.trailing.bottom.equalToSuperview().offset(-8)
		}

		nameLabel.setContentCompressionResistancePriority(.init(rawValue: 751), for: .vertical)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		catImageView.kf.cancelDownloadTask()
	}

	private func viewModelDidChange() {
		guard let viewModel = viewModel else { return }

		viewModel.imageURLDidLoad = { [weak self] in self?.viewModelDidChange() }

		nameLabel.text = viewModel.name
		if let imageURL = viewModel.imageURL {
			catImageView.kf.setImage(
				with: imageURL,
				options: [
					// An empirically chosen fixed size to maintain smooth scrolling
					.processor(DownsamplingImageProcessor(size: CGSize(width: 150, height: 150))),
					.transition(.fade(Constants.imageTransitionTimeInterval)),
					.scaleFactor(UIScreen.main.scale)
				]
			)
		} else {
			catImageView.image = nil
			viewModel.fetchImageURL()
		}
	}
}
