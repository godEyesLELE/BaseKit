//
// Created by chen on 2020/4/14.
// Copyright (c) 2020 MBC. All rights reserved.
//

import Foundation
import HandyJSON
import RxAlamofire
import RxSwift
import UIKit

public enum CacheType {
    case CacheFirst
    case CacheOnly
    case NetFirst
    case NetOnly
}

open class BaseRepos {
    open func token() -> String? {
        nil
    }
    public required init() {
//         #if DEBUG
//            host = "http://150.129.193.16:1080/cmb-xt-api"
//           #else
//            host = "https://liuxi.mbcloud.com/cmb-xt-api"
//           #endif
        
        
        #if DEBUG
         host = "http://150.129.193.16:1080/liuxi-home-api"
        #else
         host = "https://liuxi.mbcloud.com/liuxi-home-api"
        #endif
    }

    public var host: String

    lazy var cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]

//    public func load<T: BaseRequest, B: HandyJSON>(_ interface: String, _ request: T) -> Observable<BaseResponse<B>> {
//        return loadSimple(interface, request)
//    }

    public func loadSimple<T: BaseRequest, B>(_ interface: String, _ request: T) -> Observable<BaseResponse<B>> {
        return doRequest(interface, request)
            .map {
                BaseResponse<B>.deserialize(from: $0 as? NSDictionary)!
            }
    }

    public func loadNetData<T: BaseRequest, M: BaseResponse<Any>>(_ interface: String, _ request: T) -> Observable<M> {
        return doRequest(interface, request)
            .map {
                M.deserialize(from: $0 as? NSDictionary)!
            }
    }

    public func loadWithCache<T: BaseRequest, B>(_ interface: String, _ request: T, cacheKey: String, _ cacheType: CacheType) -> Observable<BaseResponse<B>> {
        let ob = ReplaySubject<BaseResponse<B>>.create(bufferSize: 2)

        var cacheDic: Dictionary<String, Any>?

        if cacheType != .NetOnly {
            cacheDic = readCache(cacheKey: cacheKey)
            if cacheDic != nil {
                if cacheType == .CacheFirst || cacheType == .CacheOnly {
                    ob.onNext(BaseResponse<B>.deserialize(from: cacheDic!)! => { it in
                        it.fromCache = true
                    })
                }
            }
        }

        _ = doRequest(interface, request)
            .catchError { _ in
                Observable.just(["data": nil,
                                 "status": "400",
                                 "message": "系统繁忙，请稍后重试"])
            }
            .subscribe(onNext: {
                let dic = $0 as! Dictionary<String, Any>
                if (dic["status"] as? Int ?? 400) == 200 {
                    if cacheType != .NetOnly { self.saveCache(dic: dic, cacheKey: cacheKey) }
                    if cacheType != .CacheOnly || cacheDic == nil {
                        ob.onNext(BaseResponse<B>.deserialize(from: dic)!)
                    }
                } else {
                    if cacheType == .NetOnly || cacheDic == nil {
                        ob.onNext(BaseResponse<B>.deserialize(from: dic)!)
                    } else if cacheType == .NetFirst && cacheDic != nil {
                        ob.onNext(BaseResponse<B>.deserialize(from: cacheDic!)! => { it in
                            it.fromCache = true
                        })
                    }
                }
            })

        return ob
    }

    func doRequest(_ interface: String, _ request: BaseRequest) -> Observable<Any> {
        let url = interface.starts(with: "http") ? interface : "\(host)\(interface)"

        var urlReq = URLRequest(url: URL(string: url)!)
        urlReq.httpMethod = request.httpMethod
        urlReq.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if request.isDownload {
            urlReq.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        }
        urlReq.setValue("1", forHTTPHeaderField: "channel")
        #if DEBUG
        urlReq.timeoutInterval = 5
        #else
            urlReq.timeoutInterval = 20
        #endif
        if let token = token() {
            urlReq.addValue(token, forHTTPHeaderField: "Authorization")
        }

        let paramJson = request.toJSONString()!

        if request.httpMethod.caseInsensitiveCompare("get") != .orderedSame{
            urlReq.httpBody = paramJson.data(using: .utf8)
        }

        print("\n")
        debugPrint("接口: ")
        debugPrint(url)
        print("头部:")
        for (a, b) in urlReq.allHTTPHeaderFields ?? [:] {
            debugPrint(a, b)
        }
        debugPrint("参数: ")
        Log(paramJson)

        return requestData(urlReq)
            .map {
                self.handleResponse(res: $0.0, result: $0.1)
            }
    }

    public func handleResponse(res: HTTPURLResponse, result: Any) -> Any {
        let data = result as! Data

        var dic: Dictionary<String, Any?>

        do {
            dic = try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String, Any>
        } catch {
            dic = ["data": nil,
                   "status": 400,
                   "message": "系统繁忙，请稍后重试"]
        }

        print("请求结果处理:")
        if data.isEmpty { print("请求无响应") }
        else { Log(String(data: data, encoding: .utf8) ?? "") }

        switch res.statusCode {
        case 200 ... 299:
            return dic
        case 300 ... 399:
            return ["data": nil,
                    "status": dic["status"] ?? 300,
                    "message": dic["message"]]
        default:
            return ["data": nil,
                    "status": dic["status"] ?? 400,
                    "message": "系统繁忙，请稍后重试"]
        }
    }

    func saveCache(dic: Dictionary<String, Any>, cacheKey: String) {
        try? FileManager.default.removeItem(at: URL(fileURLWithPath: getCachePath(cacheKey: cacheKey)))
        try? JSONSerialization.data(withJSONObject: dic, options: []).write(to: URL(fileURLWithPath: getCachePath(cacheKey: cacheKey)))
    }

    func readCache(cacheKey: String) -> Dictionary<String, Any>? {
        if let data = NSData(contentsOfFile: cachePath + cacheKey) {
            return try? JSONSerialization.jsonObject(with: data as Data, options: []) as? Dictionary<String, Any>
        }
        return nil
    }

    func getCachePath(cacheKey: String) -> String {
        cachePath + cacheKey
    }
}
