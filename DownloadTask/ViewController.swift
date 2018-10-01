//
//  ViewController.swift
//  DownloadTask
//
//  Created by MAC-4 on 6/19/18.
//  Copyright © 2018 MAC-4. All rights reserved.
//

import UIKit
import CircleProgressView

class ViewController: UIViewController {

    @IBOutlet var lblProgress: UILabel!
    
    @IBOutlet var progressView: CircleProgressView!
    
    let downloadManager = DownloadManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        downloadManager.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startDownloadClicked(_ sender: UIButton) {
        if let data = UserDefaults.standard.data(forKey: urlTest) {
            downloadManager.resumeDownload(with: data, url: urlTest)
        }
        else  {
            downloadManager.downloadFile(with: urlTest)
        }
    }
    
}

extension ViewController: DownloadManagerDelegate {
    func downloadManager(finishDownload at: URL, task: URLSessionDownloadTask) {
        <#code#>
    }
    
    func downloadManager(updateWith progress: Float, task: URLSessionDownloadTask) {
        progressView.progress = Double(progress)
    }
    
    func downloadManager(failedWith resumeData: Data?, urlString: String?, error: Error, task: URLSessionTask) {
        print("Resume data")
    }
    
    func downloadManager(task: URLSessionTask) {
        <#code#>
    }
    
    
}


