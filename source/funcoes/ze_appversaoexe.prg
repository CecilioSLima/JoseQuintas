/*
ZE_APPVERSAOEXE
Jos� Quintas
*/

FUNCTION AppVersaoExe( xValue )

   STATIC AppVersaoExe := ""

   IF xValue != NIL
      AppVersaoExe := xValue
   ENDIF

   RETURN AppVersaoExe

