/*
ZE_GETSECRET
Jos� Quintas
*/

#include "inkey.ch"

FUNCTION GetSecret( nRow, nCol, nLen )

   LOCAL cText, nKey

   hb_Default( @nLen, 20 )

   @ nRow, nCol SAY Replicate( "*", nLen )
   cText = ""
   DO WHILE .T.
      @ nRow, nCol + Len( cText ) SAY ""
      nKey := Inkey(600)
      DO CASE
      CASE nKey == 0
         QUIT // KEYBOARD Chr( K_ESC ) + "S"
      CASE nKey == K_RBUTTONDOWN
         KEYBOARD Chr( K_ESC )
      CASE nKey < 1 .OR. nKey > 126
         LOOP
      CASE nKey == K_ENTER
         cText := Pad( cText, 20 )
         EXIT
      CASE nKey = K_ESC
         EXIT
      CASE nKey == K_BS .OR. nKey == K_LEFT
         IF Len( cText ) > 0
            cText := Substr( cText, 1, Len( cText ) - 1 )
         ENDIF
      CASE Len( cText ) == nLen
      OTHERWISE
         cText += Upper( Chr( nKey ) )
      ENDCASE
   ENDDO

   RETURN cText

