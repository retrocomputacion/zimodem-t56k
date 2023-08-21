!--------------------------------------------------
!- Tuesday, July 18, 2017 2:54:31 AM
!- Import of : 
!- c:\src\zimodem\cbm8bit\src\telnet64-128.prg
!- Commodore 64
!--------------------------------------------------
1 REM TELNET64/128  1200B 1.8+
2 REM UPDATED 09/02/2022 12:54A
10 POKE254,PEEK(186):IFPEEK(254)<8THENPOKE254,8
12 SY=PEEK(65532):IFSY=61THENPOKE58,254:CLR
13 IFSY=34THENX=23777:POKEX,170:IFPEEK(X)<>170THENPRINT"<16k":STOP
15 OPEN5,2,0,CHR$(8):IFPEEK(65532)=34THENPOKE56,87:POKE54,87:POKE52,87
17 DIMPP$(25):P$="ok":POKE186,PEEK(254):BA=1200:XB=1200
20 CR$=CHR$(13):PRINTCHR$(14);:SY=PEEK(65532):POKE53280,254:POKE53281,246
30 CO$="{light blue}":IFSY=226THENML=49152:POKE665,73-(PEEK(678)*30)
35 IFSY=34THENML=22273:IFPEEK(ML)<>76THENCLOSE5:LOAD"pmlvic.bin",peek(254),1:RUN
38 IFSY=34THENPOKE36879,27:CO$=CHR$(31)
40 IFSY=226ANDPEEK(ML+1)<>209THENCLOSE5:LOAD"pml64.bin",PEEK(254),1:RUN
50 IFSY=61THENML=4864:POKE981,15:S8=PEEK(215)AND128:IFS8=128THENSYS30643
60 IFSY=61ANDPEEK(ML+1)<>217THENCLOSE5:LOAD"pml128.bin",PEEK(254),1:RUN
61 IFSY=61ANDS8=128THENXB=2400:CO$=CHR$(159)
70 TM=828:IFSY=61THENTM=2816
80 I=TM:DD=56577:IFSY=34THENDD=37136
90 READA%:IFSY=61AND(A%=155ORA%=156)THENREADB%:POKEI,A%-131:I=I+1:A%=10
95 IFA%>=0THENPOKEI,A%:I=I+1:GOTO90
100 REM
101 REM
102 REM
110 P$="a"
120 PRINTCO$;"{clear}{down*2}TELNET v1.6":PRINT"Requires C64Net WiFi firmware 1.8+"
130 PRINT"1200 baud version"
140 PRINT"By Bo Zimmerman (bo@zimmers.net)":PRINT:PRINT
197 REM --------------------------------
198 REM GET STARTED                    !
199 REM -------------------------------
200 UN=PEEK(254)
201 PH=0:PT=0:MV=ML+18:CR$=CHR$(13)+CHR$(10):QU$=CHR$(34)
202 PRINT "Initializing modem...";:GOSUB6000
203 GET#5,A$:IFA$<>""THEN203
205 PRINT#5,CR$;"athz0&p0f0e0";CR$;
206 GOSUB900:IFP$<>"ok"THEN203
208 GET#5,A$:IFA$<>""THEN208
210 PRINT".";:PRINT#5,CR$;"ate0n0r0v1f0";CR$;
220 GOSUB900:IFP$<>"ok"THEN208
230 PRINT".";:PRINT#5,"ate0v1x1q0f0";CR$;CHR$(19);
240 GOSUB900:IFP$<>"ok"THENPRINT"Zimodem init failed: ";P$:STOP
250 PRINT"!":DIM HO$(30):DIM PO(30):DIM HM$(30)
255 HO$(0)="coffeemud.net":PO(0)=23:HZ=1
260 OPEN1,UN,15:OPEN8,UN,8,"telnetphonebook,s,r"
270 INPUT#1,E:IFE<>0THENCLOSE8:CLOSE1:GOTO300
280 INPUT#8,HZ:FORI=1TOHZ:INPUT#8,HO$(I-1):INPUT#8,PO(I-1)
285 INPUT#8,H$:HM$(I-1)=MID$(H$,2)
290 NEXTI:CLOSE8:CLOSE1
300 GOTO 1000
897 REM --------------------------------
898 REM GET E$ FROM MODEM, OR ERROR    !
899 REM -------------------------------
900 E$=""
910 SYSML
920 IFE$<>""ANDP$<>E$THENPRINT"{reverse on}{red}Comm error. Expected ";E$;", Got ";P$;CO$;"{reverse off}"
925 RETURN
997 REM --------------------------------
998 REM THE MAIN LOOP                  !
999 REM -------------------------------
1000 PRINT:PRINTCO$;"Main Menu:"
1010 PRINT" 1) Dial from Phonebook"
1020 PRINT" 2) Modify Phonebook"
1030 PRINT" 3) Quick Connect"
1035 PRINT" 4) Terminal mode"
1040 PRINT" 9) Quit"
1050 PRINT:PRINT"Enter a number: {reverse on} {reverse off}{left}";
1060 GOSUB5000:IFP$=""THEN1000
1070 P=VAL(P$):IFP=9THENCLOSE5:OPEN1,UN,15,"i0":CLOSE1:END
1080 IFP<1ORP>4THEN1050
1090 PRINT
1100 IFP=1THENGOSUB2000:GOTO1000
1110 IFP=2THENGOSUB3000:GOTO1000
1120 IFP=3THENGOSUB4000:GOTO1000
1124 IFP=4THENPRINT#5,CR$;"at&p1";CR$;:GOSUB2430:GOTO1000
1130 PRINT"?!":GOTO1000
2000 PRINT:PRINT"{down}Dial from Phonebook:"
2020 FORI=1TOHZ
2030 PRINT STR$(I)+") ";HO$(I-1);":";MID$(STR$(PO(I-1)),2)
2080 NEXTI:PRINT:PRINT"Enter a number or RETURN: ";
2090 GOSUB5000:IFP$=""THENRETURN
2100 X=VAL(P$):IFX<1ORX>HZTHEN2000
2110 HO$=HO$(X-1):PO=PO(X-1)
2300 PRINT"{reverse on}{light green}Connecting to ";HO$;":";MID$(STR$(PO),2);"...{reverse off}";CO$
2310 GET#5,A$:IFA$<>""THEN2310
2320 PRINT#5,CR$;"atf3hctep";QU$;HO$;":";MID$(STR$(PO),2);QU$;CR$;
2330 GOSUB900:IFLEN(P$)>7ANDLEFT$(P$,7)="connect"THEN2400
2340 PRINT"{reverse on}{red}Unable to connect to ";HO$;":";MID$(STR$(PO),2)
2350 RETURN
2400 PRINT"{reverse on}{light green}* Connected. ";
2420 PRINT#5,CR$;"at0o";CR$;
2430 IFSY=226THENPRINT"Hit F1 to exit.{light gray}"
2440 IFSY=61THENPRINT"Hit ESC to exit.{light gray}"
2445 PRINT"{reverse on}{light green}Terminal mode.{light gray}";CR$;
2450 POKE53280,0:POKE53281,0:IFSY=34THENPOKE36879,8
2453 SYSTM
2457 POKE53280,254:POKE53281,246:IFSY=34THENPOKE36879,27
2460 PRINT:PRINTCO$;CHR$(14);"{reverse off}Hanging up...";:GOSUB6000
2470 PRINT:FORI=1TO100:GET#5,A$:NEXTI
2480 GET#5,A$:IFA$<>""THEN2480
2490 RETURN
3000 PRINT:PRINT"{down}Modify Phonebook:"
3020 FORI=1TOHZ
3030 PRINT STR$(I)+") ";HO$(I-1);":";MID$(STR$(PO(I-1)),2):NEXTI
3040 PRINTSTR$(HZ+1)+") Add New Entry"
3080 PRINT:PRINT"Enter a number or RETURN: ";
3090 GOSUB5000:IFP$=""THENRETURN
3100 X=VAL(P$):IFX<1ORX>HZ+1THEN3000
3110 PRINT"Enter hostname/ip: ";:GOSUB5000:H$=P$:IFP$=""THEN3000
3120 PRINT"Enter port number (23): ";:GOSUB5000:HP=VAL(P$):IFHP<=0THENHP=23
3130 HO$(X-1)=H$:PO(X-1)=HP:IFX=HZ+1THENHZ=HZ+1
3140 OPEN1,UN,15:OPEN8,UN,8,"@0:telnetphonebook,s,w"
3150 INPUT#1,E:IFE<>0THENCLOSE8:CLOSE1:GOTO300
3160 PRINT#8,HZ:FORI=1TOHZ:PRINT#8,HO$(I-1):PRINT#8,PO(I-1)
3165 PRINT#8,"-"+HM$(I-1)
3170 NEXTI:CLOSE8:CLOSE1: GOTO 3000
4000 PRINT:PRINT"Enter hostname/ip: ";:GOSUB5000:H$=P$:IFP$=""THENRETURN
4010 PRINT"Enter port number (23): ";:GOSUB5000:HP=VAL(P$):IFHP<=0THENHP=23
4020 HO$=H$:PO=HP:GOTO2300
4999 STOP
5000 P$=""
5005 PRINT"{reverse on} {reverse off}{left}";
5010 GETA$:IFA$=""THEN5010
5020 A=ASC(A$):IFA=13THENPRINT" {left}":RETURN
5025 IFA=34THENPRINTA$;A$;"{left}{reverse on} {reverse off}{left}";:P$=P$+A$:GOTO5010
5030 IFA<>20THENPRINTA$;"{reverse on} {reverse off}{left}";:P$=P$+A$:GOTO5010
5040 IFP$=""THEN5010
5050 P$=LEFT$(P$,LEN(P$)-1):PRINT" {left*2} {left}{reverse on} {reverse off}{left}";:GOTO5010
6000 IF(PEEK(DD)AND16)=0THENRETURN
6010 GOSUB6100
6020 PRINT#5,"+++";:PRINT".";
6030 GOSUB6100
6040 PRINT".";:PRINT#5,"ath&p0":TT=TI+150
6050 SYSML+12:IFTI<TTTHEN6050
6060 RETURN
6100 TT=TI+150
6110 IFTI<TTTHEN6110
6120 RETURN
39999 STOP
40000 OPEN1,8,15:OPEN8,8,8,"telnetml.bin,p,r":LN=41000:DN=0
40010 INPUT#1,E:IFE<>0THENCLOSE8:CLOSE1:STOP
40020 GET#8,A$:IFST>0THENCLOSE8:END
40030 IFA$=""THENA$=CHR$(0)
40035 A=ASC(A$):A$=MID$(STR$(A),2)
40040 IFDN=0THENPRINTMID$(STR$(LN),2);" data ";A$;:DN=DN+1:GOTO40020
40060 PRINT",";A$;:DN=DN+1
40070 IFDN=18THENPRINT:DN=0:LN=LN+10
40080 GOTO 40020
41000 DATA 162,5,32,198,255,32,228,255,201,0,240,61,201,10,240,57
41010 DATA 32,210,255,173,155,2,205,156,2,240,38,176,13,169,255,56,237,156
41020 DATA 2,24,109,155,2,56,176,4,56,237,156,2,201,200,144,11,173,1
41030 DATA 221,41,253,141,1,221,56,176,12,201,20,176,8,173,1,221,9,2
41040 DATA 141,1,221,162,0,32,198,255,32,228,255,201,0,240,171,201,133,240
41050 DATA 4,201,27,208,4,32,204,255,96,72,162,5,32,201,255,104,32,210
41060 DATA 255,162,0,32,201,255,56,176,141
41999 DATA -1
49999 STOP
50000 OPEN5,2,0,CHR$(8)
50010 GET#5,A$:IFA$<>""THENPRINTA$;
50020 GETA$:IFA$<>""THENPRINT#5,A$;
50030 GOTO 50010
55555 U=8:F$="telnet":OPEN1,U,15,"s0:"+F$:CLOSE1:SAVE(F$),U:VERIFY(F$),U
