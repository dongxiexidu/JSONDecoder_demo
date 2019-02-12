//
//  DXCacheManager.swift
//  JSONEncoder&JSONDecoder_demo
//
//  Created by fashion on 2018/9/6.
//  Copyright © 2018年 shangZhu. All rights reserved.
//

import UIKit

public class DXCacheManager {
    
    private var directoryUrl:URL?
    private var fileManager : FileManager{
        return FileManager.default
    }
    
    private var cacheQueue = DispatchQueue.init(label: "com.nikkscache.dev.cacheQueue")
    
    public static var sharedInstance = DXCacheManager.init(cacheName: Bundle.main.infoDictionary?["TargetName"] as? String ?? "MyAppCache")
    
    //MARK:- Initializers

    /// Private class initializer
    private init() {}
    
    
    /// This initializer method will use ~/Library/Caches/com.nikkscache.dev/targetName to save data
    ///
    /// - Parameter cacheName: Name of the cache (by default it is 'TargetName')
    private init(cacheName: String) {
        if let cacheDirectory = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last {
            let dir = cacheDirectory + "/com.nikkscache.dev/" + cacheName
            directoryUrl = URL.init(fileURLWithPath: dir)
            if fileManager.fileExists(atPath: dir) == false{
                do{
                    try fileManager.createDirectory(atPath: dir, withIntermediateDirectories: true, attributes: nil)
                }catch{}
            }
            
        }
    }
    
    
    //MARK:- Adding / Removing Cached Object
    
    
    /// This method will write Object of specified type to a particular key in cache directory
    ///
    /// - Parameters:
    ///   - object: Object to be cached
    ///   - key: Identifier in cache for object
    public func setObject<T: Codable>(_ object: T,forKey key:String) {
        cacheQueue.async { [weak self] in
            //dispatch asynchronously on cacheQueue
            guard let path = self?.pathForKey(key) else{
                print("File at path for key : \(key) not found")
                return
            }
            do{
                let data = try PropertyListEncoder().encode(object)
                let success = NSKeyedArchiver.archiveRootObject(data, toFile: path)
                var fileUrl = URL.init(fileURLWithPath: path)
                self?.excludeFromBackup(fileUrl: &fileUrl)
                print(success ? "data saved to cache SUCCESSFULLY" : "data caching FAILED")
            }catch{
                print("data caching FAILED")
            }
        }
    }
    
    
    /// This method will remove Object corresponding to specified key
    ///
    /// - Parameter key: Identifier in cache for object
    func removeObjectForKey(_ key: String) {
        //dispatch asynchronously on cacheQueue
        cacheQueue.sync { [weak self] in
            guard let path = self?.pathForKey(key) else{
                print("File at path for key : \(key) not found")
                return
            }
            
            do {
                try fileManager.removeItem(atPath: path)
                print("cached data for key \(key) removed SUCCESSFULLY")
            } catch {
                print("FAILED removing cachced data for key \(key)")
            }
            
        }

    }
    
    public func removeAllObjects(){
        cacheQueue.async { [weak self] in
            guard let `self` = self else{ return }
            guard let directoryUrls = self.directoryUrl else{ return }
            do {
                try self.fileManager.contentsOfDirectory(at: directoryUrls, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles).forEach{
                    
                    do{
                        try self.fileManager.removeItem(atPath: $0.path)
                        print("cached data item removed SUCCESSFULLY")
                    }catch{
                        print("FAILED removing all cached data")
                    }
                    
                }

            }catch{
                print("FAILED removing all cached data")
            }
        }
    }
    
    //MARK: - Fetching cached object
    
    
    /// This method is used to retrieve value from cache for specified key
    ///
    /// - Parameters:
    ///   - key: Identifier in cache for object
    ///   - completionHandler: For handling completion state of fetch operation
    public func getObjectForKey<T: Codable>(_ key: String, completionHandler: @escaping (T?)->()) {
        cacheQueue.async { [weak self] in
            guard let path = self?.pathForKey(key) else{
                print("File at path for key : \(key) not found")
                return
            }
            
            guard let data = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? Data else{
                print("ERROR data retriving from cache")
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
                return
            }
            
            do {
                let object = try PropertyListDecoder().decode(T.self, from: data)
                print("data retriving SUCCESSFULLY from cache")
                DispatchQueue.main.async {
                    completionHandler(object)
                }
            }catch{
                print("ERROR data retriving from cache")
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
        }
    }
    
    
    /// This method is used to retrieve value from cache for specified key
    ///
    /// - Parameters:
    ///   - key: Identifier in cache for objects
    ///   - completionHandler: For handling completion state of fetch operation
    public func getObjectsForKey<T: Codable>(_ key: String, completionHandler: @escaping ([T]?)->()) {
        cacheQueue.async { [weak self] in
            guard let path = self?.pathForKey(key) else{
                print("File at path for key : \(key) not found")
                return
            }
            
            guard let data = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? Data else{
                print("ERROR data retriving from cache")
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
                return
            }
            
            do {

                let object = try PropertyListDecoder().decode(Array<T>.self, from: data)
                print("data retriving SUCCESSFULLY from cache")
                DispatchQueue.main.async {
                    completionHandler(object)
                }
            }catch{
                print("ERROR data retriving from cache")
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
        }
    }
    
    
    //MARK: - Private Methods
    
    private func pathForKey(_ key: String)->String?{
        return directoryUrl?.appendingPathComponent(key).path
    }
    
    
    /// This method is used beacuse it is required as per App Store Review Guidelines/ iOS Data Storage Guidelines to exculude files from being backedup on iCloud
    ///
    /// - Parameter fileUrl: filePath url for file to be excluded from backup
    /// - Returns: <#return value description#>
    @discardableResult
    private func excludeFromBackup(fileUrl: inout URL) ->Bool {
        if fileManager.fileExists(atPath: fileUrl.path) {
            fileUrl.setTemporaryResourceValue(true, forKey: URLResourceKey.isExcludedFromBackupKey)
            return true
        }
        return false
    }

}
