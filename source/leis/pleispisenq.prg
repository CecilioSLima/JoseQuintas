/*
PLEISPISENQ - ENQUADRAMENTO DE PIS/COFINS
2013.01.15 - Jos� Quintas

...
2016.08.26.1830 - Mensagem ref c�digo conforme CST
*/

#include "josequintas.ch"
#include "inkey.ch"
#include "hbclass.ch"

PROCEDURE pLeisPisEnq

   LOCAL oFrm := AUXPISENQClass():New()
   MEMVAR m_Prog

   IF ! AbreArquivos( "jptabel" )
      RETURN
   ENDIF
   SELECT jptabel
   SET FILTER TO jptabel->axTabela == AUX_PISENQ
   oFrm:Execute()
   CLOSE DATABASES

   RETURN

CREATE CLASS AUXPISENQClass INHERIT AUXILIARClass

   VAR  cTabelaAuxiliar INIT AUX_PISENQ
   METHOD Especifico( lExiste )
   METHOD Valida( cCodigo, cCst )

   ENDCLASS

METHOD Especifico( lExiste ) CLASS AUXPISENQClass

   LOCAL GetList := {}
   LOCAL maxCodigo := jptabel->axCodigo

   IF ::cOpc == "I"
      maxCodigo := Space(6)
   ENDIF
   @ Row() + 1, 22 GET maxCodigo PICTURE "@K 99.999" VALID Val( maxCodigo ) > 0
   @ Row() + 5, 22 SAY "C�digo composto de CST + C�digo de enquadramento"
   Mensagem( "Digite c�digo para cadastro, F9 pesquisa, ESC sai" )
   READ
   Mensagem()
   IF LastKey() == K_ESC
      GOTO ::nUltRec
      RETURN .F.
   ENDIF
   IF ! Encontra( AUX_PISENQ + Substr( maxCodigo, 1, 2 ), "jptabel", "numlan" )
      MsgStop( "CST de PIS/Cofins (Primeiros dois d�gitos) inv�lidos!" )
      RETURN .F.
   ENDIF
   SEEK AUX_PISENQ + maxCodigo
   IF ! ::EspecificoExiste( lExiste, Eof() )
      RETURN .F.
   ENDIF
   ::axKeyValue := { maxCodigo }

   RETURN .T.

METHOD Valida( cCodigo, cCst ) CLASS AUXPISENQClass

   IF cCodigo == "999"
      RETURN .T.
   ENDIF
   IF ! Encontra( AUX_PISENQ + cCst + "." + cCodigo, "jptabel", "numlan" )
      MsgStop( "C�digo de enquadramento Pis/Cofins inexistente ou inv�lido pra CST!" )
      RETURN .F.
   ENDIF
   @ Row(), 32 SAY jptabel->axDescri

   RETURN .T.
