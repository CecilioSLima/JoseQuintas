/*
ZE_APPEMPRESANOME
Jos� Quintas
*/

FUNCTION AppEmpresaNome( xValue )

   STATIC AppEmpresaNome := ""

   IF xValue != NIL
      AppEmpresaNome := Trim( xValue )
   ENDIF

   RETURN AppEmpresaNome

