; Persona 2 debug patch - main code
;
; Author: Revenant (d@revenant1.net)
; Date: 8 Sep 2016
; https://tcrf.net

.open MainFileName, 0x8000F800

; Patch main gamestate loop to handle debug mode value (-2)
.org MainGameLoop
	j      MainLoopPatch
	nop

; Patch input read function to try activating debug mode after select+start flag is checked
; (original code at this address calls an empty function)
.org ReadInputPatch
	jal    CheckDebugKeys
	nop

.org PatchAddr
MainLoopPatch:
	; at this point, a0 = current gamestate, v0 = -4
	; gamestate = -4: init game
	beq    a0, v0, @@InitGame
	li     s3, DebugGamestate
	; gamestate = -2; debug mode
	bne    a0, s3, @@NormalGamestate
	nop
	
	; load debug menu overlay
	li     a1, OverlayAddr
	jal    LoadOverlay
	li     a0, OverlayNum
	
	; start debug menu
	jal    DebugMenu
	nop
	; debug menu returned != 0?
	bnez   v0, @@end
	nop
	
	; call selected debug menu function
	lw     v0, DebugMenuCallback
	lw     a0, DebugMenuCallbackParam
	jalr   v0
	nop
	
@@end:
	j      EndMainLoop
	nop
	
@@InitGame:
	j      InitGame
	nop
	
@@NormalGamestate:
	j      NormalGamestate
	addiu  v0, v1, -4 ; used in original function to determine how to handle current gamestate

CheckDebugKeys:
	lb     a0, DebugKeyFlag(gp) ; this is set by pressing start+select
	nop
	beqz   a0, @@end
	
	li     v0, DebugGamestate
	li     s0, GameStatePointer ; restore this for the main game loop
	sw     v0, CurrGameState(s0)
	
	; mega hack: force a return to the end of the gamestate loop
	; with enough correct register values (s0, s2, and sp)
	li     s2, -1
	li     a0, RestoreStackValue
	li     ra, EndMainLoop
	move   sp, a0
	
@@end:
	jr     ra
	nop

.close
