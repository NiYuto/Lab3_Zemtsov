.686
.model flat,stdcall
.stack 100h
.data
mas DD 100 dup(?)
num dd 5.0 ; стартовое значение
step dd 0.1 ; шаг для числа
six dd 6.0
.code

ExitProcess PROTO STDCALL :DWORD
Start:

xor eax, eax
xor ebx, ebx
xor ecx, ecx ; регистр ecx будет счетчиком до 100 для массива
	Loop_start:
	finit
	cmp ecx, 100 
	je exit ; если прошло 100 циклов, то завершаем программу

	fldz ;загрузка 0 для сравнения(уезжает в  регистр st1)
	fld num; загруска числа
	fcomi st,st(1);сравнение ST(0) > 0
	ja greater_0

	FLD1
	fchs ;загрузка -1
	FXCH st(1)
	fcomi st, st(1)
	jae greater_1
	jmp less_1

	greater_0:
	FMUL ST(0),ST(0)
	FST [mas+ecx*4] ; сохраняем в массив число 
	jmp Loop_end

	greater_1:
	FST [mas+ecx*4]
	jmp Loop_end

	less_1: ;при выполенении всегда получается положительная неопределенность
			;так как мы берем квадратный корень от отрицательного числа
	FSUB six
	FSQRT
	fld1
	fadd st(0), st(0)
	fmul st(0), st(1)
	FST [mas+ecx*4]
	jmp Loop_end
	

		Loop_end:
		fld num
		fsub step 
		fst num; num - 0.1  
		add ecx,1 ; увеличение итератора на 1
		jmp Loop_start

exit:
Invoke ExitProcess,1
End Start