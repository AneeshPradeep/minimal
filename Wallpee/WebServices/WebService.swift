//
//  WebService.swift
//  Wallpee
//
//  Created by Thanh Hoang on 3/6/24.
//

import UIKit
import Alamofire

//Lưu nhạc tải xuống vào thư mục này
enum FolderName: String {
    case videoFiles = "VideoFiles"
}

class WebService: NSObject {
    
    static let shared = WebService()
    
    enum APIError: Error {
        case error(String)
        
        var localizedDescription: String {
            switch self {
            case .error(let string):
                return string
            }
        }
    }
    
    enum AssemblyAI_LanguageCode: String {
        case vi = "vi"
        case en_us = "en_us"
    }
    
    private let pexelsPhotoLink = "https://api.pexels.com/v1"
    private let pexelsVideoLink = "https://api.pexels.com/videos"
    
    //Đang tải MP3
    lazy var downloadTask: [String: Task<(), Never>] = [:]
    lazy var downloadRequest: [String: DataRequest] = [:]
    
    let receiptFN = "Receipt" //Lưu Biên Nhận khi mua hàng
    
    override init() {
        super.init()
    }
    
    private func pexelsHeader() -> HTTPHeaders {
        print("PexelsKey: \(getFromAPIKeyFile(key: "PexelsKey"))")
        
        return [
            "Authorization": getFromAPIKeyFile(key: "PexelsKey")
        ]
    }
}

//MARK: - Plist File

extension WebService {
    
    ///Nhận 'NSDictionary' từ tệp '.plist'
    func getDictionaryFrom(fileName: String) -> NSDictionary {
        if let url = Bundle.main.url(forResource: fileName, withExtension: nil) {
            let dict = try? NSDictionary(contentsOf: url, error: ())
            return dict ?? [:]
        }
        
        return [:]
    }
    
    ///Lấy các 'Value' từ tệp 'API-Key.plist' thông qua 'Key' đã cho
    func getFromAPIKeyFile(key: String) -> String {
        return "\(getDictionaryFrom(fileName: "API-Key.plist").object(forKey: key) ?? "")"
    }
    
    ///Lấy các 'Value' từ tệp 'API-Key.plist' thông qua 'Key' đã cho
    func getFromGoogleServiceInfoFile(key: String) -> String {
        return "\(getDictionaryFrom(fileName: "GoogleService-Info.plist").object(forKey: key) ?? "")"
    }
}

//MARK: - Photos

extension WebService {
    
    func loadData<T: Decodable>(type: T.Type, filename: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = Bundle.main.url(forResource: "\(filename).json", withExtension: nil) else {
            completion(.failure(APIError.error("Link error")))
            return
        }
        guard let data = try? Data(contentsOf: url) else {
            completion(.failure(APIError.error("Data error")))
            return
        }
        guard let json = try? JSONDecoder().decode(type, from: data) else {
            completion(.failure(APIError.error("Unable to decode data")))
            return
        }
        
        completion(.success(json))
    }
    
    func loadResult<T: Decodable>(type: T.Type, filename: String) async throws -> T {
        try await withCheckedThrowingContinuation { c in
            loadData(type: type, filename: filename) { result in
                switch result {
                case .success(let success):
                    c.resume(returning: success)
                    
                case .failure(let failure):
                    c.resume(throwing: failure)
                }
            }
        }
    }
}

//MARK: - Request Data

extension WebService {
    
    private func requestData<T: Decodable>(type: T.Type, link: String, completion: @escaping (Result<T, Error>) -> Void) {
        AF.request(link,
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: pexelsHeader(),
                   interceptor: nil) { r in r.timeoutInterval = 10.0 }
            .validate(statusCode: 200..<500)
            .response(queue: .main) { response in
                switch response.result {
                case .success(let data):
                    if let data = data {
                        if let result = try? JSONDecoder().decode(type, from: data) {
                            completion(.success(result))
                            
                        } else {
                            completion(.failure(APIError.error("Unable to decode data")))
                        }
                        
                    } else {
                        completion(.failure(APIError.error("Data error")))
                    }
                    
                case .failure(let error):
                    completion(.failure(APIError.error(error.localizedDescription)))
                }
            }
    }
}

//MARK: - Curated Photos

extension WebService {
    
    func fetchCuraterPhotos<T: Decodable>(type: T.Type) async throws -> T {
        try await withCheckedThrowingContinuation { c in
            let link = pexelsPhotoLink + "/curated?per_page=80"
            
            requestData(type: type, link: link) { result in
                switch result {
                case .success(let success):
                    return c.resume(returning: success)
                    
                case .failure(let failure):
                    if let error = failure as? APIError {
                        print("fetchCuraterPhotos error: \(error.localizedDescription)")
                    }
                    
                    return c.resume(throwing: failure)
                }
            }
        }
    }
}

//MARK: - Search Photos

extension WebService {
    
    func searchPhotos<T: Decodable>(with keyword: String, type: T.Type) async throws -> T {
        try await withCheckedThrowingContinuation { c in
            let keyword = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let query = "query=\(keyword)&orientation=portrait&per_page=80"
            let link = pexelsPhotoLink + "/search?\(query)"
            
            requestData(type: type, link: link) { result in
                switch result {
                case .success(let success):
                    c.resume(returning: success)
                    
                case .failure(let failure):
                    if let error = failure as? APIError {
                        print("searchPhotos error: \(error.localizedDescription)")
                    }
                    
                    c.resume(throwing: failure)
                }
            }
        }
    }
}

//MARK: - Load More Photos

extension WebService {
    
    func loadMorePhotos<T: Decodable>(link: String, type: T.Type) async throws -> T {
        try await withCheckedThrowingContinuation { c in
            requestData(type: type, link: link) { result in
                switch result {
                case .success(let success):
                    c.resume(returning: success)
                    
                case .failure(let failure):
                    if let error = failure as? APIError {
                        print("loadMorePhotos error: \(error.localizedDescription)")
                    }
                    
                    c.resume(throwing: failure)
                }
            }
        }
    }
}

//MARK: - Cancel Download

extension WebService {
    
    func cancelDownloadTrack(audioURL: String) {
        downloadRequest[audioURL]?.cancel()
        downloadTask[audioURL]?.cancel()
        
        downloadTask[audioURL] = nil
        downloadRequest[audioURL] = nil
    }
}

//MARK: - Download File

extension WebService {
    
    private func downloadDataFromAudioFile(audioURL: String, playlistID: String?) async throws -> Data {
        try await withCheckedThrowingContinuation { c in
            let queue = DispatchQueue.global(qos: .background)
            
            //Tải xuống và lưu vào Documents
            let request = AF.request(audioURL)
                .downloadProgress(closure: { progress in
                    //print("download.progress.audio: \(progress.fractionCompleted)")
                    
                    /*
                    let path = audioURL.lastPath
                    let dict: [String: Any] = [
                        path: progress.fractionCompleted
                    ]
                    NotificationCenter.default.post(name: .downloadingKey, object: dict)
                    */
                })
                .responseData(queue: queue) { response in
                    switch response.result {
                    case .success(let data):
                        c.resume(returning: data)
                        break
                        
                    case .failure(let error):
                        print("downloadAudioFile error: \(error.localizedDescription)")
                        c.resume(throwing: error)
                        break
                    }
                }
            
            downloadRequest[audioURL] = request
        }
    }
}

//MARK: - JSON

extension WebService {
    
    func saveJSONFile(_ fileName: String, dataAny: Any) {
        let defaults = FileManager.default
        if let url = defaults.urls(for: .libraryDirectory, in: .userDomainMask).first {
            let getURL = url.appendingPathComponent("Wallpee")
            
            do {
                try defaults.createDirectory(at: getURL, withIntermediateDirectories: true, attributes: nil)
                
                let toURL = getURL.appendingPathComponent("\(fileName).json")
                let saved = try JSONSerialization.data(withJSONObject: dataAny, options: .prettyPrinted)
                try saved.write(to: toURL)
                print("*** saveJSONFile: \(toURL)")
                
            } catch {}
        }
    }
    
    func getJSONFile(_ fileName: String) -> Any? {
        var downloadData: Any?
        
        let defaults = FileManager.default
        if let url = defaults.urls(for: .libraryDirectory, in: .userDomainMask).first {
            let jsonFile = "\(fileName).json"
            let getURL = url.appendingPathComponent("Wallpee/\(jsonFile)")
            
            if defaults.fileExists(atPath: getURL.path) {
                do {
                    let data = try Data(contentsOf: getURL)
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    downloadData = json
                    
                } catch {}
            }
        }
        
        return downloadData
    }
    
    class func getAllJSONFile() -> [String] {
        var fileNames: [String] = []
        
        let defaults = FileManager.default
        if let url = defaults.urls(for: .libraryDirectory, in: .userDomainMask).first {
            let getURL = url.appendingPathComponent("Wallpee/")
            
            if defaults.fileExists(atPath: getURL.path) {
                do {
                    fileNames = try defaults.contentsOfDirectory(atPath: getURL.path)
                    fileNames = fileNames.sorted(by: { $0 < $1 })
                    
                } catch {}
            }
        }
        
        return fileNames
    }
    
    func removeJSONFile(_ fileName: String) {
        let defaults = FileManager.default
        if let url = defaults.urls(for: .libraryDirectory, in: .userDomainMask).first {
            let jsonFile = "\(fileName).json"
            
            let getURL = url.appendingPathComponent("Wallpee/\(jsonFile)")
            
            if defaults.fileExists(atPath: getURL.path) {
                do {
                    try defaults.removeItem(at: getURL)
                    print("*** RemoveJSONFile: \(jsonFile)")
                    
                } catch {}
            }
        }
    }
}

//MARK: - Remove File

extension WebService {
    
    func removeAudioFile(audioURL: String) {
        let desURL = getAudioURL(audioURL: audioURL)
        removeItem(desURL: desURL)
    }
    
    ///Lấy đường dẫn của tệp trong thư mục 'folder'
    func getAudioURL(audioURL: String) -> URL {
        let currentURL = getDestinationAudioFileURL(folder: .videoFiles)
        
        let path = audioURL.lastPath
        let ext = path.contains(".mp3") ? "" : ".mp3"
        
        return currentURL.appendingPathComponent(path + ext)
    }
    
    ///Lấy URL từ đường dẫn trong thư mục 'folder'
    private func getDestinationAudioFileURL(folder: FolderName) -> URL {
        let document = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let newURL = document.appendingPathComponent(folder.rawValue)
        
        if !FileManager.default.fileExists(atPath: newURL.path) {
            do {
                try FileManager.default.createDirectory(at: newURL, withIntermediateDirectories: true, attributes: nil)
                
            } catch let error as NSError {
                print("Create Directory Error: \(error.localizedDescription)")
            }
        }
        
        return newURL
    }
    
    private func removeItem(desURL: URL) {
        if FileManager.default.fileExists(atPath: desURL.path) {
            do {
                try FileManager.default.removeItem(at: desURL)
                
            } catch let error as NSError {
                print("removeItem error: \(error.localizedDescription)")
            }
        }
    }
    
    ///Xóa tất cả các tệp '.m4v' tồn tại trong thư mục
    func removeAllM4VFile() {
        if let document = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            do {
                let arrayDoc = try FileManager.default.contentsOfDirectory(atPath: document.path)
                for arr in arrayDoc {
                    if arr.contains(".m4v") {
                        let url = document.appendingPathComponent(arr)
                        try FileManager.default.removeItem(at: url)
                    }
                }
                
            } catch {}
        }
    }
}
