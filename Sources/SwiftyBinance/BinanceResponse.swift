import Foundation

public enum BinanceResponse {
    
    public struct MinerListResponse: Codable {
        
        public struct Data: Codable {
            
            public struct Worker: Codable {
                
                public enum Status: Int, Codable {
                    case valid = 1
                    case invalid = 2
                    case noLongerValid = 3
                }
                
                public let workerId: String
                public let workerName: String
                public let status: Status
                public let hashRate: Double
                public let dayHashRate: Double
                public let rejectRate: Double
                public let lastShareTime: Double
            }
            
            public let workerDatas: [Worker]
        }
        
        public let code: Int
        public let msg: String
        public let data: Data
    }

    public struct EarningsListResponse: Codable {
        
        public struct Data: Codable {
            
            public struct AccountProfits: Codable {
                
                public enum ProfitType: Int, Codable {
                    case miningWallet = 0
                    case miningAddress = 5
                    case poolSavings = 7
                    case transfered = 8
                    case incomeTransfer = 31
                    case hashrateResaleMiningWallet = 32
                    case hashrateResalePoolSavings = 33
                }
                
                public enum Status: Int, Codable {
                    case unpaid = 0
                    case paying = 1
                    case paid = 2
                }
                
                public let time: Int
                public let type: ProfitType
                public let hashTransfer: Double?
                public let transferAmount: Double?
                public let dayHashRate: Double
                public let profitAmount: Double
                public let coinName: String
                public let status: Status
            }
            
            public let accountProfits: [AccountProfits]
        }
        
        public let code: Int
        public let msg: String
        public let data: Data
    }
}
