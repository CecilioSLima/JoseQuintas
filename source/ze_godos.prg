/*
ZE_GODOS
Jos� Quintas
*/

FUNCTION GoDos()

   IF AppUserLevel() == 0
      ShellExecuteOpen( GetEnv( "COMSPEC" ) )
   ENDIF

   RETURN NIL

