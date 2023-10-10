## ZQMusic

先git clone 将代码拉到本地，然后进入工程目录进行pod install进行pod安装，当然首先你的cocoapod环境需要先安装，然后就可以运行起来了，当然目前github上的代码并没有ignore  pod相关的代码，所以clone下来后直接build也应该可以跑起来


####整个项目依赖一些第三方组件

1. pod 'SnapKit', '5.0.0' #用来进行UI布局
2. pod 'MJRefresh', '3.7.5' #用来下来刷新，上啦加载更多
3. pod 'RxSwift', '6.2.0' # 响应式
4. pod 'RxCocoa', '6.2.0' # 响应式
5. pod 'CocoaLumberjack/Swift' # logger组件
6. pod 'Kingfisher', '7.6.1' #图片加载组件
7. pod 'RxDataSources' # 响应式
8. pod 'Moya/RxSwift' # HTTP请求
9. pod 'MBProgressHUD' #loading菊花
10. pod 'KMNavigationBarTransition' #页面跳转转场以及navigationbar管理相关的
11. pod "ESTabBarController-swift"  #tabbar管理相关的

12. debug情况下还多了一个LookinServer，用来查看UI的，方便UI调整


####整个项目分如下几个模块

1. Main
	
	Main是入口，包含了AppDelegate以及TabBarController相关
	整个框架如下
	
	```
		  tabbar
	page1, page2, page3
	```
				
	每个page由NavigationController包裹
	这样每个TabBar有自己的navigationbar，
	
2. BaseKit

	一些基础工具，包括HTTP请求封装，Logger打印工具封装，还有一些扩展

3. Modules

	各个模块代码，目前只有Home(搜索)，Favorites（收藏），Me（这个没内容）
	模块内的业务代码按照mvvm架构进行
4. Resources

	一些资源文件，如图片资源，多语言的Localizable.strings，以及后续可以放font资源，视频资源，或一些LottieFiles,
	或者svga等等

	目前多语言只支持english, chinese(Hong Kong)，Chinese（Simplified）

5. DB
	
	数据库相关，目前用的是coredata，当然也可以用realm数据库，目前只有Favorites一个表