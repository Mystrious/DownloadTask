//
//  DownloadManager.swift
//  DownloadTask
//
//  Created by MAC-4 on 6/19/18.
//  Copyright © 2018 MAC-4. All rights reserved.
//

import Foundation

// url video
let urlTest = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4"

protocol DownloadManagerDelegate {
    func downloadManager(finishDownload at:URL, task:URLSessionDownloadTask)
    func downloadManager(updateWith progress:Float, task:URLSessionDownloadTask)
    func downloadManager(failedWith resumeData:Data?, urlString:String?, error:Error, task:URLSessionTask)
    func downloadManager(task: URLSessionTask)
}

class DownloadManager: NSObject {
        
    var delegate:DownloadManagerDelegate!
    
    private var session: URLSession!
    
    override init() {
        super.init()
        initSession()
    }
    
    private func initSession() {
        let configration = URLSessionConfiguration.background(withIdentifier: "com.DownloadTask")
        session = URLSession(configuration: configration, delegate: self, delegateQueue: OperationQueue.current)
    }
    
    func downloadFile(with url: String) {
        if let Url = URL(string: url) {
            let task = session.downloadTask(with: Url)
            task.taskDescription = url
            task.resume()
        }
    }
    
    func resumeDownload(with resumeData: Data, url:String) {
        let task = session.downloadTask(withResumeData: resumeData)
        task.taskDescription = url
        task.resume()
    }
}

extension DownloadManager: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        delegate?.downloadManager(finishDownload: location, task: downloadTask)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        delegate?.downloadManager(updateWith: progress, task: downloadTask)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {

    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print(error?.localizedDescription ?? "")
        if error == nil {
            delegate.downloadManager(task: task)
            UserDefaults.standard.removeObject(forKey: task.taskDescription ?? "")
        }
        else {
            let userInfo = (error! as NSError).userInfo
            print(userInfo)
            if let data = userInfo["NSURLSessionDownloadTaskResumeData"] as? Data {
                let urlStr = userInfo["NSErrorFailingURLStringKey"] as? String
                UserDefaults.standard.set(data, forKey: urlStr!)
                delegate.downloadManager(failedWith: data, urlString: urlStr,  error: error!, task: task)
            }
            else {
                delegate.downloadManager(failedWith: nil, urlString:nil,  error: error!, task: task)
            }
        }
    }
    
}
