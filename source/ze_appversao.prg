/*
ZE_APPVERSAO
Jos� Quintas
*/

FUNCTION AppVersaoDbfAnt( xValue )

   STATIC AppVersaoDbfAnt := 0

   IF xValue != NIL
      AppVersaoDbfAnt := xValue
   ENDIF

   RETURN AppVersaoDbfAnt
