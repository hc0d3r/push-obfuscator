# push-obfuscator

A simple shellcode obfuscator, unhappily it's very easy to decode. You should write this to a w|x memory region

## example

```
$ perl push-obfuscator.pl <<SC > test.asm
48 31 ff            
48 f7 e7            
b0 01               
48 be 20 70 6c 61 6e
65 74 0a 
56                  
48 be 68 61 63 6b 20
74 68 65 
56                  
48 89 e6            
48 ff c7            
b2 10               
0f 05               
b0 3c               
48 31 ff            
0f 05               
SC
$ nasm -f elf64 test.asm
$ ld -o test test.o --omagic
$ ./test
hack the planet
```


