//
//  Log.swift
//  BoilerPlate
//
//  Created by dhanasekaran on 18/08/21.
//

import Foundation

public class Log : NSObject {
    
    public static let shared = Log()
    private lazy var gmtDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "GMT")!
        formatter.dateFormat = "dd-MM-yyyy EEEE hh:mm:ss a"
        formatter.locale = Locale(identifier: "en")
        formatter.isLenient = true
        return formatter
    }()
    private override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let endIdentifier = "\n\n\n==================================\n\nTIME"
    
    public lazy var logs: [String] = {
        do{
            let data = try Data(contentsOf: Log.shared.pathURL)
            let logString = try String(contentsOf: Log.shared.pathURL, encoding: .utf8)
            let reversedLogs = logString.components(separatedBy: Log.shared.endIdentifier).map({ "\(Log.shared.endIdentifier)\($0)" })
            return reversedLogs.reversed()
        }
        catch{
            Swift.print(error)
            return [""]
        }
    }()
    
    public lazy var pathURL: URL = {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        let path = documentDirectory! + "/logs.txt"
        let pathURL = URL.init(fileURLWithPath: path)
        return pathURL
    }()
    
    static func debugLog(_ object:Any, line: Int = #line) {
        let time = shared.gmtDateFormatter.string(from: Date())
        
        let log = "\n\n\n==================================\n\nTIME : \(time)\n\(object)\n"
        Log.shared.store(log: log)
    }
    
    public func log(_ object: Any) {
        Log.debugLog(object)
    }
    
    public static func logRequestAndResponse(urlRequest: URLRequest, responseData: Data?, urlResponse: URLResponse?, requestTime: Date, responseTime: Date) {
        print("stored")
        var responseString = ""
        if let data = responseData {
            responseString = String(data: data, encoding: .utf8) ?? ""
        }
        var statusCode = ""
        if let urlHTTPResponse = urlResponse as? HTTPURLResponse {
            statusCode = "\(urlHTTPResponse.statusCode)"
        }
        Log.debugLog("STATUS CODE : " + statusCode + "\n" + "REQUEST TIME : \(shared.gmtDateFormatter.string(from: requestTime))" + "\n" + "RESPONSE TIME : \(shared.gmtDateFormatter.string(from: responseTime))" + "\n" + "API TIME : \(responseTime.timeIntervalSince(requestTime))" + urlRequest.messageForLog() + "\n" + "RESPONSE : " + responseString)
    }
    
    func store(log : String){
        DispatchQueue.global().async {
            self.logs.append(log)
            if self.logs.count > 20 {
                self.logs = self.logs.suffix(20)
            }
            let reversedLogs: [String] = self.logs.reversed()
            let logsString = reversedLogs.joined()
            guard let data = logsString.data(using: String.Encoding.utf8) else {
                return
            }
            if FileManager.default.fileExists(atPath: Log.shared.pathURL.path) {
                if let fileHandle = FileHandle.init(forUpdatingAtPath: Log.shared.pathURL.path){
                    fileHandle.truncateFile(atOffset: 0)
                    fileHandle.closeFile()
                }
                if let fileHandle = FileHandle.init(forWritingAtPath: Log.shared.pathURL.path) {
                    fileHandle.write(data)
                    fileHandle.closeFile()
                }
            } else {
                do {
                    try data.write(to: Log.shared.pathURL)
                }
                catch {
                    Swift.print(error)
                }
            }
        }
    }
    
    public func clearLogs() {
        logs = [""]
        if let fileHandle = FileHandle.init(forUpdatingAtPath: Log.shared.pathURL.path){
            fileHandle.truncateFile(atOffset: 0)
            fileHandle.closeFile()
        }
    }
}

extension URLRequest
{
    func messageForLog() -> String {
        let URL = url?.absoluteString ?? ""
        var bodyMessage = ""
        var header = ""
        let httpMethod = self.httpMethod ?? ""
        if let body = self.httpBody, let bodyString = String(data: body, encoding: .utf8)?.removingPercentEncoding {
            bodyMessage = bodyString
        }
        if let headerFields = self.allHTTPHeaderFields {
            for (key,value) in headerFields {
                if key.contains("Authorization") || key.contains("X-Auth-Key") || key.contains("X-Refresh-Key") {
                    continue
                }
                header += "\(key): \(value) "
            }
        }
        
        let urlString = "\nHTTP METHOD : \(httpMethod)\nURL : \(URL)\nBODY : \(bodyMessage)\nHEADER : \(header)"
        return urlString
    }
}
