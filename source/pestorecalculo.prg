/*
PESTORECALCULO - RECALCULO DO ESTOQUE
2002.06 Jos� Quintas

2018.02.08 Campos estoque e reserva do produto
*/

#include "inkey.ch"

PROCEDURE pEstoRecalculo

   LOCAL GetList := {}, mCalcReserva := "S", mCalcFinal := "N", mCalcUltimo := "N"

   IF ! AbreArquivos( "jpempre", "jpconfi", "jpitped", "jpestoq", "jpitem", "jppedi", "jptransa", "jpnota" )
      RETURN
   ENDIF
   DO WHILE .T.
      @ 10, 5 SAY "Recalcula Estque Reserva.....:" GET mCalcReserva PICTURE "!A" VALID mCalcReserva $ "SN"
      @ 12, 5 SAY "Recalcula Estoque Final......:" GET mCalcFinal   PICTURE "!A" VALID mCalcFinal   $ "SN"
      @ 14, 5 SAY "Recalcula Custo/Ultima Compra:" GET mCalcUltimo  PICTURE "!A" VALID mCalcUltimo  $ "SN"
      Mensagem( "Confirme condi��es" )
      READ
      Mensagem()
      IF LastKey() == K_ESC
         EXIT
      ENDIF
      IF ! MsgYesNo( "Confirma rec�lculo" )
         EXIT
      ENDIF
      SELECT jpitped
      IF mCalcReserva == "S"
         RecalculaReserva()
      ENDIF
      IF mCalcFinal == "S"
         RecalculaSaldo()
      ENDIF
      IF mCalcUltimo == "S"
         RecalculaUltimo()
      ENDIF
      MsgExclamation( "fim" )
      EXIT
   ENDDO
   CLOSE DATABASES

   RETURN

STATIC FUNCTION RecalculaReserva()

   LOCAL nAtual, cReacao, nCont

   SELECT jpitem
   GOTO TOP
   DO WHILE ! Eof()
      RecLock()
      REPLACE jpitem->ieRes1 WITH 0
      RecUnlock()
      SKIP
   ENDDO

   SELECT jppedi
   GOTO TOP
   GrafTempo( "Atualizando" )
   nAtual := 0
   DO WHILE ! Eof()
      GrafTempo( nAtual++, LastRec() + 1 )
      DO CASE
      CASE jppedi->pdStatus $ "C"
      CASE Encontra( jppedi->pdPedido, "jpnota", "pedido" )
      CASE jppedi->pdConf != "S"
      OTHERWISE
         Encontra( jppedi->pdPedido, "jpitped", "pedido" )
         cReacao := Pedido():Reacao()
         IF "C+R" $ cReacao
            SELECT jpitped
            SEEK jppedi->pdPedido
            DO WHILE jpitped->ipPedido == jppedi->pdPedido .AND. ! Eof()
               Encontra( jpitped->ipItem, "jpitem", "item" )
               SELECT jpitem
               RecLock()
               IF "C+R," $ cReacao
                  REPLACE jpitem->ieRes1 WITH jpitem->ieRes1 + jpitped->ipQtde
               ELSE
                  FOR nCont = 1 TO 3
                     IF "C+R" + Str( nCont, 1 ) $ cReacao
                        REPLACE &( "jpitem->ieRes" + Str( nCont, 1 ) ) WITH &( "jpitem->ieRes" + Str( nCont, 1 ) ) + jpitped->ipQtde
                     ENDIF
                  NEXT
               ENDIF
               RecUnlock()
               SELECT jpitped
               SKIP
            ENDDO
            SELECT jppedi
         ENDIF
      ENDCASE
      SELECT jppedi
      SKIP
   ENDDO

   RETURN NIL

STATIC FUNCTION RecalculaSaldo()

   LOCAL anQtd, nNumDep

   SELECT jpitem
   GOTO TOP
   DO WHILE ! Eof()
      anQtd := Array(9)
      Afill( anQtd, 0 )
      SELECT jpestoq
      OrdSetFocus( "jpestoq3" )
      SEEK jpitem->ieItem
      DO WHILE jpestoq->esItem == jpitem->ieItem .AND. ! Eof()
         nNumDep := iif( jpestoq->esNumDep $ "23456789", Val( jpestoq->esNumDep ), 1 )
         IF jpestoq->esTipLan == "1"
            anQtd[ nNumDep ] -= jpestoq->esQtde
         ELSE
            anQtd[ nNumDep ] += jpestoq->esQtde
         ENDIF
         SKIP
      ENDDO
      SELECT jpitem
      RecLock()
      REPLACE ;
         jpitem->ieQtd1 WITH anQtd[ 1 ], ;
         jpitem->ieQtd2 WITH anQtd[ 2 ], ;
         jpitem->ieQtd3 WITH anQtd[ 3 ], ;
         jpitem->ieQtd4 WITH anQtd[ 4 ], ;
         jpitem->ieQtd5 WITH anQtd[ 5 ], ;
         jpitem->ieQtd6 WITH anQtd[ 6 ], ;
         jpitem->ieQtd7 WITH anQtd[ 7 ], ;
         jpitem->ieQtd8 WITH anQtd[ 8 ], ;
         jpitem->ieQtd9 WITH anQtd[ 9 ]
      RecUnlock()
      SELECT jpitem
      SKIP
   ENDDO

   RETURN NIL

STATIC FUNCTION RecalculaUltimo()

   LOCAL nAtual, nTotal

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

   RETURN NIL
