/*
ZE_APPMENUWINDOWS
Jos� Quintas
*/

FUNCTION AppMenuWindows( xValue )

   STATIC AppMenuWindows := .F.

   IF xValue != NIL
      AppMenuWindows := xValue
   ENDIF

   RETURN AppMenuWindows

