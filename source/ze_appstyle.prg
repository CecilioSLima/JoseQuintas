/*
ZE_APPSTYLE
Jos� Quintas
*/

FUNCTION AppStyle( xValue )

   STATIC AppStyle := 4 // GUI_TEXTIMAGE

   IF xValue != NIL
      AppStyle := xValue
   ENDIF

   RETURN AppStyle

