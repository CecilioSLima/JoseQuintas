/*
SHOWMAP - Mostra mapa do google
2017.09.01 Jos� Quintas
*/

FUNCTION GoogleMap( aCepList )

   LOCAL oElement, cCmd

   IF Len( aCepList ) == 1
      cCmd := "http://www.google.com.br/maps/place/" + aCepList[ 1 ] + "/"
   ELSE
      cCmd := "http://www.google.com.br/maps/dir/"
      IF Len( aCepList ) > 20
         MsgExclamation( "Limitando a 20 CEPs" )
         ASize( aCepList, 20 )
      ENDIF
      FOR EACH oElement IN aCepList
         cCmd += oElement + "/"
      NEXT
      ShellExecuteOpen( cCmd )
   ENDIF

   RETURN NIL
