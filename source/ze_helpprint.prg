/*
ZE_HELPPRINT - Imprime manual do sistema
José Quintas

2018.01.31 Nome do arquivo de help
*/

PROCEDURE ze_HelpPrint

   LOCAL cText, cModulo, nTotal, nAtual := 0, cDescri, cnInternet := ADOClass():New( AppcnInternet() )
   LOCAL oPDF := PDFClass():New(), nPos, aText, acMenu, oElement

   IF ! MsgYesNo( "Gera PDF?" )
      RETURN
   ENDIF
   cnInternet:Open()
   cnInternet:cSql := "UPDATE WEBHELP SET HLEXISTE = 'N' WHERE HLMODULO <> 'JPA'"
   cnInternet:Execute()
   oPDF:acHeader := { "HELP DO SISTEMA", "" }
   oPDF:nPrinterType := 2
   oPDF:Begin()
   acMenu := OpcoesDoMenu( cnInternet )
   oPDF:MaxRowTest()
   oPDF:DrawZebrado(2)
   oPDF:DrawText( oPDF:nRow, 0, "OPÇÕES DO MENU/ÍNDICE" )
   oPDF:nRow += 2
   FOR EACH oElement IN acMenu
      oPDF:MaxRowTest()
      oPDF:DrawText( oPDF:nRow++, 0, oElement )
   NEXT
   oPDF:MaxRowTest( 1000 )
   cnInternet:cSql := "SELECT COUNT(*) AS QTD FROM WEBHELP WHERE HLOLD='N'"
   cnInternet:Execute()
   nTotal := cnInternet:NumberSql( "QTD" )
   cnInternet:CloseRecordset()
   cnInternet:cSql := "SELECT * FROM WEBHELP WHERE HLOLD='N' ORDER BY HLMODULO"
   cnInternet:Execute()
   GrafTempo( "Gerando manual em PDF" )
   DO WHILE ! cnInternet:Eof()
      GrafTempo( nAtual++, nTotal )
      cModulo := cnInternet:StringSql( "HLMODULO" )
      cDescri := cnInternet:StringSql( "HLDESCRICAO" )
      cText   := cnInternet:StringSql( "HLTEXTO" )
      IF Empty( cText )
         cnInternet:MoveNext()
         LOOP
      ENDIF
      oPDF:nRow += 2
      oPDF:MaxRowTest()
      oPDF:DrawZebrado(2)
      oPDF:DrawText( oPDF:nRow, 0, cModulo + " - " + cDescri )
      oPDF:nRow += 2
      DO WHILE Len( cText ) > 0
         oPDF:MaxRowTest(2)
         nPos := At( hb_eol(), cText + hb_eol() )
         aText := TextToArray( Substr( cText, 1, nPos - 1 ), oPDF:MaxCol )
         FOR EACH oElement IN aText
            oPDF:DrawText( oPDF:nRow, 0, oElement )
            oPDF:nRow += 1
         NEXT
         cText := Substr( cText, nPos )
         IF Left( cText, 2 ) == hb_eol()
            cText := Substr( cText, 3 )
         ENDIF
      ENDDO
      cnInternet:MoveNext()
   ENDDO
   cnInternet:CloseRecordset()
   cnInternet:CloseConnection()
   oPDF:End()

   RETURN

STATIC FUNCTION OpcoesDoMenu( cnInternet )

   LOCAL mOpcoes, acMenu := {}

   mOpcoes := MenuCria()
   ListaOpcoes( mOpcoes,,, acMenu, cnInternet )

   RETURN acMenu

STATIC FUNCTION ListaOpcoes( mOpcoes, nLevel, cSelecao, acMenu, cnInternet )

   LOCAL cModule, cDescription, oElement, nNumOpcao

   hb_Default( @nLevel, 0 )
   hb_Default( @cSelecao, "" )
   nLevel    := nLevel + 1
   nNumOpcao := 1

   FOR EACH oElement IN mOpcoes
      cModule := oElement[ 3 ]
      IF ValType( cModule ) != "C"
         cModule := ""
      ENDIF
      cDescription := oElement[ 1 ]
      AAdd( acMenu, Pad( cSelecao + StrZero( nNumOpcao, 2 ) + ".", 15 ) + Space( nLevel * 3 ) + cDescription + iif( Len( cModule ) !=  0, " (" + oElement[ 3 ] + ")", "" ) )
      IF ! Empty( cModule )
         cnInternet:cSql := "UPDATE WEBHELP SET HLEXISTE='S', HLDESCRICAO=" + StringSql( cDescription ) + " WHERE HLMODULO=" + StringSql( AllTrim( cModule ) )
         cnInternet:ExecuteCmd()
      ENDIF
      IF Len( oElement[ 2 ] ) != 0
         ListaOpcoes( oElement[ 2 ], nLevel, cSelecao + StrZero( nNumOpcao, 2 ) + ".", acMenu, cnInternet )
      ENDIF
      nNumOpcao += 1
   NEXT

   RETURN NIL
