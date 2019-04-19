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

generated code:
```asm
section .text
  global _start
_start:
  call 4
  push rbp
  mov rbp, rsp
  mov rsp, [rsp+8]
  sub rsp, 5
  mov [rbp+8], rsp
  add rsp, 48
  times 18 db 0x90
  push word 0x9005
  push word 0x0fff
  push word 0x3148
  push word 0x3cb0
  push word 0x050f
  push word 0x10b2
  push word 0xc7ff
  push word 0x48e6
  push word 0x8948
  push word 0x5665
  push word 0x6874
  push word 0x206b
  push word 0x6361
  push word 0x68be
  push word 0x4856
  push word 0x0a74
  push word 0x656e
  push word 0x616c
  push word 0x7020
  push word 0xbe48
  push word 0x01b0
  push word 0xe7f7
  push word 0x48ff
  push word 0x3148
  mov rsp, rbp
  pop rbp
  ret
```
