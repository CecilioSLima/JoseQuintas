/*
ZE_UPDATE2016 - convers�es 2016
2016 Jos� Quintas

2017.12.01 - Considera JPPREHIS somente no MySQL
*/

FUNCTION ze_Update2016()

   Update20160101() // DBFs opcionais com default
   IF AppVersaoDbfAnt() < 20160829; Update20160901();   ENDIF // MYSQL.JPREGUSO - aumento de campo
   IF AppVersaoDbfAnt() < 20160908; Update20160908();   ENDIF // MYSQL.JPEDICFG
   IF AppVersaoDbfAnt() < 20161209; Update20161209();   ENDIF // Campo CDCONTRIB em MYSQL.JPCADAS

   RETURN NIL

STATIC FUNCTION Update20160101()

   IF AppcnMySqlLocal() == NIL
      JPREGUSOCreateDbf()
      //JPIBPTCreateDbf()
      RETURN NIL
   ENDIF
   IF File( "jpreguso.cdx" )
      fErase( "jpreguso.cdx" )
   ENDIF
   IF File( "jpdecret.cdx" )
      fErase( "jpdecret.cdx" )
   ENDIF
   IF File( "jpibpt.cdx" )
      fErase( "jpibpt.cdx" )
   ENDIF
   IF File( "jpreguso.dbf" )
//      CopyDbfToMySql( "JPREGUSO", .T. )
      fErase( "jpreguso.dbf" )
   ENDIF
/*
   IF File( "jpibpt.dbf" )
      JPIBPTCreateDbf()
      CopyDbfToMySql( "JPIBPT", .T. )
      fErase( "jpibpt.dbf" )
   ENDIF
*/
   CLOSE DATABASES

   RETURN NIL

/*
STATIC FUNCTION JPIBPTCreateDbf()

   LOCAL mStruOk

   IF AppcnMySqlLocal() != NIL .AND. ! File( "JPIBPT.DBF" )
      RETURN NIL
   ENDIF
   SayScroll( "JPIBPT, verificando atualiza��es" )
   mStruOk := { ;
      { "IBCODIGO",  "C", 8 }, ;
      { "IBEXCECAO", "C", 2 }, ;
      { "IBNCMNBS",  "C", 1 }, ; // 0 NCM
      { "IBUF",      "C", 2 }, ;
      { "IBNACALI",  "N", 7, 2 }, ;
      { "IBIMPALI",  "N", 7, 2 }, ;
      { "IBALIFEDN", "N", 7, 2 }, ;
      { "IBALIFEDI", "N", 7, 2 }, ;
      { "IBALIEST",  "N", 7, 2 }, ;
      { "IBALIMUN",  "N", 7, 2 }, ;
      { "IBINFINC",  "C", 80 }, ;
      { "IBINFALT",  "C", 80 } }
   IF ! ValidaStru( "jpibpt", mStruOk )
      MsgStop( "JPIBPT nao dispon�vel!" )
      QUIT
   ENDIF

   RETURN NIL
*/

STATIC FUNCTION Update20160901()

   LOCAL cnMySql := ADOClass():New( AppcnMySqlLocal() )

   IF AppcnMySqlLocal() == NIL
      RETURN NIL
   ENDIF
   cnMySql:ExecuteCmd( "ALTER TABLE JPREGUSO MODIFY RUARQUIVO VARCHAR(15) NOT NULL DEFAULT ''" )

   RETURN NIL

   /*
   RDBEDICFG - TESTA ESTRUTURA JPEDICFG
   2016.08.29.1900 - Jos� Quintas

   2016.09.08.1330 - Oficial

   */

   // bloqueado at� ajuste geral

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

   SayScroll( "JPEDICFG, verificando atualiza��es" )
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
      MsgStop( "JPEDICFG n�o dispon�vel!" )
      QUIT
   ENDIF

   RETURN NIL

   /*
   RC20161209 - Campo CDCONTRIB em JPCADAS
   2016.12.09.1936 - Jos� Quintas
   */

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
