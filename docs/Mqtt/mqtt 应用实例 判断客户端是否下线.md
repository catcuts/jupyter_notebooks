
护士站主机如何渲染门口机在线/离线状态：通过对门口机状态变更的响应来实现。

具体是：

门口机上线应触发状态变更消息： /voerka/<domain>/groups/<门口机group>/$$status
（online=true）

            {
                "type"     : 3,
                "sid"      : 0,
                "sync"     : false,
                "from"     : <String:本机sn>,
                "to"       : "",
                "timestamp": <Long:timestamp>,
                "receipt"  : false,
                "flags"    : "",
                "token"    : <String:token>,
                "tid"      : "",
                "payload"  : {
                    "code"    : 1001,
                    "source"  : <同from>,
                    "level"   : 1,
                    "status": {
                        "online": true
                    }
                }
            }

门口机下线（或意外断线）应触发状态变更消息：到同一主题（online=false）

以上消息设置均为：retain=1, qos=2

如何在下线或断线自动触发状态变更消息？
http://www.eclipse.org/paho/files/jsdoc/Paho.MQTT.Client.html
网页内搜索“willMessage”然后跳转至：http://www.eclipse.org/paho/files/jsdoc/Paho.MQTT.Message.html 查看相关设置（retain、qos等）
