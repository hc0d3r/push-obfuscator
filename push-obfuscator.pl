#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';

my (@sc, $len, $limit);

while(<STDIN>){
    push @sc, /([[:xdigit:]]{2})/g;
}

$len = scalar(@sc);

if($len == 0){
    exit;
} elsif($len%2){
    push @sc, "90";
    $len++;
}

say "section .text";
say "  global _start";
say "_start:";

# a way to get the rip
say "  call 4";

# save rbp in stack
say "  push rbp";

# save stack pointer
say "  mov rbp, rsp";

# now rsp has the address of push rbp, remember call 4
say "  mov rsp, [rsp+8]";

# -5 because 'call 4' has five byte
say "  sub rsp, 5";

# save the address to return after
say "  mov [rbp+8], rsp";

# 'alloc' space for instructions
say "  add rsp, $len";

# opcode len in bytes for previous instructions:
# 5+1+3+5+4+4+(4+$pad)
$limit = 5+1+3+5+4+4+4;

# if len is bigger than 127 then the opcode
# for 'add rsp, xxx' are increase in three bytes
if($len > 127){
    $limit += 3;
}

# write nops to prevent push instructions
# overwrite the push instructions, õ.õ
if($len > $limit+4){
    say "  times ".($len-($limit+4))." db 0x90";
}

# write all the shit
for(my $i=$len; $i>0; $i-=2){
    say "  push word 0x". lc($sc[$i-1]). lc($sc[$i-2]);
}

# restore stack pointer
say "  mov rsp, rbp";

# restore rbp
say "  pop rbp";

# jump to 'call 4', now overwrited with shellcode
say "  ret";
