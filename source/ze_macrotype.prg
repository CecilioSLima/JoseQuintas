/*
ZE_MACROTYPE
Jos� Quintas
*/

FUNCTION MacroType( cExpression )

   LOCAL cType := "U", bBlock

   BEGIN SEQUENCE WITH __BreakBlock()
      bBlock := hb_MacroBlock( cExpression )
      cType  := ValType( Eval( bBlock ) )
   ENDSEQUENCE

   RETURN cType

