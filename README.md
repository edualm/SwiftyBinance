# SwiftyBinance

Binance API for usage from within Swift.

For now, only two API methods are implemented, which are used in the example.

## Example Usage

```
let apiKey = "<Your API Key>"
let secretKey = "<Your Secret Key>"

let connection = BinanceConnection(apiKey: apiKey, secretKey: secretKey)

connection.getMinerList { result in
    switch result {
    case .success(let workers):
        workers.forEach {
            let hashRateMHs = $0.hashRate / 1_000_000
            
            print("[\($0.workerName)] Hash Rate: \(hashRateMHs) MH/s")
        }
        
    case .failure(let error):
        print(error)
    }
}

connection.getEarnings { result in
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    
    switch result {
    case .success(let profits):
        profits.forEach {
            let date = Date(timeIntervalSince1970: TimeInterval($0.time / 1_000))
            let dateStr = dateFormatter.string(from: date)
            
            print("[\(dateStr)] \($0.profitAmount) \($0.coinName)")
        }
        
    case .failure(let error):
        print(error)
    }
}
```
