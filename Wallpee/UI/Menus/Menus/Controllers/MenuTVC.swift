//
//  MenuTVC.swift
//  Wallpee
//
//  Created by Thanh Hoang on 9/6/24.
//

import UIKit

protocol MenuTVCDelegate: AnyObject {
    func sideMenuDidTap(item: MenuModel)
}

class MenuTVC: UITableViewController {
    
    //MARK: - Properties
    weak var delegate: MenuTVCDelegate?
    
    lazy var items: [MenuModel] = {
        return MenuModel.shared()
    }()
    
    private var selectedItem: MenuModel?
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

//MARK: - Configures

extension MenuTVC {
    
    func setupViews() {
        view.backgroundColor = .clear
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 80.0
        tableView.sectionHeaderHeight = 0.0
        tableView.sectionFooterHeight = 0.0
        tableView.contentInset.bottom = 70.0
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(MenuTVCell.self, forCellReuseIdentifier: MenuTVCell.id)
    }
}

//MARK: - UITableViewDataSource

extension MenuTVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTVCell.id, for: indexPath) as! MenuTVCell
        let item = items[indexPath.row]
        
        cell.updateUI(item: item)
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension MenuTVC {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedItem = items[indexPath.item]
        
        if let nextVC = parent as? MenuContainerVC {
            nextVC.toggleSideMenu()
            
            removeEffectFromMenuContainerVC()
            
            if let selectedItem = selectedItem {
                delegate?.sideMenuDidTap(item: selectedItem)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .zero
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .zero
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let kView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: MenuContainerVC.menuWidth, height: 5.0))
        kView.clipsToBounds = true
        kView.backgroundColor = .clear
        
        return nil
    }
}
