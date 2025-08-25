//
//  S_SuggestionView.swift
//  Wallpee
//
//  Created by Thanh Hoang on 16/6/24.
//

import UIKit

class S_SuggestionView: UIView {
    
    //MARK: - UIView
    let headerView = UIView()
    let titleLbl = UILabel()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let layout = TagLayout()
    
    //MARK: - Properties
    var viewModel: SearchViewModel?
    
    lazy var items: [String] = [
        "Ocean", "Tigers", "Pears", "Nature", "People", "Art", "Sea"
    ]
    
    //MARK: - Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Setups

extension S_SuggestionView {
    
    private func setupViews() {
        let contentH = TagLayout.tagH*2 + 10
        
        let height: CGFloat = S_ContainerView.headerH + contentH
        
        clipsToBounds = true
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - HeaderView
        headerView.clipsToBounds = true
        headerView.backgroundColor = .clear
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: S_ContainerView.headerH).isActive = true
        
        //TODO: - CollectionView
        collectionView.clipsToBounds = true
        collectionView.backgroundColor = .clear
        collectionView.decelerationRate = .fast
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(S_SuggestionCVCell.self, forCellWithReuseIdentifier: S_SuggestionCVCell.id)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: contentH).isActive = true
        
        collectionView.collectionViewLayout = layout
        layout.scrollDirection = .vertical
        layout.contentPadding = ContentPadding(horizontal: 20.0, vertical: 0.0)
        layout.contentAlign = .left
        layout.cellPadding = 10.0
        layout.delegate = self
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 0.0, distribution: .fill, axis: .vertical, alignment: .center)
        stackView.addArrangedSubview(headerView)
        stackView.addArrangedSubview(collectionView)
        addSubview(stackView)
        
        //TODO: - TitleLbl
        titleLbl.font = UIFont(name: FontName.montSemiBold, size: 18.0)
        titleLbl.text = "Suggestions".localized()
        titleLbl.textColor = .black
        headerView.addSubview(titleLbl)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: screenWidth),
            heightAnchor.constraint(equalToConstant: height),
            
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleLbl.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            titleLbl.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20.0),
        ])
    }
    
    func setupDataSourceAndDelegate(dl: UICollectionViewDataSource & UICollectionViewDelegate) {
        collectionView.dataSource = dl
        collectionView.delegate = dl
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

//MARK: - UICollectionViewDataSource

extension S_SuggestionView: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: S_SuggestionCVCell.id, for: indexPath) as! S_SuggestionCVCell
        
        if items.count > 0 && indexPath.item < items.count {
            let item = items[indexPath.item]
            cell.titleLbl.text = item
        }

        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension S_SuggestionView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if items.count > 0 && indexPath.item < items.count {
            let item = items[indexPath.item]
            viewModel?.searchPhotos(with: item, saved: false)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension S_SuggestionView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize(indexPath)
    }
}

//MARK: - TagLayoutDelegate

extension S_SuggestionView: TagLayoutDelegate {
    
    func cellSize(_ indexPath: IndexPath) -> CGSize {
        var itemW = TagLayout.tagH
        
        if items.count > 0 && indexPath.item < items.count {
            let item = items[indexPath.item]
            itemW = item.estimatedTextRect(fontN: FontName.montMedium, fontS: 16.0).width + 40
        }
        
        return CGSize(width: itemW, height: TagLayout.tagH)
    }
}
