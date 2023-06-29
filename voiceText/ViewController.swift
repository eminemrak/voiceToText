import UIKit
import AVFoundation
import Speech
import MobileCoreServices
import CoreData

class ViewController: UIViewController, AVAudioRecorderDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var projectName: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var sesDosyasıYukle: UIButton!
    @IBOutlet weak var uiTextView: UITextView!
    
    @IBOutlet weak var editButton: UIButton!
    
    var conversionStatus = false
    
    var mediaName = ""
    
    var text2 = ""
    

    
    var projectArray : [Document] = []
    
    
    
    var audioEngine: AVAudioEngine!
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "tr_TR"))
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        sesDosyasıYukle.setTitle("Yüklemek istediğiniz ses dosyasını seçin!", for: .normal)
        
       
        
        
        
        
        
        
        
        
        
        
        
        
        audioEngine = AVAudioEngine()
        
        AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
            if granted {
                // Mikrofon erişimi verildi
            } else {
                // Mikrofon erişimi reddedildi
            }
        }
    }
    
    
    @IBAction func SesDosyasıYukle(_ sender: Any) {
            
        
    
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeAudio)], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
        
    
        
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        
        projectName.layer.borderWidth = 1.0
        projectName.layer.borderColor = UIColor(named: "dark-brown-2")?.cgColor
        projectName.layer.cornerRadius = 20
        
        
        uiTextView.layer.borderWidth = 1.0
        uiTextView.layer.borderColor = UIColor(named: "dark-brown-2")?.cgColor
        
        uiTextView.layer.cornerRadius = 20
        
        sesDosyasıYukle.layer.borderWidth = 1.0
        sesDosyasıYukle.layer.borderColor = UIColor(named: "dark-brown-2")?.cgColor
        sesDosyasıYukle.layer.cornerRadius = 20
        
        
        
        //sesDosyasıYukle.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 14)
        //sesDosyasıYukle.setTitleColor(UIColor.black, for: .normal)
        sesDosyasıYukle.layer.cornerRadius = 20
        
        
        
        deleteButton.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 12)
        saveButton.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 12)
        editButton.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 12)
        
        deleteButton.setTitleColor(UIColor(named: "backgraund"), for: .normal)
        saveButton.setTitleColor(UIColor(named: "backgraund"), for: .normal)
        editButton.setTitleColor(UIColor(named: "backgraund"), for: .normal)
        
        
        deleteButton.layer.cornerRadius = 20
        saveButton.layer.cornerRadius = 20
        editButton.layer.cornerRadius = 20
        
        
        
      /*
       
       
       
        if text2 != "" {
            uiTextView.text = text2

        }
       */
        NotificationCenter.default.addObserver(self, selector: #selector(veriAktarildi(_:)), name: Notification.Name("VeriAktarildi"), object: nil)

        
        
  
    }
    
    @objc func veriAktarildi(_ notification: Notification) {
           if let veri = notification.userInfo?["veri"] as? String {
               // Veri işleme
               print("Alınan veri: \(veri)")
               uiTextView.text = veri
           }
        
       }
    
    
    func convertSpeechToText(url: URL) {
        
        conversionStatus = true
        

        // SFSpeechRecognizer örneği oluşturma
        let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "tr_TR")) // Tanıma dilini Türkçe olarak ayarladık
        
        // Ses dosyasını çözümlemek için SFSpeechURLRecognitionRequest örneği oluşturma
        let recognitionRequest = SFSpeechURLRecognitionRequest(url: url)
        
        recognizer?.recognitionTask(with: recognitionRequest) { [unowned self] (result, error) in
            if let error = error {
                print("Recognition Error: \(error)")
            } else if let result = result {
                
                //sil butonuna basıldığında çeviri durucak.
                if conversionStatus == true {
                    let recognizedText = result.bestTranscription.formattedString
                    
                    DispatchQueue.main.async {
                        
                        
                        self.uiTextView.text = recognizedText
                        
                        
                    }
                    
                    print(recognizedText)
                    
                }
            }
        }
    }
    
    
    @IBAction func deleteButton(_ sender: Any) {
        conversionStatus = false
        
        
        sesDosyasıYukle.setTitle("Yüklemek istediğiniz ses dosyasını seçin!", for: .normal)
        sesDosyasıYukle.isEnabled = true
        projectName.text = ""
        uiTextView.text = "Henüz ses dosyası seçmediniz."
        mediaName = ""
       
        
        audioEngine.stop()
        recognitionTask?.cancel()
        
        
        
        
        
        
  
        
        
    }
    
    
    
    @IBAction func saveButton(_ sender: Any) {
            
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newPainting = NSEntityDescription.insertNewObject(forEntityName: "Documents", into: context)
        
        newPainting.setValue(uiTextView.text, forKey: "documentContent")
        
        newPainting.setValue(projectName.text!, forKey:"name")
       
        newPainting.setValue(mediaName, forKey: "mediaName")
        newPainting.setValue(UUID(), forKey: "id")
        
        do {
            try context.save()
            print("success save")
        }catch{
            print("error save")
        }
        
        //ViewController arası iletişimi sağlar. "newData" mesajını gönderiyorum. diğer taraftada bu mesajı görürsen getData fonksiyonunu tekrar çalıştır komutunu vericem. bu sayede save butonu olduğunda diğer taraftaki tableView tekrar çalışacak ve yeni eklenen proje ismini de göstermiş olacak.
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newData"), object: nil)
        
       
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "vcToEditing" {
            let destinationVC = segue.destination as! editingVC
            destinationVC.textt = self.uiTextView.text
        }
    }
    
    @IBAction func editButton(_ sender: Any) {
        
        if conversionStatus == true {
            print("ses devam ediyor")
            showAlert(title: "Düzenleme Yapılamaz", message: "Ses dosyası henüz tamamlanmadı, düzenleme yapmak için tamamlanmasını beklemelisiniz", okTitle: "Anladım!")
        }
        /*
         
    
        if conversionStatus == false && uiTextView.text == "Henüz ses dosyası seçmediniz."{
            showAlert(title: "Düzenleme Yapılamaz", message: "Çeviri için ses dosyası seçmediniz. Lütfen ses dosyasını seçin!", okTitle: "Anladım!")

        }
         */
        else{
            
            performSegue(withIdentifier: "vcToEditing", sender: nil)
        }
    }
    
    
}

extension ViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedURL = urls.first else { return }
        convertSpeechToText(url: selectedURL)
        
        if selectedURL != nil {
            sesDosyasıYukle.setTitle("\(selectedURL.lastPathComponent)", for: .normal)
            sesDosyasıYukle.isEnabled = false
            
            
        }
        
        mediaName = selectedURL.lastPathComponent
        
        //Ses dosyası seçildikten sonra ses dosyası yükleme butonunda dosyanın ismi yazsın.
        
       
        

        
       
    }
    

    func showAlert(title: String, message: String, okTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okTitle, style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        let when = DispatchTime.now() + 0.6
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            alert.dismiss(animated: true, completion: nil)
        }
    }

}
