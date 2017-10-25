/*
PDFECTECANCEL - CANCELAR CTE
2017.01 Jos� Quintas
*/

#include "inkey.ch"

PROCEDURE pDfeCteCancel

   LOCAL nNumDoc := 0, oXmlPdf, oCte, oSefaz := SefazClass():New(), cMotivo, cConfirma, GetList := {}

   IF AppEmpresaApelido() != "CARBOLUB"
      MsgExclamation( "Empresa n�o emite CTE" )
      RETURN
   ENDIF
   IF ! AbreArquivos( "jpempre" )
      RETURN
   ENDIF
   DO WHILE .T.
      @ 12, 10 SAY "N�mero do CTE:" GET nNumDoc PICTURE "@K 999999999" VALID nNumDoc > 0
      Mensagem( "Digite n�mero do CTE, ESC Sai" )
      READ
      Mensagem()
      IF LastKey() == K_ESC
         EXIT
      ENDIF
      oXmlPdf := XmlPdfClass():New()
      oXmlPdf:GetFromMySql( "", StrZero( nNumDoc, 9 ), "57" )
      IF ! Empty( oXmlPdf:cXmlCancelamento )
         MsgExclamation( "CTE j� cancelado" )
         LOOP
      ENDIF
      IF Empty( oXmlPdf:cXmlEmissao )
         MsgExclamation( "Emiss�o n�o salva pra poder cancelar" )
         LOOP
      ENDIF
      oCte := XmlToDoc( oXmlPdf:cXmlEmissao )
      IF Empty( oCte:Protocolo )
         MsgStop( "Protocolo n�o localizado" )
         LOOP
      ENDIF
      WOpen( 5, 5, 15, 90, "Cancelamento de CTE na Fazenda" )
      cMotivo   := Space(90)
      cConfirma := "NAO"
      @ 7, 7 SAY "Motivo (m�nimo de 15 letras):"
      @ 8, 7 GET cMotivo PICTURE "@!" VALID Len( Trim( cMotivo ) ) > 15
      @ 9, 7 SAY "Confirme fazer cancelamento:" GET cConfirma PICTURE "@!"
      Mensagem( "Digite dados para cancelamento" )
      READ
      Mensagem()
      WClose()
      IF LastKey() == K_ESC .OR. cConfirma != "SIM"
         LOOP
      ENDIF
      IF Len( Trim( cMotivo ) ) < 15
         MsgWarning( "Texto precisa no m�nimo 15 letras" )
         LOOP
      ENDIF
      oSefaz:CteEventoCancela( oXmlPdf:cChave, 1, Val( oCte:Protocolo ), Trim( cMotivo ), AppEmpresaApelido(), "1" )
      IF oSefaz:cStatus == "135"
         hb_MemoWrit( hb_cwd() + "IMPORTA\Cancelamento-CTE" + StrZero( nNumDoc, 9 ) + "-110111.xml", oSefaz:cXmlAutorizado )
         oXmlPdf:cXmlCancelamento := oSefaz:cXmlAutorizado
         oXmlPdf:GeraPDF()
         MsgExclamation( "Cancelamento autorizado" )
      ELSE
         hb_MemoWrit( hb_cwd() + "NFE\Cancelamento-CTE" + StrZero( nNumDoc, 9 ) + "-110111-documento.xml", oSefaz:cXmlDocumento )
         hb_MemoWrit( hb_cwd() + "NFE\Cancelamento-CTE" + StrZero( nNumDoc, 9 ) + "-110111-retorno.xml", oSefaz:cXmlRetorno )
         Errorsys_WriteErrorLog( oSefaz:cXmlSoap )
         MsgExclamation( oSefaz:cXmlRetorno )
         MsgExclamation( "Erro na autoriza��o do cancelamento " + oSefaz:cStatus + " " + oSefaz:cMotivo )
      ENDIF
      EXIT
   ENDDO
   CLOSE DATABASES

   RETURN
