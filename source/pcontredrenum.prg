/*
PCONTREDRENUM - REGRAVA CODIGO REDUZIDO DAS CONTAS
1992.07 Jos� Quintas
*/

#include "inkey.ch"

PROCEDURE pContRedRenum

   LOCAL nCodigo, m_Conf, GetList := {}

   IF ! AbreArquivos( "jpempre", "ctplano" )
      RETURN
   ENDIF
   SELECT ctplano

   SayScroll( "ATENCAO!!!" )
   SayScroll( "Esta rotina renumera os c�digos reduzidos em ordem crescente, seguindo a ordem" )
   SayScroll( "do plano de contas. Ser�o alterados todos os c�digos  reduzidos  do  plano  de" )
   SayScroll( "contas" )
   SayScroll( "Os lan�amentos n�o seram afetados, devido  a  serem  registrados  pelo  c�digo" )
   SayScroll( "normal" )
   SayScroll( "Ap�s a execu��o deste  modulo,  os  c�digos  anteriores  somente  poder�o  ser" )
   SayScroll( "recuperados atrav�s do retorno de um backup (Fa�a um backup antes de executar)" )

   mensagem( "Confirme a opera��o digitando <SIM>" )
   m_conf = "NAO"
   @ Row(), Col()+2 GET m_conf PICTURE "@!"
   READ
   mensagem()

   IF m_conf == "SIM" .AND. LastKey() != K_ESC
      Mensagem( "Aguarde... alterando c�digos reduzidos..." )
      SayScroll( "Alterando c�digos reduzidos do plano..." )
      GOTO TOP
      nCodigo := 1
      DO WHILE ! Eof()
         GrafProc()
         IF ctplano->a_tipo == "A"
            RecLock()
            REPLACE ctplano->a_reduz WITH str( nCodigo, 5 ) + CalculaDigito( str( nCodigo ), "11" )
            nCodigo += 1
            RecUnlock()
         ENDIF
         SKIP
      ENDDO
      Mensagem()
      MsgExclamation( "Fim" )
   ENDIF
   CLOSE DATABASES

   RETURN
