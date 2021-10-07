.286
.model small
.stack 256
	picxsize  equ 13    
	picysize  equ 14     

.data
x  dw 34;14-for max tavla(9*15)
y  dw 9;9-for max tavla(9*15)
x1 dw ?
y1 dw ?
xb dw 60
yb dw 184
	;     1   2   3   4   5   6   7   8   9  10  11  12  13	    	 	

pic1  db 000,000,000,004,004,004,004,004,004,004,000,000,000	;1
      db 000,000,004,004,004,004,004,004,004,004,004,000,000	;2
      db 000,004,004,004,004,004,004,004,004,004,004,004,000	;3
      db 004,004,004,004,004,004,004,004,004,004,004,004,004	;4
      db 004,004,004,004,004,004,004,004,004,004,004,004,004	;5
      db 004,004,004,004,004,004,004,004,004,004,004,004,004	;6
      db 004,004,004,004,004,004,004,004,004,004,004,004,004	;7
      db 004,004,004,004,004,004,004,004,004,004,004,004,004	;8
      db 004,004,004,004,004,004,004,004,004,004,004,004,004	;9
      db 004,004,004,004,004,004,004,004,004,004,004,004,004	;10
      db 004,004,004,004,004,004,004,004,004,004,004,004,004	;11
      db 000,004,004,004,004,004,004,004,004,004,004,004,000	;12
      db 000,000,004,004,004,004,004,004,004,004,004,000,000	;13
      db 000,000,000,004,004,004,004,004,004,004,000,000,000	;14

	continue    db 'Wanna play again?(I know where you live)',10,13,'       Y/N$',10,13
	ten      db 10
	timepass db 0
	difficulty db 'choose difficulty',10,13,'Easy',10,13,'Normal',10,13,'Hard$',10,13
	msgPoints db'Balls catched:$',10,13
	msgTime   db'Time:   /300000$',10,13
	msgControls		 db '                               Catch The Ball',10,13,'Controls:',10,13,'         Move Left - Left Corsur',10,13,10,13,'         Move Right - Right Corsur',10,13,10,13,'         Move Down - Down Corsur',10,13,10,13,'         Move Up - Up Corsur',10,13,10,13,'         Catch the ball - Enter/Space button',10,13,10,13,'         Quit - Esc',10,13,10,13,'                    All Rights Reserved To Galili Or (c)',10,13,10,13,'Press any key to continue$'
	ok       db ?
	points   dw 0
	side     dw 20
	num      dw 5  
	ycol     dw ?
	xcol     dw ?
	yline    dw ?	
	xline    dw ?
	limit    dw ?  
	m_amudot dw ?
	m_shurot dw ?
	orehamud     dw 0
	orehshura    dw 0
	xtop     dw 30;10-for max tavla(9*15)
	ytop     dw 5;5-for max tavla(9*15)
	amudimcolor    db 30
	tavlacolor     db 22
.code
mov ax,@data
mov ds,ax

	call ControlsMenu
	anotherRound:
		call DifficultyMenu

	call BuildGame
	call PlayTheGame
	call YourScore
	call IfContinue
	cmp ok,'Y'
	jz anotherRound
	cmp ok,'y'
	jz anotherRound
	
	mov ax,2
	int 10h

	


mov ah,4ch
int 21h
;----------------------------------------------------------------------------
;in- continue- äåãòä òì äîñê äàí äîùúîù øåöä îùç÷ ðåñó
;out- äôåð÷öéä îçæéøä úùåáä ùì îùúîù äàí ìäîùéê àå ìà
IfContinue:	pusha
			mov bh,0
			mov dh,1
			mov dl,0
			mov ah,2
			int 10h
			lea dx,continue
			mov ah,09h
			int 21h
		chooseStart:	
			mov ah,07h
			int 21h
			cmp al,'Y'
			jz youChoosed
			cmp al,'N'
			jz youChoosed
			cmp al,'y'
			jz youChoosed
			cmp al,'n'
			jz youChoosed
			jmp chooseStart
		youChoosed:
			mov ok,al
			popa
			ret
;----------------------------------------------------------------------------
;in-
;out-
YourScore:	pusha
			mov ax,12h
			int 10h
			call ShowPoints
			popa
			ret
;----------------------------------------------------------------------------
;in-
;out-
PlayTheGame:	
			pusha
			mov ch,0
			mov cl,0
			mov dh,0
			mov dl,0
			mov ah,3
			int 1ah
		Game:	
			call movement
			mov ah,2
			int 1ah
			cmp cl,90		;ã÷ä
			mov timepass,dh
			jae finish
			cmp ok,1bh		; escape key
			jnz Game
		finish:
			mov ax,2
			int 10h
			popa
			ret
;----------------------------------------------------------------------------
;in-
;out-
BuildGame:	pusha
			mov ax,13h
			int 10h
			call ShowTime
			call ShowPoints
			call Temp
			call SizeAmudim ;cheak size of the amudim
			call drawTavla
			call drawAmudim
			call RandomPlace
			popa
			ret
;----------------------------------------------------------------------------
;in- 
;out-
DifficultyMenu:	pusha
				mov xb,60
				mov yb,184
				mov points,0
				mov ax,12h
				int 10h
				call DifficultyText
				call Choose
				popa
				ret
;----------------------------------------------------------------------------
;in- msgControls - äåãòä äîöéâä îä äî÷ùéí ùîùç÷éí áäí áîùç÷ 
;out-
ControlsMenu:	
			pusha
			mov ax,02h
			int 10h
	
			lea dx,msgControls
			mov ah,09h
			int 21h

			mov ah,0          ;wait for any key from keyboard
			int 16h
			popa
			ret
;----------------------------------------------------------------------------
;in- msgPoints- äåãòú äð÷åãåú ùöáø äîùúîù, points- äð÷åãåú ùöáø äîùúîù
;out- äåãòä òì äîñê ëîä ð÷åãåú öáø äîùúîù
ShowPoints:	pusha
			mov bh,0
			mov dh,0
			mov dl,0
			mov ah,2
			int 10h
			lea dx,msgPoints
			mov ah,09h
			int 21h
			mov ax,points
			div ten
			mov bh,ah
			add al,48
			mov dl,al
			mov ah,2
			int 21h
			mov ah,bh
			add ah,48
			mov dl,ah
			mov ah,2
			int 21h
			popa
			ret
;----------------------------------------------------------------------------
;in- msgTime- äåãòú æîï , timepass- æîï ùðåúø ìîùç÷ , ten- îçì÷ àú äæîï äðåúø ìùðé ñôøåú : òùøåú åàçãåú
;out- äåãòä òì äîñê ëîä æîï ðùàø ìñéåí äîùç÷
ShowTime:	pusha
			mov bh,0
			mov dh,0
			mov dl,27
			mov ah,2
			int 10h

			lea dx,msgTime
			mov ah,09h
			int 21h

			mov bh,0
			mov dh,0
			mov dl,33
			mov ah,2
			int 10h
			
			mov al,1
			mul timepass
			div ten
			mov bh,ah
			add al,48
			mov dl,al
			mov ah,2
			int 21h
			mov ah,bh
			add ah,48
			mov dl,ah
			mov ah,2
			int 21h
			popa
			ret
;----------------------------------------------------------------------------
;in-
;out-
EasyDiff:	pusha
			mov m_amudot,5
			mov m_shurot,5
			mov x,94
			mov y,49
			mov xtop,90
			mov ytop,45
			popa
			ret
;----------------------------------------------------------------------------
;in-
;out-
NormalDiff:	pusha
			mov m_amudot,9
			mov m_shurot,7
			mov x,74
			mov y,29
			mov xtop,70
			mov ytop,25
			popa
			ret
;----------------------------------------------------------------------------
;in-
;out-
HardDiff:	pusha
			mov m_amudot,13
			mov m_shurot,9
			mov x,34
			mov y,12
			mov xtop,30
			mov ytop,8
			popa
			ret
;----------------------------------------------------------------------------
;in- xb - îé÷åí äòîåãä , yb - îé÷åí äùåøä
;out- äôåð÷öéä îöééøú ÷å
PutpixelLoop:	pusha
				mov cx,xb
				mov dx,yb
				mov bx,cx
				add bx,5
			loopPix:	
				call putpixel
				inc cx
				cmp cx,bx
				jnz loopPix
				popa
				ret
;----------------------------------------------------------------------------
;in- difficulty- äåãòä òì äîñê ùì øîåú
;out-
DifficultyText:	pusha
				mov bh,0
				mov dh,10
				mov dl,25
				mov ah,2
				int 10h
		
				lea dx,difficulty
				mov ah,09h
				int 21h
			
				mov al,3
				call PutpixelLoop
				popa
				ret
;----------------------------------------------------------------------------
;in-
;out-
moveUp:	pusha
		mov al,0
		call PutpixelLoop
		mov al,3
		cmp yb,184
		jz goDown
		sub yb,16
		call PutpixelLoop
		popa
		ret
		goDown:
			mov yb,216
			call PutpixelLoop
		popa
		ret
;----------------------------------------------------------------------------
;in-
;out-
moveDown:	pusha
			mov al,0
			call PutpixelLoop
			mov al,3
			cmp yb,216
			jz goUp
			add yb,16
			call PutpixelLoop
			popa
			ret
			goUp:
				mov yb,184
				call PutpixelLoop
			popa
			ret
;----------------------------------------------------------------------------
;in-
;out-
Choose:		pusha
	start:	mov ah,0
			int 16h
			cmp al,' '
			jz ChooseDiff
			cmp al,13
			jz ChooseDiff
			cmp ah,80
			jz mDown
			cmp ah,72
			jz mUp
			jmp start
		mUp:
			call moveUp
			jmp start
		mDown:
			call moveDown
			jmp start
		ChooseDiff:
			cmp yb,184
			jz Easy 
			cmp yb,200
			jz Normal
			cmp yb,216
			jz Hard
			Easy:
				call EasyDiff
				jmp theEnd
			Normal:
				call NormalDiff
				jmp theEnd
			Hard:
				call HardDiff
	theEnd:	popa
			ret
;----------------------------------------------------------------------------
;in-   x-òîåãú äúîåðä , y-ùåøú äúîåðä
;out-  x1=x , y1=y
Temp:	pusha
		mov bx,x
		mov x1,bx
		mov bx,y
		mov y1,bx
		popa
		ret	
;----------------------------------------------------------------------------
;in-  m_shurot-îñôø ùåøåú , m_amudot-îñôø òîåãåú
;out- àåøê òîåãä , àåøê ùåøä
SizeAmudim:	pusha
			mov ax,m_shurot
			mul side
			add ax,ytop
			mov orehamud,ax
			mov ax,m_amudot
			mul side
			add ax,xtop
			mov orehshura,ax
			popa
			ret
;----------------------------------------------------------------------------
;in- m_shurot-îñôø ùåøåú , m_amudot-îñôø òîåãåú , ytop-÷öä ùåøú äèáìä , xtop-÷öä òîåãú äèáìä , tavlacolor-öáò äèáìä,side-îøç÷ áéï ùåøä ìùåøä àå òîåãä ìòîåãä
;out- èáìä
drawTavla:	pusha
			mov bx,0
			mov dx,ytop
			mov cx,xtop
		loopShura:
				mov al,tavlacolor
				call drawRow
				inc bx
				add dx,side
				cmp bx,m_shurot
				jbe loopShura
			mov bx,0
			mov dx,ytop
			mov cx,xtop
		loopAmuda:
				mov al,tavlacolor
				call drawCol
				inc bx
				add cx,side
				cmp bx,m_amudot
				jbe loopamuda
			popa
			ret
;----------------------------------------------------------------------------
;in-  ytop- ÷öä ùåøú äòîåãéí ,xtop- ÷öä òîåãú äòîåãéí
;out-
drawAmudim:	pusha
			mov dx,ytop
			mov al,amudimcolor
			call drawRow
			add dx,side
			mov cx,xtop
			mov al,amudimcolor
			call drawRow
		
			mov xline,cx
			mov yline,dx
			mov dx,ytop
			mov cx,xtop
		
			mov al,amudimcolor
			call drawCol
			add cx,side
			mov dx,ytop
			mov al,amudimcolor
			call drawCol

			mov xcol,cx
			mov ycol,dx
			popa
			ret
;-----------------------------------------------------------------------------
;in-ytop- ÷öä ùåøú äòîåãéí , tavlacolor- öáò äèáìä , orehamud- àåøê äòîåãä , amudimcolor- öáò äòîåãéí , side- îøç÷ áéï òîåã ìòîåã ,yline- äî÷åí äàçøåï ùì òîåãé äùåøåú
;out-îåç÷ òîåãä
deleteCol:	pusha
			mov al,tavlacolor
			mov dx,orehamud
		deleteC:	
			call putpixel
			dec dx
			cmp dx,ytop
			jae deleteC 
			mov al,amudimcolor
			mov dx,yline
			call putpixel	
			sub dx,side
			call putpixel
			mov dx,ytop
			popa
			ret
;-----------------------------------------------------------------------------
;in- tavlacolor- öáò äèáìä , orehshura- àåøê ùåøä , amudimcolor- öáò äòîåãéí , xtop- ÷öä òîåãú äòîåãéí , xcol- äî÷åí äàçøåï ùì òîåãé äòîåãéí
;out- îåç÷ ùåøä
deleteRow:	pusha
			mov al,tavlacolor
			mov cx,orehshura
		deleteR:
			call putpixel
			dec cx
			cmp cx,xtop
			jae deleteR
			mov al,amudimcolor
			mov cx,xcol
			call putpixel
			sub cx,side
			call putpixel
			mov cx,xtop
			popa
			ret									
;-----------------------------------------------------------------------------
;in- ytop- ÷öä ùåøú äòîåãéí , orehamud- àåøê äòîåãä
;out- îöééø òîåã 
drawCol:	mov dx,ytop
		drawC:
			call putpixel
			inc dx
			cmp orehamud,dx
			jae drawC
			ret
;-----------------------------------------------------------------------------
;in- xtop- ÷öä òîåãú äòîåãéí , orehshura- àåøê ùåøä
;out- îöééø ùåøä
drawRow:	mov cx,xtop
		drawR:
			call putpixel
			inc cx
			cmp cx,orehshura
			jbe drawR
			ret
;-----------------------------------------------------------------------------
;in- xcol- äî÷åí äàçøåï ùì òîåãé äòîåãéí , side- îøç÷ áéï òîåã ìòîåã , x- òîåãú äúîåðä , y- ùåøú äúîåðä ,yline- äî÷åí äàçøåï ùì òîåãé äùåøåú , points-ð÷åãåú ùöáø äîùúîù 
;out- úùåáä äàí ðúôñ äëãåø àå ìà
cheakPlace: pusha
			mov bx,xcol
			cmp x,bx
			jns finishFunc
			sub bx,side
			cmp x,bx
			jbe finishFunc
			mov bx,yline
			cmp y,bx
			jns finishFunc
			sub bx,side
			cmp y,bx
			jbe finishFunc
			inc points
			mov ok,1
			call ShowPoints
	finishFunc:popa
			ret
;-----------------------------------------------------------------------------
;in- side- îøç÷ áéï òîåã ìòîåã , orehamud- àåøê äòîåãä , orehshura- àåøê ùåøä , amudimcolor- öáò äòîåãéí
;out- îåç÷ ùðé äòîåãéí ùáöã ùîàì åîöééø ùðééí çãùéí áúçéìú öã éîéï
Rightstart:	pusha
			call deleteCol
			add cx,side
			mov dx,orehamud
			call deleteCol
			mov cx,orehshura
			mov al,amudimcolor
			call drawCol
			sub cx,side
			mov al,amudimcolor
			call drawCol
			add cx,side
			mov xcol,cx
			mov ycol,dx
			popa
			ret	
;-----------------------------------------------------------------------------
;in- xcol- äî÷åí äàçøåï ùì òîåãé äòîåãéí , ycol- äî÷åí äàçøåï ùì ùåøú äòîåãéí , side- îøç÷ áéï òîåã ìòîåã , xtop- ÷öä òîåãú äòîåãéí , amudimcolor- öáò äòîåãéí
;out- îåç÷ òîåãä åîöééø òîåãä çãùä áî÷åí àçø 
Left:	pusha
		mov cx,xcol
		mov dx,ycol
		sub cx,side
		cmp cx,xtop
		jz Rside
		add cx,side
		call deleteCol
		sub cx,side
		sub cx,side
		mov al,amudimcolor
		call drawCol
		add cx,side
		mov xcol,cx
		mov ycol,dx
		popa
		ret
	Rside:
		call Rightstart
		popa
		ret
;-----------------------------------------------------------------------------
;in- side- îøç÷ áéï òîåã ìòîåã , orehamud- àåøê äòîåãä , amudimcolor- öáò äòîåãéí , xtop- ÷öä òîåãú äòîåãéí
;out- îåç÷ ùðé äòîåãéí ùáöã éîéï åîöééø ùðééí çãùéí áúçéìú öã ùîàì
leftstart:	pusha
			call deleteCol
			sub cx,side
			mov dx,orehamud
			call deleteCol
			mov cx,xtop
			mov al,amudimcolor
			call drawCol
			add cx,side
			mov al,amudimcolor
			call drawCol
			mov xcol,cx 
			mov ycol,dx
			popa	
			ret
;-----------------------------------------------------------------------------
;in- yline- ð÷åãú äùåøä ùì òîåãé äùåøåú , xline- ð÷åãú äòîåãä ùì òîåãé äùåøåú , orehamud- àåøê òîåã , side- îøç÷ áéï òîåã ìòîåã , amudimcolor- öáò äòîåãéí  
;out- îåç÷ ùåøä àçú åîöééø ùåøä àçøú áî÷åí àçø
Down:	pusha
		mov dx,yline
		mov cx,xline
		cmp dx,orehamud
		jz Uside
		sub dx,side
		call deleteRow
		add dx,side
		add dx,side
		mov al,amudimcolor
		call drawRow
		mov yline,dx
		mov xline,cx
		popa
		ret
	Uside:
		call Upstart
		popa
		ret
;-----------------------------------------------------------------------------
;in-orehshura- àåøê ùåøä , side-îøç÷ áéï òîåã ìòîåã , amudimcolor- öáò äòîåãéí , ytop-äúçìú ùåøú äòîåãéí 
;out- îåç÷ ùðé äòîåãéí ùìîèä åîöééø ùðé òîåãéí áäúçìä ùì ìîòìä
Upstart:	pusha
			call deleteRow
			mov cx,orehshura
			sub dx,side
			call deleteRow
			mov dx,ytop
			mov al,amudimcolor
			call drawRow
			add dx,side
			mov al,amudimcolor
			call drawRow
			mov xline,cx
			mov yline,dx
			popa
			ret
;-----------------------------------------------------------------------------
;in-orehshura- àåøê ùåøä , side-îøç÷ áéï òîåã ìòîåã , amudimcolor- öáò äòîåãéí , orehamud- àåøê òîåãä 
;out- îåç÷ ùðé äòîåãéí ùìîòìä åîöééø ùðé òîåãéí ááúçìä ùì ìîèä
DownStart:	pusha
			call deleteRow
			mov cx,orehshura
			add dx,side
			call deleteRow
			mov dx,orehamud
			mov al,amudimcolor
			call drawRow
			sub dx,side
			mov al,amudimcolor
			call drawRow
			add dx,side
			mov xline,cx
			mov yline,dx
			popa
			ret
;-----------------------------------------------------------------------------
;in- yline- ð÷åãú äùåøä ùì òîåãé äùåøåú , xline- ð÷åãú äòîåãä ùì òîåãé äùåøåú , ytop-äúçìú ùåøú äòîåãéí , side- îøç÷ áéï òîåã ìòîåã , amudimcolor- öáò äòîåãéí  
;out- îåç÷ ùåøä àçú åîöééø ùåøä àçøú áî÷åí àçø
Up:	pusha
	mov dx,yline
	mov cx,xline
	sub dx,side
	cmp dx,ytop
	jz Dside
	add dx,side
	call deleteRow
	sub dx,side			
	sub dx,side
	mov al,amudimcolor
	call drawRow
	add dx,side
	mov xline,cx
	mov yline,dx
	popa
	ret
	Dside:
		call DownStart
		popa 
		ret		
;-----------------------------------------------------------------------------
;in- xcol- äî÷åí äàçøåï ùì òîåãé äòîåãéí , ycol- äî÷åí äàçøåï ùì ùåøú äòîåãéí , side- îøç÷ áéï òîåã ìòîåã , orehshura- àåøê ùåøä , amudimcolor- öáò äòîåãéí
;out- îåç÷ òîåãä åîöééø òîåãä çãùä áî÷åí àçø 
Right:	pusha
		mov cx,xcol
		mov dx,ycol
		cmp cx,orehshura
		jz LSide
		sub cx,side
		call deleteCol
		add cx,side
		add cx,side
		mov al,amudimcolor
		call drawCol
		mov xcol,cx
		mov ycol,dx
		popa
		ret
	LSide:
		call leftstart
		popa
		ret
;-----------------------------------------------------------------------------
;in al- ëéååï äúæåæä
;out
movement:	
		pusha
		mov ah,0
		int 16h
		mov ok,al
		cmp al,' '
		jz cheak
		cmp al,13
		jz cheak
		cmp ah,75
		jz l
		cmp ah,77
		jz R
		cmp ah,80
		jz D
		cmp ah,72
		jz U
		jmp return
	cheak:	;Cheak if the ball is in there
		call cheakPlace
		cmp ok,1
		jnz noRand
		call delPic
		call RandomPlace
	noRand:	
		jmp return
	R:		;move Right
		call ifRandPlace	
		call Right
		jmp return
	l:      ;move Left
		call ifRandPlace
		call Left
		jmp return
	D:      ;move Down 
		call ifRandPlace
		call Down
		jmp return 
	U:		;move up
		call ifRandPlace
		call Up
	return:
		call showTime
		popa
		ret
;-----------------------------------------------------------------------------
;in- num- îñôø , ax- î÷áì îñôø øðãåîìé
;out-úùåáä äàí ìäçìéó î÷åí ùì äúîåðä àí ëï îåç÷ àú àú äúîåðä ä÷åãîú åîöééø àú äúîåðä áî÷åí äçãù äøðãåîìé
ifRandPlace:pusha
			mov dx,0
			in al,40h
			div num
			mov bx,dx
			mov dx,0
			in al,40h
			div num
			cmp dx,bx
			jnz sof
			call delPic
			call RandomPlace
		sof:
			popa
			ret
;-----------------------------------------------------------------------------
;in- (x1,y1)-äî÷åí ùì äúîåðä ìîìòìä á÷öä äùîàìé ùì äèáìä , m_amudot-îñôø äòîåãåú , m_shurot-îñôø ùåøåú , side-îøç÷ áéï òîåã ìòîåã
;out-îöééø àú äúîåðä áî÷åí äøðãåîìé
RandomPlace:pusha
			mov bx,x1
			mov x,bx
			mov bx,y1
			mov y,bx
			mov dx,0
			in al,40h
			div m_amudot
			mov ax,dx
			mul side
			add x,ax
			in al,40h
			div m_shurot
			mov ax,dx
			mul side
			add y,ax
			call loadpic
			call drawpic
			popa
			ret	
;-----------------------------------------------------------------------------
;in-
;out-
delPic:
		pusha
		mov dx,y
		mov al,0
		mov cx,x
	delLines:
		call putpixel
		inc cx
		cmp cx,xb
		jnz delLines
		mov cx,x
		inc dx
		cmp dx,yb
		jnz delLines
		popa
		ret
;------------------------------------------------------------------------
; in: al-the number of the picture to draw
; out: lea the right picture
	loadpic:
				cmp al,'1'
				lea si,pic1
				ret			
;------------------------------------------------------------------------
;in:
;out:	
	drawpic:       ;in: (x,y) , si
	pusha
			mov dx,y			; xb=x+ysize
			mov cx,x			; yb=y+xsize
			mov yb,dx
			mov xb,cx
			mov bx,picysize
			add yb,bx
			mov bx,picxsize
			add xb,bx
	cycle:
			mov al,[si]			;lokhim zeva mesauyam be makom si memaarah shel zvaim shel solder
			call putpixel		;in: (dx,cx), al-collor; out: pixel
			inc si				;zeva haba memaarah zvaim shel pic
			inc cx				;raz lefi amudot be kol shura
			cmp cx,xb			;bdika haim siem shura
			js cycle
			sub cx,picxsize		;makem et cx be thilat ha shura ha baa
			inc dx				;laavor shura
			cmp dx,yb			;bdika im siem picture
			js cycle
	popa
	ret
;------------------------------------------------------------------------------------	
		putpixel:   ; *** the proc need al=color , cx=col, dx= row ***
	pusha
		mov ah,0ch  ;**   ah=0c -> the interupt number    **;
		int 10h
	popa
	ret
end
