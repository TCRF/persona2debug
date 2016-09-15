; Persona 2 debug patch for Eternal Punishment (JP ver.)
;
; Author: Revenant (d@revenant1.net)
; Date: 9 Sep 2016
; https://tcrf.net

.psx

MainFileName           equ "SLPS_028.25"

; overlay number for the debug menu
DebugOverlayNum        equ 1 ; /D/F0001.BIN
ShopOverlayName        equ "D/F0018.BIN"

; address that the debug menu overlay is loaded to
OverlayAddr            equ 0x80093000

; where a jump to new code is inserted in main game loop
MainGameLoop           equ 0x800235E0
; where a jump to new code is inserted in controller read func
ReadInputPatch         equ 0x80025A8C
; end of loop that copies current shop menu items
EndGetShopPatch        equ (OverlayAddr + 0xB10)
; where new code is inserted (right before OverlayAddr)
PatchAddr              equ (OverlayAddr - 256)

; (relative to GP register) flag set when Sel+Start pressed
DebugKeyFlag           equ 0xF0

; region of RAM where game state info is located
GameStatePointer       equ 0x8007D1E8
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
.definelabel EndMainLoop,            0x80023794
.definelabel InitGame,               0x800237D4
.definelabel NormalGamestate,        0x800235E8

; function to load overlays (a0 = overlay num, a1 = address)
.definelabel LoadOverlay,            0x800272D0

; debug menu function
.definelabel DebugMenu,              (OverlayAddr + 0x1D30)
; call this after DebugMenu returns to execute the user's selection
.definelabel DebugMenuCallback,      0x8007CA98
.definelabel DebugMenuCallbackParam, 0x8007CAA0

.include "persona2_debugmain.asm"
