/*
PSETUPWINDOWS - Setup Windows
Jos� Quintas
*/

FUNCTION pSetupWindows()

   // Politica de controle de conta de usuario para drives mapeados (UAC) que bloqueia acesso a pastas mapeadas
   // Ao que parece, ate mesmo o administrador vira usuario comum para isso
   // [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System]"EnableLinkedConnections"=dword:00000001
   IF win_OsNetRegOk()
      MsgExclamation( "Windows j� configurado" )
   ELSE
      IF MsgYesNo( "Windows n�o configurado corretamente para o JPA." + hb_eol() + "Configura agora?" + hb_eol() + ;
            "Obs. Conforme vers�o do Windows, S� vai ser possivel configurar se JPA executado como administrador" )
         IF win_OsNetRegOk( .T., .T. )
            IF ! MsgYesNo( "Configura��o necess�ria aplicada. Continua?" )
               QUIT
            ENDIF
         ELSE
            MsgStop( "N�o foi possivel aplicar configura��o." )
         ENDIF
      ENDIF
   ENDIF

   RETURN NIL
