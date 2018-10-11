

> [参考 from stackoverflow](https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux)
>
> [参考 from wikipedia](https://zh.wikipedia.org/wiki/ANSI%E8%BD%AC%E4%B9%89%E5%BA%8F%E5%88%97)

　　示例：
  
```shell
Black="\033[0;30m"
Dark_Gray="\033[1;30m"
Red="\033[0;31m"
Light_Red="\033[1;31m"
Green="\033[0;32m"
Light_Green="\033[1;32m"
Brown_Orange="\033[0;33m"
Yellow="\033[1;33m"
Blue="\033[0;34m"
Light_Blue="\033[1;34m"
Purple="\033[0;35m"
Light_Purple="\033[1;35m"
Cyan="\033[0;36m"
Light_Cyan="\033[1;36m"
Light_Gray="\033[0;37m"
White="\033[1;37m"
NC='\033[0m' # No Color

# how to use ?
# source /path/to/this.sh
# then start using these color constants !

# an example
echo -e "${Light_Green}I${NC} ${Red}love${NC} ${Cyan}Stack${NC} ${Light_Purple}Overflow${NC}"
```


```sh
%%sh
Black="\033[0;30m"
Dark_Gray="\033[1;30m"
Light_Red="\033[0;31m"
Red="\033[1;31m"
Light_Green="\033[0;32m"
Green="\033[1;32m"
Brown_Orange="\033[0;33m"
Yellow="\033[1;33m"
Light_Blue="\033[0;34m"
Blue="\033[1;34m"
Light_Purple="\033[0;35m"
Purple="\033[1;35m"
Light_Cyan="\033[0;36m"
Cyan="\033[1;36m"
Light_Gray="\033[0;37m"
White="\033[1;37m"
NC='\033[0m' # No Color

# how to use ?
# source /path/to/this.sh
# then start using these color constants !

# an example
echo "${Green}I${NC} ${Red}love${NC} ${Cyan}Stack${NC} ${Purple}Overflow${NC}"
```

    [1;32mI[0m [1;31mlove[0m [1;36mStack[0m [1;35mOverflow[0m

