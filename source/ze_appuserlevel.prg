/*
ZE_APPUSERLEVEL
Jos� Quintas
*/

FUNCTION AppUserLevel( xValue )

   STATIC AppUserLevel := 2

   IF xValue != NIL
      AppUserLevel := xValue
   ENDIF

   RETURN AppUserLevel

