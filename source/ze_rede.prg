/*
ZE_REDE - ROTINAS PARA USO EM REDE
1995.04 Jos� Quintas
*/

#include "inkey.ch"

FUNCTION RecLock( lForever )

   LOCAL nCont := 1

   hb_Default( @lForever, .T. )
   wSave( MaxRow() - 1, 0, MaxRow(), MaxCol() )
   DO WHILE .T.
      IF rLock()
         EXIT
      ENDIF
      Mensagem( "Aguardando libera��o do registro em " + Alias() + "... Tentativa " + lTrim( Str( nCont ) ) + iif( lForever, "", ". ESC cancela" ) )
      IF Inkey( 0.5 ) == K_ESC .AND. ! lForever
         EXIT
      ENDIF
      nCont += 1
   ENDDO
   WRestore()
   SKIP 0

   RETURN ( rLock() )

FUNCTION RecAppend( lForever )

   LOCAL nCont := 1, lOk := .F.

   hb_Default( @lForever, .T. )
   wSave( MaxRow()-1, 0, MaxRow(), MaxCol() )
   DO WHILE .T.
      APPEND BLANK
      IF ! NetErr()
         lOk := .T.
         RecLock()
         EXIT
      ENDIF
      Mensagem( "Aguardando libera��o do arquivo: " + Alias() + "... Tentativa " + LTrim( Str( nCont ) ) + iif( lForever, "", ". ESC cancela" ) )
      IF Inkey( 0.5 ) == K_ESC .AND. ! lForever
         EXIT
      ENDIF
      nCont += 1
   ENDDO
   WRestore()
   SKIP 0

   RETURN lOk

FUNCTION RecDelete( lForever )

   LOCAL lOk := .F.

   hb_Default( @lForever, .T. )
   IF RecLock( lForever )
      DELETE
      RecUnlock()
      lOk := .T.
   ENDIF

   RETURN lOk

FUNCTION RecUnlock()

   SKIP 0
   UNLOCK

   RETURN NIL
