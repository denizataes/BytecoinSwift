
import Foundation

protocol CoinManagerDelegate{
    func didUpdateCoin(_ coinManager: CoinManager, coin: Coin)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/"
    let apiKey = "729A4687-6281-47EA-9CB9-203F88E574BD"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?
    
    func getCoinPrice(for currency:String)
    {
        var url = URL(string: baseURL + currency + "?apikey=" + apiKey)
        if let completedURL = url {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: completedURL){ (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let res = self.parseJSON(safeData){
                        self.delegate?.didUpdateCoin(self, coin: res)
                    }
                    
                }
            }
            task.resume()
            
        }
        
    }
    func parseJSON(_ coinData: Data) -> Coin?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(Coin.self, from: coinData)
            
            let time = decodedData.time
            let assetIdBase = decodedData.asset_id_base
            let assetIdQuote = decodedData.asset_id_quote
            let rate = decodedData.rate
            
            return Coin(time: time, asset_id_base: assetIdBase, asset_id_quote: assetIdQuote, rate: rate)
            
        }
        catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
 
    
}
