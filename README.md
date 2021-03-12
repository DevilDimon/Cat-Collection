## Approach explanation
* I spent around 5-6 hours on the task in total.
* I chose MVVM as the architecture I am most familiar (and currently, productive) with. This architecture also provides a good tradeoff between code complexity and testability/difficulty of support. 
* I used simple closure callbacks for bindings since they don't require a radical paradigm shift or massive external dependencies (unlike Combine/RxSwift) and they don't pollute the global namespace with throwaway delegate protocols.
* I built all the layouts in code as it eases code review & is more sustainable in the long run (i.e. no suddent XIB changes in git, no need to open IB to edit).
* I didn't consider the new advances in UITableView & UICollectionView (namely, diffable data sources & composable layouts) for this task due to my inexperience with them. Experiments are probably not for the test tasks, so I stuck with the tried & tested solutions (plain old UICollectionViewFlowLayout).
* External dependencies include:
	* SnapKit as a lightweight DSL for AutoLayout used in most projects
	* Kingfisher to offload the frequent task of image loading and caching to a tried & tested solution
	* Nantes (a TTTAttributedLabel Swift Package reimplementation) to easily detect & highlight  URLs in a UILabel.

## Current limitations & proposed solutions
* Many obvious optimisations are missing due to the lack of time – there is no paging (though the Cat API does not seem to support it for `/search` endpoint, anyway), the table is always reloaded in its entirety, requests are not canceled on scrolling away. Some of these could easiliy be fixed by adopting diffable data sources.
* There is no progress or error indication for the user, nor is there any ability for fine-grained manual loading control (e.g. pull-to-refresh). This could be fixed with extra time on the project.
* No debounce (extra time before a request is fired) is present for search request input. This could easily be fixed with Combine's `Publishers.Debounce`, but doing this in UIKit required more time than I had.
* The collection cell size, while adaptive for different size classes, is not particularly beatiful or very usable on extra large devices such as iPad Pro 12,9".
* Image caching & downsampling does not take the real cell size into account. This also could be fixed with more time by passing the actual size into the view models.
* A separate navigation service/router/coordinator is not present as the app only has two screens.
* There are no tests as I could not write them in time, but all the view models are easily testable: they depend on protocols with mockable implementations, their inputs coming from views are exposed as internal methods, their outputs – as internal variables, all of which could be checked in a unit test when needed.