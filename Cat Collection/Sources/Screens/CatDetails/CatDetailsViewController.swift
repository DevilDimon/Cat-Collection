import SnapKit
import Nantes
import UIKit

final class CatDetailsViewController: UIViewController {
	private let viewModel: CatDetailsViewModel

	private let scrollView: UIScrollView = {
		let view = UIScrollView()
		view.backgroundColor = .systemBackground
		return view
	}()

	private let contentView = UIView()

	private let textView: UITextView = {
		let view = UITextView()
		view.isEditable = false
		view.isScrollEnabled = false
		view.font = .preferredFont(forTextStyle: .body)
		return view
	}()

	private let wikilinkLabel: NantesLabel = {
		let label = NantesLabel()
		label.numberOfLines = 0
		label.linkAttributes = [NSAttributedString.Key.foregroundColor : UIColor.systemBlue]
		label.font = .preferredFont(forTextStyle: .body)
		return label
	}()

	init(viewModel: CatDetailsViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBackground

		view.addSubview(scrollView)
		scrollView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}

		scrollView.addSubview(contentView)
		contentView.snp.makeConstraints { make in
			make.edges.width.equalToSuperview()
		}

		contentView.addSubview(textView)
		textView.snp.makeConstraints { make in
			make.leading.top.equalToSuperview().offset(16)
			make.trailing.equalToSuperview().offset(-16)
		}

		contentView.addSubview(wikilinkLabel)
		wikilinkLabel.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(24)
			make.top.equalTo(textView.snp.bottom).offset(16)
			make.trailing.bottom.equalToSuperview().offset(-24)
		}
		wikilinkLabel.delegate = self

		viewModelDidChange()
	}
}

// MARK: - Private

private extension CatDetailsViewController {
	func viewModelDidChange() {
		title = viewModel.titleText
		textView.text = viewModel.fullText
		wikilinkLabel.text = viewModel.linkText
	}
}

// MARK: - NantesLabelDelegate

extension CatDetailsViewController: NantesLabelDelegate {
	func attributedLabel(_ label: NantesLabel, didSelectLink link: URL) {
		viewModel.wikilinkTapped()
	}
}
