'sof
'
LIBRARY "xbios"
'====================================================
vectors&=0
mvec&=0
midivec%=0
midithru&=0
DIM a%(24)
'
RESTORE thru
FOR x%=0 TO 24 
READ a%(x%)
NEXT x%
'
vectors&=KBDVBASE&
mvec&=PEEKL(vectors&+midivec%)
'
midithru&=VARPTR(a%(0))
'
POKEL vectors&+midivec%,midithru&
PRINT "MIDI thru enabled."
'
POKEL vectors&+midivec%,mvec&
PRINT "MIDI thru disabled."
'
END
'
thru:
DATA &H1211
DATA &H801
DATA &H01
DATA &H6700
DATA &HFFF8
DATA &H1340
DATA &H02
DATA &H3228
DATA &H08
DATA &H5241
DATA &HB268
DATA &H04
DATA &H6500
DATA &H04
DATA &H7200
DATA &HB268
DATA &H06
DATA &H6700
DATA &H0C
DATA &H2450
DATA &H1580
DATA &H1000
DATA &H3141
DATA &H08
DATA &H4E75
'
'eof
