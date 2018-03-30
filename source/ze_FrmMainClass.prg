/*
ZE_FRMMAINCLASS - CLASSE GENERICA PRA TELAS
2013.01 Jos� Quintas

2018.02.19 Retirado icone fora de uso
*/

#include "inkey.ch"
#include "hbclass.ch"
#include "wvgparts.ch"
#include "hbgtwvg.ch"
#include "wvtwin.ch"

#define JPA_IDLE 600

EXTERNAL HB_KEYPUT

/*
THREAD STATIC aPaint := {}

FUNCTION WVT_Paint

   LOCAL oElement

   FOR EACH oElement IN aPaint
      Eval( oElement )
   NEXT

   RETURN NIL
*/

CREATE CLASS frmGuiClass

   VAR    cOpc             INIT "C"
   VAR    oButtons         INIT {}
   VAR    cOptions         INIT "IAE"
   VAR    acMenuOptions    INIT {}
   VAR    acTabName        INIT { "Geral" }
   VAR    acHotKeys        INIT {}
   VAR    GUIButtons       INIT {}
   VAR    acSubMenu        INIT {}
   VAR    nButtonWidth     INIT 6
   VAR    nButtonHeight    INIT 3.5
   VAR    oGetBox          INIT {}
   VAR    lNavigateOptions INIT .T. // First,Next,Previous,Last

   METHOD FormBegin()
   METHOD FormEnd()
   METHOD OptionCreate()
   METHOD ButtonCreate()
   METHOD ButtonSelect()
   METHOD ShowTabs()
   METHOD RowIni()
   METHOD GUIHide()       INLINE AEval( ::GuiButtons, { | oElement | oElement[ 3 ]:Hide() } )
   METHOD GUIShow()       INLINE AEval( ::GuiButtons, { | oElement | oElement[ 3 ]:Show() } ), wvgSetAppWindow():InvalidateRect()
   METHOD GUIDestroy()    INLINE AEval( ::GuiButtons, { | oElement | oElement[ 3 ]:Destroy() } )
   METHOD GUIEnable()     INLINE AEval( ::GuiButtons, { | oElement | oElement[ 3 ]:Enable() } )
   METHOD GUIDisable()    INLINE AEval( ::GuiButtons, { | oElement | oElement[ 3 ]:Disable() } )
   //METHOD IconFromCaption( cCaption, cTooltip )

   ENDCLASS

METHOD RowIni() CLASS frmGuiClass

   LOCAL nRowIni

   nRowIni := Round( 1 + ::nButtonHeight, 0 )
   nRowIni += iif( Len( ::acTabName ) < 2, 0, 2 )
   @ nRowIni, 0 SAY ""

   RETURN nRowIni

METHOD ShowTabs() CLASS frmGuiClass

   LOCAL nRow, nCol, oElement

   nRow    := ::RowIni() - iif( Len( ::acTabName ) < 2, 0, 2 )
   Scroll( nRow, 0, MaxRow() - 3, MaxCol(), 0 )
   ::RowIni()
   IF Len( ::acTabName ) < 2
      RETURN NIL
   ENDIF
   @ nRow, 0 SAY ""
   nCol := 0
   @ nRow + 2, 0 TO nRow + 2, MaxCol()
   FOR EACH oElement IN ::acTabName
      IF oElement:__EnumIndex == ::nNumTab
         @ nRow, nCol TO nRow + 2, nCol + Len( oElement ) + 1 COLOR SetColorNormal() // SetColorFocus()
      ENDIF
      @ nRow + 1, nCol + 1 SAY oElement COLOR iif( oElement:__EnumIndex == ::nNumTab, SetColorFocus(), SetColor() )
      nCol := nCol + Len( oElement ) + 2
   NEXT
   ::RowIni()

   RETURN NIL

METHOD OptionCreate() CLASS frmGuiClass

   LOCAL oElement, cLetter

   // MEMVAR m_Prog

   IF "I" $ ::cOptions
      AAdd( ::oButtons, { Asc( "I" ), "<I>Inclui" } )
      AAdd( ::acHotKeys, { K_INS,      Asc( "I" ) } )          // Traduz INS para Inclui
      Aadd( ::acHotKeys, { Asc( "0" ), Asc( "I" ) } )
   ENDIF
   IF "A" $ ::cOptions
      AAdd( ::oButtons, { Asc( "A" ), "<A>Altera" } )
   ENDIF
   IF "E" $ ::cOptions
      AAdd( ::oButtons, { Asc( "E" ), "<E>Exclui" } )
      AAdd( ::acHotKeys, { K_DEL,      Asc( "E" ) } ) // Traduz DEL para Exclui
      Aadd( ::acHotKeys, { Asc( "." ), Asc( "E" ) } )
      Aadd( ::acHotKeys, { Asc( "," ), Asc( "E" ) } )
   ENDIF
   IF ::lNavigateOptions
      AAdd( ::oButtons,  { Asc( "C" ), "<C>Consulta" } )
      AAdd( ::oButtons,  { Asc( "P" ), "<P>Primeiro" } )
      AAdd( ::oButtons,  { Asc( "-" ), "<->Anterior" } )
      AAdd( ::oButtons,  { Asc( "+" ), "<+>Seguinte" } )
      AAdd( ::oButtons,  { Asc( "U" ), "<U>�ltimo" } )
      Aadd( ::acHotKeys, { K_HOME,     Asc( "P" ) } )
      Aadd( ::acHotKeys, { Asc( "7" ), Asc( "P" ) } )
      Aadd( ::acHotKeys, { K_END,      Asc( "U" ) } )
      Aadd( ::acHotKeys, { Asc( "1" ), Asc( "U" ) } )
      Aadd( ::acHotKeys, { K_PGUP,     Asc( "-" ) } )
      Aadd( ::acHotKeys, { Asc( "9" ), Asc( "-" ) } )
      Aadd( ::acHotKeys, { K_PGDN,     Asc( "+" ) } )
      Aadd( ::acHotKeys, { Asc( "3" ), Asc( "+" ) } )
   ENDIF
   FOR EACH oElement IN ::acMenuOptions
      IF "<" $ oElement .AND. ">" $ oElement
         cLetter := Substr( oElement, 2, At( ">", oElement ) - 2 )
         DO CASE
         CASE Len( cLetter ) == 1 ;    Aadd( ::oButtons, { Asc( cLetter ), oElement } )
         CASE cLetter == "Alt-F" ;     Aadd( ::oButtons, { K_ALT_F, oElement } )
         CASE cLetter == "Alt-T" ;     Aadd( ::oButtons, { K_ALT_T, oElement } )
         CASE cLetter == "Alt-L" ;     Aadd( ::oButtons, { K_ALT_L, oElement } )
         CASE cLetter == "Up" ;        AAdd( ::oButtons, { K_UP, oElement } )
         CASE cLetter == "Down" ;      AAdd( ::oButtons, { K_DOWN, oElement } )
         CASE cLetter == "Ctrl-PgUp" ; AAdd( ::oButtons, { K_CTRL_PGUP, oElement } )
         CASE cLetter == "Ctrl-PgDn" ; AAdd( ::oButtons, { K_CTRL_PGDN, oElement } )
         CASE cLetter == "PgUp" ;      AAdd( ::oButtons, { K_PGUP, oElement } )
         CASE cLetter == "PgDn" ;      AAdd( ::oButtons, { K_PGDN, oElement } )
         CASE cLetter == "DEL" ;       Aadd( ::oButtons, { K_DEL, oElement } )
         CASE cLetter == "INS" ;       AAdd( ::oButtons, { K_INS, oElement } )
         CASE Len( cLetter ) > 1 .AND. Left( cLetter, 1 ) == "F" // Teclas de funcao (F2 a F48)(fx s-fx c-fx a-fx)
            Aadd( ::oButtons,  { -( Val( Substr( cLetter, 2 ) ) - 1 ), Substr( oElement, At( ">", oElement ) + 1 ) } )
            AAdd( ::acHotkeys, { -( Val( Substr( cLetter, 2 ) ) - 1 ), -( Val( Substr( cLetter, 2 ) ) - 1 ), cLetter } )
         ENDCASE
      ELSE
         cLetter := Substr( oElement, 1, 1 )
         AAdd( ::oButtons, { Asc( cLetter ), oElement } )
      ENDIF
   NEXT
   IF Len( ::oButtons ) > ( Int( ( MaxCol() + 1 ) / ::nButtonWidth ) )
      DO WHILE Len( ::oButtons ) > Int( ( MaxCol() + 1 ) / ::nButtonWidth ) - 1 // reserva 2 botoes:Sair/Mais
         AAdd( ::acSubMenu, AClone( ::oButtons[ Len( ::oButtons ) ] ) )
         aSize( ::oButtons, Len( ::oButtons ) - 1 )
      ENDDO
   ENDIF
   //IF Len( ::acSubMenu ) > 0 .AND. ! AScan( ::oButtons, { | e | e[ 1 ] == Asc( "X" ) } ) != 0
      //Aadd( ::oButtons, { Asc( "X" ), "<X>Mais" } )
   //ENDIF
   AAdd( ::oButtons, { K_ESC, "<ESC>Sair" } )
   Aadd( ::acHotKeys, { K_RBUTTONDOWN, 27 } )
   Aadd( ::acHotKeys, { K_RDBLCLK, 27 } )
   // Lowercase
   FOR EACH oElement IN ::oButtons
      IF Upper( Chr( oElement[ 1 ] ) ) != Lower( Chr( oElement[ 1 ] ) )
         Aadd( ::acHotKeys, { Asc( Lower( Chr( oElement[ 1 ] ) ) ), oElement[ 1 ] } )
      ENDIF
   NEXT
   ::ButtonCreate()

   RETURN NIL

METHOD ButtonCreate() CLASS frmGuiClass

   LOCAL oElement, oThisButton, nCol, cTooltip

   SetColor( SetColorToolBar() )
   Scroll( 1, 0, ::nButtonHeight, MaxCol(), 0 )
   SetColor( SetColorNormal() )
   FOR EACH oElement IN ::oButtons
      Aadd( ::GUIButtons, { oElement[ 1 ], oElement[ 2 ] } )
   NEXT

   nCol := 0
   FOR EACH oElement IN ::GUIButtons
      oThisButton := wvgtstPushbutton():New()
      oThisButton:PointerFocus := .F.
      //oThisButton:exStyle      := WS_EX_TRANSPARENT // n�o funciona
      IF win_osIsVistaOrUpper()
         oThisButton:lImageResize    := .T.
         oThisButton:nImageAlignment := BS_TOP
      ELSE
         //oThisButton:Style += BS_ICON
      ENDIF
      oThisButton:Caption := Substr( oElement[ 2 ], At( ">", oElement[ 2 ] ) + 1 )
      oThisButton:oImage  := IconFromCaption( oElement[ 2 ], @cTooltip )
      oThisButton:Create( , , { -1, iif( nCol == 0, -0.1, -nCol ) }, { -( ::nButtonHeight ), -( ::nButtonWidth ) } )
      // oThisButton:Activate := &( [{ || HB_KeyPut( ] + Ltrim( Str( ::oButtons[ nCont, 1 ] ) ) + [ ) } ] )
      oThisButton:HandleEvent( HB_GTE_CTLCOLOR, WIN_TRANSPARENT )
      oThisButton:Activate := BuildBlockHB_KeyPut( oElement[ 1 ] )
      oThisButton:TooltipText( Substr( oElement[ 2 ], At( ">", oElement[ 2 ] ) + 1 ) )
      Aadd( oElement, oThisButton )
      // nCol += ::nButtonWidth
      nCol += ::nButtonWidth
   NEXT
   IF nCol < MaxCol()
      oThisButton := wvgTstPushButton():New()
      oThisButton:PointerFocus := .F.
      oThisButton:Create( , , { -1, -nCol }, { -( ::nButtonHeight ), -( MaxCol() - nCol + 1 ) } )
      AAdd( ::GUIButtons, { -1, "", oThisButton } )
   ENDIF
   IF Len( ::acSubMenu ) > 0
      nCol := MaxCol() - ::nButtonWidth + 1
      FOR EACH oElement IN ::acSubMenu
         oThisButton := wvgtstPushbutton():New()
         oThisButton:PointerFocus := .F.
         //oThisButton:exStyle      := WS_EX_TRANSPARENT // n�o funciona
         IF win_osIsVistaOrUpper()
            oThisButton:lImageResize    := .T.
            oThisButton:nImageAlignment := BS_TOP
         ELSE
            //oThisButton:Style += BS_ICON
         ENDIF
         oThisButton:Caption := Substr( oElement[ 2 ], At( ">", oElement[ 2 ] ) + 1 )
         oThisButton:oImage  := IconFromCaption( oElement[ 2 ], @cTooltip )
         oThisButton:Create( , , { -1 - ::nButtonHeight, iif( nCol == 0, -0.1, -nCol ) }, { -( ::nButtonHeight ), -( ::nButtonWidth ) } )
         // oThisButton:Activate := &( [{ || HB_KeyPut( ] + Ltrim( Str( ::oButtons[ nCont, 1 ] ) ) + [ ) } ] )
         oThisButton:HandleEvent( HB_GTE_CTLCOLOR, WIN_TRANSPARENT )
         oThisButton:Activate := BuildBlockHB_KeyPut( oElement[ 1 ] )
         oThisButton:TooltipText( Substr( oElement[ 2 ], At( ">", oElement[ 2 ] ) + 1 ) )
         Aadd( ::GUIButtons, { oElement[ 1 ], oElement[ 2 ], oThisButton } )
         // nCol += ::nButtonWidth
         nCol -= ::nButtonWidth
      NEXT
   ENDIF
   IF Len( ::acTabName ) > 1
      nCol := 1
      FOR EACH oElement IN ::acTabName
         oThisButton := wvgtstPushbutton():New()
         oThisButton:PointerFocus := .F.
         oThisButton:Caption := oElement
         oThisButton:Create( , , { -1.5 - ::nButtonHeight, -nCol }, { -2.0, -( Len( oElement ) ) } )
         oThisButton:ToolTipText := oElement
         oThisButton:Activate := BuildBlockHB_KeyPut( oElement:__EnumIndex + 2000 )
         Aadd( ::GUIButtons, { oElement:__EnumIndex + 2000, oElement, oThisButton } )
         nCol += Len( oElement ) + 2
      NEXT
   ENDIF
   ::GUIShow()

   RETURN NIL

METHOD ButtonSelect() CLASS frmGuiClass

   LOCAL nKey, oElement, lButtonDown := .F., nOpc, acXOptions

   ::GUIEnable()
   DO WHILE ! lButtonDown
      nKey := Inkey( JPA_IDLE, INKEY_ALL - INKEY_MOVE + HB_INKEY_GTEVENT )
      IF nKey == HB_K_RESIZE
         //wvgSetAppWindow():InvalidateRect()
         wvgSetAppWindow():Refresh()
      ENDIF
      IF SetKey( nKey ) != NIL
         Eval( SetKey( nKey ) )
      ENDIF
      nKey := iif( nKey == 0, K_ESC, nKey )
      IF nKey > 2000
         ::cOpc := "T" + Ltrim( Str( nKey - 2000 ) )
         lButtonDown := .T.
      ELSE
         FOR EACH oElement IN ::acHotKeys
            IF nKey == oElement[ 1 ]
               nKey := oElement[ 2 ]
               IF Len( oElement ) > 2
                  ::cOpc := oElement[ 3 ]
               ENDIF
               lButtonDown:= .T.
               EXIT
            ENDIF
         NEXT
         IF nKey > 0
            FOR EACH oElement IN ::GUIButtons
               IF nKey == oElement[ 1 ]
                  ::cOpc := Chr( oElement[ 1 ] )
                  lButtonDown := .T.
                  EXIT
               ENDIF
            NEXT
         ENDIF
      ENDIF
   ENDDO
   ::GUIDisable()
   IF ::cOpc == "X" .AND. Len( ::acSubMenu ) > 0 // Op��es que n�o cabem na tela
      nOpc := 1
      acXOptions := {}
      FOR EACH oElement IN ::acSubMenu
         AAdd( acXOptions, oElement[ 2 ] )
      NEXT
      wAchoice( 5, Min( MaxCol() - 25, AScan( ::acMenuOptions, { | e | "<X>" $ e } ) * ::nButtonWidth ), acXOptions, @nOpc, "Mais op��es" )
      IF LastKey() == K_ESC .OR. nOpc == 0
         ::ButtonSelect()
      ELSE
         nKey := Ascan( ::acHotKeys, { | e | ::acSubMenu[ nOpc, 1 ] == e[ 1 ] } )
         IF nKey = 0 .OR. Len( ::acHotKeys[ nKey ] ) < 3
            ::cOpc := Chr( ::acSubMenu[ nOpc, 1 ] )
         ELSE
            ::cOpc := ::acHotKeys[ nKey, 3 ]
         ENDIF
      ENDIF
   ENDIF

   RETURN NIL

METHOD FormBegin() CLASS frmGuiClass

   LOCAL oElement

   Aadd( AppForms(), SELF )
   FOR EACH oElement IN ::acTabName
      IF Len( oElement ) < 10
         oElement := Padc( oElement, 10 )
      ENDIF
   NEXT
   ::OptionCreate()

   RETURN NIL

METHOD FormEnd() CLASS frmGuiClass

   ::GUIDestroy()
   aSize( AppForms(), Len( AppForms() ) - 1 )

   RETURN NIL

FUNCTION IconFromCaption( cCaption, cTooltip )

   LOCAL cSource := ""

   hb_Default( @cTooltip, "" )

   DO CASE
   CASE cCaption == "<ESC>Sair" ;                cSource := "icoExit" ;         cTooltip := "ESC Encerra a utiliza��o deste m�dulo"
   CASE cCaption == "<->Anterior" ;              cSource := "icoPrevious" ;     cTooltip := "- PGUP Move ao registro anterior"
   CASE cCaption == "<+>Seguinte" ;              cSource := "icoNext" ;         cTooltip := "+ PGDN Move ao registro seguinte"
   CASE cCaption == "<A>Altera" ;                cSource := "icoEdit" ;         cTooltip := "A Alterar existente"
   CASE cCaption == "<B>Baixa" ;                 cSource := "icoMoney" ;        cTooltip := "B Baixa documento" // financeiro
   CASE cCaption == "<B>Base" ;                  cSource := "icoBuilding" ;     cTooltip := "B Base"
   CASE cCaption == "<B>CodBarras" ;             cSource := "icoBarcode" ;      cTooltip := "B Codigo de Barras" // Pedidos
   CASE cCaption == "<B>Recibos" ;               cSource := "icoDuplicata" ;    cToolTip := "B Recibos" // Haroldo Recibos
   CASE cCaption == "<B>Boleto" ;                cSource := "icoBoleto" ;       cTooltip := "B Boleto" // Haroldo Recibos
   CASE cCaption == "<C>Consulta" ;              cSource := "icoSearch" ;       cTooltip := "C Consultar um c�digo espec�fico"
   CASE cCaption == "<C>Conta" ;                 cSource := "" ;                cTooltip := "C Escolhe uma das contas" // bancario
   CASE cCaption == "<D>Divide";                 cSource := "icoDivide" ;       cTooltip := "D Divide em parcelas"
   CASE cCaption == "<D>Duplicar" ;              cSource := "ico2page" ;        cTooltip := "D Cria um novo registro id�ntico ao atual" // OS/Pedido/Cotacoes
   CASE cCaption == "<D>DesligaRecalculo" ;      cSource := "" ;                cTooltip := "D Desliga Recalculo" // bancario
   CASE cCaption == "<E>Exclui" ;                cSource := "icoCut" ;          cTooltip := "E <Del> Excluir"
   CASE cCaption == "<F>Ficha" ;                 cSource := "icoFicha" ;        cTooltip := "F Escolhe imovel por numero de ficha" // Haroldo AluguelClass
   CASE cCaption == "<F>Financeiro" ;            cSource := "icoMoney" ;        cTooltip := "F Mostra financeiro relacionado"
   CASE cCaption == "<F>Filtro" ;                cSource := "icoFilter" ;       cTooltip := "F Permite digitar um filtro" // bancario
   CASE cCaption == "<F>Folha" ;                 cSource := "icoSearch" ;       cTooltip := "F Escolhe Folha"
   CASE cCaption == "<G>EmailCnpj" ;             cSource := "icoMailCnpj" ;     cTooltip := "G Deixa matriz/filial (CNPJ) com mesmo email"
   CASE cCaption == "<G>EmiteMDFE" ;             cSource := "icoSefazEmite" ;   cTooltip := "G Gera XML do MDFE"
   CASE cCaption == "<G>Agenda" ;                cSource := "icoPhonebook" ;    cTooltip := "G Dados de agenda"
   CASE cCaption == "<H>HistEmails" ;            cSource := "cmdHistEmail" ;    cTooltip := "H Hist�rico dos emails de NFE enviados" // notas
   CASE cCaption == "<H>Hist�rico" ;             cSource := "cmdHistorico" ;    cTooltip := "H Visualiza informa��es anteriores" // precos
   CASE cCaption == "<I>Imprime" ;               cSource := "icoPrint" ;        cTooltip := "I Imprime"
   CASE cCaption == "<I>Inclui" ;                cSource := "icoInsert" ;       cTooltip := "I <Insert> Incluir novo"
   CASE cCaption == "<J>ConsultaCad" ;           cSource := "icoSefaz" ;        cTooltip := "J Consulta cadastro na Sefaz usando servidor JPA"
   CASE cCaption == "<J>EmissorNFE" ;            cSource := "icoSefazEmite" ;   cTooltip := "J Emite NFE na Sefaz"
   CASE cCaption == "<K>CancelaNF" ;             cSource := "icoX"  ;           cTooltip := "K Cancela a nota fiscal no JPA" // notas
   CASE cCaption == "<K>CContabil" ;             cSource := "icoCashregister" ; cTooltip := "K C�lculo do Custo Cont�bil" // item
   CASE cCaption == "<L>Imprime" ;               cSource := "icoPrint" ;        cTooltip := "L Imprime"
   CASE cCaption == "<L>Boleto" ;                cSource := "icoBoleto" ;       cTooltip := "L Emite Boleto" // financeiro
   CASE cCaption == "<M>Email" ;                 cSource := "icoMail" ;         cTooltip := "M Envia Email"
   CASE cCaption == "<M>Mapa" ;                  cSource := "icoWorld" ;        cTooltip := "M Mapa do trajeto"
   CASE cCaption == "<N>Sel.NFs" ;               cSource := "icoImport" ;       cTooltip := "N Importa Notas"
   CASE cCaption == "<N>NFCupom" ;               cSource := "icoNF" ;           cTooltip := "N Emite Nota Fiscal"
   CASE cCaption == "<N>Endereco" ;              cSource := "icoHouse" ;        cTooltip := "N Consulta endereco" // sistema Haroldo Lopes
   CASE cCaption == "<N>NovaConta" ;             cSource := "" ;                cTooltip := "N Cria uma nova conta" // bancario
   CASE cCaption == "<O>Ocorrencias" ;           cSource := "icoBook" ;         cTooltip := "O Ocorr�ncias registradas"
   CASE cCaption == "<O>Observa��es" ;           cSource := "icoBook" ;         cTooltip := "O Editar observa��es"
   CASE cCaption == "<P>Primeiro" ;              cSource := "icoFirst" ;        cTooltip := "P <Home> Move ao primeiro registro"
   CASE cCaption == "<Q>PesqDoc" ;               cSource := "cmdPesqNF" ;       cTooltip := "Q Pequisa por um documento" // financeiro
   CASE cCaption == "<Q>PesqNF" ;                cSource := "cmdPesqNF" ;       cTooltip := "Q Pesquisa por uma nota fiscal"
   CASE cCaption == "<R>Repete" ;                cSource := "ico2win" ;         cTooltip := "R Repete lan�amento pra v�rios meses" // financeiro-pagar
   CASE cCaption == "<R>Reserva" ;               cSource := "icoShopCart" ;     cTooltip := "R Mostra reserva"
   CASE cCaption == "<R>Compara" ;               cSource := "ico2win" ;         cTooltip := "R Compara produtos dos pedidos"
   CASE cCaption == "<R>Locatarios" ;            cSource := "icoFolderouse" ;  cTooltip := "R Locat�rios" // sistema Haroldo Lopes
   CASE cCaption == "<R>Recalculo" ;             cSource := "" ;                cTooltip := "R Recalcula os valores" // bancario
   CASE cCaption == "<R>Encerra" ;               cSource := "icoSefazEncerra" ; cTooltip := "R Encerramento de MDFe na Fazenda"
   CASE cCaption == "<S>Confirma" ;              cSource := "icoCheckMark" ;    cTooltip := "S Confirma"
   CASE cCaption == "<S>Simulado" ;              cSource := "icoCalulator" ;    cTooltip := "S Mostra simula��o Dimob" // Haroldo Lopes
   CASE cCaption == "<S>SomaLancamentos" ;       cSource := "icoCalulator" ;    cTooltip := "S Soma lancamentos" // bancario
   CASE cCaption == "<T>Correcao" ;              cSource := "icoSefazCarta" ;   cTooltip := "T Carta de Corre��o pelo servidor JPA" // notas
   CASE cCaption == "<T>CTE" ;                   cSource := "icoTruck" ;        cTooltip := "T Emite CTE"
   CASE cCaption == "<T>Filtro" ;                cSource := "icoFilter" ;       cTooltip := "T Aplica um filtro para visualiza��o" // Varios
   CASE cCaption == "<T>Status" ;                cSource := "icoLock" ;         cTooltip := "T Altera Status"
   CASE cCaption == "<T>Telefone" ;              cSource := "icoPhone" ;        cTooltip := "T Pesquisa por Telefone" // sistema Haroldo Lopes
   CASE cCaption == "<T>Troca" ;                 cSource := "icoCoin" ;         cTooltip := "T Troca por um novo documento" // financeiro
   CASE cCaption == "<T>TrocaConta" ;            cSource := "" ;                cTooltip := "T Troca a conta deste lan�amento" // bancario
   CASE cCaption == "<U>�ltimo" ;                cSource := "icoLast" ;         cTooltip := "U <End> Move ao �ltimo registro"
   CASE cCaption == "<V>Val.Adic" ;              cSource := "icoCalculator" ;   cTooltip := "V Modifica valores adicionais"
   CASE cCaption == "<V>Visualiza" ;             cSource := "icoBrowse" ;       cTooltip := "V Visualiza em lista" // precos, comissoes
   CASE cCaption == "<V>Invalidos";              cSource := "cmdInvalidos" ;    cTooltip := "V Filtra inv�lidos" // Haroldo Lopes
   CASE cCaption == "<V>Ve�culo" ;               cSource := "icoTruck" ;        cTooltip := "V Ve�culo"
   CASE cCaption == "<W>VerPDF" ;                cSource := "icoPdf" ;          cTooltip := "W Visualiza PDF"
   CASE cCaption == "<X>Mais" ;                  cSource := "icoPlus" ;         cTooltip := "X Mais comandos al�m dos atuais"
   CASE cCaption == "<Y>Chave" ;                 cSource := "icoKey" ;          CTooltip := "Y Copia chave pra Clipboard Windows"
   CASE cCaption == "<Z>Analisa" ;               cSource := "icoBarGraph";      cTooltip := "Z An�lise das informa��es"
   CASE cCaption == "<Z>Limpar" ;                cSource := "icoBroom" ;        cTooltip := "Z Limpar informa��es" // cod.barras
   CASE cCaption == "<Alt-L>Pesq.Frente" ;       cSource := "icoSearchAhead" ;  cTooltip := "ALT-L Pesquisa da posi��o atual pra frente"
   CASE cCaption == "<Alt-T>Pesq.Tras" ;         cSource := "icoSearchBack" ;   cTooltip := "ALT-T Pesquisa da posi��o atual pra tr�s"
   CASE cCaption == "<Alt-F>Filtro" ;            cSource := "icoFilter" ;       cTooltip := "ALT-F Aplica um filtro na pesquisa"
   CASE cCaption == "<Ctrl-PgUp>Primeiro";       cSource := "icoTop" ;          cTooltip := "Ctrl-PgUp primeiro"
   CASE cCaption == "<Ctrl-PgDn>�ltimo";         cSource := "icoBottom" ;       cTooltip := "Ctrl-PgDn �ltimo"
   CASE cCaption == "<PgUp>P�g.Ant";             cSource := "icoPgUp";          cTooltip := "PgUp P�gina anterior"
   CASE cCaption == "<PgDn>P�g.Seg";             cSource := "icoPgDn";          cTooltip := "PgDn P�gina Seguinte"
   CASE cCaption == "<Up>Sobe";                  cSource := "icoUp";            cTooltip := "Up Sobe"
   CASE cCaption == "<Down>Desce";               cSource := "icoDown";          cTooltip := "Down Desce"
   CASE cCaption == "<Ins>Inclui" ;              cSource := "icoInsert" ;       cTooltip := "INS Inclui"
   CASE cCaption == /*F2*/  "Mapa" ;             cSource := "icoworld" ;        cTooltip := "Apresenta Mapa"
   CASE cCaption == /*F3*/  "Duplicata" ;        cSource := "icoDuplicata" ;    cTooltip := "Emite Duplicata" // financeiro
   CASE cCaption == /*F5*/  "Ordem" ;            cSource := "icoSort" ;         cTooltip := "F5 Altera a ordem de exibi��o"
   CASE cCaption == /*F11*/ "Cancela";           cSource := "icoX";             cTooltip := "Cancela Pedido"
   CASE cCaption == /*F12*/ "ReemiteC" ;         cSource := "icoCupom" ;        cTooltip := "ReemiteCupom"
   CASE cCaption == /*F13*/ "I.Gar" ;            cSource := "icoGarantia" ;     cTooltip := "Imprime Garantia"
   CASE cCaption == /*F14*/ "Juntar";            cSource := "icoInBox" ;        cTooltip := "Juntar Dois Pedidos"
   CASE cCaption == /*F15*/ "Limpar";            cSource := "icoBroom";         cTooltip := "Limpa C�digos de barra"
   CASE cCaption == /*F16*/ "Config" ;           cSource := "icoSetup" ;        cTooltip := "N Modifica Configura��o"
   CASE cCaption == /*F17*/ "CancelaDFe" ;       cSource := "icoSefazCancela" ; cTooltip := "J Cancela Documento na Sefaz"
   CASE cCaption == "F9" ;                       cSource := "icoSearch" ;       cTooltip := "Pesquisa no cadastro"
   ENDCASE
   IF Empty( cSource )
      cSource := "AppIcon"
   ENDIF
   IF Empty( cTooltip )
      cTooltip := cCaption
   ENDIF
   cSource := { , WVG_IMAGE_ICONRESOURCE, cSource }

   RETURN cSource
