/*
PTESDANFE - Teste de gerar Danfe usando PDFClass
Jos� Quintas
*/

#include "harupdf.ch"
#include "hbclass.ch"

PROCEDURE PTESDANFE

   LOCAL oPDF

   oPdf := DanfeClass():New()
   oPDF:Begin()
   oPdf:AddDanfe()
   oPDF:End()
   CLOSE DATABASES

   RETURN

#define SMALL_FONT  5
#define NORMAL_FONT 9
#define LARGE_FONT 11

CREATE CLASS DanfeClass INHERIT PDFClass

   VAR    cFontName         INIT "Times-Roman" // "Helvetica"
   VAR    nDrawMode         INIT 2 // mm
   VAR    nPdfPage          INIT 2 // Portrait
   METHOD Init()
   METHOD AddDanfe()

   ENDCLASS

METHOD Init() CLASS DanfeClass

   ::SetType( 2 )
   RETURN NIL

METHOD AddDanfe() CLASS DanfeClass

   ::AddPage()
   ::DrawBox( 12, 12, 27, 200 )
   ::DrawLine( 20, 12, 20, 165 )
   ::DrawLine( 20, 46, 27, 46 )
   ::DrawLine( 20, 165, 27, 165 )
   ::DrawText( 14, 14, "RECEBEMOS DE XXX OS PRODUTOS E/OU SERVI�OS CONSTANTES DA NOTA FISCAL ELETR�NICA INDICADA", , SMALL_FONT )
   ::DrawText( 16, 14, "AO LADO, EMISS�O XX/XX/XX, VALOR R$ 1,00 DESTINAT�RIO XXXX",, SMALL_FONT )
   ::DrawText( 22, 14, "DATA DO RECEBIMENTO", , SMALL_FONT )
   ::DrawText( 22, 48, "IDENTIFICA��O E ASSINATURA DO RECEBEDOR", , SMALL_FONT )
   ::DrawText( 16, 167, "NF-e", , NORMAL_FONT )
   ::DrawText( 20, 167, "N.111111", , NORMAL_FONT )
   ::DrawText( 24, 167, "S�RIE 1", , NORMAL_FONT )
   ::DrawLine( 12, 165, 22, 165 )

   ::DrawBox( 29, 12, 81, 200 )
   ::DrawLine( 30, 94, 67, 94 )
   ::DrawLine( 30, 127, 74, 127 )
   ::DrawLine( 44, 127, 44, 200 )
   ::DrawLine( 51, 127, 51, 200 )
   ::DrawLine( 67, 12, 67, 200 )
   ::DrawLine( 74, 12, 74, 200 )
   ::DrawText( 46, 129, "CHAVE DE ACESSO", , SMALL_FONT )
   ::DrawText( 69, 14, "NATUREZA DA OPERA��O", , SMALL_FONT )
   ::DrawText( 69, 129, "PROTOCOLO DE AUTORIZA��O DE USO", , SMALL_FONT )
   ::DrawLine( 74, 72, 81, 72 )
   ::DrawLine( 74, 139, 81, 139 )
   ::DrawText( 77, 14, "INSCRI��O ESTADUAL", , SMALL_FONT )
   ::DrawText( 77, 74, "INSCRI��O ESTADUAL DO SUBSTITUTO TRIBUT�RIO", , SMALL_FONT )
   ::DrawText( 77, 141, "CNPJ", , SMALL_FONT )

   ::DrawText( 83, 12, "DESTINAT�RIO/REMETENTE", , SMALL_FONT )

   ::DrawBox( 84, 12, 103, 200 )
   ::DrawLine( 84, 138, 91, 138 )
   ::DrawLine( 84, 174, 103, 174 )
   ::DrawLine( 91, 108, 103, 108 )
   ::DrawLine( 91, 157, 97, 157 )
   ::DrawLine( 91, 12, 91, 200 )
   ::DrawText( 86, 14, "NOME/RAZ�O SOCIAL", , SMALL_FONT )
   ::DrawText( 86, 140, "CNPJ/CPF", , SMALL_FONT )
   ::DrawText( 86, 176, "DATA DE EMISS�O", , SMALL_FONT )
   ::DrawLine( 97, 12, 97, 200 )
   ::DrawLine( 97, 139, 103, 139 )
   ::DrawText( 93, 14, "ENDERE�O", , SMALL_FONT )
   ::DrawText( 93, 110, "BAIRRO", , SMALL_FONT )
   ::DrawText( 93, 159, "CEP", , SMALL_FONT )
   ::DrawText( 93, 176, "DATA DE SA�DA", , SMALL_FONT )
   ::DrawText( 99, 14, "MUNIC�PIO", , SMALL_FONT )
   ::DrawText( 99, 103, "UF", , SMALL_FONT )
   ::DrawText( 99, 110, "FONE/FAX", , SMALL_FONT )
   ::DrawText( 99, 141, "INSCRI��O ESTADUAL", , SMALL_FONT )
   ::DrawText( 99, 176, "HORA DE SA�DA", , SMALL_FONT )

   ::DrawText( 105, 12, "FATURA/DUPLICATA", , SMALL_FONT )

   ::DrawBox( 106, 12, 111, 200 )

   ::DrawText( 113, 12, "C�LCULO DO IMPOSTO", , SMALL_FONT )

   ::DrawBox( 114, 12, 126, 200 )
   ::DrawLine( 120, 12, 120, 200 )
   ::DrawLine( 114, 49, 120, 49 )
   ::DrawLine( 114, 87, 120, 87 )
   ::DrawLine( 114, 124, 120, 124 )
   ::DrawLine( 114, 163, 120, 163 )
   ::DrawLine( 120, 39, 126, 39 )
   ::DrawLine( 120, 65, 126, 65 )
   ::DrawLine( 120, 92, 126, 92 )
   ::DrawLine( 120, 119, 126, 119 )
   ::DrawLine( 120, 146, 126, 146 )
   ::DrawLine( 120, 173, 126, 173 )
   ::DrawText( 116, 14, "BASE C�LC.ICMS", , SMALL_FONT )
   ::DrawText( 116, 51, "VALOR ICMS", , SMALL_FONT )
   ::DrawText( 116, 89, "BASE DE C�LC.ICMS ST", , SMALL_FONT )
   ::DrawText( 116, 126, "VALOR ICMS ST", , SMALL_FONT )
   ::DrawText( 116, 165, "VALOR DOS PRODUTOS", , SMALL_FONT )
   ::DrawText( 122, 14, "VALOR FRETE", , SMALL_FONT )
   ::DrawText( 122, 41, "VALOR SEGURO", , SMALL_FONT )
   ::DrawText( 122, 67, "VALOR DESCONTO", , SMALL_FONT )
   ::DrawText( 122, 94, "OUTRAS DESP", , SMALL_FONT )
   ::DrawText( 122, 121, "VALOR IPI", , SMALL_FONT )
   ::DrawText( 122, 148, "VALOR APROX TRIB", , SMALL_FONT )
   ::DrawText( 122, 175, "VALOR DA NOTA", , SMALL_FONT )

   ::DrawText( 128, 12, "TRANSPORTADOR/VOLUMES TRANSPORTADOS", , SMALL_FONT )

   ::DrawBox( 129, 12, 147, 200 )
   ::DrawLine( 135, 12, 135, 200 )
   ::DrawLine( 141, 12, 141, 200 )
   ::DrawLine( 129, 96, 135, 96 )
   ::DrawLine( 129, 119, 135, 119 )
   ::DrawLine( 129, 140, 135, 140 )
   ::DrawLine( 129, 159, 135, 159 )
   ::DrawLine( 129, 167, 135, 167 )
   ::DrawLine( 135, 112, 141, 112 )
   ::DrawLine( 135, 159, 141, 159 )
   ::DrawLine( 135, 167, 141, 167 )
   ::DrawLine( 141, 39, 147, 39 )
   ::DrawLine( 141, 66, 147, 66 )
   ::DrawLine( 141, 95, 147, 95 )
   ::DrawLine( 141, 136, 147, 136 )
   ::DrawLine( 141, 168, 147, 168 )
   ::DrawText( 131, 14, "NOME/RAZ�O SOCIAL", , SMALL_FONT )
   ::DrawText( 131, 98, "FRETE POR CONTA", , SMALL_FONT )
   ::DrawText( 131, 121, "C�DIGO ANTT", , SMALL_FONT )
   ::DrawText( 131, 142, "PLACA VE�CULO", , SMALL_FONT )
   ::DrawText( 131, 162, "UF", , SMALL_FONT )
   ::DrawText( 131, 169, "CNPJ/CPF", , SMALL_FONT )
   ::DrawText( 137, 14, "ENDERE�O", , SMALL_FONT )
   ::DrawText( 137, 114, "MUNIC�PIO", , SMALL_FONT )
   ::DrawText( 137, 161, "UF", , SMALL_FONT )
   ::DrawText( 137, 169, "INSCRI��O ESTADUAL", , SMALL_FONT )
   ::DrawText( 143, 14, "QUANTIDADE", , SMALL_FONT )
   ::DrawText( 143, 41, "ESP�CIE", , SMALL_FONT )
   ::DrawText( 143, 68, "MARCA", , SMALL_FONT )
   ::DrawText( 143, 97, "NUMERA��O", , SMALL_FONT )
   ::DrawText( 143, 138, "PESO BRUTO", , SMALL_FONT )
   ::DrawText( 143, 170, "PESO L�QUIDO", , SMALL_FONT )

   ::DrawText( 150, 12, "DADOS DOS PRODUTOS/SERVI�OS", , SMALL_FONT )

   ::DrawBox( 151, 12, 244, 200 )
   ::DrawLine( 158, 12, 158, 200 )
   ::DrawLine( 151, 23, 244, 23 )
   ::DrawLine( 151, 99, 244, 99 )
   ::DrawLine( 151, 112, 244, 112 )
   ::DrawLine( 151, 118, 244, 118 )
   ::DrawLine( 151, 125, 244, 125 )
   ::DrawLine( 151, 132, 244, 132 )
   ::DrawLine( 151, 141, 244, 141 )
   ::DrawLine( 151, 150, 244, 150 )
   ::DrawLine( 151, 163, 244, 163 )
   ::DrawLine( 151, 172, 244, 172 )
   ::DrawLine( 151, 181, 244, 181 )
   ::DrawLine( 151, 188, 244, 188 )
   ::DrawText( 153, 14, "C�DIGO", , SMALL_FONT )
   ::DrawText( 155, 14, "PRODUTO", , SMALL_FONT )
   ::DrawText( 153, 25, "DESCRI��O DO PRODUTO/SERVI�O", , SMALL_FONT )
   ::DrawText( 153, 101, "NCM/SH", , SMALL_FONT )
   ::DrawText( 153, 114, "CST", , SMALL_FONT )
   ::DrawText( 153, 120, "CFOP", , SMALL_FONT )
   ::DrawText( 153, 127, "UNID", , SMALL_FONT )
   ::DrawText( 153, 134, "QUANT", , SMALL_FONT )
   ::DrawText( 153, 143, "VALOR", , SMALL_FONT )
   ::DrawText( 155, 143, "UNIT", , SMALL_FONT )
   ::DrawText( 153, 152, "VALOR", , SMALL_FONT )
   ::DrawText( 155, 152, "TOTAL", , SMALL_FONT )
   ::DrawText( 153, 165, "B.CALC", , SMALL_FONT )
   ::DrawText( 155, 165, "ICMS", , SMALL_FONT )
   ::DrawText( 153, 174, "VALOR", , SMALL_FONT )
   ::DrawText( 155, 174, "ICMS", , SMALL_FONT )
   ::DrawText( 153, 183, "AL�Q", , SMALL_FONT )
   ::DrawText( 155, 183, "ICMS", , SMALL_FONT )
   ::DrawText( 153, 190, "V APROX", , SMALL_FONT )
   ::DrawText( 155, 190, "TRIBUTOS", , SMALL_FONT )

   ::DrawText( 246, 12, "DADOS ADICIONAIS", , SMALL_FONT )

   ::DrawBox( 247, 12, 277, 200 )
   ::DrawLine( 247, 122, 277, 122 )
   ::DrawText( 250, 14, "INFORMA��ES COMPLEMENTARES", , SMALL_FONT )
   ::DrawText( 250, 124, "RESERVADO AO FISCO", , SMALL_FONT )

   RETURN NIL

