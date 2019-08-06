/*
PESTOITEMXLS - PRODUTOS EM EXCEL
2012 José Quintas

2018.02.08 Campos estoque e reserva do produto
*/

#define XLS_SEP ";"

PROCEDURE pEstoItemXLS

   LOCAL cTmpFile

   IF ! AbreArquivos( "jpitem" )
      RETURN
   ENDIF
   SELECT jpitem

   cTmpFile := MyTempFile( "XLS" )
   SET ALTERNATE TO ( cTmpFile )
   SET ALTERNATE ON
   SET CONSOLE OFF
   IF MsgYesNo( "ANP" )
      GeraAnp()
   ELSE
      GeraComercial()
   ENDIF
   SET CONSOLE ON
   SET ALTERNATE OFF
   SET ALTERNATE TO
   RUN ( "START " + cTmpFile )
   CLOSE DATABASES

   RETURN

STATIC FUNCTION GeraComercial()

   OrdSetFocus( "itemvenda" )

   ?? "COD" + XLS_SEP
   ?? "DESCRICAO" + XLS_SEP
   ?? "DEP.1" + XLS_SEP
   ?? "DEP.2" + XLS_SEP
   ?? "PRECO VENDA" + XLS_SEP
   ?? "ULT PRECO" + XLS_SEP
   ?? "CUSTO CONTABIL" + XLS_SEP
   ?
   GOTO TOP
   DO WHILE ! Eof()
      ?? jpitem->ieItem + XLS_SEP
      ?? jpitem->ieDescri + XLS_SEP
      ?? LTrim( Str( jpitem->ieQtd1, 16, 2 ) ) + XLS_SEP
      ?? LTrim( Str( jpitem->ieQtd2, 16, 2 ) ) + XLS_SEP
      ?? LTrim( Str( jpitem->ieValor, 16, 2 ) ) + XLS_SEP
      ?? LTrim( Str( jpitem->ieUltPre, 16, 2 ) ) + XLS_SEP
      ?? LTrim( Str( jpitem->ieCusCon, 16, 2 ) ) + XLS_SEP
      ?
      SKIP
   ENDDO

   RETURN NIL

STATIC FUNCTION GeraAnp()

   ?? "ITEM" + XLS_SEP
   ?? "NCM" + XLS_SEP
   ?? "ANP" + XLS_SEP
   ?? "DESCRICAO" + XLS_SEP
   ?
   GOTO TOP
   DO WHILE ! Eof()
      IF Empty( jpitem->ieAnp ) .OR. jpitem->ieLibera != "S"
         SKIP
         LOOP
      ENDIF
      ?? jpitem->ieItem   + XLS_SEP
      ?? jpitem->ieNCM    + XLS_SEP
      ?? jpitem->ieAnp    + XLS_SEP
      ?? jpitem->ieDescri + XLS_SEP
      ?
      SKIP
   ENDDO

   RETURN NIL
