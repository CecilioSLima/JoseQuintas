/*
ZE_APPUSERNAME
Jos� Quintas
*/

FUNCTION AppUserName( xValue )

   STATIC AppUserName := "JPA"

   IF xValue != NIL
      AppUserName := Trim( xValue )
   ENDIF

   RETURN AppUserName

