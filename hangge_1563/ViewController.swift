//
//  ViewController.swift
//  hangge_1563
//
//  Created by hangge on 2017/2/20.
//  Copyright © 2017年 hangge. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //获取网站文件夹路径
        let websitePath = Bundle.main.path(forResource: "Website", ofType: nil)
        
        let webServer = GCDWebServer()
        
        //先设置个默认的handler处理静态文件（比如css、js、图片等）
        webServer?.addGETHandler(forBasePath: "/", directoryPath: websitePath,
                                 indexFilename: nil, cacheAge: 3600,
                                 allowRangeRequests: true)
        
        //再覆盖个新的handler处理动态页面（html页面）
        webServer?.addHandler(forMethod: "GET", pathRegex: "^/.*\\.html$",
                              request: GCDWebServerRequest.self,
                              processBlock: { (request) -> GCDWebServerResponse? in
            let var_li = "<li data='1.png'>图片1</li>" +
                         "<li data='2.png'>图片2</li>" +
                         "<li data='3.png'>图片3</li>" +
                         "<li data='4.png'>图片4</li>"
            let variables = [
                "var_title": "点击切换图片",
                "var_li": var_li,
            ]
            let htmlTemplate = websitePath?.appending(request!.path)
            return GCDWebServerDataResponse(htmlTemplate: htmlTemplate,
                                            variables: variables)
        })
        
        //HTTP请求重定向（/从定向到/index.html）
        webServer?.addHandler(forMethod: "GET", path: "/",
                              request: GCDWebServerRequest.self,
                              processBlock: { (request) -> GCDWebServerResponse? in
                    let url = URL(string: "index.html", relativeTo: request?.url)
                    return GCDWebServerResponse.init(redirect: url, permanent: false)
        })
        
        //服务器启动
        webServer?.start(withPort: 8080, bonjourName: "GCD Web Server")
        print("服务启动成功，使用你的浏览器访问：\(webServer?.serverURL)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
