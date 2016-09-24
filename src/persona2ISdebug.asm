; Persona 2 debug patch for Innocent Sin (JP ver.)
;
; Author: Revenant (d@revenant1.net)
; Date: 17 Sep 2016
; https://tcrf.net

.psx

MainFileName           equ "SLPS_021.00"

; overlay number for the debug menu
DebugOverlayNum        equ 138 ; /D/F0138.BIN

; address that the debug menu overlay is loaded to
OverlayAddr            equ 0x80093000

; where a jump to new code is inserted in main game loop
; (replaces comparison of gamestate to -4)
MainGameLoop           equ 0x80021468
; where a jump to new code is inserted in controller read func
; (replaces call to nullsub_1)
ReadInputPatch         equ 0x80023708
; where new code is inserted (right before OverlayAddr)
PatchAddr              equ (OverlayAddr - 256)

; (relative to GP register) flag set when Sel+Start pressed
DebugKeyFlag           equ 0x124

; region of RAM where game state info is located
GameStatePointer       equ 0x8007BA50
CurrGameState          equ 0x1098 ; relative to GameStatePointer

; game state value representing the debug menu
DebugGamestate         equ -2

; value of stack pointer during main game loop 
; (to force return when debug menu is activated)
RestoreStackValue      equ 0x807FFF90

; some points of interest in the main game loop
.definelabel EndMainLoop,            0x8002161C ; location of call to DrawSyncCallback
.definelabel InitGame,               0x8002165C ; branched to when gamestate = -4
.definelabel NormalGamestate,        0x80021470 ; after comparison of -4 (and delay slot)

; function to load overlays (a0 = overlay num, a1 = address)
.definelabel LoadOverlay,            0x800249D0

; debug menu function
.definelabel DebugMenu,              (OverlayAddr + 0x1D68)
; call this after DebugMenu returns to execute the user's selection
.definelabel DebugMenuCallback,      0x8007B2F0
.definelabel DebugMenuCallbackParam, 0x8007B2F8

.include "persona2_debugmain.asm"
