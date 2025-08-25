//
//  SearchViewModel.swift
//  Wallpee
//
//  Created by Thanh Hoang on 16/6/24.
//

import UIKit

class SearchViewModel: NSObject {
    
    //MARK: - Properties
    private let parentVC: SearchVC
    
    lazy var keywords: [String] = [] //Recent Searches
    lazy var photos: [PhotoModel] = [] //Search Results
    
    var transitionAnimator: SharedTransitionAnimator?
    
    var searchText = "" //Từ khóa
    var nextPage = "" //Liên kết tải thêm trang mới
    var fileName = "" //Tên JSON
    
    //MARK: - Initializes
    init(parentVC: SearchVC) {
        self.parentVC = parentVC
    }
}

//MARK: - Load Keywords

extension SearchViewModel {
    
    func loadKeywords() {
        keywords = CoreDataStack.fetchAllKeywords()
        parentVC.recentView.reloadData()
        
        parentVC.recentView.isHidden = keywords.count == 0
        
        //Tùy chỉnh chiều cao cho phần Recent Searches
        if keywords.count > 0 {
            var maxW: CGFloat = 0.0
            
            //Tính tổng chiều dài của tất cả từ khóa
            keywords.forEach({
                let itemW = $0.estimatedTextRect(fontN: FontName.montMedium, fontS: 16.0).width + 50 + TagLayout.tagH
                maxW += itemW
            })
            
            //Mặc định chiều cao là 3 dòng
            let defaultTagH = TagLayout.tagH*3 + 10*2
            let line = maxW/(screenWidth-40)
            var value = Int(line)
            
            if line <= 1 {
                value = 1
                
            } else if line > 1 {
                value = value + 1
            }
            
            var tagH = (CGFloat(value)*TagLayout.tagH) + (CGFloat(value-1)*10)
            tagH = tagH >= defaultTagH ? defaultTagH : tagH
            
            let recentH = tagH + S_ContainerView.headerH
            
            parentVC.recentView.tagHeightConstraint.constant = tagH
            parentVC.recentView.heightConstraint.constant = recentH
        }
    }
    
    func searchAgain() {
        /*
         - Khi khởi chạy lại ứng dụng
         - Lấy kết quả tìm kiếm cuối cùng từ Recent Searches
         - Thực hiện tìm kiếm cho Search Result
         */
        guard let keyword = keywords.first else {
            return
        }
        
        
        //Lưu kết quả tìm kiếm vào JSON
        let fileName = keyword
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
            .replacingOccurrences(of: "đ", with: "d")
            .replacingOccurrences(of: " ", with: "_")
        
        //Nếu tệp tồn tại
        guard let dict = WebService.shared.getJSONFile(fileName) as? NSDictionary else {
            return
        }
        print("Nếu tệp tồn tại")
        
        //Cho UI
        guard let data = try? JSONSerialization.data(withJSONObject: dict),
           let result = try? JSONDecoder().decode(PhotoResult.self, from: data) else {
            return
        }
        
        //Cho UI
        photos = result.photos
            .compactMap({
                var p = $0
                
                if let photo = CoreDataStack.fetchPhoto(by: $0.id) {
                    p.liked = photo.liked
                    p.src.coin = photo.coin.intValue
                    p.src.unlock = photo.unlock
                    
                } else {
                    p.src.coin = Int.random(min: 4, max: 11)
                    p.src.unlock = false
                }
                
                return p
            })
            .shuffled()
        
        nextPage = result.next_page ?? ""
        
        updateUI(hud: nil, saved: false, keyword: keyword)
    }
}

//MARK: - Search Photos

extension SearchViewModel {
    
    //Lưu từ khóa khi tìm kiếm. Hiển thị cho Recent Searches
    func searchPhotos(with keyword: String, saved: Bool) {
        let hud = HUD.hud(parentVC.view)
        
        let keyword = keyword.lowercased()
        
        //Lưu kết quả tìm kiếm vào JSON
        let fileName = keyword
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
            .replacingOccurrences(of: "đ", with: "d")
            .replacingOccurrences(of: " ", with: "_")
        
        self.fileName = fileName
        
        //Nếu tệp tồn tại
        if let dict = WebService.shared.getJSONFile(fileName) as? NSDictionary {
            print("Nếu tệp tồn tại")
            
            delay(duration: 0.5) {
                //Cho UI
                if let data = try? JSONSerialization.data(withJSONObject: dict),
                   let result = try? JSONDecoder().decode(PhotoResult.self, from: data)
                {
                    //Cho UI
                    self.photos = result.photos
                        .compactMap({
                            var p = $0
                            
                            if let photo = CoreDataStack.fetchPhoto(by: $0.id) {
                                p.liked = photo.liked
                                p.src.coin = photo.coin.intValue
                                p.src.unlock = photo.unlock
                                
                            } else {
                                p.src.coin = Int.random(min: 4, max: 11)
                                p.src.unlock = false
                            }
                            
                            return p
                        })
                        .shuffled()
                    
                    self.nextPage = result.next_page ?? ""
                }
                
                self.updateUI(hud: hud, saved: saved, keyword: keyword)
            }
            
            return
        }
        
        Task(priority: .userInitiated) {
            let result = try await WebService.shared.searchPhotos(with: keyword, type: PhotoResult.self)
            
            //Lưu kết quả tìm kiếm vào JSON
            let fileName = keyword
                .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
                .replacingOccurrences(of: "đ", with: "d")
                .replacingOccurrences(of: " ", with: "_")
            
            //Nếu tệp ko tồn tại
            if let data = try? JSONEncoder().encode(result),
               var json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any]
            {
                print("Nếu tệp ko tồn tại")
                
                json["keyword"] = keyword
                
                let dict = NSMutableDictionary(dictionary: json)
                WebService.shared.saveJSONFile(fileName, dataAny: dict)
            }
            
            //Cho UI
            photos = result.photos
                .compactMap({
                    var p = $0
                    
                    if let photo = CoreDataStack.fetchPhoto(by: $0.id) {
                        p.liked = photo.liked
                        p.src.coin = photo.coin.intValue
                        p.src.unlock = photo.unlock
                        
                    } else {
                        p.src.coin = Int.random(min: 4, max: 11)
                        p.src.unlock = false
                    }
                    
                    return p
                })
                .shuffled()
            
            nextPage = result.next_page ?? ""
            
            updateUI(hud: hud, saved: saved, keyword: keyword)
        }
    }
    
    private func updateUI(hud: HUD?, saved: Bool, keyword: String) {
        DispatchQueue.main.async {
            self.parentVC.contentView.isHidden = self.photos.count <= 0
            self.parentVC.contentView.viewAllBtn.isHidden = self.photos.count <= 6
            
            hud?.removeHUD {}
        }
        
        let coverUrls = photos.compactMap({
            URL(string: $0.src.medium)
        })
        DownloadImage.shared.batchDownloadImages(coverUrls)
        
        parentVC.contentView.reloadData()
        
        //Lưu từ khóa vào CoreData
        if saved && (photos.count > 0) {
            CoreDataStack.saveKeyword(keyword: keyword, photos: photos)
            
            //Làm mới UI
            DispatchQueue.main.async {
                self.loadKeywords()
            }
        }
    }
}

//MARK: - Setup Cell

extension SearchViewModel {
    
    func contentCVCell(cell: S_ContentCVCell, indexPath: IndexPath) {
        cell.indexPath = indexPath
    }
    
    func contentCoverImage(cell: S_ContentCVCell, indexPath: IndexPath) {
        if photos.count > 0 && indexPath.item < photos.count {
            let photo = photos[indexPath.item]
            cell.updateUI(photo: photo, indexPath: indexPath)
        }
    }
}

//MARK: - Did Select

extension SearchViewModel {
    
    func didSelectPhoto(indexPath: IndexPath) {
        if photos.count > 0 && indexPath.item < photos.count {
            let cell = parentVC.contentView.collectionView.cellForItem(at: indexPath) as? S_ContentCVCell
            
            parentVC.selectedCell = cell
            parentVC.selectedIndexPath = indexPath
            
            let photo = photos[indexPath.item]
            
            transitionAnimator = nil
            transitionAnimator = SharedTransitionAnimator()
            
            parentVC.goToPhotoDetailVC(photo: photo, placeholderImage: cell?.image, transitionAnimator: transitionAnimator)
        }
    }
}

//MARK: - Actions

extension SearchViewModel {
    
    func goToSearchDetailVC() {
        let nextVC = SearchDetailVC()
        nextVC.photos = photos
        nextVC.nextPage = nextPage
        nextVC.fileName = fileName
        nextVC.hidesBottomBarWhenPushed = true
        
        parentVC.navigationController?.pushViewController(nextVC, animated: true)
    }
}
