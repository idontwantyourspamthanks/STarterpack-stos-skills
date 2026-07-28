Errata:

p47 - It's RIGHT$ - given left$ is that way and everywhere else in the RIGHT$ listing uses the $.
p49 - I already answered this to GLM but sounds like it didn't relay that info - instr("STOS Basic","STOS") - 1 is correct, 6 is not.
p49 - Yep, quotes going missing a lot - common sense is good. Though in this case it's the book missing it rather than the OCR. Start quote required.
p50 Line should be... print "Word number ", I;" = ";mid$(P$,P,L) : P=P+1 : inc I
p52 I checked running in STOS - listbanks is a syntax error, listbank does not, so it's listbank
p52 I checked running in STOS - HEXA is the valid version.
p53 see p52 comments
p53 RESERVE - comma shouldn't be there
p55 In the page-055.txt print start<10) should be print start(10) but I have no idea what you're on about with your comment.
p57 The restored looks fine
p61 That's fine - I don't think STOS minds spacing tbh but it's fine
p62 Interesting - not sure how an invented phrase got there but good work removing it. Happy also with the ACCLOAD and ACCNEW.

p91 Before we continue let's look at how this works.. the movements both have a sprite ID and then a movement string that defines behaviour. It's made up of:
 - speed (50=1s, 100=2s, etc per movement)
 - step - how many pixels to move
 - count how many steps in a movement
 - We can have multiple movements carried out sequentially by wrapping each movement in brackets
 - L at the end of a given movement makes it loop
 - E100 will stop the sprite when it reaches a specific position on the screen (ie 100) - if we skip past due to badly chosen increment it won't trigger
 
I've pasted an online STOS sprites guide into this folder as sprites-guide.md which may help.

MOVE X the first example - so the sprite is created with SPRITE n,x,y,p meaning we have sprite 1 at 100,100. Then we move sprite X every frame, 5 px, 30 times (so it'll move 150px total thus getting to 250). L100 maybe means loop 100 times?

MOVE X the second example (the one you cite) starts in the same place, and yet the comment says it's off screen. I think maybe x should be -100 here. The move x line then I'm not sure what the 100 outside of the brackets is for. Tbh the whole line is a mystery to me. Loops 200 times I guess? It's a mess and we should probably just not reference it, ever.

MOVE Y the example starts with a sprite at 100,10. Again we have a move with a 10 at the start of the movestring and I can't find anything online anywhere to explain what it might be, most things suggesting it would be an error. Let's just say then that the first move line is no good and we should ignore it. My best guess at an interpretation assuming the 10 shouldn't be there is we start at y 10, move by 1px 180 times, which takes us to 190, and the L with no number means infinitely looping.

The second where a sprite starts at 100,100 and we have a movmement that has two moves in brackets makes more sense - we move (1,4,25) which means a fast move 4px at a time 25 times (so 100 px total) followed by the reverse. This is fine.

I think the wisest thing to do is to keep the two good moves and ignore the ones with a number in the quotes before a bracket as there's no useful documentation for their intent.

p93 - yep, I'm with you. It should be move on and not menu on.
p95 - I've gone through page-095.txt and corrected a few errors on there - and yes the correction you made is correct. There were also a few misplaced . instead of , and brackets changed to other things.
p97 It's image 5
AUTOBACK p107-108 I tested in STOS and it's without the space
UPDATE p108 Thank you
UPDATE p109 Yeah it should be move x 1"(1, 1, 100)(1, -1, 100)L": rem....
UPDATE p109 I think update has 3 forms - update on, update off and update - all are ok in STOS, I just ran to check, and I think maybe update just uses the default of on.

PLAY p111 should be click on
VOICE p115 Yeah should be Restarts some music halted by the VOICE OFF instructions. No proofreading in that manual whatsoever.
TRANSPOSE p114 should read A df increment of 1. I think it scanned that way and I manually fixed it.
SHOOT p124 The book had click off which was erroneous and I corrected it in the text in the page-124.txt file.
ENVEL p125 says 66535 on the actual book, a typo, vs the 65535 it should be. Re the line merging - that's a typo and wouldn't work - should be a separate line. Splitting is correct.
NOISE p125 Should indeed be 30 noise I.
ENVEL p126 Don't think the trailing space matters

COLOUR p129 there were a few things wrong with the txt file here - I've fixed mco! to be mcol, swapped the l for an I in for I=0 to and HEX$(colour(I) and so on.
RBOX p131 good stuff
PAINT p134 the manual does actually say ink 3 ink 3 but I think that's an error so yeah ink 3 is probably sufficient.
POLYGON p135 happy with that
EARC p133 happy with that
PIE p136 Also happy with that
ELLIPSE p136 Good stuff - new is actually the command you enter to clear before typing a new listing btw
EPIE p137 epie is indeed correct
SET PAINT p138 good
SET PATTERN p139 I think the book is wrong here - the SPB= line is followed by a rem and then the POS setting on 130 - nothing happens between so it's not like we're reasserting POS, so I'm happy to remove it from 110.
FLASH p139 happy with that
GR WRITING p141 I'd say it should be I for no i exists and we're discussing 4 modes.
POLYMARK p141 Verbatim is good.
SET MARK p142 Good stuff
DIVX p144 should be COLS upper case
CLIP p144 good.

LOGIC p147 It's a comment so doesn't matter too much but a . is correct
SCREEN SWAP p147 The code is..
  60 polygon X1+I-8,Y1 to X2+I-8,Y2 to X3+I-8,Y3 to X1+I-8,Y1
RESERVE AS DATASCREEN p148 Should be "reserve as datascreen" - the other version gives a syntax error when I try it
GET PALETTE 149-150 ok
ZOOM p150 - 120 zoom physical ,Y1,X2,Y2 to X3,Y2,X4,Y4 should read 120 zoom physic,X1,Y1,X2,Y2 to X3,Y2,X4,Y4 and I've just added a b scan for further checks
ZOOM p151 250 until M<>0:rem click on a mouse button on exit
SCREEN COPY p153 good
SCREEN$ p155 should say SCREEN$ and line 50 is P$(X,Y)=screen$(back,X*32,Y*32 to (X+1)*32,(X+1)*32 according to the book, but I do think the second (X+1)*32 should be (Y+1)*32 since we're dealing with the Y co-ordinate
DEF SCROLL/SCROLL - good
SYNCHRO p158 - good
UNPACK p159 - Should indeed be load "backgrnd.mbk":rem Load a compressed screen saved in bank 5
FADE p161 Those were valid typo fixes - whoever wrote this manual can't spell for shit. The lines that got numbers added - your correction is correct as I think these are meant to be typed in direct mode to experiment.

ICON$ p179 Let's keep it ICON$ - we don't want print quirks, we want accurate information we can give an AI working on this stuff.
UNDER ON/OFF p164 yep, should be INVERSE. Again we want the working version, not the print quirk.
WINDOW p172 I checked in STOS and windcopy is correct.
CURS ON/FF p169 I think the manual plays fast and loose with terms - a function and a command in the 80s were likely used interchangeably.
IF THEN ELSE p193-4 we are indeed missing a page - I've obtained page-193.b.png to fill that gap.
FOR NEXT p191 yeah that should indeed be an I - weird book typo
OPEN p206 Should indeed be next I - we want accurate, not quirk
USING p202 the ; is correct.
USING p201 the listing is correct - the ~ characters get substituted with characters from the word "Small". The output string should capitalise the S.
FKEY p198 yep, should be depending on. This kind of common sense I just expect you to do and not mention.
DRVMAP p213 Good correction - OCR failed
GET p209 ok

RESTORE p226-7 ok
DEG p209 The invented syntax is correct and with a radian being 57 degrees let's make sure our skill reflects that truth and not the error in the manual
RAD p209 Same deal
RND p215 Split is good
AREG and DREG p253 There are 8 address registers and 8 data registers so both should go from 0 to 7.
CALL p252 There are 8 registers.
COLLIDE p102 upper case L is indeed correct
PUT SPRITE p105 same again with the E. It might well be that STOS permits lower case but let's keep consistent.
GET SPRITE p106 same again.
PUT SPRITE p105 My feeling is that the 0 doesn't belong.

compiler p12 ok to all
compilor p8 - fine
compiler p9 - fine
compiler p17 fine

Errata appendix b aggre pic.pil should be pic.pi1.


CORRECTION TO MY OWN NOTES.. the number at the start before brackets in a move string is the optional start position. I'm an idiot.
