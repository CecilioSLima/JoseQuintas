/*
PDFEGERAPDF - VISUALIZAR PDF DE CTES, MDFE, NFE
2017.01 - Jos� Quintas
*/

#include "inkey.ch"

PROCEDURE pDfeGeraPdf

   LOCAL GetList := {}, mNFe := Space(9), mCte := Space(9), mMDFe := Space(9), oXmlPdf

   IF ! AbreArquivos( "jpempre" )
      RETURN
   ENDIF
   DO WHILE .T.
      @ 12, 10 SAY "NFE..:" GET mNFE  PICTURE "@K 999999999" VALID Val( mNFE ) >= 0
      @ 14, 10 SAY "CTE..:" GET mCTE  PICTURE "@K 999999999" VALID Val( mCte ) >= 0
      @ Row(), Col() + 2 SAY "(Aten��o � empresa em uso)"
      @ 16, 10 SAY "MDFE.:" GET mMDFE PICTURE "@K 999999999" VALID Val( mMDFE ) >= 0
      Mensagem( "Digite n�mero, ESC Sai" )
      READ
      IF LastKey() == K_ESC
         EXIT
      ENDIF
      IF Val( mNFe ) != 0
         oXmlPdf := XmlPdfClass():New()
         oXmlPdf:GetFromMySql( "", mNFe, "55" )
         oXmlPdf:GeraPDF()
      ENDIF
      IF Val( mCTe ) != 0
         oXmlPdf := XmlPdfClass():New()
         oXmlPdf:GetFromMySql( "", mCTe, "57" )
         oXmlPdf:GeraPDF()
      ENDIF
      IF Val( mMDFe ) != 0
         oXmlPdf := XmlPdfClass():New()
         oXmlPdf:GetFromMySql( "", mMDFe, "58" )
         oXmlPdf:GeraPDF()
      ENDIF
   ENDDO
   CLOSE DATABASES

   RETURN
