
### 一、核心模块划分（`server/core/*`）

　　主要模块放在 `server/core/` 目录，包括：

1. **基类**
    - 基类（`vigmodule.js`）  
<br>
2. **主体**
    - 设备（`devices/*`）
    - 服务（`services/*`）
        - web 服务（`services/web`）
    - 应用（`app/*`）
    - 平台（`platform/*`）  
<br>
3. **辅助**
    - 常数（`const.js`）
    - 缓存（`cache.js`）
    - 日志（`logger.js`）
    - 国际化（`i18n.js`）  
<br>
4. **通信**
    - 总线（`eventbus/*`）
    - 协议（`protocols/*`）  
<br>
5. **存储** 
    - 数据（`storage.js`）
    - 资源（`resource.js`）
    - 事务（`transactions.js`）  
<br>
6. **接口**
    - API（`api/*`）

### 二、周边模块划分（`server/!core/*`）

　　周边模块放在 `server/` 目录（除了 `core/`），包括：

1. **实例**
    - 设备（`devices/*`）
    - 服务（`services/*`）
    - 应用（`apps/*`）  
<br>
2. **辅助**
    - 配置（`settings/*`）
    - 命令（`command/*`）
    - 模板（`templates/*`）
    - 文档（`docsites/*`）  
<br>
3. **工具**
    - 工具（`utils/*`）  
<br>
4. **存储** 
    - 数据（`data/*`） 
    - 资源（`www/*`）  
<br>
5. **测试**
    - 测试（`test/*`）  
<br>
6. **其他**
    - 启动（`start.js`）
    - 入口（`server.js`）
    - 调试（`shell.js`）

### 三、一个服务（service）的启动过程

#### 1. 启动服务器（server）
`start.js`：

```js
// 前略
const vigserver= require("./server")
vigserver.start()
```

#### 2. 装载服务 -> 启动服务
`server/server.js`：

```js
class VIServer {
// 前略
    start() {
        // 按顺序启动
        async.series({
            init: async () => {
                // 略
            },
            // 加载硬件平台实例
            platform: async () => {
                // 略
            },
            // 加载存储管理对象，负责数据库读取
            loadStorage: async () => {
                // 略
            },// 加载设备类型
            //获取网关设备本身实例
            getHost: async () => {
                // 略
            },
            loadDeviceTypes: async () => {
                // 略
                this.storage = new VIGStorageManager()
                global.VIGStorage = this.storage  // 注意这里把 VIGStorage 设为了全局对象，所以后面在获取 module 配置信息时可以直接引用
                // 略
            },
            // 创建事件总线,用来内部模块之间的通讯
            createEventbus: async () => {
                // 略
            },
            // 启动服务引擎
            loadServices: async () => {
                this.serviceManager = new VIGServiceManager(this)
                global.VIGServices = this.serviceManager//在全局注入一个getServices方法，用来获取服务实例引用
                
                await this.serviceManager.load()  // <- 装载服务实例
                // 装载逻辑：（代码详见 VIGModuleManager 类，serviceManager 继承于此）
                // 1. getModules()：从 storage 中获取所有启用的 module（service、app、devicetype的统称）的配置信息 moduleSettings
                // 2. loadModule(moduleSettings)
                
                logger.debug(_("ServiceManager is successfully loaded : {list}").params(this.serviceManager.getModuleList()))
                return true
            },
            //启动用所有应用
            loadApps: async () => {
                // 略
            },
            //启动服务
            startServices: async () => {
                await this.serviceManager.start()  // <- 启动服务实例
                // 启动逻辑：
                // 1. 对所有装载的 module 应用 _startModule(module)
                // 2. _startModule 内部对传入的 module 应用 _start()
                // 3. _start() 内部：（详见 VIGModule 类）
                //   3.1. 连接总线、调用子类 start()（见 3. 启动服务实例）、
                //   3.2. 更新相关状态、调用相关回调等
                // 中略
                return true
            },
            Ready: this.onReady.bind(this)
        }, (err, results) => {
            //汇总显示上述各个步骤的执行情况
            for (let key in results) {
                logger.debug("Step : " + key.ljust(36, ".") + (results[key] ? "OK" : "ERROR"))
            }
            if (err) {
                logger.error(_("Error when starting :{err}").params(err.stack))
            }
        })
    }
// 后略
}
```

#### 3. 启动服务实例（以 web 服务为例）
`services/web/service.js`：

```js
const ServiceBase = require("core/service/servicebase")
const HTTPServer = require("./httpserver")
const WebFramework = require("./webframework")

class WebService extends ServiceBase {  // 继承于服务基类（服务基类继承于 VIGModule）
    async start() {  // 并书写本服务实例的启动逻辑
        this.web = new WebFramework(this.attrs)  // 实例化一个 web 框架实例
        this.httpserver = new HTTPServer(this.web.express, this.attrs)  // 基于该 web 框架实例，创建一个 httpserver
        await this.httpserver.start()  // 启动该 httpserver
    }
    async stop() {
        await this.httpserver.close()
    }

}

module.exports = WebService
```

### 四、Web 服务的启动过程

1. 实例化一个 WebFramework
    - settings 来自 web 服务的 settings（services.yaml:web）
    - settings 包括：...
2. 初始化 \_init()
    - 实例化 express 并设置 模板引擎 和 视图选项
    - 实例化 带认证根路由 和 不带认证跟路由，并分别注册到 express
    - 注册框架级中间件（包括全局中间件和其他必要的中间件，如认证等，注意 pos=0 的注册到不带认证的跟路由下，pos=1 的注册到带认证的跟路由下）
    - 注册全局路由，包括：...
    - 注册模块网站，即各个应用的、各个服务的、各个设备的网站（\<moduleManager\>.registerWebsite，注册网站包括注册 模块路由 和 中间件）——分别由应用管理器、服务管理器、设备管理器获取并实例化及注册
    - ~~同时，模块在实例化时会注册相关的中间件、api资源、视图资源和静态资源等~~


3. 如：caller 应用的网站
    - 该 app 类继承自 appBase，appBase 继承自 VIGModule
    - appBase 定义了 getWebsite 方法
    - getWebsite 方法 实例化了 WebSite
    - 实例化 WebSite 时传入了：
        - 名称（用于显示）
        - url 前缀（用于注册路由，web框架调用的时候）
        - 中间件实例（用于注册中间件，实例化的时候）
        - api 资源（用于注册api资源，实例化的时候）
        - 视图资源（用于注册视图资源，实例化的时候）
        - 静态资源上下文路径（用于注册静态资源，实例化的时候）
    - WebSite 实例化 时会注册中间件、api资源、视图资源和静态资源
    - web框架在 注册模块网站 时会调用模块管理器的 registerWebsite 方法对该管理器管理下的各个模块对应的 website 实例注册其指定的路由
