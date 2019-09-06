/*
ZE_UPDATE2016 - conversões 2016
2016 José Quintas

2017.12.01 - Considera JPPREHIS somente no MySQL
*/

FUNCTION ze_Update2016()

   Update20160101() // DBFs opcionais com default
   IF AppVersaoDbfAnt() < 20160908; Update20160908();   ENDIF // MYSQL.JPEDICFG
   IF AppVersaoDbfAnt() < 20161209; Update20161209();   ENDIF // Campo CDCONTRIB em MYSQL.JPCADAS

   RETURN NIL

STATIC FUNCTION Update20160101()

   IF AppcnMySqlLocal() == NIL
      JPREGUSOCreateDbf()
      RETURN NIL
   ENDIF
   IF File( "jpreguso.cdx" )
      fErase( "jpreguso.cdx" )
   ENDIF
   IF File( "jpdecret.cdx" )
      fErase( "jpdecret.cdx" )
   ENDIF
   IF File( "jpreguso.dbf" )
//      CopyDbfToMySql( "JPREGUSO", .T. )
      fErase( "jpreguso.dbf" )
   ENDIF
   CLOSE DATABASES

   RETURN NIL

STATIC FUNCTION Update20160908()

   LOCAL lEof, cnMySql := AdoClass():New( AppcnMySqlLocal() )

   IF File( "jpedicfg.cdx" )
      fErase( "jpedicfg.cdx" )
   ENDIF
   IF AppcnMySqlLocal() != NIL
      cnMySql:ExecuteCmd( "ALTER TABLE JPEDICFG MODIFY EDDESEDI VARCHAR(50) NOT NULL DEFAULT ''" )
   ENDIF
   IF File( "jpedicfg.dbf" )
      SayScroll( "Somente em MySQL - JPEDICFG" )
      JPEDICFGCreateDbf()
      USE jpedicfg
      lEof := ( LastRec() < 5 )
      USE
      IF ! lEof
         CopyDbfToMySql( "JPEDICFG", .T. )
      ENDIF
      fErase( "jpedicfg.dbf" )
   ENDIF

   RETURN NIL

STATIC FUNCTION JPEDICFGCreateDbf()

   LOCAL mStruOk

   SayScroll( "JPEDICFG, verificando atualizações" )
   mStruOk := { ;
      { "EDNUMLAN",  "C", 6 }, ;
      { "EDTIPO",    "C", 6 }, ;
      { "EDCODJPA",  "C", 6 }, ;
      { "EDCODEDI1", "C", 20 }, ;
      { "EDCODEDI2", "C", 20 }, ;
      { "EDDESEDI",  "C", 30 }, ;
      { "EDINFINC",  "C", 80 }, ;
      { "EDINFALT",  "C", 80 } }
   IF ! ValidaStru( "jpedicfg", mStruOk )
      MsgStop( "JPEDICFG não disponível!" )
      QUIT
   ENDIF

   RETURN NIL

STATIC FUNCTION Update20161209()

   LOCAL cnMySql := ADOClass():New( AppcnMySqlLocal() )

   IF AppcnMySqlLocal() == NIL
      RETURN NIL
   ENDIF
   WITH OBJECT cnMySql
      IF ! :FieldExists( "CDCONTRIB", "JPCADAS" )
         :AddField( "CDCONTRIB", "JPCADAS", "VARCHAR(1) NOT NULL DEFAULT ''" )
      ENDIF
      :ExecuteCmd( "ALTER TABLE JPCADAS MODIFY CDCONTRIB VARCHAR(1) NOT NULL DEFAULT ''" )
   END WITH

   RETURN NIL
