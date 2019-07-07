/*
PCONTREL0230 - RELACAO DE LANCAMENTOS PADRAO
1993.05 Jos� Quintas
*/

#include "josequintas.ch"
#include "inkey.ch"

PROCEDURE PCONTREL0230

   LOCAL GetList := {}, nOpcGeral, acTxtGeral
   MEMVAR m_DeAte, m_TxtDeAte, mctLancpi, mctlancpf, nOpcPrinterType

   IF ! abrearquivos( "jpempre", "jptabel", "ctplano", "cthisto", "ctlanca" )
      RETURN
   ENDIF
   SELECT ctlanca

   IF File( "PCONTREL0230.mem" )
      RESTORE FROM ( "PCONTREL0230" ) ADDITIVE
   ENDIF

   m_deate   = 1
   mctLancPi = Space( 6 )
   mctLancPf = Space( 6 )
   DECLARE m_txtdeate := { "Todos", "Intervalo" }

   nOpcPrinterType := AppPrinterType()

   nOpcGeral = 1
   acTxtGeral := Array( 4 )

   WOpen( 5, 4, Len( acTxtGeral ) + 7, 45, "Op��es dispon�veis" )

   DO WHILE .T.
      acTxtGeral := { ;
         TxtImprime(), ;
         TxtSalva(), ;
         "Intervalo : " + iif( m_DeAte == 1, m_txtdeate[ 1 ], ;
         mctLancPi + " A " + mctLancPf ), ;
         "Sa�da.....: " + TxtSaida()[ nOpcPrinterType ] }

      FazAchoice( 7, 5, Len( acTxtGeral ) + 6, 44, acTxtGeral, @nOpcGeral )

      DO CASE

      CASE LastKey() == K_ESC
         EXIT

      CASE nOpcGeral == 1
         IF ConfirmaImpressao()
            Imprime()
         ENDIF

      CASE nOpcGeral == 2

      CASE nOpcGeral == 3
         WOpen( 9, 25, 13, 65, "Intervalo" )
         DO WHILE .T.
            FazAchoice( 11, 26, 12, 64, m_txtdeate, @m_deate )
            IF LastKey() != K_ESC .AND. m_deate == 2
               WOpen( 12, 45, 16, 65, "C.Lanc." )
               @ 14, 47 GET mctLancPi PICTURE "@k 999999" VALID CTLANCAClass():Valida( @mctLancPi )
               @ 15, 47 GET mctLancPf PICTURE "@k 999999" VALID CTLANCAClass():Valida( @mctLancPf )
               Mensagem( "Digite C�digo do Lan�amento, F9 pesquisa, ESC sai" )
               READ
               WClose()
               IF LastKey() == K_ESC
                  LOOP
               ENDIF
            ENDIF
            EXIT
         ENDDO
         WClose()

      CASE nOpcGeral == 4
         WAchoice( 11, 25, TxtSaida(), @nOpcPrinterType, "Sa�da" )
         AppPrinterType( nOpcPrinterType )

      ENDCASE
   ENDDO
   WClose()
   CLOSE DATABASES

   RETURN

STATIC FUNCTION imprime()

   LOCAL oPDF, nKey, m_Chave, m_ImpTit
   MEMVAR m_DeAte, mctLancpi, mctlancpf, nOpcPrinterType

   oPDF := PDFClass():New()
   oPDF:SetType( nOpcPrinterType )
   oPDF:Begin()

   oPDF:acHeader := { "", "", "", "" }
   oPDF:acHeader[ 1 ] = "RELACAO DE LANCAMENTOS PADRAO"

   oPDF:acHeader[ 2 ] = ""
   IF m_deate == 2
      oPDF:acHeader[ 2 ] = "De: " + mctLancPi + "ate': " + mctLancPf
   ENDIF
   oPDF:acHeader[ 2 ] = Trim( oPDF:acHeader[ 2 ] )
   oPDF:acHeader[ 3 ] = "--COD--  --SEQ-  PARTIDA-  LANCAM.  CD. CONTA NORMAL / REDUZI" + ;
      "DO ------------ DESCRICAO ------------  --------- CEN" + ;
      "TRO DE CUSTO ----------"
   oPDF:acHeader[ 4 ] = Space( 23 ) + Replicate( "-", 49 ) + " HISTORICO " + Replicate( ;
      "-", 48 )
   nKey = 0

   IF m_deate == 1
      GOTO TOP
   ELSE
      SEEK mctLancPi
   ENDIF

   DO WHILE nKey != K_ESC .AND. ! Eof()
      nKey = Inkey()
      DO CASE
      CASE ctlanca->laCodigo > mctLancPf .AND. m_deate == 2
         EXIT
      CASE oPDF:nRow > oPDF:MaxRow() - 9
         oPDF:PageHeader()
      ENDCASE
      m_chave  = ctlanca->laCodigo
      m_imptit = .T.
      DO WHILE ctlanca->laCodigo = m_chave .AND. nKey != K_ESC .AND. ! Eof()
         nKey = Inkey()
         IF oPDF:nRow > oPDF:MaxRow() - 9
            oPDF:PageHeader()
            m_imptit = .T.
         ENDIF
         IF m_imptit
            oPDF:DRAWTEXT( oPDF:nRow, 0, ctlanca->laCodigo )
            oPDF:DRAWTEXT( oPDF:nRow, 12, iif( ctlanca->laPartida == "S", "Simples", ;
               iif( ctlanca->laPartida == "D", "Dobrada", ;
               iif( ctlanca->laPartida == "M", "Multipla", "" ) ) ) )
            m_imptit = .F.
         ENDIF
         oPDF:DRAWTEXT( oPDF:nRow, 22, iif( ctlanca->laDebCre == "D", "Debito", iif( ctlanca->laDebCre == "C", "Credito", "" ) ) )
         IF ! encontra( ctlanca->laCConta, "ctplano" )
            oPDF:DRAWTEXT( oPDF:nRow, 31, "*** conta nao cadastrada ***" )
         ELSE
            oPDF:DRAWTEXT( oPDF:nRow, 31, PicConta( ctlanca->laCConta ) )
            oPDF:DRAWTEXT( oPDF:nRow, 51, ctplano->a_Reduz, "999999" )
            oPDF:DRAWTEXT( oPDF:nRow, 59, ctplano->a_nome )
         ENDIF
         Encontra( AUX_CCUSTO + ctlanca->laCCusto, "jptabel", "numlan" )
         oPDF:DRAWTEXT( oPDF:nRow, 104, Pad( AUXCCUSTOClass():Descricao( ctlanca->laCCusto ), 25 ) )
         oPDF:nRow += 1
         IF Val( ctlanca->laHisPad ) == 0
            oPDF:DRAWTEXT( oPDF:nRow, 31, Substr( ctlanca->laHisto, 1, 100 ) )
            oPDF:nRow += 1
            IF ! Empty( Substr( ctlanca->laHisto, 101 ) )
               oPDF:DRAWTEXT( oPDF:nRow, 31, Substr( ctlanca->laHisto, 101, 100 ) )
               oPDF:nRow += 1
               IF ! Empty( Substr( ctlanca->laHisto, 201 ) )
                  oPDF:DRAWTEXT( oPDF:nRow, 31, Substr( ctlanca->laHisto, 201 ) )
                  oPDF:nRow += 1
               ENDIF
            ENDIF
         ELSE
            oPDF:DRAWTEXT( oPDF:nRow, 24, ctlanca->laHisPad, "999999" )
            IF ! encontra( ctlanca->laHisPad, "cthisto" )
               oPDF:DRAWTEXT( oPDF:nRow, 31, "*** historico nao cadastrado ***" )
               oPDF:nRow += 1
            ELSE
               oPDF:DRAWTEXT( oPDF:nRow, 31, Substr( cthisto->hiDescri, 1, 100 ) )
               oPDF:nRow += 1
               IF Len( Trim( Substr( cthisto->hiDescri, 101, 100 ) ) ) <> 0
                  oPDF:DRAWTEXT( oPDF:nRow, 31, Substr( cthisto->hiDescri, 101, 100 ) )
                  oPDF:nRow += 1
                  IF Len( Trim( Substr( cthisto->hiDescri, 201 ) ) ) <> 0
                     oPDF:DRAWTEXT( oPDF:nRow, 31, Substr( cthisto->hiDescri, 201 ) )
                     oPDF:nRow += 1
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
         SELECT ctlanca
         SKIP
         oPDF:nRow += 1
      ENDDO
      oPDF:DRAWLINE( oPDF:nRow, 0, oPDF:nRow, oPDF:MaxCol() )
      oPDF:nRow += 2
   ENDDO
   oPDF:End()

   RETURN NIL
