'sof
'
LIBRARY "gemvdi"
'
'********************
'******* INIT *******
'********************
CONST  h0%=25,_
       r1%=130,r0%=120,_
       sec.z%=115,min.z%=105,hour.z%=80,_
       xm%=320,ym%=200
'
pi=4*ATN(1)
g89 = 89.9*(pi/180) 
g90 = pi/2 
g91 = 90.1*(pi/180)
'
FULLW 2:CLEARW 2
'
vst_point h0%
'
DIM time%(23)
RESTORE init.time
FOR l%=0 TO 23
 READ time%(l%)
NEXT 
'
zifferblatt
'
'********************
'******* MAIN *******
'********************
'
WHILE INKEY$=""
'
CALL LOC VARPTR(time%(0))
'
IF sec%<>time%(20)*2
sec%=time%(20)*2
COLOR 0,0,0,0,0
zeiger phisec,sec.z%
phisec=sec%*(pi/30)-g90 
COLOR 1,0,1,1,1
zeiger phisec,sec.z%
IF minute%<>time%(21) THEN
minute%=time%(21)
COLOR 0,0,0,0,0
zeiger phimin,min.z%
phimin=minute%*6*(pi/180)-g90 
COLOR 1,0,1,1,1
zeiger phimin,min.z%
IF hour%<>time%(22) THEN
hour%=time%(22)
COLOR 0,0,0,0,0
zeiger phihour,hour.z%
phihour=hour%*30*(pi/180)-g90 
COLOR 1,0,1,1,1
zeiger phihour,hour.z%
END IF
END IF
digital sec%,minute%,hour%
END IF
'
WEND
'
STOP -1
'
'********************
'*** SUB-ROUTINES ***
'********************
'
SUB zeiger(BYVAL phi,BYVAL r%)
SELECT CASE r%
=sec.z%
  LINEF xm%,ym%,xm%+r%*COS(phi),ym%+r%*SIN(phi)
=min.z%
  LINEF xm%+1,ym%,xm%+r%*COS(phi)+1,ym%+r%*SIN(phi)
  LINEF xm%,ym%+1,xm%+r%*COS(phi),ym%+r%*SIN(phi)+1
  LINEF xm%+1,ym%+1,xm%+r%*COS(phi)+1,ym%+r%*SIN(phi)+1
=hour.z%
  LINEF xm%+2,ym%,xm%+r%*COS(phi)+2,ym%+r%*SIN(phi)
  LINEF xm%,ym%+2,xm%+r%*COS(phi),ym%+r%*SIN(phi)+2
  LINEF xm%+2,ym%+2,xm%+r%*COS(phi)+2,ym%+r%*SIN(phi)+2
END SELECT
END SUB
'
SUB zifferblatt
SHARED pi,g89,g90,g91
LOCAL phi,h%,m%
  CIRCLE xm%,ym%,r0%,r0%,r0%
  CIRCLE xm%,ym%,r1%,r1%,r1%
 FOR h%=1 TO 12
  phi=h%*30*(pi/180)-g90 
  LINEF xm%+r0%*COS(phi),ym%+r0%*SIN(phi),xm%+r1%*COS(phi),ym%+r1%*SIN(phi)
  phi=h%*30*(pi/180)-g89 
  LINEF xm%+r0%*COS(phi),ym%+r0%*SIN(phi),xm%+r1%*COS(phi),ym%+r1%*SIN(phi)
  phi=h%*30*(pi/180)-g91 
  LINEF xm%+r0%*COS(phi),ym%+r0%*SIN(phi),xm%+r1%*COS(phi),ym%+r1%*SIN(phi)
 NEXT
 FOR m%=1 TO 59
  phi=m%*(pi/30) 
  LINEF xm%+r0%*COS(phi),ym%+r0%*SIN(phi),xm%+r1%*COS(phi),ym%+r1%*SIN(phi)
 NEXT
END SUB
'
SUB digital(BYVAL sec%,BYVAL minute%,BYVAL hour%)
LOCAL sec$,min$,hour$
  sec$=STR$(sec%):IF LEN(sec$)=2 THEN sec$=" 0"+RIGHT$(sec$,1)
  min$=STR$(minute%):IF LEN(min$)=2 THEN min$=" 0"+RIGHT$(min$,1)
  hour$=STR$(hour%):IF LEN(hour$)=2 THEN hour$=" 0"+RIGHT$(hour$,1)
  CALL printdig(RIGHT$(hour$,2)+CHR$(26)+RIGHT$(min$,2)+CHR$(26)+RIGHT$(sec$,2))
END SUB
'
SUB printdig(BYVAL timdig$)
LOCAL l%
 FOR l%=1 TO 8
  MID$(timdig$,l%,1)=CHR$(ASC(MID$(timdig$,l%,1))XOR 32)
 NEXT
 v_justified 210,80,timdig$,220,1,1
END SUB
'
init.time:
  DATA &h2a48,&h3f3c,&h002c,&h4e41,&h548f,&h3b40,&h0028,&h026d
  DATA &h001f,&h0028,&hea48,&h3200,&h0240,&h003f,&h3b40,&h002a
  DATA &hec49,&h3b41,&h002c,&h4e75,&h0000,&h0000,&h0000,&h0000
'
'eof