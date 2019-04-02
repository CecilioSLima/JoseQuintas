/*
ZE_UPDATE2017 - Conversões 2017
2017 José Quintas

2018.04.03
*/

FUNCTION ze_Update2017()

   IF AppVersaoDbfAnt() < 20170404; Update20170404();   ENDIF // Status de manifesto
   IF AppVersaoDbfAnt() < 20170614; Update20170614();   ENDIF // Corrige estoque
   IF AppVersaoDbfAnt() < 20170816; Update20170816();   ENDIF // lixo jpconfi

   RETURN NIL

   /*
   Status de manifesto
   */

STATIC FUNCTION Update20170404()

   LOCAL oXmlPdf, cStatus, oElement

   IF AppcnMySqlLocal() == NIL
      RETURN NIL
   ENDIF

   IF ! AbreArquivos( "jpempre", "jpmdfcab" )
      RETURN NIL
   ENDIF
   SELECT jpmdfcab
   SET ORDER TO 0
   GrafTempo( "Ajustando status de manifestos" )
   GOTO TOP
   DO WHILE ! Eof()
      GrafTempo( RecNo(), LastRec() )
      Inkey()
      oXmlPdf := XmlPdfClass():New()
      oXmlPdf:GetFromMySql( "", jpmdfcab->mcNumLan, "58" )
      cStatus := ""
      IF ! Empty( oXmlPdf:cXmlCancelamento )
         cStatus := "C"
      ELSE
         IF ! Empty( oXmlPdf:cXmlEmissao )
            cStatus := "E"
            FOR EACH oElement IN oXmlPdf:aXmlEvento
               IF "<tpEvento>110112</tpEvento>" $ oElement
                  cStatus := "F"
               ENDIF
            NEXT
         ENDIF
      ENDIF
      DO CASE
      CASE Empty( cStatus )
         // Não desfaz cancelamento
      CASE Trim( jpmdfcab->mcStatus ) == "C"
         // Não desfaz encerramento, mas permite cancelar
      CASE Trim( jpmdfcab->mcStatus ) == "F" .AND. cStatus != "C"
      OTHERWISE
         RecLock()
         REPLACE jpmdfcab->mcStatus WITH cStatus
         RecUnlock()
      ENDCASE
      SKIP
   ENDDO
   CLOSE DATABASES
   Mensagem()

   RETURN NIL

   /*
   Corrige estoque
   */

STATIC FUNCTION Update20170614()

   IF ! AbreArquivos( "jpestoq" )
      RETURN NIL
   ENDIF
   SELECT jpestoq
   SET ORDER TO 0
   GOTO TOP
   GrafTempo( "Verificando lançamentos de estoque antigos" )
   DO WHILE ! Eof()
      GrafTempo( RecNo(), LastRec() )
      Inkey()
      IF ! jpestoq->esTipLan $ "12"
         RecLock()
         REPLACE jpestoq->esTipLan WITH "1"
         RecUnlock()
      ENDIF
      IF Val( jpestoq->esNumDep ) == 0
         RecLock()
         REPLACE jpestoq->esNumDep WITH "1"
         RecUnlock()
      ENDIF
      DO CASE
      CASE jpestoq->esQtde == 0
         RecLock()
         DELETE
         RecUnlock()
      CASE Empty( jpestoq->esItem )
         RecLock()
         DELETE
         RecUnlock()
      CASE Empty( jpestoq->esDatLan )
         RecLock()
         DELETE
         RecUnlock()
      ENDCASE
      SKIP
   ENDDO
   CLOSE DATABASES

   RETURN NIL

STATIC FUNCTION Update20170816()

   SayScroll( "Eliminando coisa inútil" )
   IF ! AbreArquivos( "jpconfi" )
      QUIT
   ENDIF
   DelCnf( "MARGEM RELATORIOS" )
   DelCnf( "ESPACO LIVRE (KB)" )
   DelCnf( "NUM.ARQ.TEMP." )
   DelCnf( "REINDEX PERIODO" )
   DelCnf( "BACKUP PERIODO" )
   DelCnf( "REINDEX ULTIMA" )
   DelCnf( "BACKUP ULTIMO" )
   DelCnf( "BACKUP DRIVE" )
   DelCnf( "BACKUP DIARIO" )
   DelCnf( "LAYOUT DE DUPLIC" )
   DelCnf( "BACKUP DATALZH" )
   DelCnf( "P0480" )
   DelCnf( "P0500" )
   DelCnf( "P1745" )
   DelCnf( "P0850" )
   DelCnf( "BA_P130" )
   DelCnf( "PEDIDO EMAIL C/PRECO" )
   DelCnf( "PEDIDO EMAIL C/GARAN" )
   DelCnf( "PEDIDO EMAIL S/GARAN" )
   DelCnf( "P0660" )
   DelCnf( "P0610" )
   DelCnf( "P0690" )
   DelCnf( "P0540" )
   DelCnf( "VARIAS TAB.PRECO" )
   DelCnf( "DESCR.P/NF" )
   DelCnf( "P0390" )
   DelCnf( "PPRE0030" )
   DelCnf( "PFIN0140" )
   DelCnf( "PFIN0120" )
   DelCnf( "PCAD0150" )
   DelCnf( "P0790" )
   DelCnf( "PEDIDO EMAIL S/PRECO" )
   DelCnf( "EMAIL BACKUP" )
   DelCnf( "P0665" )
   DelCnf( "LAYOUT DE NF" )
   DelCnf( "PROXIMO CONTRATO" )
   DelCnf( "PROXIMO CTRC" )
   DelCnf( "PROXIMO REL.NOTAS" )
   DelCnf( "VENCIDO NAO PEDIDO" )
   DelCnf( "VENCIDO NAO NF" )
   DelCnf( "PEDIDO PARCIAL" )
   DelCnf( "PROXIMA NF" )
   DelCnf( "BAIXA P/ TRANSACAO" )
   DelCnf( "BAIXA P/TRANSACAO" )
   DelCnf( "XMLID" )
   DelCnf( "ESTOQUE FISCAL" )
   DelCnf( "DESCR.NF ESTOQUE" )
   DelCnf( "CCUSTO ESTOQUE" )
   DelCnf( "PEDIDOS DEZ EM DEZ" )
   DelCnf( "VARIAS TAB.P/CLI" )
   DelCnf( "MICRO MONTADO" )
   DelCnf( "NUM.RECDIA" )
   DelCnf( "REGRAS TRIBUTACAO" )
   DelCnf( "VERSAOWIN" )
   DelCnf( "DIGITA NUM.BOLETO" )
   GOTO TOP
   DO WHILE ! Eof()
      IF Left( jpconfi->cnf_Nome, 11 ) == "IMPRESSORA " .OR. Empty( jpconfi->cnf_Nome )
         RecLock()
         DELETE
         RecUnlock()
      ENDIF
      SKIP
   ENDDO
   CLOSE DATABASES

   RETURN NIL
