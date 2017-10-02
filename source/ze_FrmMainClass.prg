/*
ZE_FRMMAINCLASS - CLASSE GENERICA PRA TELAS
2013.01 Jos� Quintas
*/

#include "inkey.ch"
#include "hbclass.ch"
#include "wvgparts.ch"
#include "hbgtwvg.ch"
#include "wvtwin.ch"

#define JPA_IDLE 600

EXTERNAL HB_KEYPUT

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
   METHOD IconFromCaption( cCaption, cTooltip )

   ENDCLASS

METHOD RowIni() CLASS frmGuiClass

   LOCAL nRowIni

   nRowIni := Round( 1 + ::nButtonHeight, 0 )
   nRowIni += iif( Len( ::acTabName ) < 2, 0, 2 )
   @ nRowIni, 0 SAY ""

   RETURN nRowIni

METHOD ShowTabs() CLASS frmGuiClass

   LOCAL nRow, nCol, oElement, cCorAnt

   nRow    := ::RowIni() - iif( Len( ::acTabName ) < 2, 0, 2 )
   cCorAnt := SetColor()
   SetColorNormal()
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
         @ nRow, nCol TO nRow + 2, nCol + Len( oElement ) + 1 COLOR SetColorFocus()
      ENDIF
      @ nRow + 1, nCol + 1 SAY oElement COLOR iif( oElement:__EnumIndex == ::nNumTab, SetColorFocus(), SetColor() )
      nCol := nCol + Len( oElement ) + 2
   NEXT
   ::RowIni()
   SetColor( cCorAnt )

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
      AAdd( ::oButtons,  { Asc( "U" ), "<U>Ultimo" } )
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
         CASE Len( cLetter ) == 1
            Aadd( ::oButtons, { Asc( cLetter ), oElement } )
         CASE cLetter == "Alt-F"
            Aadd( ::oButtons, { K_ALT_F, oElement } )
         CASE cLetter == "Alt-T"
            Aadd( ::oButtons, { K_ALT_T, oElement } )
         CASE cLetter == "Alt-L"
            Aadd( ::oButtons, { K_ALT_L, oElement } )
         CASE cLetter == "DEL"
            Aadd( ::oButtons, { K_DEL, oElement } )
         CASE Len( cLetter ) > 1 .AND. Left( cLetter, 1 ) == "F" // Teclas de funcao (F2 a F48)(fx s-fx c-fx a-fx)
            Aadd( ::oButtons,  { -( Val( Substr( cLetter, 2 ) ) - 1 ), Substr( oElement, At( ">", oElement ) + 1 ) } )
            AAdd( ::acHotkeys, { -( Val( Substr( cLetter, 2 ) ) - 1 ), -( Val( Substr( cLetter, 2 ) ) - 1 ), cLetter } )
         ENDCASE
      ELSE
         cLetter := Substr( oElement, 1, 1 )
         AAdd( ::oButtons, { Asc( cLetter ), oElement } )
      ENDIF
   NEXT
   IF Len( ::oButtons ) > ( Int( MaxCol() / ::nButtonWidth ) - 2 )
      DO WHILE Len( ::oButtons ) > Int( MaxCol() / ::nButtonWidth ) - 2 // reserva 2 botoes:Sair/Mais
         AAdd( ::acSubMenu, AClone( ::oButtons[ Len( ::oButtons ) ] ) )
         aSize( ::oButtons, Len( ::oButtons ) - 1 )
      ENDDO
   ENDIF
   IF Len( ::acSubMenu ) > 0
      Aadd( ::oButtons, { Asc( "X" ), "<X>Mais" } )
   ENDIF
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

   LOCAL oElement, oThisButton, nCol, cTooltip, cCorAnt

   cCorAnt := SetColor()
   SetColor( SetColorToolBar() )
   Scroll( 1, 0, ::nButtonHeight, MaxCol(), 0 )
   SetColor( cCorAnt )
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
         oThisButton:oImage  := ::IconFromCaption( oElement[ 2 ], @cTooltip, 2 )
         oThisButton:Create( , , { -1, iif( nCol == 0, -0.1, -nCol ) }, { -( ::nButtonHeight ), -( ::nButtonWidth ) } )
      // oThisButton:Activate := &( [{ || HB_KeyPut( ] + Ltrim( Str( ::oButtons[ nCont, 1 ] ) ) + [ ) } ] )
      oThisButton:HandleEvent( HB_GTE_CTLCOLOR, WIN_TRANSPARENT )
      oThisButton:Activate := BuildBlockHB_KeyPut( oElement[ 1 ] )
      oThisButton:TooltipText( Substr( oElement[ 2 ], At( ">", oElement[ 2 ] ) + 1 ) )
      Aadd( oElement, oThisButton )
      // nCol += ::nButtonWidth
      nCol += ::nButtonWidth
   NEXT
   IF Len( ::acTabName ) > 1
      nCol := 1
      FOR EACH oElement IN ::acTabName
         oThisButton := wvgtstPushbutton():New()
         oThisButton:PointerFocus := .F.
         oThisButton:Caption := oElement
         oThisButton:Create( , , { -1 - ::nButtonHeight, -nCol }, { -2, -( Len( oElement ) ) } )
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
      nKey := Inkey( JPA_IDLE )
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

METHOD IconFromCaption( cCaption, cTooltip ) CLASS frmGuiClass

   LOCAL cSource := ""

   hb_Default( @cTooltip, "" )

   DO CASE
   CASE cCaption == "<ESC>Sair" ;                cSource := "cmdSai" ;          cTooltip := "ESC Encerra a utiliza��o deste m�dulo"
   CASE cCaption == "<->Anterior" ;              cSource := "cmdAnterior" ;     cTooltip := "- PGUP Move ao registro anterior"
   CASE cCaption == "<+>Seguinte" ;              cSource := "cmdSeguinte" ;     cTooltip := "+ PGDN Move ao registro seguinte"
   CASE cCaption == "<A>Altera" ;                cSource := "cmdAltera" ;       cTooltip := "A Alterar existente"
   CASE cCaption == "<B>Baixa" ;                 cSource := "cmdBaixa" ;        cTooltip := "B Baixa documento" // financeiro
   CASE cCaption == "<B>CodBarras" ;             cSource := "cmdBarCode" ;      cTooltip := "B Codigo de Barras" // Pedidos
   CASE cCaption == "<B>Recibos" ;               cSource := "cmdFatura" ;       cToolTip := "B Recibos" // Haroldo Recibos
   CASE cCaption == "<B>Boleto" ;                cSource := "cmdBoleto" ;       cTooltip := "B Boleto" // Haroldo Recibos
   CASE cCaption == "<C>Consulta" ;              cSource := "cmdPesquisa" ;     cTooltip := "C Consultar um c�digo espec�fico"
   CASE cCaption == "<C>Conta" ;                 cSource := "" ;                cTooltip := "C Escolhe uma das contas" // bancario
   CASE cCaption == "<D>Duplicar" ;              cSource := "cmdClona" ;        cTooltip := "D Cria um novo registro id�ntico ao atual" // OS/Pedido/Cotacoes
   CASE cCaption == "<D>DesligaRecalculo" ;      cSource := "" ;                cTooltip := "D Desliga Recalculo" // bancario
   CASE cCaption == "<E>Exclui" ;                cSource := "cmdExclui" ;       cTooltip := "E <Del> Excluir"
   CASE cCaption == "<F>Fecha" ;                 cSource := "cmdStatus" ;       cTooltip := "F Altera a situa��o para fechado" // DemoFin
   CASE cCaption == "<F>Ficha" ;                 cSource := "cmdFicha" ;        cTooltip := "F Escolhe imovel por numero de ficha" // Haroldo AluguelClass
   CASE cCaption == "<F>Financeiro" ;            cSource := "cmdFinanceiro" ;   cTooltip := "F Mostra financeiro relacionado"
   CASE cCaption == "<F>Filtro" ;                cSource := "cmdFiltro" ;       cTooltip := "F Permite digitar um filtro" // bancario
   CASE cCaption == "<G>EmailCnpj" ;             cSource := "cmdEmailCnpj" ;    cTooltip := "G Deixa matriz/filial (CNPJ) com mesmo email"
   CASE cCaption == "<G>EmiteMDFE" ;             cSource := "cmdSefazEmite" ;   cTooltip := "G Gera XML do MDFE"
   CASE cCaption == "<G>Agenda" ;                cSource := "cmdTelefone" ;     cTooltip := "G Dados de agenda"
   CASE cCaption == "<H>HistEmails" ;            cSource := "cmdHistEmail" ;    cTooltip := "H Hist�rico dos emails de NFE enviados" // notas
   CASE cCaption == "<H>Hist�rico" ;             cSource := "cmdHistorico" ;    cTooltip := "H Visualiza informa��es anteriores" // precos
   CASE cCaption == "<I>Inclui" ;                cSource := "cmdInclui" ;       cTooltip := "I <Insert> Incluir novo"
   CASE cCaption == "<J>ConsultaCad" ;           cSource := "cmdSefaz" ;        cTooltip := "J Consulta cadastro na Sefaz usando servidor JPA"
   CASE cCaption == "<J>CancelaMDFe" ;           cSource := "cmdSefazCancela" ; cTooltip := "J Cancela MDFe na Sefaz"
   CASE cCaption == "<J>CancelaNFe" ;            cSource := "cmdSefazCancela" ; cTooltip := "J Cancela a NFE na Sefaz" // notas
   CASE cCaption == "<J>EmissorNFE" ;            cSource := "cmdSefazEmite" ;   cTooltip := "J Emite NFE na Sefaz"
   CASE cCaption == "<K>CancelaNF" ;             cSource := "cmdCancela"  ;     cTooltip := "K Cancela a nota fiscal no JPA" // notas
   CASE cCaption == "<K>CContabil" ;             cSource := "" ;                cTooltip := "K C�lculo do Custo Cont�bil" // item
   CASE cCaption == "<L>Imprime" ;               cSource := "cmdimprime" ;      cTooltip := "L Imprime"
   CASE cCaption == "<L>Boleto" ;                cSource := "cmdBoleto" ;       cTooltip := "L Emite Boleto" // financeiro
   CASE cCaption == "<M>Email" ;                 cSource := "cmdEmail" ;        cTooltip := "M Envia Email"
   CASE cCaption == "<N>NFCupom" ;               cSource := "cmdNF" ;           cTooltip := "N Emite Nota Fiscal"
   CASE cCaption == "<N>Config" ;                cSource := "cmdConfigura" ;    cTooltip := "N Modifica Configura��o"
   CASE cCaption == "<N>Endereco" ;              cSource := "cmdEndereco" ;     cTooltip := "N Consulta endereco" // sistema Haroldo Lopes
   CASE cCaption == "<N>NovaConta" ;             cSource := "" ;                cTooltip := "N Cria uma nova conta" // bancario
   CASE cCaption == "<O>Ocorrencias" ;           cSource := "cmdOcorrencias" ;  cTooltip := "O Ocorr�ncias registradas"
   CASE cCaption == "<O>Observa��es" ;           cSource := "cmdOcorrencias" ;  cTooltip := "O Editar observa��es"
   CASE cCaption == "<P>Primeiro" ;              cSource := "cmdPrimeiro" ;     cTooltip := "P <Home> Move ao primeiro registro"
   CASE cCaption == "<Q>PesqDoc" ;               cSource := "cmdPesqNf" ;       cTooltip := "Q Pequisa por um documento" // financeiro
   CASE cCaption == "<Q>PesqNF" ;                cSource := "cmdPesqNF" ;       cTooltip := "Q Pesquisa por uma nota fiscal"
   CASE cCaption == "<R>Repetir" ;               cSource := "cmdClona" ;        cTooltip := "R Repete lan�amento pra v�rios meses" // financeiro-pagar
   CASE cCaption == "<R>Compara" ;               cSource := "cmdCompara" ;      cTooltip := "R Compara produtos dos pedidos"
   CASE cCaption == "<R>Locatarios" ;            cSource := "cmdLocatarios" ;   cTooltip := "R Locat�rios" // sistema Haroldo Lopes
   CASE cCaption == "<R>Recalculo" ;             cSource := "" ;                cTooltip := "R Recalcula os valores" // bancario
   CASE cCaption == "<R>Encerra" ;               cSource := "cmdSefazEncerra" ; cTooltip := "R Encerramento de MDFe na Fazenda"
   CASE cCaption == "<S>Confirma" ;              cSource := "cmdConfirma" ;     cTooltip := "S Confirma"
   CASE cCaption == "<S>Simulado" ;              cSource := "cmdValores" ;      cTooltip := "S Mostra simula��o Dimob" // Haroldo Lopes
   CASE cCaption == "<S>SomaLancamentos" ;       cSource := "cmdValores" ;      cTooltip := "S Soma lancamentos" // bancario
   CASE cCaption == "<T>Correcao" ;              cSource := "cmdSefazCarta" ;   cTooltip := "T Carta de Corre��o pelo servidor JPA" // notas
   CASE cCaption == "<T>CTE" ;                   cSource := "cmdVeiculo" ;      cTooltip := "T Emite CTE"
   CASE cCaption == "<T>Filtro" ;                cSource := "cmdFiltro" ;       cTooltip := "T Aplica um filtro para visualiza��o" // Varios
   CASE cCaption == "<T>Status" ;                cSource := "cmdStatus" ;       cTooltip := "T Altera Status"
   CASE cCaption == "<T>Telefone" ;              cSource := "cmdTelefone" ;     cTooltip := "T Pesquisa por Telefone" // sistema Haroldo Lopes
   CASE cCaption == "<T>Troca" ;                 cSource := "cmdTroca" ;        cTooltip := "T Troca por um novo documento" // financeiro
   CASE cCaption == "<T>TrocaConta" ;            cSource := "" ;                cTooltip := "T Troca a conta deste lan�amento" // bancario
   CASE cCaption == "<U>Ultimo" ;                cSource := "cmdUltimo" ;       cTooltip := "U <End> Move ao �ltimo registro"
   CASE cCaption == "<V>ValoresAdic" ;           cSource := "cmdValores" ;      cTooltip := "V Modifica valores adicionais"
   CASE cCaption == "<V>Visualiza" ;             cSource := "cmdBrowse" ;       cTooltip := "V Visualiza emm lista" // precos, comissoes
   CASE cCaption == "<V>Invalidos";              cSource := "cmdInvalidos" ;    cTooltip := "V Filtra inv�lidos" // Haroldo Lopes
   CASE cCaption == "<W>VerPDF" ;                cSource := "cmdPdf" ;          cTooltip := "W Visualiza PDF"
   CASE cCaption == "<X>Mais" ;                  cSource := "cmdMais" ;         cTooltip := "X Mais comandos al�m dos atuais"
   CASE cCaption == "<Y>Chave" ;                 cSource := "cmdKey" ;          CTooltip := "Y Copia chave pra Clipboard Windows"
   CASE cCaption == "<Z>Analisa" ;               cSource := "cmdAnalisa";       cTooltip := "Z An�lise das informa��es"
   CASE cCaption == "<Z>Limpar" ;                cSource := "cmdLimpar" ;       cTooltip := "Z Limpar informa��es" // cod.barras
   CASE cCaption == "<Alt-L>Pesq.Frente" ;       cSource := "cmdPraFrente" ;    cTooltip := "ALT-L Pesquisa da posi��o atual pra frente"
   CASE cCaption == "<Alt-T>Pesq.Tras" ;         cSource := "cmdPraTras" ;      cTooltip := "ALT-T Pesquisa da posi��o atual pra tr�s"
   CASE cCaption == "<Alt-F>Filtro" ;            cSource := "cmdFiltro" ;       cTooltip := "ALT-F Aplica um filtro na pesquisa"
   CASE cCaption == "<F5>Ordem" ;                cSource := "cmdOrdem" ;        cTooltip := "F5 Altera a ordem de exibi��o"
   CASE cCaption == /*F2*/  "Mapa" ;             cSource := "cmdMapa" ;         cTooltip := "Apresenta Mapa"
   CASE cCaption == /*F3*/  "Duplicata" ;        cSource := "cmdDuplicata" ;    cTooltip := "Emite Duplicata" // financeiro
   CASE cCaption == /*F11*/ "Cancela Pedido"
   CASE cCaption == /*F12*/ "Reemite Cupom" ;    cSource := "cmdCupom" ;        cTooltip := "ReemiteCupom"
   CASE cCaption == /*F13*/ "Imp.Garantia" ;     cSource := "cmdGarantia" ;     cTooltip := "Imprime Garantia"
   CASE cCaption == /*F15*/ "Limpar Cod.Barras"
   CASE cCaption == /*F14*/ "Juntar Pedido";     cSource := "cmdJuntar" ;       cTooltip := "Juntar Dois Pedidos"
   ENDCASE
   IF Empty( cSource )
      cSource := "AppIcon"
   ENDIF
   IF Empty( cTooltip )
      cTooltip := cCaption
   ENDIF
   cSource := { , WVG_IMAGE_ICONRESOURCE, cSource }

   RETURN cSource
