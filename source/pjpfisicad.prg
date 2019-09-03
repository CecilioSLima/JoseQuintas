/*
PJPFISICAD - CONTAGEM FISICA
2009.08 Jos� Quintas

...
2016.09.10 - jpfisica em MySQL
*/

PROCEDURE PJPFISICAD

   LOCAL cTmpFile, oTBrowse, cnMySql := ADOClass():New( AppcnMySqlLocal() )

   IF AppcnMySqlLocal() == NIL
      MsgExclamation( "MySQL n�o dispon�vel" )
      RETURN
   ENDIF
   WITH OBJECT cnMySql
      :cSql := "SELECT * FROM JPFISICA WHERE FSQTDDIG1 <> FSQTDJPA1 OR FSQTDDIG2 <> FSQTDJPA2 OR FSQTDDIG3 <> FSQTDJPA3"
      :Execute()
      cTmpFile := :SqlToDbf()
   ENDWITH
   USE ( cTmpFile ) ALIAS JPFISICA
   oTBrowse := { ;
      { "PRODUTO", { || Pad( jpfisica->fsItem + '-' + jpfisica->fsDescri, 30 ) } }, ;
      { "DATA",    { || jpfisica->fsData } }, ;
      { "EST.1",   { || Str( jpfisica->fsQtdJpa1, 6 ) } }, ;
      { "DIG.1",   { || Str( jpfisica->fsQtdDig1, 6) } }, ;
      { "DIF.1",   { || Str( jpfisica->fsQtdDig1 - jpfisica->fsQtdJpa1, 6 ) } }, ;
      { "EST.2",   { || Str( jpfisica->fsQtdJpa2, 6 ) } }, ;
      { "DIG.2",   { || Str( jpfisica->fsQtdDig2, 6 ) } }, ;
      { "DIF.2",   { || Str( jpfisica->fsQtdDig2 - jpfisica->fsQtdJpa2, 6 ) } }, ;
      { "EST.3",   { || Str( jpfisica->fsQtdJpa3, 6 ) } }, ;
      { "DIG.3",   { || Str( jpfisica->fsQtdDig3, 6 ) } }, ;
      { "DIF.3",   { || Str( jpfisica->fsQtdDig3 - jpfisica->fsQtdJpa3, 6 ) } } }

   FazBrowse( oTBrowse )
   CLOSE DATABASES
   fErase( cTmpFile )

   RETURN
