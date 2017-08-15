/*
PBOL0030 - GERA TXT PRA BOLETOS ITAU PELO FINANC
2012.02 Jos� Quintas
*/

#include "josequintas.ch"
#include "inkey.ch"

PROCEDURE PBOL0030

   LOCAL GetList := {}, mDir, mDirItau, mFileTxt, mLetra, mPrimeira, mRecNo, mfiNumLan, nCont, mIdade, mFilial
   MEMVAR mDocBanco, mTxJuros, mAgencia, mConta, mCarteira, mTaxaBoleto, mQtRegs

   IF ! AbreArquivos( "jpconfi", "jptabel", "jpempre", "jpcadas", "jpfinan", "jpnota" )
      RETURN
   ENDIF
   SELECT jpcadas

   mDirItau := "ITAU\"

   mDir := Directory( mDirItau + "I*.TXT" )
   FOR nCont = 1 TO Len( mDir )
      mIdade := ( Date() - mDir[ nCont, 3 ] )
      IF mIdade > 60
         FErase( mDirItau + mDir[ nCont, 1 ] )
      ENDIF
   NEXT

   mFileTxt := "I" + SubStr( DToS( Date() ), 3 )
   mLetra := 65 // "A"
   DO WHILE File( mDirItau + mFileTxt + Chr( mLetra ) + ".txt" )
      mLetra += 1
   ENDDO
   mFileTxt := mFileTxt + Chr( mLetra ) + ".txt"

   SET ALTERNATE TO ( mDirItau + mFileTxt )

   mQtRegs   := 1 // Qtde. Registros
   mDocBanco := Pad( LeCnf( "BOLETO NOSSO" ), 6 )
   mTxJuros  := Val( LeCnf( "BOLETO JUROS" ) )
   mAgencia  := Pad( LeCnf( "BOLETO AGENCIA" ), 4 )
   mConta    := Pad( LeCNf( "BOLETO CONTA" ), 6 )
   mCarteira := "109"
   mfiNumLan := Space( 6 )
   IF AppEmpresaApelido() == "CORDEIRO"
      mFilial := StrZero( 3, 6 )
   ELSEIF AppEmpresaApelido() == "JPA"
      mFilial := StrZero( 2, 6 )
   ELSE
      IF AppEmpresaApelido() == "MARINGA"
         // mCarteira := "157"
      ENDIF
      mFilial := StrZero( 1, 6 )
   ENDIF

   mPrimeira := .T.
   mTaxaBoleto := 0

   mDocBanco := StrZero( Val( LeCnf( "BOLETO NOSSO" ) ) + 1, 6 )
   DO WHILE .T.
      SELECT jpfinan
      @ 20, 1 SAY "SENDO GRAVADO EM " + mFileTxt
      @ 6, 1  SAY "Ag�ncia.........:" GET mAgencia  PICTURE "@K 9999" WHEN mPrimeira
      @ 7, 1  SAY "Conta...........:" GET mConta    PICTURE "@K 999999" WHEN mPrimeira
      @ 8, 1  SAY "Nosso N�mero....:" GET mDocBanco PICTURE "@K 999999" VALID FillZeros( @mDocBanco ) WHEN mPrimeira
      @ 9, 1  SAY "Juros Mensais(%):" GET mTxJuros  PICTURE "999.99" VALID mTxJuros > 0 WHEN mPrimeira
      @ 10, 1 SAY "Carteira........:" GET mCarteira PICTURE "999" VALID FillZeros( @mCarteira ) WHEN mPrimeira
      @ 11, 1 SAY "Filial..........:" GET mFilial   PICTURE "@K 999999" VALID AuxFilialClass():Valida( @mFilial ) WHEN mPrimeira
      IF "MARINGA" $ AppEmpresaApelido()
         @ 12, 1 SAY "Taxa de Boleto..:" GET mTaxaBoleto PICTURE "99999999.99" VALID mTaxaBoleto >= 0 WHEN mPrimeira
      ENDIF
      READ
      IF LastKey() == K_ESC
         EXIT
      ENDIF
      IF jpfinan->fiTipLan == "2"
         MSGSTOP( "Lan�amento se refere a contas a pagar" )
         LOOP
      ENDIF
      IF Encontra( mDocBanco, "jpfinan", "numbanco" )
         MsgWarning( "ATEN��O! Num.Banc�rio j� utilizado, ou emiss�o em duas m�quinas, somando 10 ao num.banc�rio!" )
         IF Val( mDocBanco ) > 999900
            mDocBanco := StrZero( 1, 6 )
         ELSE
            mDocBanco := StrZero( Val( mDocBanco ) + 10, 6 )
         ENDIF
         ordSetFocus( "numlan" )
         mPrimeira := .T.
         LOOP
      ENDIF
      mPrimeira := .F.
      @ 13, 1 SAY "Num.Financeiro..:" GET mfiNumLan PICTURE "@K!" VALID FillZeros( @mfiNumLan ) .AND. Encontra( mfiNumLan, "jpfinan", "numlan" )
      Mensagem( "Digite campos, F9 Pesquisa, ESC Sai" )
      READ
      Mensagem()
      IF LastKey() == K_ESC
         EXIT
      ENDIF
      IF ! Empty( jpfinan->fiNumBan )
         IF ! MSGYESNO( "Lan�amento j� cont�m n�mero banc�rio. Continua?" )
            LOOP
         ENDIF
      ENDIF
      IF ( Date() - jpfinan->fiDatEmi ) > 5
         IF ! MSGYESNO( "Documento emitido h� mais de 5 dias. Continua?" )
            LOOP
         ENDIF
      ENDIF
      Encontra( jpfinan->fiCliFor, "jpcadas", "numlan" )
      Encontra( AUX_FINPOR + jpcadas->cdPortador, "jptabel", "numlan" )
      IF ! "ITAU" $ jptabel->axDescri .OR. "DEPOSITO" $ "ITAU"
         IF ! MSGYESNO( "Portador � " + Trim( jptabel->axDescri ) + ". Continua?" )
            LOOP
         ENDIF
      ENDIF
      IF mQtRegs == 1
         TxtItau( "I" )
      ENDIF

      mRecNo := RecNo()
      IF Encontra( mDocBanco, "jpfinan", "numbanco" )
         MsgWarning( "ATEN��O! M�dulo parece estar em uso em duas m�quinas de uma vez!" )
         SELECT jpfinan
         ordSetFocus( "numbanco" )
         GOTO BOTTOM
         mDocBanco := StrZero( Val( SubStr( jpfinan->fiNumBan, 1, 6 ) ), 6 )
         ordSetFocus( "pedido" )
      ENDIF
      GOTO ( mRecNo )
      TxtItau( "D" )
      Scroll( 6, 41, MaxRow() - 3, MaxCol(), 1 )
      @ MaxRow() - 3, 41 SAY jpfinan->fiParcela + "." + DToC( jpfinan->fiDatVen ) + " " + Pad( jpcadas->cdNome, 15 ) + " " + Transform( jpfinan->fiValor + mTaxaBoleto, "9,999,999.99" )
      SELECT jpfinan
      RecLock()
      REPLACE jpfinan->fiNumBan WITH  mDocBanco
      RecUnlock()
      mDocBanco := StrZero( Val( mDocBanco ) + 1, 6 )
      GravaCnf( "BOLETO NOSSO", StrZero( Val( mDocBanco ) - 1, 6 ) ) // Corrigido
   ENDDO
   TxtItau( "F" )
   SET ALTERNATE TO
   fDelEof( mDirItau + mFileTxt )
   IF mQtRegs < 4 // N�o tem conteudo
      FErase( mDirItau + mFileTxt )
      MsgWarning( "Arquivo sem conte�do" )
   ELSE
      GravaCnf( "BOLETO JUROS", LTrim( Str( mTxJuros ) ) )
      GravaCnf( "BOLETO AGENCIA", mAgencia )
      GravaCnf( "BOLETO CONTA", mConta )
      MSGEXCLAMATION( "Gerado arquivo " + mFileTxt )
   ENDIF
   CLOSE DATABASES

   RETURN

STATIC FUNCTION TxtItau( mTipoReg )

   LOCAL mTxtDocto, mValor, mCnpj
   MEMVAR mDocBanco, mTxJuros, mAgencia, mConta, mCarteira, mQtRegs, mTaxaBoleto

   mTxtDocto := jpfinan->fiNumDoc
   IF ! Empty( jpfinan->fiParcela )
      mTxtDocto := mTxtDocto + "/" + jpfinan->fiParcela
   ENDIF

   SET ALTERNATE ON
   SET CONSOLE OFF

   DO CASE
   CASE mTipoReg == "I" // Inicial
      ?? "0"
      ?? "1"
      ?? "REMESSA"
      ?? "01"
      ?? Pad( "COBRANCA", 15 )
      ?? mAgencia
      ?? "00"
      ?? SubStr( mConta, 1, Len( mConta ) - 1 )
      ?? SubStr( mConta, Len( mConta ), 1 )
      ?? Space( 8 )
      ?? Pad( AppEmpresaNome(), 30 )
      ?? "341"
      ?? Pad( "BANCO ITAU S/A", 15 )
      ?? hb_Dtoc( Date(), "DDMMYY" )
      ?? Space( 294 )
      ?? StrZero( mQtRegs, 6 )
      ?
   CASE mTipoReg == "F" // Final
      ?? "9"
      ?? Space( 393 )
      ?? StrZero( mQtRegs, 6 )
      ?
   CASE mTipoReg == "D"
      mValor := jpfinan->fiValor + mTaxaBoleto
      ?? "1"
      IF Val( jpfinan->fiSacado ) == 0 .OR. jpfinan->fiSacado == jpfinan->fiCliFor
         ?? "02" // 04=CNPJ EMPRESA
         ?? StrZero( Val( SoNumeros( jpempre->emCnpj ) ), 14 )
      ELSE
         Encontra( jpfinan->fiCliFor, "jpcadas", "numlan" )
         IF Len( SoNumeros( jpcadas->cdCnpj ) ) == 14
            ?? "04" // 04=CNPJ TERCEIRO
         ELSE
            ?? "03"
         ENDIF
         ?? Pad( SoNumeros( jpcadas->cdCnpj ), 14 )
      ENDIF
      ?? mAgencia
      ?? "00"
      ?? SubStr( mConta, 1, Len( mConta ) - 1 )
      ?? SubStr( mConta, Len( mConta ), 1 )
      ?? Space( 4 )
      ?? Space( 4 ) // Nota 27
      ?? Pad( jpfinan->fiDocAux, 25 )
      // ?? Space(25) // Titulo na empresa
      IF mCarteira == "112"
         ?? Space( 8 ) // Escritural, o Itau ira' preencher
      ELSE
         ?? StrZero( Val( mDocBanco ), 8 ) // Direta, sequencial
      ENDIF
      ?? StrZero( 0, 13 ) // Outra moeda
      ?? mCarteira // "109"
      ?? Space( 21 )
      ?? "I" // Nota 5
      ?? "01" // Remessa - Nota 6
      IF jpfinan->fiCliFor == jpfinan->fiSacado
         IF "CARREFOUR" $ jpcadas->cdNome .OR. "ELDORADO S/A" $ jpcadas->cdNome
            IF "/" $ mTxtDocto
               mTxtDocto := SubStr( mTxtDocto, 1, At( "/", mTxtDocto ) - 1 )
               mTxtDocto := StrZero( Val( mTxtDocto ), 9 ) + " "
            ENDIF
            ?? mTxtDocto
         ELSE
            ?? Right( mTxtDocto, 10 ) // Nota 18
         ENDIF
      ELSE
         ?? Pad( jpfinan->fiDocAux, 10 )
      ENDIF
      ?? hb_Dtoc( jpfinan->fiDatVen, "DDMMYY" )
      ?? StrZero( mValor * 100, 13 )
      ?? "341"
      ?? StrZero( 0, 5 ) // Nota 9 - Agencia cobradora
      ?? "01" // Cordeiro - Duplicata Mercantil
      ?? "N"  // Aceite
      ?? hb_Dtoc( jpfinan->fiDatEmi, "DDMMYY" )
      IF ( "CORDEIRO" $ AppEmpresaApelido() .OR. "CARBOLUB" $ AppEmpresaApelido() ) .AND. jpfinan->fiCliFor == jpfinan->fiSacado
         ?? "43" // SUJEITO A PROTESTO SE N�O FOR PAGO NO VENCIMENTO
      ELSE
         ?? "  " // Instrucao Nota 11 - mensagens
      ENDIF
      ?? "  " // Instrucao Nota 11 - mensagens
      ?? StrZero( mValor * mTxJuros / 30, 13 )
      ?? "      " // Data limite pra desconto
      ?? StrZero( 0, 13 ) // Desconto a ser concedido - nota 13
      ?? StrZero( 0, 13 ) // IOF recolhido - nota 14
      ?? StrZero( 0, 13 ) // Abatimento concedido - nota 13
      IF Val( jpfinan->fiSacado ) == 0
         Encontra( jpfinan->fiClifor, "jpcadas", "numlan" )
      ELSE
         Encontra( jpfinan->fiSacado, "jpcadas", "numlan" )
      ENDIF
      mCnpj := SoNumeros( jpcadas->cdCnpj )
      IF Len( mCnpj ) <= 11
         ?? "01"
      ELSE
         ?? "02" // 01=CPF 02=CNPJ
      ENDIF
      ?? StrZero( Val( mCnpj ), 14 )
      ?? Pad( jpcadas->cdNome, 30 )
      ?? Space( 10 ) // Nota 15
      ?? Pad( Trim( jpcadas->cdEndCob ) + " " + Trim( jpcadas->cdNumCob ) + " " + Trim( jpcadas->cdComCob ), 40 )
      ?? Pad( jpcadas->cdBaiCob, 12 )
      ?? StrZero( Val( SoNumeros( jpcadas->cdCepCob ) ), 8 )
      ?? Pad( jpcadas->cdCidCob, 15 )
      ?? jpcadas->cdUfCob
      Encontra( jpfinan->fiCliFor, "jpcadas", "numlan" )
      IF jpfinan->fiCliFor == jpfinan->fiSacado
         ?? Space( 30 )
      ELSE
         ?? Pad( jpcadas->cdNome, 30 )
      ENDIF
      ?? Space( 4 )
      ?? hb_Dtoc( jpfinan->fiDatVen, "DDMMYY" ) // Data de mora
      ?? StrZero( 0, 2 ) // Qtd.Dias - nota 11
      ?? Space( 1 )
      ?? StrZero( mQtRegs, 6 )
      ?

   ENDCASE
   mQtRegs += 1
   SET ALTERNATE OFF
   SET CONSOLE   ON

   RETURN NIL
