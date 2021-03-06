#!/bin/sed -f

# Скрипт вычисляет наибольший общий делитель
# Ввод:  два натуральных десятичных числа, разделенные пробелом
# Вывод: собственно наибольший общий делитель

# проверка корректности ввода

/^[0-9]* [0-9]*$/!{s/.*/Bad input/;q;}
/^0 /{s/.*/Bad input/;p;d;};/ 0$/{s/.*/Bad input/;p;d;}

# удаление ведущих нулей
s/^0*\([0-9]*\) 0*\([0-9]*\)/\1 \2/;
# несколько частных случаев
/^\([^ ]*\) \1$/ {s/ .*//;p;d;}
/^[^ ]* 1$/ {s/.*/1/;p;d;}
/^1 / {s/.*/1/;p;d;}
# преобразование чисел из десятичного представления в двоичное.
s/$/ S:label1:/; b function_dec2bin; :label1
s/^\([^ ]*\) \([^ ]*\) /\2 \1 /;s/S:/S:label2:/; b function_dec2bin; :label2

s/S/K S/

t B1_cycle; : B1_cycle
s/\([^ ]*\)0 \([^ ]*\)0 K/\1 \2 K0/; t B1_cycle;
s/^\([^ ]*\)10* \([^ ]*\)10* /\11 \21 \11 \21 /;

s/S:/S:label3:/;b function_bcom; :label3
/^B/ {s/B //;b THE_END;}
s/^C \([^ ]*\) \([^ ]*\) /\2 \1 /; s/^A //;
s/^\([^ ]*\) \([^ ]*\) /\1 \2 \2 /;
s/S:/S:label4:/; b function_bsub; :label4
/^1 / b THE_END
/^\([^ ]*\) \1 / b THE_END
t B1_cycle

: THE_END
s/^\([^ ]*\) [^ ]* K\(0*\) .*/\1\2 /
s/$/S:label5:/;b function_bin2dec; :label5;
s/ .*//;
p;d;

: function_badd
# Функция двоичного сложения
s/^[01]* [01]*/& T A K0 /;
:f_badd_begin
/^ [01]/s/^/0/;/^[01]*[01]  /s/  / 0 /;/^  /b f_badd_end;
/^[01]*1 /s/T/Ta/;
/^[01]* [01]*1 /s/T/Ta/;
/K1 /s/T/Ta/;
s/^\([01]*\). \([01]*\). /\1 \2 /;
/T /{s/A/A0/;s/K./K0/;};
/Ta /{s/A/A1/;s/K./K0/;};
/Taa /{s/A/A0/;s/K./K1/;};
/Taaa /{s/A/A1/;s/K./K1/;};
s/T[a]* /T /;b f_badd_begin
:f_badd_end
/K1/s/A/A1/;
s/^  T[^ ]* A\([^ ]*\) K\([^ ]*\) /\1/;
b function_return

:function_bmul
# Функция двоичного умножения
/\(^0 \)\|\(^[^ ]* 0\)/ {s/\([^ ]*\) \([^ ]*\)/0/; b function_return;}
/^1 / {s/1 //; b function_return;}
/^\([^ ]*\) 1 / {s/ 1//; b function_return;}
s/^[^ ]* [^ ]* /&A0 /; 
:f_bmul_cycle
/^[^ ]* [^ ]*1 / {
  s/^\([^ ]*\) \([^A]*\)A\([01]*\) /\1 \3 \1 \2A\3 /;
  s/S:/S:f_bmul_1:/; b function_badd; :f_bmul_1;
  s/^\([^ ]*\) \([^A]*\)A\([01]*\) /\2A\1 /;
}
s/^\([^ ]*\) \([^ ]*\)[^ ] /\10 \2 /;
/^\([^ ]*\)  / b f_bmul_end;
b f_bmul_cycle
:f_bmul_end
s/^[^A]*A\([01]*\) /\1 /
b function_return

:function_dec2bin
# Преобразует десятичную запись числа в двоичную
s/\([0-9]*\) /\1 A0 /
:f_d2b_cycle
/^0\([^ ]*\) / {s/^/0 /;b f_d2b_1;}
/^1\([^ ]*\) / {s/^/1 /;b f_d2b_1;}
/^2\([^ ]*\) / {s/^/10 /;b f_d2b_1;}
/^3\([^ ]*\) / {s/^/11 /;b f_d2b_1;}
/^4\([^ ]*\) / {s/^/100 /;b f_d2b_1;}
/^5\([^ ]*\) / {s/^/101 /;b f_d2b_1;}
/^6\([^ ]*\) / {s/^/110 /;b f_d2b_1;}
/^7\([^ ]*\) / {s/^/111 /;b f_d2b_1;}
/^8\([^ ]*\) / {s/^/1000 /;b f_d2b_1;}
/^9\([^ ]*\) / {s/^/1001 /;b f_d2b_1;}
: f_d2b_1
s/\([^A]*\)A\([01]*\) /\2 1010 \1A\2 /;
s/S:/S:f_d2b_2:/; b function_bmul; :f_d2b_2
s/S:/S:f_d2b_3:/; b function_badd; :f_d2b_3
s/^\([^ ]*\) .\([^A]*\)A[^ ]* /\2A\1 /
/^ / {s/ A//; b function_return;}
b f_d2b_cycle

:function_bsub
# Функция двоичного вычитания
s/^[^ ]* [^ ]* /&A /;
:f_bsub_cycle
/^[^ ]*\(.\) [^ ]*\1 / {
  s/^\([^ ]*\). \([^ ]*\). A/\1 \2 A0/; b f_bsub_1;}
/^[^ ]*1 [^ ]*0 / {
  s/^\([^ ]*\)1 \([^ ]*\)0 A/\1 \2 A1/; b f_bsub_1;}
s/^\([^ ]*\)1\(0*\)0 \([^ ]*\)1 A/\1E\20 \3 A1/
t f_bsub_2; :f_bsub_2
s/E\(1*\)0\(0*\)0 /E\11\20 /;t f_bsub_2;
s/E\(1*\)0/0\1/;
:f_bsub_1;
/^[^ ]* [^ ]/ b f_bsub_cycle;
/^0*1/ s/^0*1\([^ ]*\)  A/1\1/; 
s/^0*  A0*//;
b function_return

:function_bcom
# Функция сравнивает два двоичных числа и возвращает:
# A если первое число больше второго;
# B если числа равны;
# C есть второе число больше.
/^\([^ ]*\) \1 / {s/^/B /;b f_bcom_end;} 
h;s/^\([^ ]*\) \([^ ]*\) .*/\1 \2 /;
s/[01]/a/g;
/^\(a*\) \1 / b f_bcom_equilong
/^\(a*\) \1a/ {s/.*/C/;b f_bcom_1;}
s/.*/A/;:f_bcom_1;
G;s/\n/ /; b f_bcom_end
# числа равной длины
:f_bcom_equilong
g
/^\(.*\)0[^ ]* \11/ {s/^/C /;b f_bcom_end;}
s/^/A /;
:f_bcom_end
s/\([ABC]\) [^ ]* [^ ]* /\1 /;
b function_return

:function_dsum
# Функция десятичного сложения
h;s/^[0-9]* [0-9]* //;x;s/^\([^ ]* [^ ]* \).*/\1AK0/;
s/A/9876543210;9876543210;A/;
:fdsum_begin
/^ [0-9]/s/^/0/;/^[0-9][0-9]*  /s/^\([0-9]*\) /\1 0/;
/^  /{/K1/s/A/A1/;bfdsum_end;
s/A/A0/;};
s/^\([0-9]*\)\([0-9]\) \([0-9]*\)\([0-9]\) \(.*\)\2\([^;]*\);\(.*\)\4\([^;]*\);/\6\8 \1 \3 \5\2\6;\7\4\8;/;
/K1/{s/K1/K0/;s/^[^ ]*/a&/;};
s/[^ ]*/&9876543210/;
/^[^ ]\{20\}/{s/K0/K1/;s/^[^ ]\{10\}//;}
s/.\{9\}\(.\)[^ ]*\(.*\)/\1\2/;
s/^\([^ ]\) \([^A]*\)A\(.*\)/\2A\1\3/;
bfdsum_begin;
:fdsum_end
s/^[^A]*A\([0-9]*\).*/\1/;G;s/\n/ /;
b function_return

:function_bin2dec
# Двоичное число в десятичное
s/^\([^ ]*\) /\1 B1 A0 /;
:f_b2d_cycle
/^\([^ ]*\)1 / {
  s/^\([^B]*\)B\([0-9]*\) A\([0-9]*\) /\2 \3 &/
  s/S:/S:f_b2d_1:/; b function_dsum; :f_b2d_1
  s/\([0-9]*\) \([^A]*\)A[0-9]* /\2A\1 /;}
/^[^ ] / b f_b2d_end
s/^\([^ ]*\). B\([0-9]*\) /\2 \2 \1 B /;
s/S:/S:f_b2d_2:/; b function_dsum; :f_b2d_2
s/^\([^ ]*\) \([^B]*\)B/\2B\1/;b f_b2d_cycle
:f_b2d_end
s/^[^A]*A//
b function_return


:function_return
# Выход из функции
/S:label1:/ {s/S:label1:/S:/;b label1;}
/S:label2:/ {s/S:label2:/S:/;b label2;}
/S:label3:/ {s/S:label3:/S:/;b label3;}
/S:label4:/ {s/S:label4:/S:/;b label4;}
/S:label5:/ {s/S:label5:/S:/;b label5;}
/S:f_bmul_1:/ {s/S:f_bmul_1:/S:/;b f_bmul_1;}
/S:f_d2b_2:/ {s/S:f_d2b_2:/S:/;b f_d2b_2;}
/S:f_d2b_3:/ {s/S:f_d2b_3:/S:/;b f_d2b_3;}
/S:f_b2d_1:/ {s/S:f_b2d_1:/S:/;b f_b2d_1;}
/S:f_b2d_2:/ {s/S:f_b2d_2:/S:/;b f_b2d_2;}
