//
//  FilesTableViewController.swift
//  manager
//
//  Created by Andrew Finke on 10/30/14.
//  Copyright (c) 2014 ATFinke Productions. All rights reserved.
//

import UIKit

class FilesTableViewController: UITableViewController, UIDocumentMenuDelegate, UIDocumentPickerDelegate {

    var fileURLs = [NSURL]()
    var UTIs = ["public.item","public.content","public.database","public.calendar-event","public.message","public.contact","public.archive","public.url-name","public.executable","com.apple.resolvable","com.apple.iwork.pages.pages", "com.apple.iwork.numbers.numbers","com.apple.iwork.keynote.key","com.apple.rtfd","com.apple.package","com.pixelcut.pcvd","com.apple.disk-image-udif","com.apple.disk-image","com.apple.xcode.project","com.apple.xcode.entitlements-property-list","com.apple.xml-property-list","com.pixelmator.pxm","com.apple.interfacebuilder.document.cocoa","com.apple.quicktime-movie"]
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFiles()
        loadUTIs()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadFiles", name: "FilesUpdated", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadFiles() {
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        var err: NSErrorPointer = nil
        let url = NSURL(fileURLWithPath: path)
        let contents = NSFileManager.defaultManager().contentsOfDirectoryAtURL(url!, includingPropertiesForKeys:[], options: NSDirectoryEnumerationOptions.SkipsHiddenFiles, error: nil)
        fileURLs = contents as [NSURL]
        self.tableView.reloadData()
        if fileURLs.count == 0 {
            NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "showFileAlert", userInfo: nil, repeats: false)
        }
    }
    
    func showFileAlert() {
        let alertController = UIAlertController(title: "No Files", message: "Add files by pressing import or by adding them from other apps", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler:nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func loadUTIs() {
        if let newFileTypes: NSArray = NSUserDefaults.standardUserDefaults().objectForKey("NewFileTypes") as? NSArray {
            let fileArray = newFileTypes as AnyObject as [String]
            for newID in fileArray {
                var hasID = false
                for currentID in UTIs {
                    if currentID == newID {
                        hasID = true
                    }
                }
                if !hasID {
                    UTIs.append(newID)
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileURLs.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        let url = fileURLs[indexPath.row]
        cell.textLabel?.text = url.lastPathComponent
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            deleteFileAtIndexPath(indexPath)
        }
    }
    
    func deleteFileAtIndexPath(indexPath: NSIndexPath) {
        NSFileManager.defaultManager().removeItemAtURL(fileURLs[indexPath.row], error: nil)
        fileURLs.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:{(alert :UIAlertAction!) -> Void in
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }))
        alertController.addAction(UIAlertAction(title: "Open in App", style: UIAlertActionStyle.Default, handler:{(alert :UIAlertAction!) -> Void in
            self.showActivityViewControllerForIndexPath(indexPath)
        }))
        alertController.addAction(UIAlertAction(title: "Export to Service", style: UIAlertActionStyle.Default, handler:{(alert :UIAlertAction!) -> Void in
            self.showExportDocumentMenuForIndexPath(indexPath)
        }))
        alertController.addAction(UIAlertAction(title: "Delete File", style: UIAlertActionStyle.Destructive, handler:{(alert :UIAlertAction!) -> Void in
            self.deleteFileAtIndexPath(indexPath)
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showActivityViewControllerForIndexPath(indexPath: NSIndexPath) {
        let controller = UIActivityViewController(activityItems: [fileURLs[indexPath.row]], applicationActivities: nil)
        self.presentViewController(controller, animated: true, completion:nil)
        controller.completionHandler = {(activityType, completed:Bool) in
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    func showExportDocumentMenuForIndexPath(indexPath: NSIndexPath) {
        let menu = UIDocumentMenuViewController(URL: fileURLs[indexPath.row], inMode: UIDocumentPickerMode.ExportToService)
        menu.delegate = self
        self.presentViewController(menu, animated: true, completion: nil)
    }
    
    @IBAction func deleteAll(sender: AnyObject) {
        while fileURLs.count > 0 {
            deleteFileAtIndexPath(NSIndexPath(forRow: fileURLs.count-1, inSection: 0))
        } 
    }
    @IBAction func showImportMenu(sender: AnyObject) {
        let menu = UIDocumentMenuViewController(documentTypes: UTIs, inMode: .Import)
        menu.delegate = self
        self.presentViewController(menu, animated: true, completion: nil)
    }
    
    func documentMenu(documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        self.presentViewController(documentPicker, animated: true, completion: nil)
    }
    
    func documentMenuWasCancelled(documentMenu: UIDocumentMenuViewController) {
        if let indexPath = self.tableView.indexPathForSelectedRow() {
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    func documentPickerWasCancelled(controller: UIDocumentPickerViewController) {
    }
    
    func documentPicker(controller: UIDocumentPickerViewController, didPickDocumentAtURL url: NSURL) {
        if controller.documentPickerMode == UIDocumentPickerMode.Import {
            var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            path = path.stringByAppendingPathComponent(url.lastPathComponent!)
            let pathURL = NSURL(fileURLWithPath: path)!
            NSFileManager.defaultManager().copyItemAtURL(url, toURL: pathURL, error: nil)
            fileURLs.append(pathURL)
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: fileURLs.count - 1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
}
