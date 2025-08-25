//
//  LanguageVC.swift
//  Wallpee
//
//  Created by Thanh Hoang on 20/6/24.
//

import UIKit

class LanguageVC: UIViewController {
    
    //MARK: - UIView
    private let tableView = UITableView(frame: .zero)
    
    private let naviView = M_NaviView()
    
    //MARK: - Properties
    lazy var items: [LocalizeModel] = {
        LocalizeModel.shared()
    }()
    
    private var changeLanguageObs: Any?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isMovingFromParent {
            removeMyObserver(any: changeLanguageObs)
        }
    }
}

//MARK: - Setups

extension LanguageVC {
    
    private func setupViews() {
        view.backgroundColor = .white
        
        //TODO: - NaviView
        naviView.setupViews(vc: self)
        
        naviView.leftBtn.delegate = self
        naviView.leftBtn.tag = 0
        
        naviView.titleLbl.text = "Language".localized()
        
        //TODO: - TableView
        tableView.clipsToBounds = true
        tableView.backgroundColor = .clear
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
        tableView.rowHeight = 50.0
        tableView.sectionHeaderHeight = 0.0
        tableView.sectionFooterHeight = 0.0
        tableView.register(LanguageTVCell.self, forCellReuseIdentifier: LanguageTVCell.id)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: naviView.bottomAnchor, constant: 20.0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - Add Observers

extension LanguageVC {
    
    private func addObservers() {
        changeLanguageObs = NotificationCenter.default.addObserver(
            forName: .changeLanguageKey,
            object: nil,
            queue: .main,
            using: { _ in
                self.naviView.titleLbl.text = "Language".localized()
                
                self.items = LocalizeModel.shared()
                self.reloadData()
            })
    }
}

//MARK: - UITableViewDataSource

extension LanguageVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LanguageTVCell.id, for: indexPath) as! LanguageTVCell
        let item = items[indexPath.row]
        
        cell.nameLbl.text = item.name
        cell.isSelect = item.code == appDL.currentLanguage.code
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension LanguageVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if appDL.currentLanguage.code == items[indexPath.row].code {
            return
        }
        
        CustomizeAlert.shared.customizeAlert(type: .alert, mesTxt: "Do you want to change the language?".localized()) { act in
            if act == "OK" {
                appDL.currentLanguage = self.items[indexPath.row]
                setLanguageCode(code: appDL.currentLanguage.code)
                
                self.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
}

//MARK: - ButtonAnimationDelegate

extension LanguageVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        if sender.tag == 0 { //Back
            navigationController?.popViewController(animated: true)
        }
    }
}
