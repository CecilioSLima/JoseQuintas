/*
PJPTRANSA - TRANSACOES
2013.01 Jos� Quintas
*/

#include "inkey.ch"
#include "hbclass.ch"

PROCEDURE PJPTRANSA

   LOCAL oFrm := JPTRANSAClass():New()
   MEMVAR m_Prog

   IF AppcnMySqlLocal() == NIL
      IF ! AbreArquivos( "jpreguso" )
         RETURN
      ENDIF
   ENDIF
   IF ! AbreArquivos( "jpconfi", "jpempre", "jpestoq", "jpimpos", "jpnota", "jpnumero", "jppedi", "jpsenha", "jptabel", "jptransa" )
      RETURN
   ENDIF
   SELECT jptransa
   oFrm:Execute()

   RETURN

CREATE CLASS JPTRANSAClass INHERIT frmCadastroClass

   METHOD GridSelection()
   METHOD TelaDados( lEdit )
   METHOD Especifico( lExiste )
   METHOD Valida( cTransacao, lMostra )
   METHOD Delete()
   METHOD Intervalo( nLini, nColi, nOpc, mpdTransa )

   ENDCLASS

METHOD GridSelection() CLASS JPTRANSAClass

   LOCAL nSelect := Select(), cOrdSetFocus

   SELECT jptransa
   cOrdSetFocus := OrdSetFocus( "descricao" )
   FazBrowse()
   IF LastKey() != K_ESC .AND. ! Eof()
      KEYBOARD jptransa->trTransa + Chr( K_ENTER )
   ENDIF
   OrdSetFocus( cOrdSetFocus )
   SELECT ( nSelect )

   RETURN NIL

METHOD TelaDados( lEdit ) CLASS JPTRANSAClass

   LOCAL GetList := {}
   LOCAL mtrTransa := jptransa->trTransa
   LOCAL mtrDescri := jptransa->trDescri
   LOCAL mtrReacao := jptransa->trReacao

   hb_Default( @lEdit, .F. )
   IF ::cOpc == "I" .AND. lEdit
      mtrTransa := ::axKeyValue[1]
   ENDIF
   ::ShowTabs()
   @ Row() + 1, 1 SAY "C�digo.............:" GET mtrTransa PICTURE "@KR 999.999" WHEN .F.
   @ Row() + 2, 1 SAY "Descri��o..........:" GET mtrDescri PICTURE "@!"
   @ Row() + 2, 1 SAY "Rea��o no pedido...:" GET mtrReacao PICTURE "@!"
   @ Row() + 2, 1 SAY "Explica��es:"
   @ Row() + 1, 1 SAY "TTT.RRR => TTT = Transa��o atual, sendo 001 a 499 para entradas, e 500 a 999 pra sa�das"
   @ Row() + 1, 1 SAY "           RRR = Transa��o que deve existir para baixa"
   @ Row() + 1, 1 SAY "C+R,C+1,C-1 => Confirma��o afeta estoque, +R soma ao reservado, +1 soma ao estoque 1, -1 tira do estoque 1, +2 Soma ao estoque 2"
   @ Row() + 1, 1 SAY "N-1,N+2,N+3,N+4 => Emiss�o de nota afeta estoque, -R tira do reservado, -1 Tira do estoque 1, +2 soma ao estoque 2"
   @ Row() + 1, 1 SAY "CCUSCON,NCUSCON => Atualiza��o do custo cont�bil, na C=Confirma��o ou N=Emissao da nota"
   @ Row() + 1, 1 SAY "CULTENT,NULTENT => Atualiza��o da �ltima entrada, na C=Confirma��o ou N=Emiss�o da nota"
   @ Row() + 1, 1 SAY "CULTSAI,NULTSAI => Atualiza��o da �ltima saida, na C=Confirma��o ou N=Emiss�o da nota"
   @ Row() + 1, 1 SAY "CDEVCOM,CDEVVEN,NDEVCOM,NDEVVEN => Devolu��o de compra ou venda, se afeta estoque na C=Confirma��o ou N=Emiss�o da nota"
   @ Row() + 1, 1 SAY "VENDA,COMPRA => Se o pedido entra nos relat�rios de compra ou venda"
   @ Row() + 1, 1 SAY "ATRASO => N�o permite confirmar ou emitir nota se houver pagamento em atraso"
   @ Row() + 1, 1 SAY "LIMCRE => N�o permite confirmar ou emitir nota se ultrapassar limite de cr�dito em aberto"
   @ Row() + 1, 1 SAY "SEMFIN => N�o gera informa��o para o financeiro"
   @ Row() + 1, 1 SAY "PEDREL => Exige pedido relacionado (DEVCOM e DEVVEN j� fazem isso) (Transa��o ???999 exige 999???)"
   @ Row() + 1, 1 SAY "ADMPEDLIBn => Somente usu�rio com acesso � ADMPEDLIBn pode liberar - n=1 a 9"
   @ Row() + 1, 1 SAY "+AJUSTE,-AJUSTE => Nota fiscal de ajuste, pra adicionar ou remover algo (*)"
   @ Row() + 1, 1 SAY "CONSUMIDOR => Nota pra consumidor, indica finalidade consumo e mostra impostos ref. venda a consumidor"
   //@ Row() + 2, 1 SAY "IMPOSTO => Deixou de ser usado"
   SEEK mtrTransa
   //SetPaintGetList( GetList )
   IF ! lEdit
      CLEAR GETS
      RETURN NIL
   ENDIF
   Mensagem( "Digite campos, ESC sai" )
   READ
   Mensagem()
   IF LastKey() == K_ESC
      GOTO ::nUltRec
      RETURN NIL
   ENDIF
   IF ::cOpc == "I"
      IF mtrTransa != "*NOVO*"
         IF Encontra( mtrTransa, "jptransa", "numlan" )
            mtrTransa := "*NOVO*"
         ENDIF
      ENDIF
      IF mtrTransa == "*NOVO*"
         mtrTransa := NovoCodigo( "jptransa->trTransa" )
      ENDIF
      RecAppend()
      REPLACE jptransa->trTransa WITH mtrTransa, jptransa->trInfInc WITH LogInfo()
      RecUnlock()
   ENDIF
   RecLock()
   REPLACE jptransa->trDescri WITH mtrDescri, jptransa->trReacao WITH mtrReacao
   IF ::cOpc == "A"
      REPLACE jptransa->trInfAlt WITH LogInfo()
   ENDIF
   RecUnlock()

   RETURN NIL

METHOD Especifico( lExiste ) CLASS JPTRANSAClass

   LOCAL GetList := {}
   LOCAL mtrTransa := jptransa->trTransa
   MEMVAR m_Prog

   IF ::cOpc == "I"
      mtrTransa = "*NOVO*"
   ENDIF
   @ Row()+1, 22 GET mtrTransa PICTURE "@KR 999.999" VALID NovoMaiorZero( @mtrTransa )
   Mensagem( "Digite c�digo para cadastro, F9 pesquisa, ESC sai" )
   READ
   Mensagem()
   IF LastKey() == K_ESC .OR. ( Val( mtrTransa ) == 0 .AND. mtrTransa != "*NOVO*" )
      GOTO ::nUltRec
      RETURN .F.
   ENDIF
   SEEK mtrTransa
   IF ! ::EspecificoExiste( lExiste, Eof() )
      RETURN .F.
   ENDIF
   ::axKeyValue := { mtrTransa }

   RETURN .T.

METHOD Delete() CLASS JPTRANSAClass

   LOCAL lExclui := .T.

   Mensagem( "Verificando se est� em uso" )
   SELECT jppedi
   LOCATE FOR jppedi->pdTransa == jptransa->trTransa .AND. GrafProc()
   IF ! Eof()
      MsgExclamation( "INV�LIDO! Transa��o em uso no pedido " + jppedi->pdPedido )
      lExclui := .F.
   ELSE
      SELECT jpestoq
      LOCATE FOR jpestoq->esTransa == jptransa->trTransa .AND. GrafProc()
      IF ! Eof()
         MsgExclamation( "INV�LIDO! Transa��o em uso no estoque " + jpestoq->esNumLan )
         lExclui := .F.
      ELSE
         SELECT jpnota
         LOCATE FOR jpnota->nfTransa == jptransa->trTransa .AND. GrafProc()
         IF ! Eof()
            MsgExclamation( "INV�LIDO! Transa��o em uso na NF lan�to " + jpnota->nfNumLan )
            lExclui := .F.
         ELSE
            SELECT jpimpos
            LOCATE FOR jpimpos->imTransa == jptransa->trTransa .AND. GrafProc()
            IF ! Eof()
               MsgExclamation( "INV�LIDO! Transa��o em uso na regra " + jpimpos->imNumLan )
               lExclui := .F.
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   SELECT jptransa
   IF lExclui
      ::Super:Delete()
   ENDIF

   RETURN NIL

METHOD Valida( cTransacao, lMostra ) CLASS JPTRANSAClass

   hb_Default( @lMostra, .T. )
   FillZeros( @cTransacao )
   IF lMostra
      @ Row(), 32 SAY EmptyValue( jptransa->trDescri )
   ENDIF
   IF ! Encontra( cTransacao, "jptransa", "numlan" )
      MsgStop( "Transa��o n�o cadastrada!" )
      RETURN .F.
   ENDIF
   IF lMostra
      @ Row(), 32 SAY jptransa->trDescri
   ENDIF

   RETURN .T.

METHOD Intervalo( nLini, nColi, nOpc, mpdTransa ) CLASS JPTRANSAClass

   LOCAL acTxtOpc := { "Todas", "Espec�fica" }
   LOCAL GetList := {}

   WOpen( nLini, nColi, nLini + 3, nColi + 40, "Transa��o" )
   DO WHILE .T.
      FazAchoice( nLini + 1, nColi + 1, nLini + 2, nColi + 39, acTxtOpc, @nOpc )
      IF LastKey() != K_ESC .AND. nOpc == 2
         WOpen( nLini + 3, nColi, nLini + 6, nColi + 40, "Transa��o" )
         @ nLini + 5, nColi + 2 GET mpdTransa PICTURE "@K 999999" VALID JPTRANSAClass():Valida( @mpdTransa, .F. )
         Mensagem( "Digite a Transa��o, F9 Pesquisa, ESC Sai" )
         READ
         WClose()
         IF LastKey() == K_ESC
            LOOP
         ENDIF
      ENDIF
      EXIT
   ENDDO
   WClose()

   RETURN nOpc
