/*
ZE_UPDATE2016 - conversões 2016
2016 José Quintas

2017.12.01 - Considera JPPREHIS somente no MySQL
*/

FUNCTION ze_Update2016()

   Update001() // DBFs opcionais com default
   IF AppVersaoDbfAnt() < 20160101; Update002();        ENDIF // Default jpdecret
   IF AppVersaoDbfAnt() < 20160829; Update20160901();   ENDIF // MYSQL.JPREGUSO - aumento de campo
   IF AppVersaoDbfAnt() < 20160908; Update20160908();   ENDIF // MYSQL.JPEDICFG
   IF AppVersaoDbfAnt() < 20161209; Update20161209();   ENDIF // Campo CDCONTRIB em MYSQL.JPCADAS

   RETURN NIL

STATIC FUNCTION Update001()

   IF AppcnMySqlLocal() == NIL
      JPREGUSOCreateDbf()
      JPIBPTCreateDbf()
      RETURN NIL
   ENDIF
   IF File( "jpreguso.cdx" )
      fErase( "jpreguso.cdx" )
   ENDIF
   IF File( "jpibpt.cdx" )
      fErase( "jpibpt.cdx" )
   ENDIF
   IF File( "jpreguso.dbf" )
      CopyDbfToMySql( "JPREGUSO", .T. )
      fErase( "jpreguso.dbf" )
   ENDIF
   IF File( "jpibpt.dbf" )
      JPIBPTCreateDbf()
      CopyDbfToMySql( "JPIBPT", .T. )
      fErase( "jpibpt.dbf" )
   ENDIF
   CLOSE DATABASES

   RETURN NIL

STATIC FUNCTION Update002()

   LOCAL oElement, oRecList, cnMySql := ADOClass():New( AppcnMySqlLocal() )

   IF AppcnMySqlLocal() == NIL
      RETURN NIL
   ENDIF
   oRecList := { ;
      { "ST FABRICANTE",           "CST 010/070: RECOLHIMENTO DO ICMS POR SUBSTITUICAO TRIBUTARIA ARTIGO 313 DO RICMS/SP. O DESTINATARIO " + ;
      "DEVERA ESCRITURAR O DOCUMENTO FISCAL NOS TERMOS DO ARTIGO 278 DO RICMS.; " }, ;
      { "ST COMERCIO",             "CST 060: ICMS RECOLHIDO POR SUBSTITUICAO TRIBUTARIA PELO FABRICANTE, CONFORME ARTIGO 412 DO RICMS " + ;
      "DECRETO 45.490-2000 DE 30-11-2000.;" }, ;
      { "COMBUSTIVEL ONU 3082",    "ONU 3082 (SUBSTANCIA QUE APRESENTA RISCOS PARA O MEIO AMBIENTE, LIQUIDA, N.E. OLEO COMBUSTIVEL) " + ;
      "CLASSE DE RISCO 9 (SUBSTANCIAS E ARTIGOS PERIGOSOS DIVERSOS), EMBALAGEM III (BAIXO RISCO).;" }, ;
      { "COMBUSTIVEL ONU 1202",    "MISTURA DIESEL/BIODIESEL ONU 1202 (OLEO DIESEL) CLASSE DE RISCO 3 (LIQUIDO INFLAMAVEL) EMBALAGEM III " + ;
      "(BAIXO RISCO).;" }, ;
      { "COMBUSTIVEL DECLARACAO",  "DECLARO QUE OS PRODUTOS PERIGOSOS ESTAO ADEQUADAMENTE CLASSIFICADOS, EMBALADOS, " + ;
      "IDENTIFICADOS, E ESTIVADOS PARA SUPORTAR OS RISCOS DAS OPERACOES DE TRANSPORTE E QUE ATENDEM AS EXIGENCIAS " + ;
      "DA REGULAMENTACAO" }, ;
      { "COMBUSTIVEL CONFERIR",    "ANTES DE DESCARREGAR O CARRO TANQUE CONFIRA AS QUANTIDADES E EXAMINE A QUALIDADE. APOS O DESCARREGAMENTO " + ;
      "EXIJA O ESCORRIMENTO.; QUALQUER IRREGULARIDADE DEVERA SER RECLAMADA ANTES DO DESCARREGAMENTO." }, ;
      { "CONFERIR MERCADORIA",     "CONFIRA A MERCADORIA RECEBIDA. NAO ACEITAMOS RECLAMACOES POSTERIORES.;" }, ;
      { "ARROZ FEIJAO CONS.FINAL", "ARROZ E/OU FEIJAO ISENTO PRA CONSUMIDOR FINAL CONFORME DECRETO 61.745/2015;" }, ;
      { "TRANSP ARROZ FEIJAO",     "TRANSPORTE DE ARROZ E/OU FEIJAO ISENTO PARA CONSUMIDOR FINAL CONFORME DECRETO 61.746/2015;" } }

   IF cnMySql:RecCount( "JPDECRET" ) == 0
      FOR EACH oElement IN oRecList
         WITH OBJECT cnMySql
            :QueryCreate()
            :QueryAdd( "DENUMLAN", StrZero( oElement:__EnumIndex, 6 ) )
            :QueryAdd( "DENOME",   oElement[ 1 ] )
            :QueryAdd( "DEDESCR1",  Substr( oElement[ 2 ], 1, 250 ) )
            :QueryAdd( "DEDESCR2",  Substr( oElement[ 2 ], 251, 250 ) )
            :QueryAdd( "DEDESCR3",  Substr( oElement[ 2 ], 501, 250 ) )
            :QueryAdd( "DEDESCR4",  Substr( oElement[ 2 ], 750, 250 ) )
            :QueryAdd( "DEDESCR5",  Substr( oElement[ 2 ], 1001, 250 ) )
            :QueryExecuteInsert( "JPDECRET" )
         ENDWITH
      NEXT
   ENDIF
   CLOSE DATABASES

   RETURN NIL

STATIC FUNCTION JPIBPTCreateDbf()

   LOCAL mStruOk

   IF AppcnMySqlLocal() != NIL .AND. ! File( "JPIBPT.DBF" )
      RETURN NIL
   ENDIF
   SayScroll( "JPIBPT, verificando atualizações" )
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
      MsgStop( "JPIBPT nao disponível!" )
      QUIT
   ENDIF

   RETURN NIL

STATIC FUNCTION Update20160901()

   LOCAL cnMySql := ADOClass():New( AppcnMySqlLocal() )

   IF AppcnMySqlLocal() == NIL
      RETURN NIL
   ENDIF
   cnMySql:ExecuteCmd( "ALTER TABLE JPREGUSO MODIFY RUARQUIVO VARCHAR(15) NOT NULL DEFAULT ''" )

   RETURN NIL

   /*
   RDBEDICFG - TESTA ESTRUTURA JPEDICFG
   2016.08.29.1900 - José Quintas

   2016.09.08.1330 - Oficial

   */

   // bloqueado até ajuste geral

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

   /*
   RC20161209 - Campo CDCONTRIB em JPCADAS
   2016.12.09.1936 - José Quintas
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
   ENDWITH

   RETURN NIL
