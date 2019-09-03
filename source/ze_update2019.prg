/*
ZE_UPDATE2019 - Conversões 2019
2019 José Quintas
*/

#include "inkey.ch"
//#include "directry.ch"

FUNCTION ze_Update2019()

   IF AppVersaoDbfAnt() < 20190202.2; Conv0202(); ENDIF
   IF AppVersaoDBFAnt() < 20190510.1; Fixa6Digitos(); ENDIF // Executar mais vezes por precaução
   IF AppVersaoDbfAnt() < 20190902; Apagajpdecret(); ENDIF
   IF .F. .AND. AppVersaoDbfAnt() < 20190511; RenumNota(); ENDIF // Demorado, invalida relatórios/controles
   IF .F. .AND. AppVersaoDbfAnt() < 20190512; RenumEstoq(); ENDIF // Demorado, invalida relatórios/controles
   IF .F. .AND. AppVersaoDbfAnt() < 20190513; RenumFinan(); ENDIF // Demorado, invalida relatórios/controles
   IF .F. .AND. AppVersaoDbfAnt() < 20190511; RenumPedido(); ENDIF // Mais demorado de todos, invalida controles

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

STATIC FUNCTION Fixa6Digitos()

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

STATIC FUNCTION RenumNota()

   LOCAL cNumVelho, cNumNovo := "1", nCont, nAtual, nTotal, nKey
   LOCAL cnMySql := ADOClass():New( AppcnMySqlLocal() )

   IF AppcnMySqlLocal() == NIL
      RETURN NIL
   ENDIF
   SayScroll( "Renumerando lançamentos de notas" )
   IF ! AbreArquivos( "jpnota" )
      RETURN NIL
   ENDIF
   nAtual := 0
   nTotal := LastRec()
   GrafTempo( "notas" )
   FOR nCont = 1 TO nTotal
      GrafTempo( nAtual++, nTotal )
      nKey := Inkey()
      IF nKey == K_ESC
         EXIT
      ENDIF
      cNumNovo := StrZero( nCont, 6 )
      SEEK cNumNovo SOFTSEEK
      cNumVelho := jpnota->nfNumLan
      IF ! Eof() .AND. cNumVelho > cNumNovo
         RecLock()
         REPLACE jpnota->nfNumLan WITH cNumNovo
         RecUnlock()
         cnMySql:cSql := "UPDATE JPREGUSO SET RUCODIGO=" + StringSql( cNumNovo ) + ;
            " WHERE RUARQUIVO='JPNOTA' AND ( RUCODIGO=" + StringSql( cNumVelho ) + ;
            " OR RUCODIGO=" + StringSql( "000" + cNumVelho ) + " )"
         cnMySql:ExecuteCmd()
      ENDIF
   NEXT
   IF nKey != K_ESC
      GravaCnf( "JPNOTA", cNumNovo )
   ENDIF
   CLOSE DATABASES

   RETURN NIL

STATIC FUNCTION RenumEstoq()

   LOCAL cNumVelho, cNumNovo := "1", nCont, nAtual, nTotal, nKey
   LOCAL cnMySql := ADOClass():New( AppcnMySqlLocal() )

   IF AppcnMySqlLocal() == NIL
      RETURN NIL
   ENDIF
   SayScroll( "Renumerando lançamentos de estoque" )
   IF ! AbreArquivos( "jpestoq" )
      RETURN NIL
   ENDIF
   nAtual := 0
   nTotal := LastRec()
   GrafTempo( "estoque" )
   FOR nCont = 1 TO nTotal
      GrafTempo( nAtual++, nTotal )
      nKey := Inkey()
      IF nKey == K_ESC
         EXIT
      ENDIF
      cNumNovo := StrZero( nCont, 6 )
      SEEK cNumNovo SOFTSEEK
      cNumVelho := jpestoq->esNumLan
      IF ! Eof() .AND. cNumVelho > cNumNovo
         RecLock()
         REPLACE jpestoq->esNumLan WITH cNumNovo
         RecUnlock()
         cnMySql:cSql := "UPDATE JPREGUSO SET RUCODIGO=" + StringSql( cNumNovo ) + ;
            " WHERE RUARQUIVO='JPESTOQ' AND ( RUCODIGO=" + StringSql( cNumVelho ) + ;
            " OR RUCODIGO=" + StringSql( "000" + cNumVelho ) + " )"
         cnMySql:ExecuteCmd()
      ENDIF
   NEXT
   IF nKey != K_ESC
      GravaCnf( "JPESTOQ", cNumNovo )
   ENDIF
   CLOSE DATABASES

   RETURN NIL

STATIC FUNCTION RenumFinan()

   LOCAL cNumVelho, cNumNovo := "1", nCont, nAtual, nTotal, nKey
   LOCAL cnMySql := ADOClass():New( AppcnMySqlLocal() )

   IF AppcnMySqlLocal() == NIL
      RETURN NIL
   ENDIF
   SayScroll( "Renumerando lançamentos de financeiro" )
   IF ! AbreArquivos( "jpfinan" )
      RETURN NIL
   ENDIF
   nAtual := 0
   nTotal := LastRec()
   GrafTempo( "jpfinan" )
   FOR nCont = 1 TO nTotal
      GrafTempo( nAtual++, nTotal )
      nKey := Inkey()
      IF nKey == K_ESC
         EXIT
      ENDIF
      cNumNovo := StrZero( nCont, 6 )
      SEEK cNumNovo SOFTSEEK
      cNumVelho := jpfinan->fiNumLan
      IF ! Eof() .AND. cNumVelho > cNumNovo
         RecLock()
         REPLACE jpfinan->fiNumLan WITH cNumNovo
         RecUnlock()
         cnMySql:cSql := "UPDATE JPREGUSO SET RUCODIGO=" + StringSql( cNumNovo ) + ;
            " WHERE RUARQUIVO='JPFINAN' AND ( RUCODIGO=" + StringSql( cNumVelho ) + ;
            " OR RUCODIGO=" + StringSql( "000" + cNumVelho ) + " )"
         cnMySql:ExecuteCmd()
      ENDIF
   NEXT
   IF nKey != K_ESC
      GravaCnf( "JPFINAN", cNumNovo )
   ENDIF
   CLOSE DATABASES

   RETURN NIL

STATIC FUNCTION RenumPedido()

   LOCAL cNumVelho, cNumNovo := "1", nCont, nAtual, nTotal, nKey := 0
   LOCAL cnMySql := ADOClass():New( AppcnMySqlLocal() )

   SayScroll( "Verificando número de pedido inexistente" )
   IF AppcnMySqlLocal() == NIL
      RETURN NIL
   ENDIF
   IF ! AbreArquivos( "jpnota", "jpestoq", "jpfinan", "jpitped", "jppedi" )
      RETURN NIL
   ENDIF
   SayScroll( "Verificando em notas" )
   SELECT jpnota
   GOTO TOP
   nAtual := 0
   nTotal := LastRec()
   GrafTempo( "jpnota" )
   DO WHILE nKey != K_ESC .AND. ! Eof()
      GrafTempo( nAtual++, nTotal )
      nKey := Inkey()
      IF ! Encontra( jpnota->nfPedido, "jppedi", "pedido" )
         RecLock()
         REPLACE jpnota->nfPedido WITH ""
         RecUnlock()
      ENDIF
      SKIP
   ENDDO
   SELECT jpestoq
   GOTO TOP
   SayScroll( "Verificando em estoque" )
   nAtual := 0
   nTotal := LastRec()
   GrafTempo( "jpestoq" )
   DO WHILE nKey != K_ESC .AND. ! Eof()
      GrafTempo( nAtual++, nTotal )
      nKey := Inkey()
      IF ! Encontra( jpestoq->esPedido, "jppedi", "pedido" )
         RecLock()
         REPLACE jpestoq->esPedido WITH ""
         RecUnlock()
      ENDIF
      SKIP
   ENDDO
   SELECT jpfinan
   GOTO TOP
   SayScroll( "Verificando no financeiro" )
   nAtual := 0
   nTotal := LastRec()
   GrafTempo( "jpfinan" )
   DO WHILE nKey != K_ESC .AND. ! Eof()
      GrafTempo( nAtual++, nTotal )
      nKey := Inkey()
      IF ! Encontra( jpfinan->fiPedido, "jppedi", "pedido" )
         RecLock()
         REPLACE jpfinan->fiPedido WITH ""
         RecUnlock()
      ENDIF
      SKIP
   ENDDO
   SELECT jpitped
   GOTO TOP
   SayScroll( "Verificando em itens de pedido" )
   nAtual := 0
   nTotal := LastRec()
   GrafTempo( "jpitped" )
   DO WHILE nKey != K_ESC .AND. ! Eof()
      GrafTempo( nAtual++, nTotal )
      nKey := Inkey()
      IF ! Encontra( jpitped->ipPedido, "jppedi", "pedido" )
         RecLock()
         DELETE
         RecUnlock()
      ENDIF
      SKIP
   ENDDO

   SayScroll( "Renumerando pedidos" )
   SELECT jppedi
   nAtual := 0
   nTotal := LastRec()
   GrafTempo( "pedidos" )
   FOR nCont = 1 TO nTotal
      GrafTempo( nAtual++, nTotal )
      IF nKey == K_ESC
         EXIT
      ENDIF
      nKey := Inkey()
      cNumNovo := StrZero( nCont, 6 )
      SEEK cNumNovo SOFTSEEK
      cNumVelho := jppedi->pdPedido
      IF ! Eof() .AND. cNumVelho > cNumNovo
         SELECT jpitped
         OrdSetFocus( "pedido" )
         DO WHILE .T.
            SEEK cNumVelho
            IF Eof()
               EXIT
            ENDIF
            RecLock()
            REPLACE jpitped->ipPedido WITH cNumNovo
            RecUnlock()
         ENDDO
         SELECT jpfinan
         OrdSetFocus( "pedido" )
         DO WHILE .T.
            SEEK cNumVelho
            IF Eof()
               EXIT
            ENDIF
            RecLock()
            REPLACE jpfinan->fiPedido WITH cNumNovo
            RecUnlock()
         ENDDO
         SELECT jpestoq
         OrdSetFocus( "pedido" )
         DO WHILE .T.
            SEEK cNumVelho
            IF Eof()
               EXIT
            ENDIF
            RecLock()
            REPLACE jpestoq->esPedido WITH cNumNovo
            RecUnlock()
         ENDDO
         SELECT jpnota
         OrdSetFocus( "pedido" )
         DO WHILE .T.
            SEEK cNumVelho
            IF Eof()
               EXIT
            ENDIF
            RecLock()
            REPLACE jpnota->nfPedido WITH cNumNovo
            RecUnlock()
         ENDDO
         SELECT jppedi
         RecLock()
         REPLACE jppedi->pdPedido WITH cNumNovo
         RecUnlock()
         cnMySql:cSql := "UPDATE JPREGUSO SET RUCODIGO=" + StringSql( cNumNovo ) + ;
            " WHERE RUARQUIVO='JPPEDI' AND ( RUCODIGO=" + StringSql( cNumVelho ) + ;
            " OR RUCODIGO=" + StringSql( "000" + cNumVelho ) + " )"
         cnMySql:ExecuteCmd()
         GravaOcorrencia( ,,"Renumerado pedido " + cNumVelho +  " para " + cNumNovo )
      ENDIF
   NEXT
   IF nKey != K_ESC
      GravaCnf( "JPPEDI", cNumNovo )
   ENDIF
   CLOSE DATABASES

   RETURN NIL

STATIC FUNCTION ApagaJpdecret()

   fErase( "jpdecret.dbf" )
   fErase( "jpdecret.cdx" )

   RETURN NIL
