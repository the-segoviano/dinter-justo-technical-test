//
//  ViewController.swift
//  Dinter
//
//  Created by Luis Segoviano on 14/08/21.
//

import UIKit
import MDCSwipeToChoose

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.people = defaultPeople()
        
        print(" self.people ", self.people.count, "\n\n")
        
        // Display the first ChoosePersonView in front. Users can swipe to indicate
        // whether they like or dislike the person displayed.
        self.setMyFrontCardView(frontCardView: self.popPersonViewWithFrame(frame: frontCardViewFrame())!)
        
        self.view.addSubview(self.frontCardView)
        
        // Display the second ChoosePersonView in back. This view controller uses
        // the MDCSwipeToChooseDelegate protocol methods to update the front and
        // back views after each user swipe.
        self.backCardView = self.popPersonViewWithFrame(frame: backCardViewFrame())
        
        self.view.insertSubview(self.backCardView, belowSubview: self.frontCardView)
        
        // Add buttons to programmatically swipe the view left or right.
        // See the `nopeFrontCardView` and `likeFrontCardView` methods.
        constructNopeButton()
        constructLikedButton()
        
        
        RequestManager.fetchRandomPerson(reference: self) { result in
            switch result {
            case .success(let personResponse):
                DispatchQueue.main.async {
                    
                    print(" personResponse \(personResponse)")
                    
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(" Error Found: ", error.localizedDescription)
                }
            }
            
        }
        
        
    }

    // MARK: - MDCSwipeToChoose
    
    var people:[Person] = []
    let ChoosePersonButtonHorizontalPadding:CGFloat = 80.0
    let ChoosePersonButtonVerticalPadding:CGFloat = 20.0
    var currentPerson: Person!
    var frontCardView: ChoosePersonView!
    var backCardView: ChoosePersonView!

}

extension ViewController: MDCSwipeToChooseDelegate {
    
    func suportedInterfaceOrientations() -> UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.portrait
    }
    
    
    // This is called when a user didn't fully swipe left or right.
    func viewDidCancelSwipe(_ view: UIView) -> Void{
        
        print("You couldn't decide on \(self.currentPerson.Name)");
    }
    
    // This is called then a user swipes the view fully left or right.
    func view(_ view: UIView, wasChosenWith wasChosenWithDirection: MDCSwipeDirection) -> Void{
        
        // MDCSwipeToChooseView shows "NOPE" on swipes to the left,
        // and "LIKED" on swipes to the right.
        if(wasChosenWithDirection == MDCSwipeDirection.left){
            print("You noped: \(self.currentPerson.Name)")
        }
        else{
            
            print("You liked: \(self.currentPerson.Name)")
        }
        
        // MDCSwipeToChooseView removes the view from the view hierarchy
        // after it is swiped (this behavior can be customized via the
        // MDCSwipeOptions class). Since the front card view is gone, we
        // move the back card to the front, and create a new back card.
        if(self.backCardView != nil){
            self.setMyFrontCardView(frontCardView: self.backCardView)
        }
        
        backCardView = self.popPersonViewWithFrame(frame: self.backCardViewFrame())
        //if(true){
        // Fade the back card into view.
        if(backCardView != nil){
            self.backCardView.alpha = 0.0
            self.view.insertSubview(self.backCardView, belowSubview: self.frontCardView)
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                self.backCardView.alpha = 1.0
                },completion:nil)
        }
    }
    func setMyFrontCardView(frontCardView:ChoosePersonView) -> Void{
        
        // Keep track of the person currently being chosen.
        // Quick and dirty, just for the purposes of this sample app.
        self.frontCardView = frontCardView
        self.currentPerson = frontCardView.person
    }
    
    func defaultPeople() -> [Person] {
        // It would be trivial to download these from a web service
        // as needed, but for the purposes of this sample app we'll
        // simply store them in memory.
        return [
            Person(name: "Finn", image: UIImage(named: "finn"), age: 21, sharedFriends: 3, sharedInterest: 4, photos: 5),
            Person(name: "Jake", image: UIImage(named: "jake"), age: 21, sharedFriends: 3, sharedInterest: 4, photos: 5),
            Person(name: "Fiona", image: UIImage(named: "fiona"), age: 21, sharedFriends: 3, sharedInterest: 4, photos: 5),
            Person(name: "P.Gumball", image: UIImage(named: "prince"), age: 21, sharedFriends: 3, sharedInterest: 4, photos: 5),
            Person(name: "Whatss", image: UIImage(named: "image-1"), age: 21, sharedFriends: 3, sharedInterest: 4, photos: 5),
            Person(name: "Otra", image: UIImage(named: "image-2"), age: 21, sharedFriends: 3, sharedInterest: 4, photos: 5),
            Person(name: "gc", image: UIImage(named: "image-3"), age: 21, sharedFriends: 3, sharedInterest: 4, photos: 5),
        ]
    }
    
    func popPersonViewWithFrame(frame:CGRect) -> ChoosePersonView? {
        if(self.people.count == 0){
            return nil;
        }
        
        // UIView+MDCSwipeToChoose and MDCSwipeToChooseView are heavily customizable.
        // Each take an "options" argument. Here, we specify the view controller as
        // a delegate, and provide a custom callback that moves the back card view
        // based on how far the user has panned the front card view.
        let options:MDCSwipeToChooseViewOptions = MDCSwipeToChooseViewOptions()
        options.delegate = self
        //options.threshold = 160.0
        options.onPan = { state -> Void in
            if(self.backCardView != nil){
                let frame:CGRect = self.frontCardViewFrame()
                
                self.backCardView.frame = CGRect(x: frame.origin.x,
                                                 y: frame.origin.y-(state!.thresholdRatio * 10.0),
                                                 width: frame.width,
                                                 height: frame.height)
            }
        }
        
        // Create a personView with the top person in the people array, then pop
        // that person off the stack.
        
        let personView:ChoosePersonView = ChoosePersonView(frame: frame, person: self.people[0], options: options)
        self.people.remove(at: 0)
        return personView
        
    }
    func frontCardViewFrame() -> CGRect{
        let horizontalPadding:CGFloat = 20.0
        let topPadding:CGFloat = 60.0
        let bottomPadding:CGFloat = 200.0
        
        return CGRect(x: horizontalPadding,
                      y: topPadding,
                      width: self.view.frame.width - (horizontalPadding * 2),
                      height: self.view.frame.height - bottomPadding)
    }
    
    func backCardViewFrame() ->CGRect{
        let frontFrame:CGRect = frontCardViewFrame()
        
        return CGRect(x: frontFrame.origin.x,
                      y: frontFrame.origin.y + 10.0,
                      width: frontFrame.width,
                      height: frontFrame.height)
    }
    
    func constructNopeButton() -> Void{
        let button:UIButton =  UIButton(type: UIButton.ButtonType.system)
        let image:UIImage = UIImage(named:"nope")!
        
        button.frame = CGRect(x: ChoosePersonButtonHorizontalPadding,
                              y: self.frontCardView.frame.maxY + ChoosePersonButtonVerticalPadding,
                              width: image.size.width,
                              height: image.size.height)
        
        button.setImage(image, for: .normal)
        
        button.tintColor = UIColor(red: 247.0/255.0, green: 91.0/255.0, blue: 37.0/255.0, alpha: 1.0)
        button.addTarget(self, action: #selector(nopeFrontCardView), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    func constructLikedButton() -> Void {
        let button:UIButton = UIButton(type: .system)
        let image:UIImage = UIImage(named:"liked")!
        
        button.frame = CGRect(x: self.view.frame.maxX - image.size.width - ChoosePersonButtonHorizontalPadding,
                              y: self.frontCardView.frame.maxY + ChoosePersonButtonVerticalPadding,
                              width: image.size.width,
                              height: image.size.height)
        
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(red: 29.0/255.0, green: 245.0/255.0, blue: 106.0/255.0, alpha: 1.0)
        // button.addTarget(self, action: "likeFrontCardView", forControlEvents: UIControl.Event.touchUpInside)
        button.addTarget(self, action: #selector(likeFrontCardView), for: .touchUpInside)
        
        self.view.addSubview(button)
        
    }
    
    @objc func nopeFrontCardView() -> Void{
        self.frontCardView.mdc_swipe(MDCSwipeDirection.left)
    }
    
    @objc func likeFrontCardView() -> Void{
        self.frontCardView.mdc_swipe(MDCSwipeDirection.right)
    }
    
}


class Person: NSObject {
    
    let Name: NSString
    let Image: UIImage!
    let Age: NSNumber
    let NumberOfSharedFriends: NSNumber?
    let NumberOfSharedInterests: NSNumber
    let NumberOfPhotos: NSNumber
    
    override var description: String {
        return "Name: \(Name), \n Image: \(Image), \n Age: \(Age) \n NumberOfSharedFriends: \(NumberOfSharedFriends) \n NumberOfSharedInterests: \(NumberOfSharedInterests) \n NumberOfPhotos/: \(NumberOfPhotos)"
    }
    
    init(name: NSString?, image: UIImage?, age: NSNumber?, sharedFriends: NSNumber?, sharedInterest: NSNumber?, photos:NSNumber?) {
        self.Name = name ?? ""
        self.Image = image
        self.Age = age ?? 0
        self.NumberOfSharedFriends = sharedFriends ?? 0
        self.NumberOfSharedInterests = sharedInterest ?? 0
        self.NumberOfPhotos = photos ?? 0
    }
}

class ImagelabelView: UIView{
    var imageView: UIImageView!
    var label: UILabel!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        imageView = UIImageView()
        label = UILabel()
    }

    init(frame: CGRect, image: UIImage, text: String) {
        
        super.init(frame: frame)
        constructImageView(image: image)
        constructLabel(text: text)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func constructImageView(image:UIImage) -> Void {
        let topPadding:CGFloat = 10.0
        let framex = CGRect(x: floor((self.bounds.width - image.size.width)/2),
                            y: topPadding,
                            width: image.size.width,
                            height: image.size.height)
        imageView = UIImageView(frame: framex)
        imageView.image = image
        addSubview(self.imageView)
    }
    
    func constructLabel(text:String) -> Void {
        let height:CGFloat = 18.0
        let frame2 = CGRect(x: 0,
                            y: self.imageView.frame.maxY,
                            width: self.bounds.width,
                            height: height)
        self.label = UILabel(frame: frame2)
        label.text = text
        addSubview(label)
        
    }
}


class ChoosePersonView: MDCSwipeToChooseView {
    
    let ChoosePersonViewImageLabelWidth:CGFloat = 42.0;
    var person: Person!
    var informationView: UIView!
    var nameLabel: UILabel!
    var carmeraImageLabelView:ImagelabelView!
    var interestsImageLabelView: ImagelabelView!
    var friendsImageLabelView: ImagelabelView!
    
    init(frame: CGRect, person: Person, options: MDCSwipeToChooseViewOptions) {
        
        super.init(frame: frame, options: options)
        self.person = person
        
        if let image = self.person.Image {
            self.imageView.image = image
        }
        
        self.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight, UIView.AutoresizingMask.flexibleWidth]
        UIView.AutoresizingMask.flexibleBottomMargin
        self.imageView.autoresizingMask = self.autoresizingMask
        constructInformationView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func constructInformationView() -> Void {
        let bottomHeight:CGFloat = 60.0
        let bottomFrame:CGRect = CGRect(x: 0,
                                        y: self.bounds.height - bottomHeight,
                                        width: self.bounds.width,
                                        height: bottomHeight);
        self.informationView = UIView(frame:bottomFrame)
        self.informationView.backgroundColor = UIColor.white
        self.informationView.clipsToBounds = true
        self.informationView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleTopMargin]
        self.addSubview(self.informationView)
        constructNameLabel()
        constructCameraImageLabelView()
        constructInterestsImageLabelView()
        constructFriendsImageLabelView()
    }
    
    func constructNameLabel() -> Void {
        let leftPadding:CGFloat = 12.0
        let topPadding:CGFloat = 17.0
        let frame: CGRect = CGRect(x: leftPadding,
                                   y: topPadding,
                                   width: floor(self.informationView.frame.width/2),
                                   height: self.informationView.frame.height - topPadding)
        self.nameLabel = UILabel(frame:frame)
        self.nameLabel.text = "\(person.Name), \(person.Age)"
        self.informationView .addSubview(self.nameLabel)
    }
    func constructCameraImageLabelView() -> Void {
        var rightPadding:CGFloat = 10.0
        let image:UIImage = UIImage(named:"camera")!
        self.carmeraImageLabelView = buildImageLabelViewLeftOf(x: self.informationView.bounds.width, image:image, text:person.NumberOfPhotos.stringValue)
        self.informationView.addSubview(self.carmeraImageLabelView)
    }
    
    func constructInterestsImageLabelView() -> Void {
        let image: UIImage = UIImage(named: "book")!
        self.interestsImageLabelView = self.buildImageLabelViewLeftOf(x: self.carmeraImageLabelView.frame.minX, image: image, text:person.NumberOfPhotos.stringValue)
        self.informationView.addSubview(self.interestsImageLabelView)
    }
    
    func constructFriendsImageLabelView() -> Void {
        let image:UIImage = UIImage(named:"group")!
        
        self.friendsImageLabelView = buildImageLabelViewLeftOf(x: self.interestsImageLabelView.frame.minX, image:image, text:"No Friends")
        
        self.informationView.addSubview(self.friendsImageLabelView)
    }
    
    func buildImageLabelViewLeftOf(x:CGFloat, image:UIImage, text:String) -> ImagelabelView{
        let frame:CGRect = CGRect(x:x-ChoosePersonViewImageLabelWidth, y: 0,
            width: ChoosePersonViewImageLabelWidth,
            height: self.informationView.bounds.height)
        let view:ImagelabelView = ImagelabelView(frame:frame, image:image, text:text)
        
        view.autoresizingMask = .flexibleLeftMargin //UIViewAutoresizing.FlexibleLeftMargin
        
        return view
    }
}
