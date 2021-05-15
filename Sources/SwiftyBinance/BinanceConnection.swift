import CryptoKit
import Foundation

public class BinanceConnection {
    
    public enum BinanceError: Error {
        case invalidResponse
    }
    
    public typealias Worker = BinanceResponse.MinerListResponse.Data.Worker
    public typealias AccountProfits = BinanceResponse.EarningsListResponse.Data.AccountProfits
    
    static private let Endpoint = "https://api.binance.com"
    
    let apiKey: String
    let secretKey: String
    
    public init(apiKey: String, secretKey: String) {
        self.apiKey = apiKey
        self.secretKey = secretKey
    }
    
    private func payloadWithTimestampAndSignature(_ input: String) -> String {
        let payload = "\(input)&timestamp=\(Int64(Date().timeIntervalSince1970 * 1000))"
        let signature = signPayload(payload, secret: secretKey)
        
        return "\(payload)&signature=\(signature)"
    }
    
    private func performCall<T: Decodable>(withPath path: String, queryString: String, completionHandler: @escaping (Result<T, BinanceConnection.BinanceError>) -> ()) {
        let payload = payloadWithTimestampAndSignature(queryString)
        
        let url = URL(string: "\(BinanceConnection.Endpoint)\(path)?\(payload)")!
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.addValue(apiKey, forHTTPHeaderField: "X-MBX-APIKEY")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil, let response = response as? HTTPURLResponse else {
                completionHandler(.failure(.invalidResponse))
                
                return
            }
            
            if response.statusCode == 403 || response.statusCode == 500 {
                completionHandler(.failure(.invalidResponse))
                
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.invalidResponse))
                
                return
            }
            
            guard let parsedResponse = try? JSONDecoder().decode(T.self, from: data) else {
                completionHandler(.failure(.invalidResponse))
                
                return
            }
            
            completionHandler(.success(parsedResponse))
        }
        
        task.resume()
    }
    
    public func getMinerList(completionHandler: @escaping (Result<[Worker], BinanceConnection.BinanceError>) -> ()) {
        performCall(withPath: "/sapi/v1/mining/worker/list", queryString: "algo=ethash&userName=trocopasso") { (result: Result<BinanceResponse.MinerListResponse, BinanceConnection.BinanceError>) in
            switch result {
            case .success(let response):
                completionHandler(.success(response.data.workerDatas))
                
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    public func getEarnings(completionHandler: @escaping (Result<[AccountProfits], BinanceConnection.BinanceError>) -> ()) {
        performCall(withPath: "/sapi/v1/mining/payment/list", queryString: "algo=ethash&userName=trocopasso") { (result: Result<BinanceResponse.EarningsListResponse, BinanceConnection.BinanceError>) in
            switch result {
            case .success(let response):
                completionHandler(.success(response.data.accountProfits))
                
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}

private func signPayload(_ payload: String, secret: String) -> String {
    let key = SymmetricKey(data: secret.data(using: .utf8)!)
    
    let signature = HMAC<SHA256>.authenticationCode(for: payload.data(using: .utf8)!, using: key)
    
    return Data(signature).map { String(format: "%02hhx", $0) }.joined()
}
