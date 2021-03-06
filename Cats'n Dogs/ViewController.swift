import UIKit
import Alamofire
import SwiftyJSON
import AVFoundation

class ViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var imageMain: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var buttonMain: UIButton!
    @IBOutlet weak var buttonSecond: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //buttonMain.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        //buttonMain.backgroundColor = UIColor.blue
        buttonMain.layer.cornerRadius = 25.0
        buttonMain.tintColor = UIColor.blue
        buttonSecond.layer.cornerRadius = 25.0
        buttonSecond.tintColor = UIColor.blue
    }


    @IBAction func buttonPressed(_ sender: Any) {
        print("Button pressed")
        let vc = UIImagePickerController()
        //vc.sourceType = .camera
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
        answerLabel.text = "Getting Image..."
        buttonMain.isHidden = true
        buttonSecond.isHidden = true
    }
    
    
    
    @IBAction func secondPressed(_ sender: Any) {
        print("Button pressed")
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        //vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
        answerLabel.text = "Getting Image..."
        buttonMain.isHidden = true
        buttonSecond.isHidden = true
    }
    
    
    //
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("An error occured: no image found")
            return
            
        }

        // print out the image size as a test
        imageMain.image = image
        print(image.size)
        answerLabel.text = "Checking..."
        let imageJPG = image.jpegData(compressionQuality: 0.0034)
        processFile(image:imageJPG!)
        //buttonMain.isHidden = false
        //buttonSecond.isHidden = false
        
    }
    
    func say(string: String) {
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }

    
    func processFile(image: Data) {
        let imageB64 = Data(image).base64EncodedData()
        //let uploadURL = "https://3h6ys7t373.execute-api.us-east-1.amazonaws.com/Predict/03378121-5f5b-4e24-8b5b-7a029003f2a4"
        //let uploadURL = "https://svexr6i4fi.execute-api.us-east-1.amazonaws.com/Predict/93396303-c75a-49d0-9736-c540ca073768"
        //let uploadURL = "https://d24l1ztb4d.execute-api.us-east-1.amazonaws.com/Predict/ccb9225e-9e27-464d-8720-18577535197f"
        let uploadURL = "https://d24l1ztb4d.execute-api.us-east-1.amazonaws.com/Predict/31f0d9d8-b573-4aaa-80d4-a56f2d785982"
        
        
        AF.upload(imageB64, to: uploadURL).responseJSON { response in
            
            debugPrint(response)
            switch response.result {
               case .success(let responseJsonStr):
                   print("\n\n Success value and JSON: \(responseJsonStr)")
                   let myJson = JSON(responseJsonStr)
                   let predictedValue = myJson["predicted_label"].string
                   print("Saw predicted value \(String(describing: predictedValue))")
                   let predictionMessage = "Animal Name: " + predictedValue!
                   self.answerLabel.text=predictionMessage
                self.say(string: predictionMessage)

               case .failure(let error):
                   print("\n\n Request failed with error: \(error)")
              

               }
            self.buttonMain.isHidden = false
            self.buttonSecond.isHidden = false
            
        }
        
    }

    
    
}

