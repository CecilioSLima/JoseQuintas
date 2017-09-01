/*
ZE_APP
Jos� Quintas
*/

FUNCTION AppEmpresaNome( xValue )

   STATIC AppEmpresaNome := ""

   IF xValue != NIL
      AppEmpresaNome := Trim( xValue )
   ENDIF

   RETURN AppEmpresaNome

FUNCTION AppEmpresaApelido( xValue )

   STATIC AppEmpresaApelido := ""

   IF xValue != NIL
      AppEmpresaApelido := Trim( xValue )
   ENDIF

   RETURN AppEmpresaApelido

FUNCTION AppUserName( xValue )

   STATIC AppUserName := "JPA"

   IF xValue != NIL
      AppUserName := Trim( xValue )
   ENDIF

   RETURN AppUserName

FUNCTION AppUserLevel( xValue )

   STATIC AppUserLevel := 2

   IF xValue != NIL
      AppUserLevel := xValue
   ENDIF

   RETURN AppUserLevel

FUNCTION AppVersaoDbfAnt( xValue )

   STATIC AppVersaoDbfAnt := 0

   IF xValue != NIL
      AppVersaoDbfAnt := xValue
   ENDIF

   RETURN AppVersaoDbfAnt

FUNCTION AppMenuWindows( xValue )

   STATIC AppMenuWindows := .F.

   IF xValue != NIL
      AppMenuWindows := xValue
   ENDIF

   RETURN AppMenuWindows

FUNCTION AppIsMultithread( xValue )

   STATIC AppIsMultithread := .F.

   IF xValue != NIL
      AppIsMultithread := xValue
   ENDIF

   RETURN AppIsMultithread

PROCEDURE ChangeMultiThread

   AppIsMultithread( ! AppIsMultiThread() )
   MsgExclamation( "Alterado para modo " + iif( AppIsMultithread(), "multijanelas", "monojanela" ) )

   RETURN
