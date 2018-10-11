
`POST` 和 `PUT` 都可用于 创建 和 更新或覆盖 资源；PATCH 用于 更新局部 资源。

以 问答网站 为例：

`POST` 一个资源有如下可能：  
（√）`POST /api/questions` —— 创建一个资源  
（√）`POST /api/questions/existed_question` —— 更新一个已存在的资源  
（×）`POST /api/questions/new_question` —— 创建一个资源（错误的做法）  

`PUT` 一个资源有如下可能：  
（×）`PUT /api/questions` —— 创建一个资源（错误的做法）  
（√）`PUT /api/questions/existed_question` —— 覆盖一个已存在的资源（覆盖意味着，如果缺少字段，则原有字段会被删除）  
（√）`PUT /api/questions/new_question` —— 创建一个资源  

`PATCH` 一个资源有如下可能：  
（×）`PATCH /api/questions` —— 创建一个资源（错误的做法）  
（√）`PATCH /api/questions/existed_question` —— 更新一个已存在的资源  
（×）`PATCH /api/questions/new_question` —— 创建一个资源（错误的做法）  

所以可以看到：  
1. 对于创建资源，使用 `POST` 还是 `PUT`，取决于 URI 要设计成什么样子 以及 幂等性：
    - 从 URI 方面考虑：
        如果希望以 `/api/questions` 的方式创建一个资源，则应该使用 `POST`；  
        如果希望以 `/api/questions/new_question` 的方式创建一个资源，则应该使用 `PUT`。  
<br>        
    - 从 幂等性 方面考虑：  
        如果希望具备 幂等性 ，则应使用 `PUT`；  
        如果不考虑 幂等性 ，则可使用 `POST` 或 `PUT`。  
<br>
2. 对于更新资源，使用 `POST` 还是 `PUT`，取决于要以什么方式更新资源：  
    如果希望以更新已有字段的方式来更新资源——即请求数据体中不存在于资源中的字段将会被忽略——则应该使用 `POST`；  
    如果希望以覆盖的方式——即不论请求体的数据是什么一律覆盖原有的资源（原有资源中不存在于请求数据体中的字段将会被删除）——则应使用 `PUT`。  
<br>
3. 对于更新资源（`/api/questions/existed_question`），使用 PATCH 还是 `POST` 或 `PUT`，取决于 幂等性：  
    如果希望具备 幂等性 ，则应使用 `POST` 或 `PUT`（取决于第 2 条）；    
    如果不考虑 幂等性 ，则可使用 `PATCH` 或 `POST` 或 `PUT`。  
    
参考：
- [PUT vs. POST in REST](https://stackoverflow.com/questions/630453/put-vs-post-in-rest)
- [patch 和put的区别](https://blog.csdn.net/mysevenyear/article/details/80674080)
- [RESTFUL服务中POST/PUT/PATCH方法的区别](https://blog.csdn.net/iefreer/article/details/10414663)
- [区分PATCH与PUT、POST方法](https://blog.csdn.net/w1859367012/article/details/49422633)
- [What is the difference between PUT, POST and PATCH?](https://stackoverflow.com/questions/31089221/what-is-the-difference-between-put-post-and-patch)
