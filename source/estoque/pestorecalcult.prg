/*
PESTORECALCULT - Recalcula ultima compra/venda e custo cont�bil
Jos� Quintas
*/

PROCEDURE PBUG0080

   LOCAL nAtual, nTotal

   IF ! MsgYesNo( "Confirma processamento?" )
      RETURN
   ENDIF
   IF ! AbreArquivos( "jpitem", "jpestoq", "jppedi", "jptransa" )
      RETURN
   ENDIF
   SayScroll( "18/03/10 - Ajustando custo cont�bil e �ltima entrada/sa�da" )
   SELECT jpitem
   GOTO TOP
   GrafTempo( "Atualizando �lt.entrada/sa�da e custo cont�bil" )
   nAtual := 0
   nTotal := LastRec()
   DO WHILE ! Eof()
      GrafTempo( nAtual++, nTotal )
      UltimaEntradaItem( jpitem->ieItem )
      UltimaSaidaItem( jpitem->ieItem )
      CustoContabilItem()
      SKIP
   ENDDO
   CLOSE DATABASES
   MsgExclamation( "Fim" )

   RETURN
