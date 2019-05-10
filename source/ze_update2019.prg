/*
ZE_UPDATE2019 - Conversões 2019
2019 José Quintas
*/

#include "directry.ch"

FUNCTION ze_Update2019()

   IF AppVersaoDbfAnt() < 20190202.2; Conv0202(); ENDIF
   IF AppVersaoDbfAnt() < 20190508; Conv0508(); ENDIF
   IF AppVersaoDBFAnt() < 20190510.1; Conv0510A(); ENDIF
   IF .F. .AND. AppVersaoDbfAnt() < 20190510.1; Conv0510B(); ENDIF

   RETURN NIL

STATIC FUNCTION Conv0202()

   IF ! AbreArquivos( "jptabel" )
      QUIT
   ENDIF
   SET ORDER TO 0
   DO WHILE ! Eof()
      IF jptabel->axTabela == "IPICST" .AND. Len( Trim( jptabel->axCodigo ) ) > 2
         RecLock()
         REPLACE jptabel->axCodigo WITH StrZero( Val( jptabel->axCodigo ), 2 )
         RecUnlock()
      ENDIF
      SKIP
   ENDDO
   CLOSE DATABASES

   RETURN NIL

STATIC FUNCTION Conv0508()

   IF ! "DRICAR" $ AppEmpresaNome()
      RETURN NIL
   ENDIF
   IF ! AbreArquivos( "jpitem" )
      RETURN NIL
   ENDIF
   GOTO TOP
   DO WHILE ! Eof()
      RecLock()
      REPLACE ;
         jpitem->ieRes1 WITH 0, ;
         jpitem->ieRes2 WITH 0, ;
         jpitem->ieRes3 WITH 0
      RecUnlock()
      SKIP
   ENDDO
   CLOSE DATABASES

   RETURN NIL

STATIC FUNCTION Conv0510A()

   LOCAL cnMySql := ADOClass():New( AppcnMySqlLocal() )

   IF AppcnMySqlLocal() == NIL
      RETURN NIL
   ENDIF

   SayScroll( "Fixando numero de lancamento no log para 6 digitos" )
   cnMySql:cSql := "UPDATE JPREGUSO SET RUCODIGO=RIGHT(RUCODIGO,6) " + ;
      "WHERE " + ;
      "RUARQUIVO IN ( 'JPCADAS', 'JPESTOQ', 'JPFINAN', 'JPITEM', 'JPPEDI', 'JPTRANSA' ) " + ;
      "AND LENGTH( RUCODIGO ) > 6"
   cnMySql:ExecuteCmd()

   RETURN NIL

STATIC FUNCTION Conv0510B()

   LOCAL cNumVelho, cNumNovo, nCont, nRecTotal, nQtOk := 0
   LOCAL cnMySql := ADOClass():New( AppcnMySqlLocal() )

   IF AppcnMySqlLocal() == NIL
      RETURN NIL
   ENDIF
   IF ! AbreArquivos( "jpfinan" )
      RETURN NIL
   ENDIF
   nRecTotal := LastRec() + 1000
   GrafTempo( "Ajustando financeiro" )
   FOR nCont = 1 TO nRecTotal
      GrafTempo( nCont, nRecTotal )
      cNumNovo := StrZero( nCont, 6 )
      SEEK cNumNovo SOFTSEEK
      cNumVelho := jpfinan->fiNumLan
      IF ! Eof() .AND. cNumVelho > cNumNovo .AND. Year( jpfinan->fiDatEmi ) < 2019
         RecLock()
         REPLACE jpfinan->fiNumLan WITH cNumNovo
         RecUnlock()
         cnMySql:cSql := "UPDATE JPREGUSO SET RUCODIGO=" + StringSql( cNumNovo ) + ;
            " WHERE RUARQUIVO='JPFINAN' AND RUCODIGO=" + StringSql( cNumVelho )
         cnMySql:ExecuteCmd()
         nQtOk += 1
         IF nQtOk > 10000
            EXIT
         ENDIF
      ENDIF
   NEXT
   CLOSE DATABASES

   RETURN NIL

