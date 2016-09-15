; Persona 2 debug patch for Eternal Punishment (US ver.)
;
; Author: Revenant (d@revenant1.net)
; Date: 8 Sep 2016
; https://tcrf.net

.psx

MainFileName           equ "SLUS_011.58"

; overlay number for the debug menu
DebugOverlayNum        equ 1 ; /D/F0001.BIN
ShopOverlayName        equ "D/F0018.BIN"

; address that the debug menu overlay is loaded to
OverlayAddr            equ 0x80097000

; where a jump to new code is inserted in main game loop
MainGameLoop           equ 0x80023894
; where a jump to new code is inserted in controller read func
ReadInputPatch         equ 0x80025D40
; end of loop that copies current shop menu items
EndGetShopPatch        equ (OverlayAddr + 0xB10)
; where new code is inserted (right before OverlayAddr)
PatchAddr              equ (OverlayAddr - 256)

; (relative to GP register) flag set when Sel+Start pressed
DebugKeyFlag           equ 0xF4

; region of RAM where game state info is located
GameStatePointer       equ 0x8007E908
CurrGameState          equ 0x10B0 ; relative to GameStatePointer

; game state value representing the debug menu
DebugGamestate         equ -2

; value of stack pointer during main game loop 
; (to force return when debug menu is activated)
RestoreStackValue      equ 0x807FFF90

; shop menu items
ShopMenuDebugOption    equ 0x1C
ShopMenuEnd            equ 0x1E

; some points of interest in the main game loop
.definelabel EndMainLoop,            0x80023A48
.definelabel InitGame,               0x80023A88
.definelabel NormalGamestate,        0x8002389C

; function to load overlays (a0 = overlay num, a1 = address)
.definelabel LoadOverlay,            0x80027584

; debug menu function
.definelabel DebugMenu,              (OverlayAddr + 0x1D90)
; call this after DebugMenu returns to execute the user's selection
.definelabel DebugMenuCallback,      0x8007E1B8
.definelabel DebugMenuCallbackParam, 0x8007E1C0

.include "persona2_debugmain.asm"
