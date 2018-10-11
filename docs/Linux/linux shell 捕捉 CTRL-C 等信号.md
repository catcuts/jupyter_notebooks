

> [参考](https://stackpointer.io/script/how-to-catch-ctrl-c-in-shell-script/248/)

　　[信号列表](../%5B%20NTE%20%5D%20Notebooks_fragment/linux%20signal%20信号列表.ipynb)

　　示例：

```shell
#!/bin/sh
 
# this function is called when Ctrl-C is sent
function trap_ctrlc ()
{
    # perform cleanup here
    echo "Ctrl-C caught...performing clean up"
 
    echo "Doing cleanup"
 
    # exit shell script with error code 2
    # if omitted, shell script will continue execution
    exit 2
}
 
# initialise trap to call trap_ctrlc function
# when signal 2 (SIGINT) is received
trap "trap_ctrlc" 2
 
# your script goes here
echo "going to sleep"
sleep 1000
echo "end of sleep"
```
