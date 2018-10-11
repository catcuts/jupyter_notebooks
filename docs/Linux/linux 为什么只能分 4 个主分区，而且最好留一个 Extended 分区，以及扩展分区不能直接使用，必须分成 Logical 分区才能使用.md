

　　一般的分区表（除了 GPT）只能存储 4 个主分区的地址，多了找不到。

　　留一个扩展分区，就可以在扩展分区内存储更多的分区地址，从而扩展成逻辑分区。
  
　　所以扩展分区如果没有扩展成逻辑分区，就只是存储分区表，不能直接使用。
  
　　[参考](https://www.quora.com/Why-does-not-Linux-let-create-more-than-4-partition)
  
