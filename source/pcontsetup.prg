/*
PCONTSETUP - CONFIGURACAO DA CONTABILIDADE
1992.01 Jos� Quintas
*/

#include "inkey.ch"

PROCEDURE PCONTSETUP

   LOCAL GetList := {}, lAltera := .F.
   LOCAL m_SemConta
   LOCAL memPicture, memAnoBase, memDiaMes, memDiaDem, memDiaBal, memDiaPla, memQtdPag, memFecha, memHisFec, memResAcu, memDiaTer, memCodAcu

   IF ! AbreArquivos( "jpempre", "ctplano" )
      RETURN
   ENDIF
   SELECT ctplano
   GOTO TOP

   m_SemConta := Eof()
   memPicture  := jpempre->emPicture
   memAnoBase  := jpempre->emAnoBase
   memDiaMes   := jpempre->emDiaMes
   memDiaDem   := jpempre->emDiaDem
   memDiaBal   := jpempre->emDiaBal
   memDiaPla   := jpempre->emDiaPla
   memQtdPag   := jpempre->emQtdPag
   memFecha    := jpempre->emFecha
   memDiaTer   := jpempre->emDiaTer
   memResAcu   := jpempre->emResAcu
   memHisFec   := jpempre->emHisFec
   DO WHILE .T.
      @ 5, 2  SAY "Estrutura de Contas..:" GET memPicture PICTURE "@!"     VALID OkPicture( memPicture )
      @ Row()+1, 2  SAY "Ano Base.............:" GET memAnoBase PICTURE "9999"   VALID memAnoBase > 2000
      @ Row()+2, 2  SAY "Meses p/ Livro Di�rio:" GET memDiaMes  PICTURE "99"     VALID StrZero( memDiaMes, 2 ) $ "01.02.03.04.06.12"
      @ Row(), Col()+2 SAY "( 1, 2, 3, 4, 6 ou 12 )"
      @ Row()+1, 2  SAY "Di�rio com Demonstr..:" GET memDiaDem  PICTURE "!A"     VALID memDiaDem $ "SN"
      @ Row()+1, 2  SAY "Di�rio com Balan�o...:" GET memDiaBal  PICTURE "!A"     VALID memDiaBal $ "SN"
      @ Row()+1, 2  SAY "Di�rio com Plano Ctas:" GET memDiaPla  PICTURE "!A"     VALID memDiaPla $ "SN"
      @ Row()+1, 2  SAY "Limite Folhas p/Livro:" GET memQtdPag  PICTURE "999"    VALID memQtdPag > 100
      @ Row(), Col()+2 SAY " (Minimo 100 folhas)"
      @ Row()+1, 2  SAY "Layout dos termos....:" GET memDiaTer  PICTURE "9"     VALID memDiaTer $ "12"
      @ Row(), Col()+2 SAY "( 1 ou 2 )"
      @ Row()+2, 2  SAY "Fechamento (meses)...:" GET memFecha   PICTURE "99" VALID StrZero( memFecha, 2 ) $ "01.02.03.04.06.12"
      @ Row(), Col()+2 SAY "( 1, 2, 3, 4, 6 ou 12 )"
      @ Row()+1, 2  SAY "Hist. de  Fechamento.:" GET memHisFec PICTURE "@!S80"
      @ Row()+1, 2  SAY "Resultado Acumulado..:" GET memResAcu    PICTURE "@R " + memPicture VALID OkctResAcu( memResAcu ) WHEN ! m_SemConta
      Encontra( CodContabil( memResAcu ), "ctplano", "ctplano1" )
      @ Row(), 50 SAY ctplano->a_nome
      @ Row()+5, 2  SAY "Movimenta��o anterior ao ano base ser� desprezada (*Poder�o ser eliminados dados anteriores ao ano base)"
      @ Row()+1, 2  SAY "Tenha certeza de que o ano base esta correto. (*Pode ser necess�rio fazer o rec�lculo ap�s altera��o)"
      @ Row()+1, 2  SAY "Se esta em d�vida sobre o ano base, fa�a um backup antes de alter�-lo"
      //SetPaintGetList( GetList )
      IF ! lAltera
         CLEAR GETS
      ENDIF
      IF lAltera
         Mensagem( "Digite campos, ESC Sai" )
         READ
         Mensagem()
         IF LastKey() == K_ESC
            lAltera := .F.
            LOOP
         ENDIF
      ELSEIF ! MsgYesNo( "Altera alguma configura��o" )
         EXIT
      ELSE
         lAltera := .T.
         LOOP
      ENDIF

      lAltera  := .F.
      SELECT jpempre
      RecLock()
      REPLACE jpempre->emDiaMes WITH memDiaMes, jpempre->emQtdPag WITH memQtdPag, jpempre->emDiaBal WITH memDiaBal, ;
         jpempre->emDiaDem WITH memDiaDem, jpempre->emDiaPla WITH memDiaPla, jpempre->emFecha WITH memFecha, ;
         jpempre->emAnoBase WITH memAnoBase, jpempre->emPicture WITH memPicture, jpempre->emDiaTer WITH memDiaTer, ;
         jpempre->emResAcu WITH memResAcu, jpempre->emHisFec WITH memHisFec
      RecUnlock()
      memPicture := Trim( memPicture )
      memCodAcu = GrupoContabil( jpempre->emResAcu )
      SELECT jpempre
      RecLock()
      REPLACE jpempre->emCodAcu WITH memCodAcu
      RecUnlock()
   ENDDO
   CLOSE DATABASES

   RETURN

STATIC FUNCTION OkPicture( mPicture )

   LOCAL lReturn := .T., nCont, mQtNiveis, nQt9, aTamanhos := {}, nTamanhoAtual, cTxt

   mPicture := Trim( mPicture )
   IF Right( mPicture, 3 ) != "9-9"
      MsgWarning( "Formato Inv�lido! Necessario d�gito no final -9!" )
      lReturn = .F.
   ELSE
      FOR nCont = 1 TO Len( Trim( mPicture ) ) - 2
         IF ! Substr( mPicture, nCont, 1 ) $ ".9"
            MsgWarning( "Formato inv�lido! Aceitos 9 indicando n�mero, . (ponto) indicando separa��o, e -9 indicando d�gito no final!" )
            lReturn = .F.
         ENDIF
      NEXT
      IF ".." $ mPicture
         MsgWarning( "Formato inv�lido! .. indica a falta de definir d�gitos de um n�vel!" )
         lReturn := .F.
      ENDIF
      nQt9 := 0
      FOR nCont = 1 TO Len( mPicture )
         IF Substr( mPicture, nCont, 1 ) == "9"
            nQt9 += 1
         ENDIF
      NEXT
      IF nQt9 > 12
         MsgWarning( "Formato inv�lido! Total de numeros excede o m�ximo de 12 n�meros!" )
         lReturn := .F.
      ENDIF
   ENDIF
   IF lReturn
      mQtNiveis := 0
      FOR nCont = 1 TO Len( mPicture )
         IF Substr( mpicture, nCont, 1 ) $ "."
            mQtNiveis += 1
         ENDIF
      NEXT
      mQtNiveis := mQtNiveis + 1
      IF mQtNiveis < 4
         MsgWarning( "Formato inv�lido! SPED Cont�bil requer um m�nimo de 4 n�veis!" )
         lReturn := .F.
      ENDIF
   ENDIF
   IF lReturn
      IF Trim( Substr( jpempre->emPicture, 1, 11 ) ) + Substr( jpempre->emPicture, 12, 1 ) != Trim( mPicture )
         Mensagem( "Verificando se formato escolhido atende plano de contas atual" )
         SELECT ctplano
         GOTO TOP
         DO WHILE ! Eof()
            nTamanhoAtual := Len( Trim( Substr( ctplano->a_Codigo, 1, 11 ) ) )
            IF aScan( aTamanhos, nTamanhoAtual ) == 0
               AAdd( aTamanhos, nTamanhoAtual )
            ENDIF
            SKIP
         ENDDO
         aSort( aTamanhos )
         cTxt := ""
         FOR nCont = 1 TO Len( aTamanhos )
            IF nCont == 1
               cTxt += Replicate( "9", aTamanhos[ nCont ] )
            ELSE
               cTxt += "." + Replicate( "9", aTamanhos[ nCont ] - aTamanhos[ nCont - 1 ] )
            ENDIF
         NEXT
         IF cTxt != Substr( mPicture, 1, Len( cTxt ) )
            MsgStop( "Formato m�nimo para plano de contas atual: " + cTxt + "-9" + hb_eol() )
            lReturn := .F.
         ENDIF
      ENDIF
   ENDIF

   RETURN lReturn

STATIC FUNCTION okctResAcu( memResAcu )

   LOCAL cCodigo, m_Digito, lReturn := .T.

   @ Row(), 50 SAY Space(40)
   IF Empty( memResAcu )
      lReturn = .F.
   ELSE
      Encontra( CodContabil( memResAcu ), "ctplano", "ctplano1" )
      @ Row(), 50 SAY ctplano->a_Nome
      m_Digito := Right( Trim( SoNumeros( memResAcu ) ), 1 )
      cCodigo  := Pad( Substr( SoNumeros( memResAcu ), 1, Len( SoNumeros( memResAcu ) ) - 1 ), 11 )
      cCodigo  := cCodigo + m_Digito
      IF ! Encontra( cCodigo, "ctplano" )
         MsgStop( "Conta cont�bil n�o cadastrada!")
         lReturn = .F.
      ELSEIF ctplano->a_grupo != "P"
         MsgWarning( "Conta n�o se refere a passivo!")
         lReturn = .F.
      ELSEIF ctplano->a_tipo != "A"
         MsgWarning( "Conta n�o e' anal�tica!")
         lReturn = .F.
      ENDIF
   ENDIF

   RETURN lReturn
