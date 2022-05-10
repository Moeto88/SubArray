  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  .global  Main

Main:

  @
  @ write your program here
  @
  @ looking for arrayB[0][0] (1st row and column (53 in this case))
  LDR R4, [R2]      @ target = word[addressOfArrayB];

  @ looking for the same number in arrayA
  @ array[r][c];
  LDR R5, =0        @ row = 0;
start:  
  CMP R5, R1        @ while(row < sizeOfArrayA)
  BHS notContained  @ {
  LDR R6, =0        @  column = 0;
while:  
  CMP R6, R1        @  while(column < sizeOfArrayA)
  BHS nextWord      @  {

  MUL R7, R5, R1    @   index = row * sizeOfArrayA;
  ADD R7, R7, R6    @   index = index + column;
  LDR R8, [R0, R7, LSL #2] @ elem = word[arrayA + (index * elem_size)]
  CMP R4, R8        @   if(target != elem)
  BEQ founded       @   {
  ADD R6, R6, #1    @    column++;
  B   while         @   }
                    @  }
nextWord:           
  ADD R5, R5, #1    @  row++;
  B   start         @ }

founded:  
  @ R5 = The row of target
  @ R6 = The column of target
  @ arrayA[r][c++]

  @ arrayB[r2][c2++]
  LDR R9, =0        @ row2 = 0;  
start2:
  CMP R9, R3        @ while(row2 < sizeOfArrayB) 
  BHS contained     @ {
  LDR R10, =0       @  column2 = 0;
while2:      
  CMP R10, R3       @  while(column2 < sizeOfArrayB)
  BHS nextNumber    @  {


  MUL R11, R9, R3   @   index2 = row2 * sizeOfArrayB;
  ADD R11, R11, R10 @   index2 = index2 + column2
  LDR R4, [R2, R11, LSL #2] @ elem2 = word[arrayB + (index2 * elem_size)];


  MUL R7, R5, R1    @   index = row * sizeOfArrayA;
  ADD R7, R7, R6    @   index = index + column;
  LDR R8, [R0, R7, LSL #2] @ elem = word[arrayA + (index * elem_size)];



  CMP R8, R4        @   if(elem == elem2)
  BNE notContained  @   {
  ADD R10, R10, #1  @    column2++;
  ADD R6, R6, #1    @    column++;
                    @   }
                    @  }

@ if the column number is greater than the size of ArrayA, this means wrap-around occured.
  CMP R6, R1        @   if(column > sizeOfArrayA)
  BHI notContained  @     this.notContained();
  B   while2

  

nextNumber:
  ADD R9, R9, #1    @  row2++;
  ADD R5, R5, #1    @  row++;
  SUB R6, R6, R3    @  column = column - sizeOfArrayB;
  B   start2        @ }

contained: 
  LDR R0, =1        @ result = 1;
  B   End_Main  

notContained:  
  LDR R0, =0        @ result = 0;



  @ End of program ... check your result

End_Main:
  BX    lr

