/*
ze_update00 - TODAS AS CONVERSOES
ZE_UPDATE00 Jos� Quintas
*/

#include "josequintas.ch"
#include "directry.ch"

FUNCTION ze_Update00()

   SayScroll()
   SayScroll( "Verificando se h� ajustes adicionais" )
   DelTempFiles()
   IF AppDatabase() != DATABASE_DBF
      RETURN NIL
   ENDIF
   ze_UpdateDbf()
   ze_UpdateMysql()
   IF AppVersaoDbfAnt() < 20170101; ze_Update2016(); ENDIF
   IF AppVersaoDbfAnt() < 20180101; ze_Update2017(); ENDIF

   RETURN NIL
