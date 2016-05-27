//
//  SettingsViewController.swift
//  Memory game
//
//  Created by admin on 4/17/16.
//  Copyright © 2016 Anya&Qusay. All rights reserved.
//

import UIKit



class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var images = [UIImage?](count:0, repeatedValue: nil)
    let IMAGE = "image"
    let DEFAULT_IMAGE = "default_image"
    var currentIndex = 0
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        for i in 0 ..< 10 {
            let imageData =  NSUserDefaults.standardUserDefaults().objectForKey(IMAGE + "\((i + 1))") as! NSData
            let image = UIImage(data: imageData)!
            images.insert(image, atIndex: i)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCell", forIndexPath: indexPath) as! TableViewCell
        
        cell.gameImage?.image = images[indexPath.row]
        cell.id = indexPath.row
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.currentIndex = indexPath.row // Save the selected index
        showChooseAlert()
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    private func showChooseAlert() {
        let alert = UIAlertController(title: "Upload Image", message: "Please choose from where to uploade", preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            self.pickFromCamera()
        }))
        alert.addAction(UIAlertAction(title: "Library", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            self.pickFromLibrary()
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Insert URL", comment: "url"), style: .Default) { [weak self] (action) in
            self?.promptImageURL()
        })
        alert.addAction(UIAlertAction(title: "Reset to default", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            self.resetImageToDefault()
        }))
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    private func resetImageToDefault() {
        let imageData =  NSUserDefaults.standardUserDefaults().objectForKey(DEFAULT_IMAGE + "\((currentIndex + 1))") as! NSData
        let image = UIImage(data: imageData)!
        setImageToView(image)
    }
    
    private func pickFromCamera() {
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.cameraCaptureMode = .Photo
            presentViewController(imagePicker, animated: true, completion: nil)
        } else {
            noCamera()
        }
    }
    
    private func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .Alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.Default,
            handler: nil)
        alertVC.addAction(okAction)
        presentViewController(alertVC,
            animated: true,
            completion: nil)
    }
    
    private func pickFromLibrary() {
        imagePicker.allowsEditing = false //2
        imagePicker.sourceType = .PhotoLibrary //3
        presentViewController(imagePicker, animated: true, completion: nil)//4
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        
        self.setImageToView(image)
        
    }
    
    private func promptImageURL() {
        let alertController = UIAlertController(title: NSLocalizedString("Enter Image URL:", comment: "title"), message: nil, preferredStyle: .Alert)
        
        let enterUrlAction = UIAlertAction(title: NSLocalizedString("Load", comment: "load"), style: .Default) { [weak self] (_) in
            let textField = alertController.textFields![0] as UITextField
            guard let url = NSURL(string: textField.text!) else { return }
            self?.loadImage(url)
        }
        enterUrlAction.enabled = false
        alertController.addAction(enterUrlAction)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = NSLocalizedString("Image URL", comment: "image url")
            textField.keyboardType = .URL
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification,
                object: textField,
                queue: NSOperationQueue.mainQueue()) { (notification) in
                    enterUrlAction.enabled = textField.text != ""
            }
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Dismiss", comment: "dismiss"), style: .Cancel) { (action) in }
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true) { }
    }
    
    private func loadImage(url: NSURL) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            var image: UIImage? = nil
            
            defer {
                self.setImageToView(image!)
            }
            
            if let data = NSData(contentsOfURL: url) {
                image = UIImage(data: data)
            }
        }
    }
    
    private func setImageToView(image: UIImage) {
        images[currentIndex] = image
        NSUserDefaults.standardUserDefaults().setObject(UIImagePNGRepresentation(image), forKey: IMAGE + "\((currentIndex + 1))")
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
}
