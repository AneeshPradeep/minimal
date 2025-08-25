//
//  SearchVC.swift
//  Wallpee
//
//  Created by Thanh Hoang on 4/6/24.
//

import UIKit

class SearchVC: MainVC {
    
    //MARK: - UIView
    let searchBar = UISearchBar()
    let scrollView = S_ScrollView()
    
    var containerView: S_ContainerView { return scrollView.containerView }
    var suggestionView: S_SuggestionView { return containerView.suggestionView }
    var recentView: S_RecentSearchesView { return containerView.recentView }
    var contentView: S_ContentView { return containerView.contentView }
    
    //MARK: - Properties
    private var viewModel: SearchViewModel!
    
    //Khi didSelect vào Cell
    var selectedCell: S_ContentCVCell?
    var selectedIndexPath: IndexPath?
    
    //Khi sử dụng SharedTransitonAnimator
    private var popToObs: Any?
    
    //Khi chọn một Photo từ More. Thay đổi Photo của Cell hiện tại
    private var changePhotoObs: Any?
    
    private var changeLanguageObs: Any?
    
    private var networkObs: Any?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addObservers()
        
        viewModel.loadKeywords()
        viewModel.searchAgain()
        
        scrollView.isHidden = !NetworkMonitor.shared.isConnected
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateUI()
    }
}

//MARK: - Setup Views

extension SearchVC {
    
    private func setupViews() {
        viewModel = SearchViewModel(parentVC: self)
        
        //TODO: - SearchBar
        searchBar.frame = CGRect(x: 14.0, y: topPadding, width: screenWidth-28, height: 50.0)
        searchBar.delegate = self
        view.addSubview(searchBar)
        
        //TODO: - ScrollView
        scrollView.setupViews(vc: self)
        
        suggestionView.viewModel = viewModel
        recentView.viewModel = viewModel
        contentView.viewModel = viewModel
        
        suggestionView.setupDataSourceAndDelegate(dl: suggestionView)
        recentView.setupDataSourceAndDelegate(dl: recentView)
        contentView.setupDataSourceAndDelegate(dl: contentView)
        
        contentView.viewAllBtn.delegate = self
        contentView.viewAllBtn.tag = 0
    }
    
    private func updateSearchBar() {
        let att: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontName.montMedium, size: 16.0)!,
            .foregroundColor: UIColor.black
        ]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(att, for: .normal)
        
        searchBar.customFontSearchBar("Search...".localized())
    }
}

//MARK: - Add Observers

extension SearchVC {
    
    private func addObservers() {
        removeMyObserver(any: popToObs)
        removeMyObserver(any: changePhotoObs)
        
        //Pop từ SharedTransitionAnimator
        popToObs = NotificationCenter.default.addObserver(
            forName: .popToKey,
            object: nil,
            queue: .main, using: { notif in
                self.viewModel.transitionAnimator = nil
                self.navigationController?.delegate = nil
                
                self.selectedCell = nil
                self.selectedIndexPath = nil
            })
        
        //Khi chọn 1 Photo từ MorePhotoVC
        changePhotoObs = NotificationCenter.default.addObserver(
            forName: .changePhotoKey,
            object: nil,
            queue: .main, using: { notif in
                guard let newPhoto = notif.object as? PhotoModel else {
                    return
                }
                guard let indexPath = self.selectedIndexPath else {
                    return
                }
                
                self.viewModel.photos[indexPath.item] = newPhoto
                self.contentView.collectionView.reloadItems(at: [indexPath])
            })
        
        changeLanguageObs = NotificationCenter.default.addObserver(
            forName: .changeLanguageKey,
            object: nil,
            queue: .main,
            using: { _ in
                self.updateUI()
            })
        
        networkObs = NotificationCenter.default.addObserver(
            forName: .networkKey,
            object: nil,
            queue: .main, using: { notif in
                self.scrollView.isHidden = !NetworkMonitor.shared.isConnected
            })
    }
    
    private func updateUI() {
        updateSearchBar()
        
        suggestionView.titleLbl.text = "Suggestions".localized()
        recentView.titleLbl.text = "Recent Searches".localized()
        contentView.titleLbl.text = "Search Results".localized()
        contentView.updateViewAll()
    }
}

// MARK: - UISearchBarDelegate

extension SearchVC: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.cancelDidTap()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.searchTextField.resignFirstResponder()
        
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        
        let keyword = searchBar.text ?? ""
        if keyword != "" {
            viewModel.searchPhotos(with: keyword, saved: true)
        }
        
        if let cancelBtn = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelBtn.isEnabled = true
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText = searchBar.text ?? ""
        
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        
        if viewModel.searchText != "" {
            //perform(#selector(searchWith), with: self, afterDelay: 1.0)
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {}
    
    @objc private func searchWith() {
        searchBarSearchButtonClicked(searchBar)
    }
    
    private func searchActive() -> Bool {
        return searchBar.text?.isEmpty == false || searchBar.isFirstResponder
    }
    
    private func cancelDidTap() {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        searchBar.searchTextField.resignFirstResponder()
        searchBar.searchTextField.text = nil
    }
}

//MARK: - ButtonAnimationDelegate

extension SearchVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        if sender.tag == 0 { //View All
            viewModel.goToSearchDetailVC()
        }
    }
}

//MARK: - SharedTransitioning

extension SearchVC: SharedTransitioning {
    
    var sharedFrame: CGRect {
        guard let selectedCell = selectedCell,
              let frame = selectedCell.frameInWindow else {
            return .zero
        }
        
        return frame
    }
    
    func prepare(for transition: SharedTransitionAnimator.Transition) {}
}
