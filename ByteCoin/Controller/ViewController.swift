
import UIKit

class ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate, CoinManagerDelegate {
  


    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var bitcoinLabel: UILabel!
    var selected: String = ""
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        bitcoinLabel.text = coinManager.currencyArray[0]
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
        
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selected = coinManager.currencyArray[ currencyPicker.selectedRow(inComponent: 0)]
        coinManager.getCoinPrice(for: self.selected)
    }
    
    func didUpdateCoin(_ coinManager: CoinManager, coin: Coin){
        DispatchQueue.main.async {
            self.currencyLabel.text = String(format: "%.2f", coin.rate)
            self.bitcoinLabel.text = self.selected
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
    
    

}

