import SnapKit
import UIKit

final class CatCollectionViewController: UIViewController {
	private var viewModel: CatCollectionViewModel?

	private var collectionView: UICollectionView?
	private let collectionViewLayout = UICollectionViewFlowLayout()
	private let searchController = UISearchController(searchResultsController: nil)

	init(viewModel: CatCollectionViewModel) {
		super.init(nibName: nil, bundle: nil)
		self.viewModel = viewModel
		viewModel.itemsDidChange = { [weak self] in
			self?.reloadCollectionView()
		}
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		title = NSLocalizedString("cats.title", comment: "")
		view.backgroundColor = .systemBackground

		collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
		guard let collectionView = collectionView else { return }
		configureCollectionView()
		view.addSubview(collectionView)
		collectionView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}

		configureSearchController()
	}
}

// MARK: - Private

private extension CatCollectionViewController {
	func configureCollectionView() {
		collectionView?.backgroundColor = .systemBackground
		collectionView?.delegate = self
		collectionView?.dataSource = self
		collectionView?.register(CatCollectionCell.self, forCellWithReuseIdentifier: CatCollectionCell.reuseIdentifier)
		collectionViewLayout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
		collectionViewLayout.minimumInteritemSpacing = 8
	}

	func configureSearchController() {
		navigationItem.searchController = searchController
		definesPresentationContext = true
		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = NSLocalizedString("cats.search.placeholder", comment: "")
	}

	func reloadCollectionView() {
		collectionView?.reloadData()
	}
}

// MARK: - UICollectionViewDelegate

extension CatCollectionViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let catCellVM = viewModel?.items[indexPath.row] else { return }
		let catDetailsVM = CatDetailsViewModel(model: catCellVM.model)
		let catDetailsVC = CatDetailsViewController(viewModel: catDetailsVM)
		navigationController?.pushViewController(catDetailsVC, animated: true)
	}
}

// MARK: - UICollectionViewDataSource

extension CatCollectionViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		viewModel?.items.count ?? 0
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatCollectionCell.reuseIdentifier, for: indexPath)
			as? CatCollectionCell
		let cellVM = viewModel?.items[indexPath.row]
		cell?.viewModel = cellVM
		return cell ?? UICollectionViewCell()
	}


}

// MARK: - UICollectionViewDelegateFlowLayout

extension CatCollectionViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {

		let spacing = self.collectionViewLayout.minimumInteritemSpacing
		let inset = self.collectionViewLayout.sectionInset.left + self.collectionViewLayout.sectionInset.right

		switch traitCollection.horizontalSizeClass {
			case .regular:
				let size = (collectionView.bounds.width - spacing * 3 - inset) / 4
				return CGSize(width: size, height: size)
			default:
				let size = (collectionView.bounds.width - spacing - inset) / 2
				return CGSize(width: size, height: size)
		}
	}
}

// MARK: - UISearchResultsUpdating

extension CatCollectionViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		let query = searchController.searchBar.text ?? ""
		viewModel?.searchQueryTyped(query)
	}
}

