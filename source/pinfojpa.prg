/*
PINFOJPA - SOBRE O JPA
2012 Jos� Quintas
*/

#include "hbgtinfo.ch"
#include "hbmemory.ch"

FUNCTION pInfoJPA()

   LOCAL cText := "", cExeName, nThreads := 0

   cExeName := Upper( hb_FNameName( hb_ProgName() ) ) + ".EXE"
   cText += cExeName + ": " + AppVersaoExe() + hb_eol()
   IF File( "jpconfi.dbf" )
      cText += "Base de Dados: " + Transform( LeCnf( "VERSAO" ), "@R 9999.99.99" ) + hb_eol()
   ENDIF
   cText += "Hardware: " + DriveSerial() + hb_eol()
   cText += Version() + hb_eol()
   cText += HB_Compiler() + hb_eol()
   cText += "Available Memory: " + LTrim( Transform( Memory(0) / 1000, "999,999" ) ) + " MB" + hb_eol()
   cText += "Window Size (Row/Col): " + LTrim( Str( MaxRow() + 1 ) ) + " x " + LTrim( Str( MaxCol() + 1 ) ) + hb_eol()
   cText += "Window Size (Pixels): " + Ltrim( Str( hb_gtInfo( HB_GTI_SCREENWIDTH ) ) ) + " x " + ;
            Ltrim( Str( hb_gtInfo( HB_GTI_SCREENHEIGHT ) ) ) + hb_Eol()
   IF HB_GtInfo( HB_GTI_FONTNAME ) != NIL
      cText += "Font Name: " + HB_GTINFO( HB_GTI_FONTNAME ) + hb_eol()
      cText += "Font Size: " + LTrim(Str( HB_GTINFO( HB_GTI_FONTSIZE ) ) ) + " x " + LTrim( Str( HB_GTINFO( HB_GTI_FONTWIDTH ) ) ) + " x " + LTrim( Str( HB_GTINFO( HB_GTI_FONTWEIGHT ) ) ) + hb_eol()
   ENDIF
   cText += "Temp Path: " + AppTempPath() + hb_eol()
   cText += "Terminal Server Client: " + iif( win_OsIsTsClient(), "Yes", "No" ) + hb_eol()
   __vmCountThreads( @nThreads, 0 )
   cText += "Threads running " + Ltrim( Str( nThreads, 10 ) ) + hb_Eol()
   MsgExclamation( cText )

   RETURN NIL
