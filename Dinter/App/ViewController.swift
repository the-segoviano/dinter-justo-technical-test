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
        self.view.backgroundColor = UIColor.mercury
        
        fetchInitialRandomPersons()
        
    }
    
    
    private func fetchInitialRandomPersons(){
        RequestManager.fetchRandomPerson(reference: self, withNumber: 10) { [weak self] result in
            guard let reference = self else {
                return
            }
            switch result {
            case .success(let personsResponse):
                DispatchQueue.main.async {
                    
                    reference.people.append(contentsOf: personsResponse.results)
                    if reference.people.count > 0 {
                        reference.setupTinderView()
                    }
                    
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    Alert.showErrorRequestAlert(on: reference,
                                                withMessage: error.localizedDescription)
                }
            }
        }
    } // [END] fetchInitialRandomPersons
    
    
    private func fetchRandomPerson(){
        RequestManager.fetchRandomPerson(reference: self) { [weak self] result in
            guard let reference = self else {
                return
            }
            switch result {
            case .success(let personResponse):
                DispatchQueue.main.async {
                    
                    if let newPerson = personResponse.results.first {
                        reference.people.append(newPerson)
                    }
                    
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    Alert.showErrorRequestAlert(on: reference,
                                                withMessage: error.localizedDescription)
                }
            }
        }
    } // [END] fetchRandomPerson
    
    
    private func setupTinderView(){
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
    }
    

    // MARK: - MDCSwipeToChoose
    
    // var people:[Person] = []
    var people:[Persona] = [Persona]()
    let ChoosePersonButtonHorizontalPadding:CGFloat = 80.0
    let ChoosePersonButtonVerticalPadding:CGFloat = 20.0
    var currentPerson: Persona!
    var frontCardView: ChoosePersonView!
    var backCardView: ChoosePersonView!

}

extension ViewController: MDCSwipeToChooseDelegate {
    
    func suportedInterfaceOrientations() -> UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.portrait
    }
    
    
    // This is called when a user didn't fully swipe left or right.
    func viewDidCancelSwipe(_ view: UIView) -> Void {
        // print("You couldn't decide on \(self.currentPerson.name.first)");
    }
    
    // This is called then a user swipes the view fully left or right.
    func view(_ view: UIView, wasChosenWith wasChosenWithDirection: MDCSwipeDirection) -> Void {
        
        // MDCSwipeToChooseView shows "NOPE" on swipes to the left,
        // and "LIKED" on swipes to the right.
        if(wasChosenWithDirection == MDCSwipeDirection.left) {
            // print("You noped: \(self.currentPerson.name.first)")
        }
        else{
            // print("You liked: \(self.currentPerson.name.first)")
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
        
        self.fetchRandomPerson()
        
    }
    func setMyFrontCardView(frontCardView:ChoosePersonView) -> Void{
        
        // Keep track of the person currently being chosen.
        // Quick and dirty, just for the purposes of this sample app.
        self.frontCardView = frontCardView
        self.currentPerson = frontCardView.person
    }
    
    /*func defaultPeople() -> [Person] {
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
    }*/
    
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
        
        let personView:ChoosePersonView = ChoosePersonView(frame: frame,
                                                           person: self.people[0],
                                                           options: options)
        self.people.remove(at: 0)
        return personView
        
    }
    
    func frontCardViewFrame() -> CGRect {
        let horizontalPadding:CGFloat = 20.0
        let topPadding:CGFloat = 80.0 // 60
        let bottomPadding:CGFloat = 260.0 // 200
        
        return CGRect(x: horizontalPadding, y: topPadding,
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
    
    
    func constructNopeButton() -> Void {
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
        button.addTarget(self, action: #selector(likeFrontCardView), for: .touchUpInside)
        
        self.view.addSubview(button)
    }
    
    
    @objc func nopeFrontCardView() -> Void {
        self.frontCardView.mdc_swipe(MDCSwipeDirection.left)
    }
    
    
    @objc func likeFrontCardView() -> Void {
        self.frontCardView.mdc_swipe(MDCSwipeDirection.right)
    }
    
}




class ImagelabelView: UIView{
    var imageView: UIImageView!
    var label: UILabel!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        imageView = UIImageView()
        label = UILabel()
        label.font = CustomGothamRoundedFont.getLightFont()
    }

    init(frame: CGRect, image: UIImage, text: String)
    {
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
        label.textAlignment = .center
        
        addSubview(label)
        
    }
}


class ChoosePersonView: MDCSwipeToChooseView {
    
    let ChoosePersonViewImageLabelWidth:CGFloat = 60.0;
    var person: Persona!
    var informationView: UIView!
    var nameLabel: UILabel!
    var carmeraImageLabelView:ImagelabelView!
    var interestsImageLabelView: ImagelabelView!
    var friendsImageLabelView: ImagelabelView!
    
    init(frame: CGRect, person: Persona, options: MDCSwipeToChooseViewOptions) {
        
        super.init(frame: frame, options: options)
        self.person = person
        
        if let image = person.picture.large {
            self.imageView?.setImageFor(url: URL(string: image)!) { image in
                self.imageView?.image = image
                self.setNeedsLayout()
            }
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
        self.nameLabel.font = CustomGothamRoundedFont.getBoldFont()
        
        if let firstName = person.name.first {
            self.nameLabel.text = "\(firstName), \(person.dob.age)"
        }
        
        self.informationView.addSubview(self.nameLabel)
    }
    func constructCameraImageLabelView() -> Void {
        //var rightPadding:CGFloat = 10.0
        let image:UIImage = UIImage(named:"camera")!
        
        let randomInt = Int.random(in: 1..<999)
        self.carmeraImageLabelView = buildImageLabelViewLeftOf(x: self.informationView.bounds.width,
                                                               image:image,
                                                               text: "\(randomInt)")
        self.informationView.addSubview(self.carmeraImageLabelView)
    }
    
    func constructInterestsImageLabelView() -> Void {
        let image: UIImage = UIImage(named: "book")!
        // person.NumberOfPhotos.stringValue
        let randomInt = Int.random(in: 1..<9)
        self.interestsImageLabelView = self.buildImageLabelViewLeftOf(x: self.carmeraImageLabelView.frame.minX,
                                                                      image: image,
                                                                      text: "\(randomInt)")
        self.informationView.addSubview(self.interestsImageLabelView)
    }
    
    func constructFriendsImageLabelView() -> Void {
        let image:UIImage = UIImage(named:"group")!
        let sentimentalSituation = ["Taken", "Married", "Single"]
        let status = sentimentalSituation.randomElement() ?? "No Situation"
        
        self.friendsImageLabelView = buildImageLabelViewLeftOf(x: self.interestsImageLabelView.frame.minX,
                                                               image:image,
                                                               text: status)
        
        self.informationView.addSubview(self.friendsImageLabelView)
    }
    
    func buildImageLabelViewLeftOf(x:CGFloat, image:UIImage, text:String) -> ImagelabelView{
        let frame:CGRect = CGRect(x:x-ChoosePersonViewImageLabelWidth,
                                  y: 0,
                                  width: ChoosePersonViewImageLabelWidth,
                                  height: self.informationView.bounds.height)
        let view:ImagelabelView = ImagelabelView(frame:frame, image:image, text:text)
        view.autoresizingMask = .flexibleLeftMargin //UIViewAutoresizing.FlexibleLeftMargin
        return view
    }
}
