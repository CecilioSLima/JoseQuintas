/*
ZE_WINAPI - Funções de API
*/

#include "hbdyn.ch"

FUNCTION win_GetShortPathName( cPath )

   LOCAL cShort := Space(5000)

   wapi_GetShortPathName( cPath, @cShort, Len( cShort) )

   RETURN cShort

#define SHERB_NOCONFIRMATION 0x00000001
#define SHERB_NOPROGRESSUI 0x00000002
#define SHERB_NOSOUND 0x00000004

FUNCTION wapi_EmptyTrash( cPath )

   LOCAL xResult

   xResult := CallDllStd( "Shell32.dll", "SHEmptyRecycleBinA", NIL, cPath, SHERB_NOCONFIRMATION + SHERB_NOPROGRESSUI + SHERB_NOSOUND )

   RETURN xResult

FUNCTION CallDllStd( cDll, cName, ... )

   LOCAL nHandle, xResult

   nHandle := hb_LibLoad( cDll )
   xResult := hb_DynCall( { cName, nHandle, HB_DYN_CALLCONV_STDCALL }, ... )
   hb_LibFree( nHandle )

   RETURN xResult
