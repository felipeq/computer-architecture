.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC; (dwa znaki podkre�lenia)
extern __read : PROC; (dwa znaki podkre�lenia)
extern _MessageBoxA@16 : PROC
public _main5
.data
tekst_pocz  db  10, 'Prosz� napisa� jaki� tekst '
db  'i nacisnac Enter', 10
koniec_t   db ?
magazyn   db  80 dup(? )
magazyn_2 db 80 dup(? )
nowa_linia   db  10
liczba_znakow  dd ?
.code
_main5 :
; wy�wietlenie tekstu informacyjnego
; liczba znak�w tekstu
mov ecx, (OFFSET koniec_t) - (OFFSET tekst_pocz)
push ecx
push OFFSET tekst_pocz; adres tekstu
push 1; nr urz�dzenia(tu: ekran - nr 1)
call __write; wy�wietlenie tekstu pocz�tkowego
add esp, 12; usuniecie parametr�w ze stosu
; czytanie wiersza z klawiatury
push 80; maksymalna liczba znak�w
push OFFSET magazyn
push 0; nr urz�dzenia(tu: klawiatura - nr 0)
call __read; czytanie znak�w z klawiatury
add esp, 12; usuniecie parametr�w ze stosu
; kody ASCII napisanego tekstu zosta�y wprowadzone
; do obszaru 'magazyn'
; funkcja read wpisuje do rejestru EAX liczb�
; wprowadzonych znak�w
mov liczba_znakow, eax
; rejestr ECX pe�ni rol�licznika obieg�w p�tli
mov ecx, eax
mov ebx, 0; indeks pocz�tkowy
ptl : mov dl, magazyn[ebx]; pobranie kolejnego znaku
	  mov magazyn_2[ebx], dl
	  ; �
	  cmp dl, 0A5H
	  jne ci
	  mov dl, 165
	  jmp zapisz
  ci :
cmp dl, 86H
jne e
mov dl, 198
jmp zapisz
e :
cmp dl, 0A9H
jne l
mov dl, 202
jmp zapisz
l :
cmp dl, 88H
jne n
mov dl, 163
jmp zapisz
n :
cmp dl, 0E4H
jne o
mov dl, 209
jmp zapisz
o :
cmp dl, 98H
jne s
mov dl, 211
jmp zapisz
s :
cmp dl, 0ABH
jne zi
mov dl, 140
jmp zapisz
zi :
cmp dl, 0BEH
jne normalne
mov dl, 175
jmp zapisz
normalne :
cmp dl, 'a'
jb dalej; skok, gdy znak nie wymaga zamiany
cmp dl, 'z'
ja dalej; skok, gdy znak nie wymaga zamiany
sub dl, 20H; zamiana na wielkie litery
; odes�anie znaku do pami�ci
zapisz :
mov magazyn[ebx], dl
dalej : inc ebx; inkrementacja indeksu
		loop ptl; sterowanie p�tl�
		; wy�wietlenie przekszta�conego tekstu
		push liczba_znakow
		push OFFSET magazyn
		push 1
		call __write; wy�wietlenie przekszta�conego
		push 0; sta�a MB_OK; adres obszaru zawieraj�cego tytu�
		push OFFSET magazyn; adres obszaru zawieraj�cego tekst
		push OFFSET magazyn
		push 0; NULL
		call _MessageBoxA@16
		add esp, 12; usuniecie parametr�w ze stosu
		push 0
		call _ExitProcess@4; zako�czenie programu
		END