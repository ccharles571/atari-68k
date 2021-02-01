'sof
'*******************************************
'*** 	ST DRUMBOX BY DAVID SNOW         ***
'*** THIS GENERATES FOUR TRACKS OF       ***
'***  RANDOM RHYTHMIC PATTERNs           ***
'*** to PLAY ON GM MIDI drum channel #10 ***
'### new hisoft write charles copp 2017  ###
'*******************************************
OPTION BASE 1

LIBRARY "xbios"


'*** VARIABLES
DIM SHARED gintin&,gintout&,addrin&
DIM SHARED array%(20,4,16),midi$

gintin&=PEEKL(GB+8)
gintout&=PEEKL(GB+12)
addrin&=PEEKL(GB+16)

tempo%=120
escape%=0
channel%=153
velocity%=88

RANDOMIZE(TIMER)

FULLW 2
WIDTH(80)

midi$=SPACE$(3)
MID$(midi$,1)=CHR$(channel%)
MID$(midi$,3)=CHR$(velocity%)


WHILE escape%=0

CALL outputwindowtitle("ST DrumBox")

CLEARW 2

GOTOXY 15,1
PRINT USING "Tempo=###",tempo%
GOTOXY 15,3
PRINT "0. Quit Prgm"
GOTOXY 15,4
PRINT "1. Randomize"
GOTOXY 15,5
PRINT "2. Edit"
GOTOXY 15,6
PRINT "3. Sequence"
GOTOXY 15,7
PRINT "4. Set Tempo(1-240)"; 
GOTOXY 15,9
INPUT "Enter Option:",option$

SELECT CASE option$
="0"
escape%=-1
="1"
CALL randomizer(tempo%)
="2"
CALL edit
="4"
CALL tempo(tempo%)
END SELECT
 
WEND

END


SUB randomizer(VAL tempo%)
LOCAL title$,numpul$,rand%,probability%,numpul%,_
track%,pulse%,pattern%

CALL outputwindowtitle("Randomizer")


FOR pattern%=1 TO 20

CLEARW 2
GOTOXY 15,1
PRINT"Pattern Number";pattern%

numpul%=INT(RND(1)*16)+1
PRINT"Pulses Per Bar";numpul%

PRINT"Probability Of Hit(1-100):"
FOR track%=1 TO 4
probability%=INT(RND(1)*100)+1
PRINT TAB(32);"Track";track%;"=";probability%

FOR pulse%=1 TO numpul%
IF INT(RND(1)*100)+1 > probability% THEN 
rand%=128
ELSE  
rand%=24+INT(RND(1)*72):INCR rand%
END IF 
array%(pattern%,track%,pulse%)=rand%
NEXT pulse%

IF pulse%<16 THEN array%(pattern%,track%,pulse%)=129
NEXT track%

CALL displayrhythmgrid(pattern%)
CALL playpattern(pattern%,tempo%)

NEXT pattern%
END SUB


SUB playpattern(VAL pattern%,VAL tempo%)
LOCAL ex%,delay%
LOCAL pulse%,track%

GOTOXY 0,11
PRINT "Any Key = Stop Play"

ex%=0
WHILE ex%=0


FOR pulse%=1 TO 16
WHILE INP(-2)
ex%=INP(2)
WEND

IF array%(pattern%,1,pulse%)=129 OR ex% THEN EXIT FOR 

FOR track%=1 TO 4
IF array%(pattern%,track%,pulse%)<128 THEN 
MID$(midi$,2)=CHR$(array%(pattern%,track%,pulse%))
CALL midiws(3,midi$)
END IF
NEXT track%
FOR delay% =1 TO (240-tempo%)*48
NEXT
NEXT pulse%

WEND

END SUB

SUB displayrhythmgrid(VAL pattern%)
LOCAL hit$,border$
LOCAL hit%,track%,pulse%

CLEARW 2
GOTOXY 17,1
PRINT "Pattern";pattern%
PRINT "Pulse";TAB(14)

border$=STRING$(13,"_")
FOR pulse%=1 TO 16
IF array%(pattern%,1,pulse%)=129 THEN EXIT FOR
PRINT RIGHT$(STR$(pulse%),2)+"  ";
border$=border$+STRING$(4,"_")
NEXT 
PRINT
PRINT border$

FOR track%=1 TO 4
PRINT "Track";track%;
PRINT TAB(14)

FOR pulse% = 1 TO 16
hit%=array%(pattern%,track%,pulse%)
SELECT CASE hit%
=129
EXIT FOR
=128 
hit$=SPACE$(3)
=ELSE
hit$=RIGHT$(STR$(hit%),3)
END SELECT
PRINT "|"+hit$;
NEXT pulse%
PRINT
NEXT track%

PRINT border$

END SUB

SUB outputwindowtitle(title$)
'wind_set()
title$=title$+CHR$(0)
POKEW gintin&,PEEKW(SYSTAB+8)     'OUTPUT aes handle
POKEW gintin&+2,2
POKEL gintin&+4,VARPTR(title$)
GEMSYS 105                        
END SUB


SUB tempo(tempo%)
LOCAL x%
GOTOXY 15,1
PRINT"Tempo=___"
GOTOXY 15,1
x%=tempo%
INPUT "Tempo=",tempo%
IF tempo%<1 OR tempo%>240 THEN
tempo%=x%
END IF
END SUB




SUB edit
LOCAL pattern%,track%,pulse%
LOCAL p%,option$,numpul%
LOCAL a$

CLEARW 2
GOTOXY 0,11

DO
INPUT "pattern TO edit (1-20)",pattern%
LOOP UNTIL pattern%>0 AND pattern%<21

CALL displayrhythmgrid(pattern%)

FOR numpul% = 1 TO 16
IF array%(pattern%,1,numpul%)>128 THEN EXIT FOR
NEXT
DECR numpul%

'DO
'INPUT "track TO edit (1-4)",track%
'LOOP UNTIL track%>0 AND track%<5
'DO
'a$="edit which pulse(1-"+STR$(numpul%)+")"
'INPUT a$,pulse%
'LOOP UNTIL (pulse%>0) AND (pulse%<numpul%+1)
INPUT p%
GOTO 1


POKEW gintin&,1
option$="[2][|Edit ?|][PulseData|Patt.Len.|]"
POKEL addrin&,VARPTR(option$)
GEMSYS 52
p%=PEEKW(gintout&)

SELECT CASE p%
=1
PRINT"pulse to edit (1-";numpul%;")";
INPUT pulse%
'IF pulse%<numpul% OR pulse%<1 THEN 2020
=2
END SELECT



'DO
'INPUT "enter pitch number(0-127) or rest(*)",pitch$
'LOOP UNTIL VAL(pitch$)<=128 

'IF pitch$="*" THEN pitch$="128"
'array%(pattern%,VAL(track$),pulse%)=VAL(pitch$)
'GOSUB displayrhythmgrid
1:

END SUB



'ELSEIF p=3 THEN
'DECR pattern%
'END IF


'POKEW gintin&,1
'option$="[2][|"+STR$(pattern%)+": edit pattern?|][edit|save|retry]"
'POKEL addrin&,VARPTR(option$)
'GEMSYS 52
'p=PEEKW(gintout&)
'IF p=1 THEN 

'eof
'WHILE pattern%<1 OR pattern%>20
'CLEARW 2
'GOTOXY 8,8
'INPUT "Start At Which Pattern(1-20):",pattern%
'WEND
