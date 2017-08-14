/*
PBAR0010 - CODIGOS DE BARRA
2003.04 Jos� Quintas
*/

#include "inkey.ch"
#include "hbclass.ch"

PROCEDURE PBAR0010

   LOCAL oFrm := PBAR0010Class():New()
   MEMVAR  mFiltroBarra, mFiltroPedido, m_Prog
   PRIVATE mFiltroBarra, mFiltroPedido

   IF .T.
      MsgExclamation( "M�dulo necessita atualiza��o para MySQL" )
      RETURN
   ENDIF
   IF AppcnMySqlLocal() == NIL
      IF ! AbreArquivos( "jpreguso", "jpbarra", "jpdecret" )
         RETURN
      ENDIF
   ENDIF
   IF ! AbreArquivos( "jpcadas", "jpcidade", "jpclista", "jpcomiss", "jpconfi", "jpempre", ;
      "jpestoq", "jpfinan", "jpforpag", "jpimpos", "jpitem", "jpitped", "jplfisc", "jpnota", "jpnumero", "jppedi", "jppretab", ;
      "jppreco", "jpsenha", "jptabel", "jptransa", "jpuf", "jpveicul", "jpvended" )
      RETURN
   ENDIF
   SELECT jpbarra
   mFiltroBarra  := Space(22)
   mFiltroPedido := Space(22)
   AAdd( oFrm:acMoreOptions, "<Z>Limpar" )
   AAdd( oFrm:acMoreOptions, "<T>Filtro" )
   AAdd( oFrm:acMoreOptions, "<O>Ocorrencias" )
   IF m_Prog == "PBAR0010"
      oFrm:cOptions := "IAE"
   ELSE
      oFrm:cOptions := "C"
   ENDIF
   oFrm:Execute()
   CLOSE DATABASES

   RETURN

STATIC FUNCTION OkAqui( mCodigo )
   LOCAL mVar

   mVar := Lower( ReadVar() )
   DO CASE
   CASE Val( mCodigo ) == 0
      mCodigo := EmptyValue( mCodigo )
   CASE mVar == "mbrpedcom"
      RETURN OkPedCom( @mCodigo )
   CASE mVar == "mbrpedven"
      RETURN OkPedVen( @mCodigo )
   CASE mVar == "mbritem"
      RETURN JPITEMClass():Valida( @mCodigo )
   ENDCASE

   RETURN .T.

STATIC FUNCTION OkPedCom( mPedido ) // usado em outro programa

   IF ! JPPEDIClass():Valida( @mPedido )
      RETURN .F.
   ENDIF
   IF jppedi->pdStatus $ "C"
      MsgWarning( "Pedido cancelado!" )
      RETURN .F.
   ENDIF
   IF Substr( jppedi->pdTransa, 1, 3 ) > "500"
      MsgStop( "N�o � pedido de entrada!" )
      RETURN .F.
   ENDIF

   RETURN .T.

STATIC FUNCTION OkPedVen( mPedido )

   IF Val( mPedido ) == 0
      mPedido := Space(6)
      RETURN .T.
   ENDIF
   IF ! JPPEDIClass():Valida( @mPedido )
      RETURN .F.
   ENDIF
   IF jppedi->pdStatus $ "C"
      MsgWarning( "Pedido cancelado!" )
      RETURN .F.
   ENDIF
   IF Substr( jppedi->pdTransa, 1, 3 ) < "500"
      MsgStop( "N�o � pedido de sa�da!" )
      RETURN .F.
   ENDIF

   RETURN .T.

CREATE CLASS PBAR0010Class INHERIT frmCadastroClass

   METHOD UserFunction( lProcessou )
   METHOD LimpaBarra()
   METHOD FiltroBarra()
   METHOD TelaDados( lEdit )
   METHOD Especifico( lExiste )

   ENDCLASS

METHOD UserFunction( lProcessou ) CLASS PBAR0010Class

   DO CASE
   CASE ::cOpc == "X"
      ::AnulaBarra()
   CASE ::cOpc == "Z"
      ::LimpaBarra()
   CASE ::cOpc == "T"
      ::FiltroBarra()
   CASE ::cOpc == "O"
      PJPREGUSO( "JPBARRA", StrZero( Val( jpbarra->brNumLan ), 9 ) )
   OTHERWISE
      lProcessou := .F.
   ENDCASE

   RETURN lProcessou

METHOD LimpaBarra() CLASS PBAR0010Class

   IF ! MsgYesNo( "Confirma limpar dados do c�digo de barras?" )
      RETURN .T.
   ENDIF
   RecLock()
   REPLACE jpbarra->brPedCom WITH "", jpbarra->brPedVen WITH "", jpbarra->brCodBar2 WITH "", jpbarra->brItem WITH ""
   RecUnlock()

   RETURN NIL

METHOD FiltroBarra() CLASS PBAR0010Class

   LOCAL GetList := {}
   MEMVAR mFiltroBarra, mFiltroPedido

   mFiltroBarra  := Space(22)
   mFiltroPedido := Space(22)
   WSave()
   @ 9, 0 CLEAR TO 15, MaxCol()
   @ 9, 0 TO 15, MaxCol()
   @ 11, 5 SAY "C�d.Barras Pr�prio " GET mFiltroBarra PICTURE "@K 9999999999999999999999"
   @ 13, 5 SAY "Numero do Pedido   " GET mFiltroPedido PICTURE "@K 999999"
   Mensagem( "Digite c�d. barras ou pedido, ESC Sai" )
   READ
   IF LastKey() == K_ESC
      SET FILTER TO
      RETURN .T.
   ENDIF
   IF Val( mFiltroBarra ) != 0
      mFiltroBarra := StrZero( Val( mFiltroBarra ), 7 )
      SET FILTER TO jpbarra->brCodBar == mFiltroBarra
   ELSEIF Val( mFiltroPedido ) != 0
      mFiltroPedido := StrZero( Val( mFiltroPedido ), 6 )
      SET FILTER TO jpbarra->brPedCom == mFiltroPedido .OR. jpbarra->brPedVen == mFiltroPedido
   ENDIF

   RETURN NIL

METHOD TelaDados( lEdit ) CLASS PBAR0010Class

   LOCAL GetList := {}
   LOCAL mbrNumLan := jpbarra->brNumLan
   LOCAL mbrCodBar := jpbarra->brCodBar
   LOCAL mbrCodBar2:= jpbarra->brCodBar2
   LOCAL mbrItem   := jpbarra->brItem
   LOCAL mbrGarCom := jpbarra->brGarCom
   LOCAL mbrGarVen := jpbarra->brGarVen
   LOCAL mbrPedCom := jpbarra->brPedCom
   LOCAL mbrPedVen := jpbarra->brPedVen
   LOCAL mbrInfCom := jpbarra->brInfCom
   LOCAL mbrInfVen := jpbarra->brInfVen
   LOCAL mbrinfInc := jpbarra->brInfInc
   LOCAL mbrInfAlt := jpbarra->brInfAlt
   LOCAL mQtdOcorr

   hb_Default( @lEdit, .F. )
   IF ::cOpc == "I" .AND. lEdit
      mbrNumLan := ::axKeyValue[1]
   ENDIF
   ::ShowTabs()
   @ Row() + 1, 0 SAY "Num. Lan�to.........:" GET mbrNumLan WHEN .F.
   @ Row() + 2, 0 SAY "Cod.Barras Pr�prio..:" GET mbrCodBar
   @ Row() + 1, 0 SAY "Cod.Barras Forneced.:" GET mbrCodBar2
   @ Row() + 1, 0 SAY "Produto.............:" GET mbrItem PICTURE "@K 999999" VALID OkAqui( @mbrItem ) .AND. ReturnValue( .T., mbrGarCom := Date() + jpitem->ieGarCom )
   Encontra( mbrItem, "jpitem", "item" )
   @ Row(), 32 SAY jpitem->ieDescri
   @ Row()+1, 0 SAY "Pedido de Compra....:" GET mbrPedCom PICTURE "@K 999999" VALID OkAqui( @mbrPedCom )
   Encontra( mbrPedCom, "jppedi", "pedido" )
   @ Row(), Col()+2 SAY jppedi->pdDatEmi
   @ Row()+1, 0 SAY "Fornecedor..........: " + jppedi->pdCliFor
   Encontra( jppedi->pdCliFor, "jpcadas", "numlan" )
   @ Row(), 32 SAY jpcadas->cdNome
   @ Row() + 1, 0 SAY "Garantia de Compra..:" GET mbrGarCom
   @ Row() + 1, 0 SAY "Garantia de Venda...:" GET mbrGarVen
   @ Row() + 1, 0 SAY "Pedido de Venda.....:" GET mbrPedVen PICTURE "@K 999999" VALID OkAqui( @mbrPedVen )
   Encontra( mbrPedVen, "jppedi", "pedido" )
   @ Row(), Col() + 2 SAY jppedi->pdDatEmi
   Encontra( jppedi->pdPedido, "jpnota", "pedido" )
   @ Row() + 1, 0 SAY "Nota Fiscal de Venda: " + jpnota->nfNotFis
   Encontra( jppedi->pdPedido, "jpnota", "pedido" )
   @ Row(), Col() + 2 SAY jpnota->nfDatEmi
   @ Row() + 1, 0 SAY "Cliente.............: " + jppedi->pdCliFor
   Encontra( jppedi->pdCliFor, "jpcadas", "numlan" )
   @ Row(), 32 SAY jpcadas->cdNome
   @ Row() + 1, 0 SAY "Inf. Compra.........:" GET mbrInfCom WHEN .F.
   @ Row() + 1, 0 SAY "Inf. Venda..........:" GET mbrInfVen WHEN .F.
   @ Row() + 2, 0 SAY "Inf. Inclus�o.......:" GET mbrInfInc WHEN .F.
   @ Row() + 1, 0 SAY "Inf. Altera��o......:" GET mbrInfAlt WHEN .F.
   mQtdOcorr := QtdOcorrencias( "JPBARRA",jpbarra->brNumLan)
   @ Row() + 1, 0 SAY "Qtd.Ocorr�ncias.....: " + StrZero( mQtdOcorr, 3 ) COLOR Iif( mQtdOcorr < 1, SetColor(), SetColorAlerta() )

   //SetPaintGetList( GetList )
   IF ! lEdit
      CLEAR GETS
   ELSE
      Mensagem("Digite campos, ESC sai")
      READ
      Mensagem()
      IF LastKey() != K_ESC
         IF ::cOpc == "I"
            mbrNumLan := ::axKeyValue[1]
            IF mbrNumLan == "*NOVO*"
               mbrNumLan := NovoCodigo( "jpbarra->brNumLan" )
            ENDIF
            RecAppend()
            REPLACE ;
               jpbarra->brNumLan WITH mbrNumLan, ;
               jpbarra->brInfInc WITH mbrInfInc
            RecUnlock()
         ENDIF
         RecLock()
         REPLACE ;
            jpbarra->brPedCom  WITH mbrPedCom, ;
            jpbarra->brItem    WITH mbrItem, ;
            jpbarra->brPedVen  WITH mbrPedVen, ;
            jpbarra->brGarCom  WITH mbrGarCom, ;
            jpbarra->brGarVen  WITH mbrGarVen, ;
            jpbarra->brCodBar  WITH mbrCodBar, ;
            jpbarra->brCodBar2 WITH mbrCodBar2
         IF ::cOpc == "A"
            REPLACE jpbarra->brInfAlt WITH mbrInfAlt
         ENDIF
         RecUnlock()
      ENDIF
   ENDIF

   RETURN NIL

METHOD Especifico( lExiste ) CLASS PBAR0010Class

   LOCAL GetList := {}
   LOCAL mbrNumLan := jpbarra->brNumLan

   hb_Default( @lExiste, .F. )
   IF ::cOpc == "I"
      mbrNumLan := "*NOVO*"
   ENDIF
   @ Row()+1, 22 GET mbrNumLan PICTURE "@K 999999" VALID NovoMaiorZero( @mbrNumLan )
   Mensagem( "Digite campo, F9 Pesquisa, ESC Sai" )
   READ
   Mensagem()
   IF LastKey() == K_ESC .OR. ( mbrNumLan != "*NOVO*" .AND. Val( mbrNumLan ) < 1 )
      GOTO ::nUltRec
      RETURN .F.
   ENDIF
   SEEK mbrNumLan
   IF ! ::EspecificoExiste( lExiste, Eof() )
      RETURN .F.
   ENDIF
   ::axKeyValue[1] := mbrNumLan

   RETURN .T.
