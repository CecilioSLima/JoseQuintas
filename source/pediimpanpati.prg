/*
PEDIIMPANPCNAE - IMPORTA T002 - ATIVIDADE ANP (CNAE)
2015.01 Jos� Quintas
*/

#include "josequintas.ch"

PROCEDURE pEdiImpAnpAti

   LOCAL matCnae, matDescri
   LOCAL cnInternet := ADOClass():New( AppcnInternet() )
   LOCAL cnExcel, nQtd, cSheetName, mFiles, mFileExcel, nQtdTotal, cTxt := "", lBegin := .T., mValDe, mValAte

   mFiles := Directory( "IMPORTA\T002*.XLS" )

   IF Len( mFiles ) = 0
      MsgStop( "Planilha ANP T002 n�o encontrada na pasta IMPORTA\" )
      RETURN
   ENDIF

   mFileExcel := hb_cwd() + "IMPORTA\" + mFiles[ 1, 1 ]
   SayScroll( mFileExcel )

   IF ! MsgYesNo( "Confirma processo?" )
      RETURN
   ENDIF

   cnInternet:Open()
   SayScroll( "Importando dados" )

   cnExcel := ADOClass():New( ExcelConnection( mFileExcel ) )
   cnExcel:Open()

   cnInternet:ExecuteCmd( "TRUNCATE TABLE JPTABANPATI" )

   cSheetName := "[AtividadeEconomica$]"

   cnExcel:cSql := "SELECT COUNT(*) AS QTD FROM " + cSheetName
   cnExcel:Execute()
   nQtdTotal := cnExcel:NumberSql( "QTD" )
   cnExcel:CloseRecordset()

   cnExcel:cSql := "SELECT COUNT(*) AS QTD FROM " + cSheetName
   cnExcel:Execute()
   nQtdTotal := nQtdTotal + cnExcel:NumberSql( "QTD" )
   cnExcel:CloseRecordset()

   nQtd := 0

   GrafTempo( "Importando CNAE" )

   cnExcel:cSql := "select * from " + cSheetName
   cnExcel:Execute()

   cnExcel:MoveFirst()
   cnExcel:MoveNext() // pula titulo
   DO WHILE ! cnExcel:Eof()
      GrafTempo( nQtd, nQtdTotal )
      nQtd += 1
      matCnae   := StrZero( Val( cnExcel:StringSql( 0 ) ), 5 )
      matDescri := Trim( cnExcel:StringSql( 1 ) )
      mValDe    := cnExcel:StringSql( 2 )
      mValAte   := cnExcel:StringSql( 3 )
      IF Val( matCnae ) != 0
         IF Len( cTxt ) == 0
            cTxt += "INSERT IGNORE INTO JPTABANPATI ( ATCNAE, ATDESCRI, ATVALDE, ATVALATE ) VALUES "
            lBegin := .T.
         ENDIF
         IF ! lBegin
            cTxt += ", "
         ENDIF
         LBegin := .F.
         cnInternet:cSql := "(" + StringSql( matCnae ) + "," + StringSql( TiraAcento( Pad( matDescri ), 100 ) ) + "," + StringSql( mValDe ) + "," + StringSql( mValAte ) + ")"
         cTxt += cnInternet:cSql
         IF Len( cTxt ) > MYSQL_MAX_CMDINSERT
            cnInternet:ExecuteCmd( cTxt )
            cTxt := ""
         ENDIF
      ENDIF
      cnExcel:MoveNext()
   ENDDO
   cnExcel:CloseRecordset()
   cnExcel:CloseConnection()
   IF Len( cTxt ) != 0
      cnInternet:ExecuteCmd( cTxt )
   ENDIF
   cnInternet:CloseConnection()
   MsgExclamation( "Fim da importa��o! Verificados " + LTrim( Str( nQtd ) ) + " CNAEs" )

   RETURN
