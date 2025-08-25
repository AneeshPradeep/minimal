//
//  CoreDataStack.swift
//  Wallpee
//
//  Created by Thanh Hoang on 15/6/24.
//

import UIKit
import CoreData

enum DailyRewardsType: String {
    case day1, day2, day3, day4, day5, day6, day7, day8, day9, day10, day11, day12
}

enum EntityName: String {
    case W_PhotoModel
    case W_RecentSearches
    case W_DailyRewards
}

class CoreDataStack: NSObject {
    
    //MARK: - Properties
    private let modelName: String
    
    /*
    //Cho CoreData && CloudKit
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: modelName)
        
        //stored()
        
        //migrateIfRequired(psc: container.persistentStoreCoordinator)
        
        container.persistentStoreDescriptions.first?.url = storeURL()
        
        container.loadPersistentStores { des, error in
            if let error = error {
                print("persistentContainer error: \(error.localizedDescription)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        try? container.viewContext.setQueryGenerationFrom(.current)
        
        #if DEBUG
        do {
            try container.initializeCloudKitSchema()
            
        } catch {
            print("Initialize schema error")
        }
        #endif
        
        return container
    }()
    */
    
     //Cho CoreData
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)

        container.loadPersistentStores { des, error in
            if let error = error {
                print("persistentContainer error: \(error.localizedDescription)")
            }
        }

        return container
    }()
    
    lazy var viewContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    static let shared = CoreDataStack(modelName: "Wallpee")
    
    //MARK: - Initializes
    init(modelName: String) {
        self.modelName = modelName
    }
}

//MARK: - Save

extension CoreDataStack {
    
    ///Lưu trữ dữ liệu
    func saveData() {
        guard viewContext.hasChanges else {
            return
        }
        do {
            try viewContext.save()
            getCoreDataPath()
            
        } catch let error as NSError {
            print("saveCoreData error: \(error.localizedDescription)")
        }
    }
    
    /*
    private func migrateIfRequired(psc: NSPersistentStoreCoordinator) {
        if FileManager.default.fileExists(atPath: storeURL().path) {
            return
        }
        
        do {
            let store = try psc.addPersistentStore(
                ofType: NSSQLiteStoreType,
                configurationName: nil,
                at: storeURL(),
                options: storeOptions()
            )
            let newStore = try psc.migratePersistentStore(
                store,
                to: storeURL(), 
                options: [NSPersistentStoreRemoveUbiquitousMetadataOption: true],
                withType: NSSQLiteStoreType)
            
            try psc.remove(newStore)
            
        } catch {
            print("Error migrating store: \(error)")
        }
    }
    
    private func storeOptions() -> [AnyHashable: Any] {
        return [
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true,
            NSPersistentStoreUbiquitousContentNameKey: "CloudStore"
        ]
    }
     */
    
    private func storeURL() -> URL {
        guard let cloudURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            fatalError("Error fetching document directory")
        }
        
        let url = cloudURL.appendingPathComponent("Wallpee.sqlite")
        return url
    }
    
    private func stored() {
        let localURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent("local.sqlite")
        let localDesc = NSPersistentStoreDescription(url: localURL)
        localDesc.configuration = "Local"
        
        let cloudURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent("cloud.sqlite")
        let cloudDesc = NSPersistentStoreDescription(url: cloudURL)
        cloudDesc.configuration = "Cloud"
        
        cloudDesc.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.com.hoangmtv.devs.Wallpee")
        
        persistentContainer.persistentStoreDescriptions = [cloudDesc, localDesc]
    }
}

//MARK: - Save Photo

extension CoreDataStack {
    
    class func savePhoto(model: PhotoModel) {
        //Nếu tồn tại. Xóa nó đi. Sau đó lưu lại
        if let photo = fetchPhoto(by: model.id) {
            deleteItem(by: "\(photo.id)", keyword: "", type: "", entityName: .W_PhotoModel)
        }
        
        //Lưu mới
        let _ = newPhoto(model: model)
        
        shared.saveData()
        
        NotificationCenter.default.post(name: .changePhotoKey, object: model)
    }
    
    class func newPhoto(model: PhotoModel) -> W_PhotoModel {
        let photo = W_PhotoModel(context: shared.viewContext)
        
        photo.id = NSNumber(integerLiteral: model.id)
        photo.width = NSNumber(integerLiteral: model.width)
        photo.height = NSNumber(integerLiteral: model.height)
        photo.url = model.url
        photo.alt = model.alt
        photo.liked = model.liked ?? false
        
        photo.portrait = model.src.portrait
        photo.landscape = model.src.landscape
        photo.original = model.src.original
        photo.large2x = model.src.large2x
        photo.large = model.src.large
        photo.medium = model.src.medium
        photo.small = model.src.small
        
        photo.coin = NSNumber(integerLiteral: model.src.coin ?? 0)
        photo.unlock = model.src.unlock ?? false
        photo.downloaded = model.src.downloaded ?? false
        photo.createdTime = longFormatter().string(from: Date())
        
        return photo
    }
}

//MARK: - Fetch Photos

extension CoreDataStack {
    
    class func fetchPhoto(by id: Int) -> W_PhotoModel? {
        let request: NSFetchRequest<W_PhotoModel> = W_PhotoModel.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", "\(id)")
        
        do {
            if let photo = try shared.viewContext.fetch(request).first {
                return photo
            }
            
        } catch let error as NSError {
            print("fetchPhoto error: \(error.localizedDescription)")
        }
        
        return nil
    }
    
    class func fetchAllPhotos() -> [W_PhotoModel] {
        var array: [W_PhotoModel] = []
        let request: NSFetchRequest<W_PhotoModel> = W_PhotoModel.fetchRequest()
        
        do {
            array = try shared.viewContext.fetch(request)
            
        } catch let error as NSError {
            print("fetchAllPhotos error: \(error.localizedDescription)")
        }
        
        return array
    }
    
    class func fetchFavouritePhotos() -> [PhotoModel] {
        var array: [W_PhotoModel] = []
        let request: NSFetchRequest<W_PhotoModel> = W_PhotoModel.fetchRequest()
        request.predicate = NSPredicate(format: "liked == %@", NSNumber(value: true))
        
        do {
            array = try shared.viewContext.fetch(request)
            
        } catch let error as NSError {
            print("fetchFavouritePhotos error: \(error.localizedDescription)")
        }
        
        let photos = getPhotos(array: array)
        return photos
    }
    
    class func fetchDownloadedPhotos() -> [PhotoModel] {
        var array: [W_PhotoModel] = []
        let request: NSFetchRequest<W_PhotoModel> = W_PhotoModel.fetchRequest()
        request.predicate = NSPredicate(format: "downloaded == %@", NSNumber(value: true))
        
        do {
            array = try shared.viewContext.fetch(request).sorted(by: {
                $0.createdTime > $1.createdTime
            })
            
        } catch let error as NSError {
            print("fetchFavouritePhotos error: \(error.localizedDescription)")
        }
        
        let photos = getPhotos(array: array)
        return photos
    }
    
    class private func getPhotos(array: [W_PhotoModel]) -> [PhotoModel] {
        let photos = array.compactMap({
            PhotoModel(
                id: $0.id.intValue,
                width: $0.width.intValue,
                height: $0.height.intValue,
                url: $0.url,
                liked: $0.liked,
                alt: $0.alt,
                src: PhotoSrc(
                    original: $0.original,
                    large2x: $0.large2x,
                    large: $0.large,
                    medium: $0.medium,
                    small: $0.small,
                    portrait: $0.portrait,
                    landscape: $0.landscape,
                    tiny: "",
                    coin: $0.coin.intValue,
                    unlock: $0.unlock
                )
            )
        })
        
        return photos
    }
}

//MARK: - Save Keyword

extension CoreDataStack {
    
    class func saveKeyword(keyword: String, photos: [PhotoModel]) {
        if let _ = fetchKeyword(by: keyword) {
            deleteItem(by: "", keyword: keyword, type: "", entityName: .W_RecentSearches)
        }
        
        let recent = W_RecentSearches(context: shared.viewContext)
        recent.keyword = keyword
        recent.createdTime = longFormatter().string(from: Date())
        
        shared.saveData()
    }
}

//MARK: - Fetch Keyword

extension CoreDataStack {
    
    class func fetchKeyword(by keyword: String) -> W_RecentSearches? {
        let request: NSFetchRequest<W_RecentSearches> = W_RecentSearches.fetchRequest()
        request.predicate = NSPredicate(format: "keyword == %@", keyword)
        
        do {
            if let keyword = try shared.viewContext.fetch(request).first {
                return keyword
            }
            
        } catch let error as NSError {
            print("fetchKeyword error: \(error.localizedDescription)")
        }
        
        return nil
    }
    
    class func fetchAllKeywords() -> [String] {
        var array: [W_RecentSearches] = []
        let request: NSFetchRequest<W_RecentSearches> = W_RecentSearches.fetchRequest()
        
        do {
            array = try shared.viewContext.fetch(request)
            
        } catch let error as NSError {
            print("fetchAllKeywords error: \(error.localizedDescription)")
        }
        
        array = array.sorted(by: { $0.createdTime > $1.createdTime })
        
        let keywords = array.compactMap({ $0.keyword })
        
        return keywords
    }
}

//MARK: - Daily Rewards

extension CoreDataStack {
    
    class func updateDailyRewards(type: DailyRewardsType) {
        //Nếu tồn tại. Xóa nó đi. Sau đó lưu lại
        if let result = fetchDailyRewards(type: type) {
            result.earn = true
            shared.saveData()
        }
    }
    
    class func saveDailyRewards(title: String, coin: Int, earn: Bool, createdTime: String, type: DailyRewardsType) {
        //Lưu mới
        let rewards = W_DailyRewards(context: shared.viewContext)
        
        rewards.title = title
        rewards.coin = NSNumber(value: coin)
        rewards.createdTime = createdTime
        rewards.earn = earn
        rewards.type = type.rawValue
        
        shared.saveData()
    }
    
    ///Lưu cho lần đầu khởi chạy App
    class func saveAllDailyRewards() {
        //Nếu dữ liệu ko tồn tại
        let rewards = fetchDailyRewards()
        
        if rewards.count <= 0 {
            deleteAllItem(entityName: .W_DailyRewards)
            
            let today = Date()
            
            for i in 0...11 {
                let index = i + 1
                var coin = 5 * index
                
                var type: DailyRewardsType = .day1
                
                switch index {
                case 1: coin = 1; break
                case 2: type = .day2; break
                case 3: type = .day3; break
                case 4: type = .day4; break
                case 5: type = .day5; break
                case 6: type = .day6; break
                case 7: type = .day7; break
                case 8: type = .day8; break
                case 9: type = .day9; break
                case 10: type = .day10; coin = 100; break
                case 11: type = .day11; coin = 150; break
                case 12: type = .day12; coin = 200; break
                default: break
                }
                
                if let date = Calendar.current.date(byAdding: .day, value: i, to: today) {
                    let f = createDateFormatter()
                    f.dateFormat = "yyyyMMdd"
                    
                    let createdTime = f.string(from: date)
                    
                    saveDailyRewards(title: "Day \(index)", coin: coin, earn: false, createdTime: createdTime, type: type)
                }
            }
            
        } else {
            /*
             - Nếu dữ liệu tồn tại
             - Nhưng ko truy cập hàng ngày
             - Xóa && Lưu lại từ đầu
             */
            let f = createDateFormatter()
            f.dateFormat = "yyyyMMdd"
            
            let today = f.string(from: Date())
            
            if let index = rewards.firstIndex(where: {
                $0.createdTime == today
            }), 
                index > 0
            {
                let array = Array(rewards[0..<index]).filter({ $0.earn == false })
                print("array.count: \(array.count)")
                
                if array.count > 0 {
                    deleteAllItem(entityName: .W_DailyRewards)
                    saveAllDailyRewards()
                }
            }
        }
    }
    
    ///Lấy 'DailyRewards' theo 'type'
    class func fetchDailyRewards(type: DailyRewardsType) -> W_DailyRewards? {
        let request: NSFetchRequest<W_DailyRewards> = W_DailyRewards.fetchRequest()
        request.predicate = NSPredicate(format: "type == %@", type.rawValue)
        
        do {
            if let result = try shared.viewContext.fetch(request).first {
                return result
            }
            
        } catch let error as NSError {
            print("fetchDailyReward error: \(error.localizedDescription)")
        }
        
        return nil
    }
    
    ///Lấy Tất cả 'DailyRewards'
    class func fetchDailyRewards() -> [W_DailyRewards] {
        var array: [W_DailyRewards] = []
        let request: NSFetchRequest<W_DailyRewards> = W_DailyRewards.fetchRequest()
        
        do {
            array = try shared.viewContext.fetch(request)
                .sorted(by: { $0.createdTime < $1.createdTime })
            
        } catch let error as NSError {
            print("fetchDailyRewards error: \(error.localizedDescription)")
        }
        
        return array
    }
}

//MARK: - Delete

extension CoreDataStack {
    
    ///Xoá tất cả Items bởi entityName
    class func deleteAllItem(entityName: EntityName) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName.rawValue)
        let batch = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try shared.viewContext.execute(batch)
            
        } catch let error as NSError {
            print("deleteAllItem error: \(error.localizedDescription)")
        }
        
        shared.saveData()
    }
    
    ///Xoá 1 Item bởi entityName
    class func deleteItem(by id: String, keyword: String, type: String, entityName: EntityName) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName.rawValue)
        if id != "" {
            request.predicate = NSPredicate(format: "id == %@", id)
            
        } else if keyword != "" {
            request.predicate = NSPredicate(format: "keyword == %@", keyword)
            
        } else if type != "" {
            request.predicate = NSPredicate(format: "type == %@", type)
        }
        
        let batch = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try shared.viewContext.execute(batch)
            
        } catch let error as NSError {
            print("deleteItem error: \(error.localizedDescription)")
        }
        
        shared.saveData()
    }
}

func getCoreDataPath() {
    let urls = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)
    print("CoreData Path: \(urls.first?.path ?? "")")
}
