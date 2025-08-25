//
//  PhotoModel.swift
//  Wallpee
//
//  Created by Thanh Hoang on 5/6/24.
//

import Foundation

struct PhotoSrc: Codable {
    
    let original: String
    let large2x: String
    let large: String
    let medium: String
    let small: String
    let portrait: String
    let landscape: String
    let tiny: String
    
    var coin: Int? //Giá để mở khóa Photo này
    var unlock: Bool? //Đã mở khóa Photo này chưa
    var downloaded: Bool? //Photo đã được tải xuống thiết bị
}

struct PhotoModel: Codable {
    
    let id: Int
    let width: Int
    let height: Int
    let url: String
    var liked: Bool?
    let alt: String
    
    var src: PhotoSrc
}

struct PhotoResult: Codable {
    
    var photos: [PhotoModel]
    var next_page: String?
}
