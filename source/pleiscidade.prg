/*
PLEISCIDADE - CADASTRO DE CIDADES/PAISES
1993.08 Jos� Quintas
*/

#include "inkey.ch"
#include "hbclass.ch"

PROCEDURE pLeisCidade

   LOCAL oFrm := JPCIDADEClass():New()

   IF ! AbreArquivos( "jpuf", "jpcidade" )
      RETURN
   ENDIF
   SELECT jpcidade
   oFrm:Execute()
   CLOSE DATABASES

   RETURN

CREATE CLASS JPCIDADEClass INHERIT FrmCadastroClass

   METHOD GridSelection( cCampoKeyboard )
   METHOD Especifico( lExiste )
   METHOD TelaDados( lEdit )
   METHOD Valida( cCidade, cUf )

   ENDCLASS

METHOD GridSelection( cCampoKeyboard ) CLASS JPCIDADEClass

   LOCAL nSelect := Select(), cOrdSetFocus, oTBrowse

   hb_Default( @cCampoKeyboard, "CODIGO" )
   SELECT jpcidade
   oTBrowse := { ;
      { "NOME",   { || jpcidade->ciNome } }, ;
      { "UF",     { || jpcidade->ciUf } }, ;
      { "IBGE",   { || jpcidade->ciIbge } }, ;
      { "C�DIGO", { || jpcidade->ciNumLan } } }
   cOrdSetFocus := OrdSetFocus( "jpcidade2" )
   Fazbrowse( oTBrowse )
   IF LastKey() != K_ESC .AND. ! Eof()
      IF cCampoKeyboard == "CODIGO"
         KEYBOARD jpcidade->ciNumLan + Chr( K_ENTER )
      ELSE
         KEYBOARD Pad( jpcidade->ciNome, Len( GetActive():VarGet ) ) + Chr( K_ENTER )
      ENDIF
   ENDIF
   OrdSetFocus( cOrdSetFocus )
   SELECT ( nSelect )

   RETURN NIL

METHOD Especifico( lExiste ) CLASS JPCIDADEClass

   LOCAL GetList := {}
   LOCAL mciNumLan := jpcidade->ciNumLan

   IF ::cOpc == "I"
      mciNumLan := "*NOVO*"
   ENDIF
   @ Row()+1, 20 GET mciNumLan PICTURE "@K 999999" VALID NovoMaiorZero( @mciNumLan )
   Mensagem( "Digite c�digo, F9 pesquisa, ESC volta" )
   READ
   Mensagem()
   IF LastKey() == K_ESC .OR. ( Val(mciNumLan) == 0 .AND. mciNumLan != "*NOVO*" )
      GOTO ::nUltRec
      RETURN .F.
   ENDIF
   SEEK mciNumLan
   IF ! ::EspecificoExiste( lExiste, Eof() )
      RETURN .F.
   ENDIF
   ::axKeyValue := { mciNumLan }

   RETURN .T.

METHOD TelaDados( lEdit ) CLASS JPCIDADEClass

   LOCAL GetList := {}
   LOCAL mciNumLan, mciNome, mciUF, mciIBGE, mciInfInc, mciInfAlt
   LOCAL cnMySql := ADOClass():New( AppcnMySqlLocal() )

   mciNumLan := jpcidade->ciNumLan
   mciNome   := jpcidade->ciNome
   mciUf     := jpcidade->ciUf
   mciIbge   := jpcidade->ciIbge
   mciInfInc := jpcidade->ciInfInc
   mciInfAlt := jpcidade->ciInfAlt

   hb_Default( @lEdit, .F. )
   IF ::cOpc == "I" .AND. lEdit
      mciNumLan := ::axKeyValue[1]
      ::nNumTab := 1
   ENDIF
   DO WHILE .T.
      ::ShowTabs()
      DO CASE
      CASE ::nNumTab == 1
         @ Row() + 1, 1  SAY "Cidade/Pa�s......:" GET mciNumLan  WHEN .F.
         @ Row() + 2, 1  SAY "Descri��o........:" GET mciNome    PICTURE "@!"       VALID ! Empty( mciNome )
         @ Row() + 1, 1  SAY "Sigla UF (ou EX).:" GET mciUf      PICTURE "@K!A"     VALID JPUFClass():Valida( @mciUf )
         Encontra( mciUf, "jpuf", "numlan" )
         @ Row(), 32   SAY jpuf->ufDescri
         @ Row() + 1, 1  SAY "C�digo IBGE/BACEN:" GET mciIbge    PICTURE "9999999"  VALID FillZeros( @mciIbge )
         @ Row() + 2, 1  SAY "Inf.Inclus�o.....:" GET mciInfInc  WHEN .F.
         @ Row() + 1, 1  SAY "Inf.Altera��o....:" GET mciInfAlt  WHEN .F.
      ENDCASE
      //SetPaintGetList( GetList )
      IF ! lEdit
         CLEAR GETS
         EXIT
      ENDIF
      Mensagem( "Digite campos, F9 Pesquisa, ESC Sai" )
      READ
      Mensagem()
      ::nNumTab += 1
      IF LastKey() == K_ESC
         EXIT
      ENDIF
      IF ::nNumTab > Len( ::acTabName )
         EXIT
      ENDIF
   ENDDO
   IF ! lEdit
      RETURN NIL
   ENDIF
   ::nNumTab := 1
   IF LastKey() == K_ESC
      RETURN NIL
   ENDIF
   IF ::cOpc == "I"
      mciNumLan := ::axKeyValue[ 1 ]
      IF mciNumLan == "*NOVO*"
         mciNumLan := NovoCodigo( "jpcidade->ciNumLan" )
      ENDIF
      RecAppend()
      REPLACE ;
         jpcidade->ciNumLan WITH mciNumLan, ;
         jpcidade->ciInfInc WITH LogInfo()
      RecUnlock()
      //WITH OBJECT cnMySql
      //   :QueryCreate()
      //   :QueryAdd( "CINUMLAN", mciNumLan )
      //   :QueryAdd( "CIINFINC", LogInfo() )
      //   :QueryExecuteInsert( "JPCIDADE" )
      //ENDWITH
   ENDIF
   RecLock()
   REPLACE ;
      jpcidade->ciNome WITH mciNome, ;
      jpcidade->ciUf   WITH mciUf, ;
      jpcidade->ciIbge WITH mciIbge
   cnMySql:cSql := "UPDATE JPCIDADE SET CINOME=" + StringSql( mciNome ) + ", CIUF=" + StringSql( mciUF ) + ", CIIBGE=" + StringSql( mciIbge )
   IF ::cOpc == "A"
      REPLACE jpcidade->ciInfAlt WITH LogInfo()
      cnMySql:cSql += ", CIINFALT=" + StringSql( LogInfo() )
   ENDIF
   cnMySql:cSql += " WHERE CINUMLAN=" + StringSql( mciNumLan ) + ";"
   RecUnlock()
   //cnMySql:ExecuteCmd()

   RETURN NIL

METHOD Valida( cCidade, cUf ) CLASS JPCIDADEClass

   LOCAL lOk := .T.

   IF ! Encontra( cUf + cCidade, "jpcidade", "jpcidade3" )
      MsgWarning( "Cidade/Pa�s n�o cadastrado!" )
      lOk := .F.
   ENDIF
   IF Empty( cCidade )
      lOk := .F.
   ENDIF

   RETURN lOk
