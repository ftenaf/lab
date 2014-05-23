<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:ino="http://namespaces.softwareag.com/tamino/response2">

	<xsl:template name="replace-string">
	  <xsl:param name="text"/>
	  <xsl:param name="from"/>
	  <xsl:param name="to"/>
	  <xsl:choose>
		<xsl:when test="contains($text, $from)">
		  <xsl:variable name="before" select="substring-before($text, $from)"/>
		  <xsl:variable name="after" select="substring-after($text, $from)"/>
		  <xsl:variable name="prefix" select="concat($before, $to)"/>
		  <xsl:value-of select="$before"/>
		  <xsl:value-of select="$to"/>
		  <xsl:call-template name="replace-string">
			<xsl:with-param name="text" select="$after"/>
			<xsl:with-param name="from" select="$from"/>
			<xsl:with-param name="to" select="$to"/>
		  </xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:value-of select="$text"/>
		</xsl:otherwise>
	  </xsl:choose>
	</xsl:template>
	
	<xsl:decimal-format name="european" decimal-separator="," grouping-separator="." />
	<xsl:variable name="zipDir" select="/transformForView/dir/@value" />
	<xsl:variable name="total_factura">
		<xsl:value-of select="factura/datosFactura/@totalFactura"/>
	</xsl:variable>
	<xsl:variable name="stringSeparacionCampos">#$</xsl:variable>
	<xsl:template match="transformForView">
		<xsl:apply-templates select="*"/>
	</xsl:template>
	<xsl:template match="xi:include">
		<xsl:apply-templates select="document( @href )"/>
	</xsl:template>
	
	<xsl:template match="INVOICE">
		<html>
			<head>
				<link rel="stylesheet" href="{$zipDir}/styles.css" type="text/css"/>			
			</head>
			<body>
				<xsl:apply-templates select="INFO"/>
				<xsl:apply-templates select="TOT"/>
				<xsl:apply-templates select="SERVSUMMARY"/>
				<xsl:apply-templates select="ACCNTCHARGES"/>
				<xsl:apply-templates select="OTHERTAXSUMM"/>
				<xsl:apply-templates select="NOTAXSUMM"/>
				<xsl:apply-templates select="SERVTOTALSUMM"/>
				<xsl:apply-templates select="INSTACCNT"/>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="factura">
		<html>
			<head>
				<link rel="stylesheet" href="{$zipDir}/styles.css" type="text/css"/>			
			</head>
			<body>
						<xsl:apply-templates select="datosFactura"/>
						<xsl:apply-templates select="elementosCabecera"/>				
						<xsl:apply-templates select="totalesLlamadasNumerosTelefono"/>
						<xsl:apply-templates select="ResCuotasYCargosPorPlanesContratados"/>
						<xsl:apply-templates select="ResDescuentos"/>
						<xsl:apply-templates select="ResAjusteHastaConsumoMinimo"/>
						<xsl:apply-templates select="resumenesNumerosTelefono"/>
						<xsl:apply-templates select="detallesCuotas"/>
						<xsl:apply-templates select="resumenesPorGrupo"/>
						<xsl:apply-templates select="totalesMensaWeb"/>
						<xsl:apply-templates select="detallesDescuentosNumerosTelefono"/>
						<xsl:apply-templates select="detallesComprasVodafone"/>
						<xsl:apply-templates select="detallesLlamadasNumerosTelefono"/>
						<xsl:apply-templates select="resumenInformativoImportes"/>	
			</body>
		</html>
	</xsl:template>
	
	<!--NEW INVOICE -->
	<xsl:template match="INFO">
		<table width="70%">
			<tr>
				<td>
					<h1>Factura</h1>
				</td>
				<td align="right">
					<img width="180" height="33" src="{$zipDir}/Vodafone_300pp.gif"/>
				</td>
			</tr>
		</table>
		<table width="70%" bgcolor="#FFFFFF" cellspacing="0" cellpadding="0" border="0">
			<tr>
				<td>
					<table>
						<tr>
							<td class="heading1">Número de Factura:</td>
							<td width="2px"/>
							<td >
								<xsl:value-of select="BILL/@billRef"/>
							</td>
						</tr>
						<tr>
							<td class="heading1" >Número de cuenta Vodafone:</td>
							<td width="2px"/>
							<td >
								<xsl:value-of select="BILL/@preNumAccnt"/><xsl:value-of select="BILL/@numAccnt"/>
							</td>
						</tr>
						<tr>
							<td class="heading1" >Titular:</td>
							<td width="2px"/>
							<td >
								<xsl:value-of select="CUST/@name"/>
							</td>
						</tr>
						<tr>
							<td class="heading1" >NIF:</td>
							<td width="2px"/>
							<td >
								<xsl:value-of select="CUST/@nifCif"/>
							</td>
						</tr>
						<tr>
							<td class="heading1" >Fecha de emisión:</td>
							<td width="2px"/>
							<td >
								<xsl:call-template name="FormatDate">
									<xsl:with-param name="DateTime" select="BILL/@emitDt"/>
								</xsl:call-template>
							</td>
						</tr>
						<tr>
							<td class="heading1" >Lugar de emisión:</td>
							<td width="2px"/>
							<td >
								<xsl:value-of select="BILL/@descEmitPlace"/>
							</td>
						</tr>
						<tr>
							<td height="20px" bgcolor="#FFFFFF"/>
							<td width="2px"/>
							<td height="20px" bgcolor="#FFFFFF"/>
						</tr>
						<tr>
							<td class="heading1" >Forma de pago:</td>
							<td width="2px"/>
							<td >
								<xsl:value-of select="PAY/@payMethodDoc1Desc"/>
							</td>
						</tr>
						<xsl:if test="PAY/@payMethodDoc1 = '2' or PAY/@payMethodDoc1Desc = '5'">
							<tr>
								<td class="heading1" >Entidad emisora de tarjeta:</td>
								<td width="2px"/>
								<td >
									<xsl:value-of select="PAY/@cardCarrier"/>
								</td>
							</tr>
							<tr>
								<td class="heading1" >Nº de tarjeta:</td>
								<td width="2px"/>
								<td >
									<xsl:call-template name="RepeatStr">
										<xsl:with-param name="output" select="'*'"/>
										<xsl:with-param name="count" select="string-length (PAY/@cardAcount)- 5"/>
									</xsl:call-template>
									<xsl:value-of select="substring(PAY/@cardAcount,string-length (PAY/@cardAcount)-3,string-length (PAY/@cardAcount))"/>
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="PAY/@payMethodDoc1 = '3'">
							<tr>
								<td class="heading1" >Entidad bancaria:</td>
								<td width="2px"/>
								<td >
									<xsl:value-of select="PAY/@bankName"/>
								</td>
							</tr>
							<tr>
								<td class="heading1" >Nº de cuenta:</td>
								<td width="2px"/>
								<td >
									<xsl:call-template name="RepeatStr">
										<xsl:with-param name="output" select="'*'"/>
										<xsl:with-param name="count" select="string-length (PAY/@bankAccNum)- 5"/>
									</xsl:call-template>
									<xsl:value-of select="substring(PAY/@bankAccNum,string-length (PAY/@bankAccNum)-3,string-length (PAY/@bankAccNum))"/>
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="PAY/@payMethodDoc1 = '4'">
							<tr>
								<td class="heading1" >Entidad bancaria:</td>
								<td width="2px"/>
								<td >
									<xsl:value-of select="PAY/@bankName"/>
								</td>
							</tr>
							<tr>
								<td class="heading1" >Nº de cuenta:</td>
								<td width="2px"/>
								<td >
									<xsl:call-template name="RepeatStr">
										<xsl:with-param name="output" select="'*'"/>
										<xsl:with-param name="count" select="string-length (PAY/@bankAccNum)- 5"/>
									</xsl:call-template>
									<xsl:value-of select="substring(PAY/@bankAccNum,string-length (PAY/@bankAccNum)-3,string-length (PAY/@bankAccNum))"/>
								</td>
							</tr>
						</xsl:if>
						<tr>
							<td class="heading1" >Fecha de vencimiento:</td>
							<td width="2px"/>
							<td >
								<xsl:call-template name="FormatDate">
									<xsl:with-param name="DateTime" select="BILL/@dueDt"/>
								</xsl:call-template>
							</td>
						</tr>
						<tr>
							<td height="20px" bgcolor="#FFFFFF"/>
							<td width="2px"/>
							<td height="20px" bgcolor="#FFFFFF"/>
						</tr>
						<tr>
							<td class="heading2" >Periodo de consumo:</td>
							<td width="2px"/>
							<td class="heading2">
								<xsl:call-template name="FormatDate">
									<xsl:with-param name="DateTime" select="BILL/@fromDt"/>
								</xsl:call-template>
								&#xa0;al&#xa0;
								<xsl:call-template name="FormatDate">
									<xsl:with-param name="DateTime" select="BILL/@toDt"/>
								</xsl:call-template>
							</td>
						</tr>
					</table>
				</td>
				<td align="right">
					<xsl:apply-templates select="ADDR"/>
				</td>
			</tr>
		</table>
	</xsl:template>
	
	<xsl:template match="ADDR">
		<table>
			<tr>
				<td >
					<xsl:value-of select="@dest"/>
				</td>
			</tr>
			<tr>
				<td >
					<xsl:value-of select="@line1"/>
				</td>
			</tr>
			<tr>
				<td >
					<xsl:value-of select="@zip"/>&#xa0;<xsl:value-of select="@city"/>
				</td>
			</tr>
			<tr>
				<td >
					<xsl:value-of select="@prov"/>
				</td>
			</tr>
			<tr>
				<td >
					<xsl:value-of select="@country"/>
				</td>
			</tr>
		</table>
	</xsl:template>
	
	<xsl:template match="TOT">
		<table>
			<tr>
				<td height="20px" bgcolor="#FFFFFF"/>
			</tr>
		</table>
		<table class="txtBox400" bgcolor="#BEBEBE">
			<xsl:for-each select="TAXSUMM">
				<xsl:choose>
					<xsl:when test="number(@taxRate) &gt; 0">
						<tr>
							<td class="heading1" >Total (base imponible <xsl:value-of select="@taxRate"/>%)</td>
							<td width="100px"/>
							<td class="heading1" align="right">
								<xsl:value-of select='format-number(@baseTotal, "#.##0,00", "european")' />
							</td>
						</tr>
						<tr>
							<td class="heading1"><xsl:value-of select="@taxName"/> (<xsl:value-of select="@taxRate"/>%)</td>
							<td width="100px"/>
							<td class="heading1" align="right">
								<xsl:value-of select='format-number(@totalTax, "#.##0,00", "european")' />
							</td>
						</tr>
					</xsl:when>
					<xsl:otherwise>
						<tr>
							<td class="heading1">Conceptos no sujetos o exentos de impuestos</td>
							<td width="100px"/>
							<td class="heading1" align="right">
								<xsl:value-of select='format-number(@totalTax, "#.##0,00", "european")' />
							</td>
						</tr>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
			<tr>
				<td class="heading2" >Total factura</td>
				<td width="100px"/>
				<td class="heading2" align="right">
					<xsl:value-of select='format-number(@totalAmt, "#.##0,00", "european")' />
				</td>
			</tr>
			<xsl:if test="@previousDue != '0.00'">
					<tr>
						<td class="heading1" >Abono pendiente de facturas anteriores</td>
						<td width="50px"/>
						<td class="heading1" align="right">
							<xsl:value-of select='format-number(@previousDue, "#.##0,00", "european")' />
						</td>
					</tr>
			</xsl:if>
			<xsl:if test="@pendingCredit != '0.00'">
					<tr>
						<td class="heading1" >Crédito pendiente de facturas anteriores</td>
						<td width="50px"/>
						<td class="heading1" align="right">
							<xsl:value-of select='format-number(@pendingCredit, "#.##0,00", "european")' />
						</td>
					</tr>
			</xsl:if>
			<tr>
				<td class="heading3" >Total a pagar</td>
				<td width="100px"/>
				<td class="heading3" align="right">
					<xsl:value-of select='format-number(@totalAmt, "#.##0,00", "european")' />&#xa0;&#8364;
				</td>
			</tr>
		</table>
	</xsl:template>
	
	<xsl:template match="SERVSUMMARY">
		<table>
			<tr>
				<td height="20px" bgcolor="#FFFFFF"/>
			</tr>
			<tr>
				<td>
					<h3>Resumen de factura:</h3>
				</td>
			</tr>
		</table>
		<div align="center">
			<table class="txtBoxResumen" width="70%" >
				<xsl:apply-templates select="Tot"/>
			</table>
		</div>
		<table>
			<tr>
				<td height="20px" bgcolor="#FFFFFF"/>
			</tr>
		</table>
		<table width="100%">
			<tr>
				<td colspan="2">
					<h3>Agregados de conceptos a nivel de servicio:</h3>
				</td>
			</tr>
			<tr>
				<td valign="top" width="50%">
					<xsl:apply-templates select="RESCHA"/>
				</td>
				<td valign="top" width="50%">
					<xsl:apply-templates select="RESUSG"/>
				</td>
			</tr>
		</table>
	</xsl:template>
	
	<xsl:template match="Tot">
		<tr bgcolor="#BEBEBE">
			<td class="heading3" width="200px">Tipo de servicio</td>
			<td class="heading3" align="right" width="75px">Cuotas</td>
			<td class="heading3" align="right" width="100px">Consumos</td>
			<td class="heading3" align="right" width="175px">Total: &#xa0;<xsl:value-of select='format-number(@totalAmt, "#.##0,0000", "european")' />&#xa0;&#8364;</td>
		</tr>
		<xsl:for-each select="groupTOT">
			<tr>
				<td  width="200px"><xsl:value-of select="@groupDesc"/></td>
				<td  align="right" width="75px"><xsl:value-of select='format-number(@totalUsg, "#.##0,0000", "european")' /></td>
				<td  align="right" width="100px"><xsl:value-of select='format-number(@totalChrg, "#.##0,0000", "european")' /></td>
				<td  align="right" width="175px"><xsl:value-of select='format-number(@totalAmt, "#.##0,0000", "european")' /></td>
			</tr>
		</xsl:for-each>
		<tr>
			<td colspan="4"><hr/></td>
		</tr>
		<xsl:for-each select="//INVOICE/OTHERTAXSUMM">
			<xsl:if test="number(@total) != 0 or number(@totalDiscount) != 0 ">
				<tr>
					<td colspan="4"> </td>
				</tr>
				<tr bgcolor="#BEBEBE">
					<td class="heading3" colspan="3">
						Conceptos con <xsl:value-of select="@taxName" /> al <xsl:value-of select="@taxRate" />%
					</td>
					<td class="heading3" align="right" width="175px">Total: &#xa0;<xsl:value-of select='format-number(@total, "#.##0,0000", "european")' />&#xa0;&#8364;</td>
				</tr>
			</xsl:if>	
		</xsl:for-each>	

		<xsl:for-each select="//INVOICE/NOTAXSUMM">
			<xsl:if test="number(@total) != 0 or number(@totalDiscount) != 0 ">
				<tr>
					<td colspan="4"> </td>
				</tr>
				<tr bgcolor="#BEBEBE">
					<td class="heading3" colspan="3">
						Conceptos no sujetos o exentos de impuestos
					</td>
					<td class="heading3" align="right" width="175px">Total: &#xa0;<xsl:value-of select='format-number(@total, "#.##0,0000", "european")' />&#xa0;&#8364;</td>
				</tr>
			</xsl:if>
		</xsl:for-each>	
	</xsl:template>
	
	<xsl:template match="RESCHA">
		<table class="tableCollapsed" width="100%">
			<tr bgcolor="#BEBEBE" >
				<td  class="blackBottomBorderHeading3">
					Cuotas
				</td>
				<td  class="blackBottomBorderHeading3" align="right">
					Total: &#xa0;<xsl:value-of select='format-number(TOT/@totalAmt, "#.##0,0000", "european")' />&#xa0;&#8364;
				</td>
			</tr>

			<xsl:for-each select="RESGROUP">
				<tr>
					<td colspan="2" height="20px" bgcolor="#FFFFFF"/>
				</tr>
				<tr>
					<td colspan="2">
						<table class="tableGreyBorderCollapsed" width="100%">
							<tr bgcolor="#BEBEBE">
								<td class="heading2" ><xsl:value-of select="@groupDesc"/></td>
								<td class="heading2" align="right"><xsl:value-of select='format-number(TOT/@totalAmt, "#.##0,0000", "european")' /></td>
							</tr>
							<xsl:for-each select="Rc">
								<tr>
									<td><xsl:value-of select="@Literal"/>&#xa0;(<xsl:value-of select="@count"/>)</td>
									<td align="right"><xsl:value-of select='format-number(@amt, "#.##0,0000", "european")' /></td>
								</tr>
							</xsl:for-each>
							<xsl:for-each select="NRC">
								<tr>
									<td><xsl:value-of select="@Literal"/>&#xa0;(<xsl:value-of select="@count"/>)</td>
									<td align="right"><xsl:value-of select='format-number(@amt, "#.##0,0000", "european")' /></td>
								</tr>
							</xsl:for-each>
							<xsl:for-each select="ADJ">
								<tr>
									<td><xsl:value-of select="@Literal"/>&#xa0;(<xsl:value-of select="@count"/>)</td>
									<td align="right"><xsl:value-of select='format-number(@amt, "#.##0,0000", "european")' /></td>
								</tr>
							</xsl:for-each>
							<xsl:for-each select="RESDISC">
								<tr>
									<td><xsl:value-of select="@desc"/>&#xa0;(<xsl:value-of select="@count"/>)</td>
									<td align="right"><xsl:value-of select='format-number(@totalDisc, "#.##0,0000", "european")' /></td>
								</tr>
							</xsl:for-each>
						</table>
					</td>
				</tr>
			</xsl:for-each>
		</table>
	</xsl:template>
	
	<xsl:template match="RESUSG">
		<table class="tableCollapsed" width="100%">
			<tr bgcolor="#BEBEBE" >
				<td  class="blackBottomBorderHeading3">
					Consumos
				</td>
				<td  class="blackBottomBorderHeading3" align="right">
					Total: &#xa0;<xsl:value-of select='format-number(TOT/@totalAmt, "#.##0,0000", "european")' />&#xa0;&#8364;
				</td>
			</tr>

			<xsl:for-each select="RESGROUP">
				<tr>
					<td colspan="2" height="20px" bgcolor="#FFFFFF"/>
				</tr>
				<tr>
					<td colspan="2">
						<table class="tableGreyBorderCollapsed" width="100%">
							<tr bgcolor="#BEBEBE">
								<td class="heading2" width="40%"><xsl:value-of select="@groupDesc"/></td>
								<xsl:variable name="groupId" select="@groupID"/>
									<xsl:if test="$groupId = '1'">
										<td class="heading2" width="15%" style="text-align: center;">Nº Llam.</td>
										<td class="heading2" width="15%" style="text-align: center;">Duración</td>
									</xsl:if>
									<xsl:if test="$groupId = '2'">
										<td class="heading2" width="15%" style="text-align: center;">Nº Mens.</td>
										<td class="heading2" width="15%" style="text-align: center;">&#xa0;</td>
									</xsl:if>
									<xsl:if test="$groupId = '3'">
										<td class="heading2" width="15%" style="text-align: center;">Nº Conex.</td>
										<td class="heading2" width="15%" style="text-align: center;">Vol.(Kb)</td>
									</xsl:if>
								<td class="heading2" align="right" width="30%"><xsl:value-of select='format-number(TOT/@totalAmt, "#.##0,0000", "european")' /></td>
							</tr>
							<xsl:for-each select="RESTYPE">
								<tr>
									<td width="40%"><xsl:value-of select="@descTipo"/></td>
									<td width="15%" style="text-align: center;"><xsl:value-of select="TOT/@count"/></td>
									<xsl:if test="$groupId = '1'">
										<td width="15%" style="text-align: center;"><xsl:value-of select="TOT/@liDura"/></td>
									</xsl:if>
									<xsl:if test="$groupId = '2'">
										<td width="15%" style="text-align: center;">&#xa0;</td>
									</xsl:if>
									<xsl:if test="$groupId = '3'">
										<td width="15%" style="text-align: center;"><xsl:value-of select='format-number(TOT/@totalUnits, "#.##0", "european")' /></td>
									</xsl:if>
									<td align="right" width="30%"><xsl:value-of select='format-number(TOT/@totalAmt, "#.##0,0000", "european")' /></td>
								</tr>
							</xsl:for-each>
							<xsl:for-each select="RESDISC">
								<tr>
									<td width="70%" colspan="3"><xsl:value-of select="@desc"/>&#xa0;(<xsl:value-of select="@count"/>)</td>
									<td align="right" width="30%"><xsl:value-of select='format-number(@totalDisc, "#.##0,0000", "european")' /></td>
								</tr>
							</xsl:for-each>
						</table>
					</td>
				</tr>
			</xsl:for-each>
		</table>
	</xsl:template>
	
	<xsl:template match="ACCNTCHARGES">
		<table>
			<tr>
				<td height="20px" bgcolor="#FFFFFF"/>
			</tr>
		</table>
		<table class="tableCollapsed" width="100%">
			<tr bgcolor="#BEBEBE">
				<td class="heading3" width="40%">
					Cuotas y Descuentos a nivel de Cuenta
				</td>
				<td class="heading3" width="20%" style="text-align: center;"> 
					Cantidad
				</td>
				<td class="heading3" align="right" width="40%">Total: &#xa0;<xsl:value-of select='format-number(Tot/@totalAmt, "#.##0,0000", "european")' /></td>
			</tr>
			<xsl:for-each select="RCS/RC">
				<xsl:if test="@draw = '1'">
					<tr>
						<td>
							<xsl:value-of select="@desc"/>&#xa0;(
							<xsl:call-template name="FormatDateText">
								<xsl:with-param name="DateTime" select="@fromDt"/>
							</xsl:call-template>
							&#xa0;a&#xa0;
							<xsl:call-template name="FormatDateText">
								<xsl:with-param name="DateTime" select="@toDt"/>
							</xsl:call-template>)
						</td>
						
						<td style="text-align: center;">&#xa0;</td>
						<td align="right"><xsl:value-of select='format-number(@amt, "#.##0,0000", "european")' /></td>
					</tr>
				</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="NRCS/NRC">
				<xsl:if test="@draw = '1'">
					<tr>
						<td>
							<xsl:value-of select="@desc"/>&#xa0;(
							<xsl:call-template name="FormatDateText">
								<xsl:with-param name="DateTime" select="@fromDt"/>
							</xsl:call-template>
							&#xa0;a&#xa0;
							<xsl:call-template name="FormatDateText">
								<xsl:with-param name="DateTime" select="@toDt"/>
							</xsl:call-template>)
						</td>
						
						<td style="text-align: center;">&#xa0;</td>
						<td align="right"><xsl:value-of select='format-number(@amt, "#.##0,0000", "european")' /></td>
					</tr>
				</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="DISCS/DISC">
				<xsl:if test="@draw = '1'">
					<tr>
						<td>
							<xsl:value-of select="@desc"/>&#xa0;(
							<xsl:call-template name="FormatDateText">
								<xsl:with-param name="DateTime" select="@startDt"/>
							</xsl:call-template>
							&#xa0;a&#xa0;
							<xsl:call-template name="FormatDateText">
								<xsl:with-param name="DateTime" select="@endDt"/>
							</xsl:call-template>)
						</td>
						
						<td style="text-align: center;"><xsl:value-of select='format-number(@amt, "#.##0,0000", "european")' /></td>
						<td align="right"><xsl:value-of select='format-number(@disc, "#.##0,0000", "european")' /></td>
					</tr>
				</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="ADJS/ADJ">
				<xsl:if test="@draw = '1'">
					<tr>
						<td>
							<xsl:value-of select="@desc"/>&#xa0;
						</td>
						
						<td style="text-align: center;">&#xa0;</td>
						<td align="right"><xsl:value-of select='format-number(@amt, "#.##0,0000", "european")' /></td>
					</tr>
				</xsl:if>
			</xsl:for-each>
			<tr>
				<td colspan="3"><hr/></td>
			</tr>
		</table>
	</xsl:template>
	
	<xsl:template match="OTHERTAXSUMM">
		<xsl:for-each select="//INVOICE/OTHERTAXSUMM">	
			<xsl:if test="number(@total) != 0 or number(@totalDiscount) != 0 ">		
				<table>
					<tr>
						<td height="20px" bgcolor="#FFFFFF"/>
					</tr>
				</table>
				<table class="tableCollapsed" width="100%">
					<tr bgcolor="#BEBEBE">
						<td class="heading3" colspan="5">
							Conceptos con <xsl:value-of select="@taxName" /> al <xsl:value-of select="@taxRate" />%
						</td>
						<td class="heading3" align="right">Total: &#xa0;<xsl:value-of select='format-number(@total, "#.##0,0000", "european")' /></td>
					</tr>
					<tr>
						<td class="heading1" width="25%">
							Descripción
						</td>
						<td class="heading1" width="15%">
							Nº de Teléfono
						</td>
						<td class="heading1" width="20%" align="center">
							Fecha
						</td>
						<td class="heading1" width="5%" align="center">
							Hora
						</td>
						<td class="heading1" width="20%" align="center">
							Producto
						</td>	
						<td class="heading1" width="15%" align="right">
							Importe
						</td>
					</tr>		
					<tr>
						<td colspan="6" class="tableGreyBorderCollapsed"></td>
					</tr>
					<xsl:for-each select="LINE/RC">
						<xsl:if test="@draw = '1'">
							<tr>
								<td>
									<xsl:value-of select="../@desc"/>
								</td>
								<td>
									<xsl:value-of select="../@serv"/>
								</td>
								<td align="center">
									<!-- xsl:value-of select="@fromDt"/>
									&#xa0;a&#xa0;
									<xsl:value-of select="@toDt"/-->

									<xsl:call-template name="FormatDateText">							
										<xsl:with-param name="DateTime" select="@fromDt"/>
									</xsl:call-template>								
									&#xa0;a&#xa0;
									<xsl:call-template name="FormatDateText">							
										<xsl:with-param name="DateTime" select="@toDt"/>
									</xsl:call-template>								
								</td>
								<td align="center">
									<xsl:value-of select="../@time"/>
								</td>
								<td align="center">
									<xsl:value-of select="../@product"/>
								</td>
								<td align="right"><xsl:value-of select='format-number(../@total, "#.##0,0000", "european")' /></td>
							</tr>
						</xsl:if>
					</xsl:for-each>
					<xsl:for-each select="LINE/NRC">
						<xsl:if test="@draw = '1'">
							<tr>
								<td>
									<xsl:value-of select="../@desc"/>
								</td>
								<td>
									<xsl:value-of select="../@serv"/>
								</td>
								<td align="center">
									<!--xsl:value-of select="../@date"/-->
									<xsl:call-template name="FormatDateText">							
										<xsl:with-param name="DateTime" select="../@date"/>
									</xsl:call-template>								
								</td>
								<td align="center">
									<xsl:value-of select="../@time"/>
								</td>
								<td align="center">
									<xsl:value-of select="../@product"/>
								</td>
								<td align="right"><xsl:value-of select='format-number(../@total, "#.##0,0000", "european")' /></td>
							</tr>
						</xsl:if>
					</xsl:for-each>
					<xsl:for-each select="LINE/EXEMPT">
						<xsl:if test="@draw = '1'">
							<tr>
								<td>
									<xsl:value-of select="../@desc"/>
								</td>
								<td>
									<xsl:value-of select="../@serv"/>
								</td>
								<td align="center">
									<!--xsl:value-of select="../@date"/-->
									<xsl:call-template name="FormatDateText">							
										<xsl:with-param name="DateTime" select="../@date"/>
									</xsl:call-template>								
								</td>
								<td align="center">
									<xsl:value-of select="../@time"/>
								</td>
								<td align="center">
									<xsl:value-of select="../@product"/>
								</td>
								<td align="right"><xsl:value-of select='format-number(../@total, "#.##0,0000", "european")' /></td>
							</tr>
						</xsl:if>
					</xsl:for-each>							
					<xsl:for-each select="LINE/DISC">
						<xsl:if test="@draw = '1'">
							<tr>
								<td>
									<xsl:value-of select="../@desc"/>
								</td>
								<td>
									<xsl:value-of select="../@serv"/>
								</td>
								<td align="center">
									<!-- xsl:value-of select="@startDt"/>
									&#xa0;a&#xa0;
									<xsl:value-of select="@endDt"/-->

									<xsl:call-template name="FormatDateText">							
										<xsl:with-param name="DateTime" select="@startDt"/>
									</xsl:call-template>								
									&#xa0;a&#xa0;
									<xsl:call-template name="FormatDateText">							
										<xsl:with-param name="DateTime" select="@endDt"/>
									</xsl:call-template>								
								</td>
								<td align="center">
									<xsl:value-of select="../@time"/>
								</td>
								<td align="center">
									<xsl:value-of select="../@product"/>
								</td>
								<td align="right"><xsl:value-of select='format-number(../@total, "#.##0,0000", "european")' /></td>
							</tr>
						</xsl:if>
					</xsl:for-each>
					<xsl:for-each select="LINE/ADJ">
						<xsl:if test="@draw = '1'">
							<tr>
								<td>
									<xsl:value-of select="../@desc"/>
								</td>
								<td>
									<xsl:value-of select="../@serv"/>
								</td>
								<td align="center">
									<!--xsl:value-of select="../@date"/-->
									<xsl:call-template name="FormatDateText">							
										<xsl:with-param name="DateTime" select="../@date"/>
									</xsl:call-template>								
								</td>
								<td align="center">
									<xsl:value-of select="../@time"/>
								</td>
								<td align="center">
									<xsl:value-of select="../@product"/>
								</td>
								<td align="right"><xsl:value-of select='format-number(../@total, "#.##0,0000", "european")' /></td>
							</tr>
						</xsl:if>
					</xsl:for-each>
					<xsl:for-each select="LINE/CDR">
						<xsl:if test="@draw != '-1'">
							<tr>
								<td>
									<xsl:value-of select="../@desc"/>
								</td>
								<td>
									<xsl:value-of select="../@serv"/>
								</td>
								<td align="center">
									<!--xsl:value-of select="../@date"/-->
									<xsl:call-template name="FormatDateText">							
										<xsl:with-param name="DateTime" select="../@date"/>
									</xsl:call-template>								
								</td>
								<td align="center">
									<xsl:value-of select="../@time"/>
								</td>
								<td align="center">
									<xsl:value-of select="../@product"/>
								</td>
								<td align="right"><xsl:value-of select='format-number(../@total, "#.##0,0000", "european")' /></td>
							</tr>
						</xsl:if>
					</xsl:for-each>
					<tr>
						<td colspan="6"><hr/></td>
					</tr>
				</table>
			</xsl:if>	
		</xsl:for-each>	
	</xsl:template>
	
	<xsl:template match="NOTAXSUMM">
		<table>
			<tr>
				<td height="20px" bgcolor="#FFFFFF"/>
			</tr>
		</table>
		<table class="tableCollapsed" width="100%">
			<tr bgcolor="#BEBEBE">
				<td class="heading3" colspan="5">
					Conceptos no sujetos o exentos de impuestos
				</td>
				<td class="heading3" align="right">Total: &#xa0;<xsl:value-of select='format-number(@total, "#.##0,0000", "european")' /></td>
			</tr>
			<tr>
				<td class="heading1" width="25%">
					Descripción
				</td>
				<td class="heading1" width="15%">
					Nº de Teléfono
				</td>
				<td class="heading1" width="20%" align="center">
					Fecha
				</td>
				<td class="heading1" width="5%" align="center">
					Hora
				</td>
				<td class="heading1" width="20%" align="center">
					Producto
				</td>	
				<td class="heading1" width="15%" align="right">
					Importe
				</td>
			</tr>
			<tr>
				<td colspan="6" class="tableGreyBorderCollapsed"></td>
			</tr>
			<xsl:for-each select="LINE/RC">
				<xsl:if test="@draw = '1'">
					<tr>
						<td>
							<xsl:value-of select="../@desc"/>
						</td>
						<td>
							<xsl:value-of select="../@serv"/>
						</td>
						<td align="center">
							<!-- xsl:value-of select="@fromDt"/>
							&#xa0;a&#xa0;
							<xsl:value-of select="@toDt"/-->

							<xsl:call-template name="FormatDateText">							
								<xsl:with-param name="DateTime" select="@fromDt"/>
							</xsl:call-template>								
							&#xa0;a&#xa0;
							<xsl:call-template name="FormatDateText">							
								<xsl:with-param name="DateTime" select="@toDt"/>
							</xsl:call-template>								
						</td>
						<td align="center">
							<xsl:value-of select="../@time"/>
						</td>
						<td align="center">
							<xsl:value-of select="../@product"/>
						</td>
						<td align="right"><xsl:value-of select='format-number(../@total, "#.##0,0000", "european")' /></td>
					</tr>
				</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="LINE/NRC">
				<xsl:if test="@draw = '1'">
					<tr>
						<td>
							<xsl:value-of select="../@desc"/>
						</td>
						<td>
							<xsl:value-of select="../@serv"/>
						</td>
						<td align="center">
							<!--xsl:value-of select="../@date"/-->
							<xsl:call-template name="FormatDateText">							
								<xsl:with-param name="DateTime" select="../@date"/>
							</xsl:call-template>								
						</td>
						<td align="center">
							<xsl:value-of select="../@time"/>
						</td>
						<td align="center">
							<xsl:value-of select="../@product"/>
						</td>
						<td align="right"><xsl:value-of select='format-number(../@total, "#.##0,0000", "european")' /></td>
					</tr>
				</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="LINE/EXEMPT">
				<!--xsl:if test="@draw = '1'"-->
					<tr>
						<td>
							<xsl:value-of select="../@desc"/>
						</td>
						<td>
							<xsl:value-of select="../@serv"/>
						</td>
						<td align="center">
							<!--xsl:value-of select="../@date"/-->
							<xsl:call-template name="FormatDateText">							
								<xsl:with-param name="DateTime" select="../@date"/>
							</xsl:call-template>								
						</td>
						<td align="center">
							<xsl:value-of select="../@time"/>
						</td>
						<td align="center">
							<xsl:value-of select="../@product"/>
						</td>
						<td align="right"><xsl:value-of select='format-number(../@total, "#.##0,0000", "european")' /></td>
					</tr>
				<!--/xsl:if-->
			</xsl:for-each>							
			<xsl:for-each select="LINE/DISC">
				<xsl:if test="@draw = '1'">
					<tr>
						<td>
							<xsl:value-of select="../@desc"/>
						</td>
						<td>
							<xsl:value-of select="../@serv"/>
						</td>
						<td align="center">
							<!-- xsl:value-of select="@startDt"/>
							&#xa0;a&#xa0;
							<xsl:value-of select="@endDt"/-->

							<xsl:call-template name="FormatDateText">							
								<xsl:with-param name="DateTime" select="@startDt"/>
							</xsl:call-template>								
							&#xa0;a&#xa0;
							<xsl:call-template name="FormatDateText">							
								<xsl:with-param name="DateTime" select="@endDt"/>
							</xsl:call-template>								
						</td>
						<td align="center">
							<xsl:value-of select="../@time"/>
						</td>
						<td align="center">
							<xsl:value-of select="../@product"/>
						</td>
						<td align="right"><xsl:value-of select='format-number(../@total, "#.##0,0000", "european")' /></td>
					</tr>
				</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="LINE/ADJ">
				<xsl:if test="@draw = '1'">
					<tr>
						<td>
							<xsl:value-of select="../@desc"/>
						</td>
						<td>
							<xsl:value-of select="../@serv"/>
						</td>
						<td align="center">
							<!--xsl:value-of select="../@date"/-->
							<xsl:call-template name="FormatDateText">							
								<xsl:with-param name="DateTime" select="../@date"/>
							</xsl:call-template>								
						</td>
						<td align="center">
							<xsl:value-of select="../@time"/>
						</td>
						<td align="center">
							<xsl:value-of select="../@product"/>
						</td>
						<td align="right"><xsl:value-of select='format-number(../@total, "#.##0,0000", "european")' /></td>
					</tr>
				</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="LINE/CDR">
				<xsl:if test="@draw != '-1'">
					<tr>
						<td>
							<xsl:value-of select="../@desc"/>
						</td>
						<td>
							<xsl:value-of select="../@serv"/>
						</td>
						<td align="center">
							<!--xsl:value-of select="../@date"/-->
							<xsl:call-template name="FormatDateText">							
								<xsl:with-param name="DateTime" select="../@date"/>
							</xsl:call-template>								
						</td>
						<td align="center">
							<xsl:value-of select="../@time"/>
						</td>
						<td align="center">
							<xsl:value-of select="../@product"/>
						</td>
						<td align="right"><xsl:value-of select='format-number(../@total, "#.##0,0000", "european")' /></td>
					</tr>
				</xsl:if>
			</xsl:for-each>		
			<tr>
				<td colspan="6"><hr/></td>
			</tr>
		</table>
	</xsl:template>
	
	<xsl:template match="SERVTOTALSUMM">
		<table>
			<tr>
				<td height="20px" bgcolor="#FFFFFF"/>
			</tr>
			<tr>
				<td>
					<h3>Resumen de total de líneas: <xsl:value-of select="@count"/></h3>
				</td>
			</tr>
		</table>
		<table class="tableCollapsed" width="100%">
			<tr bgcolor="#BEBEBE">
				<td class="heading3" width="20%">
					Nº de Teléfono
				</td>
				<td class="heading3" width="40%"> 
					Plan de Precios
				</td>
				<td class="heading3" width="10%" style="text-align: center;"> 
					Cuotas
				</td>
				<td class="heading3" width="10%" style="text-align: center;"> 
					Consumos
				</td>
				<td class="heading3" align="right" width="20%">Total: &#xa0;<xsl:value-of select='format-number(@totalAmt, "#.##0,0000", "european")' /></td>
			</tr>
			<xsl:for-each select="SERVTOTAL">
				<xsl:variable name="serviceNumber">
					<xsl:value-of select="@extIdDOC1"/>
				</xsl:variable>
			
				<tr>
					<td><xsl:value-of select="@extIdDOC1"/></td>
					<xsl:choose>
						<xsl:when test="//INSTACCNT/SERV/INFO/SERV[@fixNum = $serviceNumber]">
							<td><xsl:value-of select="@fixPricePlan"/></td>
						</xsl:when>
						<xsl:otherwise>
							<td><xsl:value-of select="@voicePricePlan"/></td>
						</xsl:otherwise>
					</xsl:choose>
					<td style="text-align: center;"><xsl:value-of select='format-number(@totalCharges, "#.##0,0000", "european")' /></td>
					<td style="text-align: center;"><xsl:value-of select='format-number(@totalUsage, "#.##0,0000", "european")' /></td>
					<td align="right"><xsl:value-of select='format-number(@total, "#.##0,0000", "european")' /></td>
				</tr>
			</xsl:for-each>
			<tr>
				<td colspan="5"><hr/></td>
			</tr>
		</table>
	</xsl:template>
	
	<xsl:template match="INSTACCNT">
		<xsl:for-each select="SERV">
			<table>
				<tr>
					<td height="20px" bgcolor="#FFFFFF"/>
				</tr>
			</table>
			<table class="tableCollapsed" width="100%">
				<tr>
					<td class="heading3" width="33%">Resumen: 
						<xsl:value-of select="INFO/SERV/@extIdDOC1"/>
					</td>
					<td class="heading3" width="33%" align="center">
						<xsl:choose>
							<xsl:when test="INFO/SERV/@fixNum != ''">
								<xsl:value-of select="INFO/SERV/@FixPricePlan"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="INFO/SERV/@VoicePricePlan"/>
							</xsl:otherwise>
						</xsl:choose>
					</td>
					<td class="heading3" width="33%" align="right">Total: &#xa0;<xsl:value-of select='format-number(TOT/@totalAmt, "#.##0,0000", "european")' />&#xa0;&#8364;</td>
				</tr>
				<tr>
					<td colspan="3"><hr/></td>
				</tr>
				<tr>
					<td colspan="3">
						<table width="100%">
							<td valign="top" width="50%">
								<xsl:apply-templates select="CHARGES"/>
							</td>
							<td valign="top" width="50%">
								<table class="tableCollapsed" width="100%">
									<tr bgcolor="#BEBEBE" >
										<td  class="blackBottomBorderHeading3">
											Consumos
										</td>
										<td  class="blackBottomBorderHeading3" align="right">
											Total: &#xa0;<xsl:value-of select='format-number(USAGE/TOT/@totalAmt, "#.##0,0000", "european")' />&#xa0;&#8364;
										</td>
									</tr>

									<xsl:for-each select="USAGE/GROUP">
										<xsl:if test="@draw = '1'">
											<tr>
												<td colspan="2" height="20px" bgcolor="#FFFFFF"/>
											</tr>
											<tr>
												<td colspan="2">
													<table class="tableGreyBorderCollapsed" width="100%">
														<tr bgcolor="#BEBEBE">
															<td class="heading2" width="40%"><xsl:value-of select="@groupDesc"/></td>
															<xsl:variable name="groupId" select="@groupID"/>
																<xsl:if test="$groupId = '1'">
																	<td class="heading2" width="15%" style="text-align: center;">Nº Llam.</td>
																	<td class="heading2" width="15%" style="text-align: center;">Duración</td>
																</xsl:if>
																<xsl:if test="$groupId = '2'">
																	<td class="heading2" width="15%" style="text-align: center;">Nº Mens.</td>
																	<td class="heading2" width="15%" style="text-align: center;">&#xa0;</td>
																</xsl:if>
																<xsl:if test="$groupId = '3'">
																	<td class="heading2" width="15%" style="text-align: center;">Nº Conex.</td>
																	<td class="heading2" width="15%" style="text-align: center;">Vol.(Kb)</td>
																</xsl:if>
															<td class="heading2" align="right" width="30%"><xsl:value-of select='format-number(TOT/@totalAmt, "#.##0,0000", "european")' /></td>
														</tr>
														<xsl:for-each select="TYPE">
															<xsl:if test="@draw = '1'">
																<tr>
																	<td width="40%"><xsl:value-of select="@descTipo"/></td>
																	<td width="15%" style="text-align: center;"><xsl:value-of select="TOT/@count"/></td>
																	<xsl:if test="$groupId = '1'">
																		<td width="15%" style="text-align: center;"><xsl:value-of select="TOT/@liDura"/></td>
																	</xsl:if>
																	<xsl:if test="$groupId = '2'">
																		<td width="15%" style="text-align: center;">&#xa0;</td>
																	</xsl:if>
																	<xsl:if test="$groupId = '3'">
																		<td width="15%" style="text-align: center;"><xsl:value-of select='format-number(TOT/@totalUnits, "#.##0", "european")' /></td>
																	</xsl:if>
																	<td align="right" width="30%"><xsl:value-of select='format-number(TOT/@totalAmt, "#.##0,0000", "european")' /></td>
																</tr>
															</xsl:if>	
														</xsl:for-each>
														<xsl:for-each select="DISCS/DISC">
															<xsl:if test="@draw = '1'">
																<tr>
																	<td width="70%" colspan="3"><xsl:value-of select="@desc"/>&#xa0;(
																		<xsl:call-template name="FormatDateText">
																			<xsl:with-param name="DateTime" select="@startDt"/>
																		</xsl:call-template>
																		&#xa0;a&#xa0;
																		<xsl:call-template name="FormatDateText">
																			<xsl:with-param name="DateTime" select="@endDt"/>
																		</xsl:call-template>)
																	</td>
																	<td align="right" width="30%"><xsl:value-of select='format-number(@disc, "#.##0,0000", "european")' /></td>
																</tr>
															</xsl:if>	
														</xsl:for-each>
													</table>
												</td>
											</tr>
										</xsl:if>	
									</xsl:for-each>
								</table>
							</td>
						</table>
					</td>
				</tr>
			</table>
			<table>
				<tr>
					<td height="20px" bgcolor="#FFFFFF"/>
				</tr>
			</table>
			<table class="tableCollapsed" width="100%">
				<tr>
					<td class="heading3">Detalle Consumo línea <xsl:value-of select="INFO/SERV/@externalID"/></td>
				</tr>
				<tr>
					<td><xsl:apply-templates select="USAGE"/></td>
				</tr>
			</table>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="CHARGES">
		<table class="tableCollapsed" width="100%">
			<tr bgcolor="#BEBEBE" >
				<td  class="blackBottomBorderHeading3">
					Cuotas
				</td>
				<td  class="blackBottomBorderHeading3" align="right">
					Total: &#xa0;<xsl:value-of select='format-number(TOT/@totalAmt, "#.##0,0000", "european")' />&#xa0;&#8364;
				</td>
			</tr>

			<xsl:for-each select="GRUPO">
				<xsl:if test="@draw = '1'">
					<tr>
						<td colspan="2" height="20px" bgcolor="#FFFFFF"/>
					</tr>
					<tr>
						<td colspan="2">
							<table class="tableGreyBorderCollapsed" width="100%">
								<tr bgcolor="#BEBEBE">
									<td class="heading2" ><xsl:value-of select="@groupDesc"/></td>
									<td class="heading2" align="right"><xsl:value-of select='format-number(Tot/@totalAmt, "#.##0,0000", "european")' /></td>
								</tr>
								<xsl:for-each select="RCS/RC">
									<xsl:if test="@draw = '1'">
										<tr>
											<td>
												<xsl:value-of select="@desc"/>&#xa0;(
												<xsl:call-template name="FormatDateText">
													<xsl:with-param name="DateTime" select="@fromDt"/>
												</xsl:call-template>
												&#xa0;a&#xa0;
												<xsl:call-template name="FormatDateText">
													<xsl:with-param name="DateTime" select="@toDt"/>
												</xsl:call-template>)
											</td>
											<td align="right"><xsl:value-of select='format-number(@amt, "#.##0,0000", "european")' /></td>
										</tr>
									</xsl:if>
								</xsl:for-each>
								<xsl:for-each select="NRCS/NRC">
									<xsl:if test="@draw = '1'">
										<tr>
											<td>
												<xsl:value-of select="@desc"/>&#xa0;(
												<xsl:call-template name="FormatDateText">
													<xsl:with-param name="DateTime" select="@transDt"/>
												</xsl:call-template>)
											</td>
											<td align="right"><xsl:value-of select='format-number(@amt, "#.##0,0000", "european")' /></td>
										</tr>
									</xsl:if>
								</xsl:for-each>
								<xsl:for-each select="DISCS/DISC">
									<xsl:if test="@draw = '1'">
										<tr>
											<td>
												<xsl:value-of select="@desc"/>&#xa0;(
												<xsl:call-template name="FormatDateText">
													<xsl:with-param name="DateTime" select="@startDt"/>
												</xsl:call-template>
												&#xa0;a&#xa0;
												<xsl:call-template name="FormatDateText">
													<xsl:with-param name="DateTime" select="@endDt"/>
												</xsl:call-template>)
											</td>
											<td align="right"><xsl:value-of select='format-number(@disc, "#.##0,0000", "european")' /></td>
										</tr>
									</xsl:if>
								</xsl:for-each>
								<xsl:for-each select="ADJS/ADJ">
									<xsl:if test="@draw = '1'">
										<tr>
											<td>
												<xsl:value-of select="@desc"/>&#xa0;(
												<xsl:call-template name="FormatDateText">
													<xsl:with-param name="DateTime" select="@transDt"/>
												</xsl:call-template>)
											</td>
											<td align="right"><xsl:value-of select='format-number(@amt, "#.##0,0000", "european")' /></td>
										</tr>
									</xsl:if>
								</xsl:for-each>
							</table>
						</td>
					</tr>
				</xsl:if>	
			</xsl:for-each>
		</table>
	</xsl:template>
	
	<xsl:template match="USAGE">
		<table>
			<tr>
				<td height="20px" bgcolor="#FFFFFF"/>
			</tr>
		</table>
		<table class="tableGreyBorderCollapsed" width="50%">
			<xsl:for-each select="GROUP">
				<xsl:if test="@draw = '1'">
					<xsl:variable name="groupId">
					  <xsl:value-of select="@groupID" />
					</xsl:variable>
					<tr bgcolor="#BEBEBE" >
						<td class="heading2" colspan="7">
							<xsl:value-of select="@groupDesc"/>
						</td>
					</tr>
					<tr>
						<td class="heading1" width="20%">
							Teléfono
						</td>
						<td class="heading1" width="30%">
							Descripción
						</td>
						<td class="heading1" width="10%" align="center">
							Fecha
						</td>
						<td class="heading1" width="10%" align="center">
							Hora
						</td>
						<xsl:if test="$groupId='1'"  >
							<td class="heading1" width="10%" align="center">
								Duración
							</td>
						</xsl:if>
						<xsl:if test="$groupId='2'"  >
							<td class="heading1" width="10%" align="center">
								Vol.(Kb)
							</td>
						</xsl:if>
						<xsl:if test="$groupId='3'"  >
							<td class="heading1" width="10%" align="center">
								Vol.(Kb)
							</td>
						</xsl:if>
						
						<td class="heading1" width="5%" align="center">
							T.
						</td>
						<td class="heading1" width="15%" align="right">
							Importe
						</td>
					</tr>
					<xsl:for-each select="TYPE">
						<xsl:if test="@draw = '1'">
							<xsl:for-each select="CDR">
								<xsl:if test="@draw != '-1'">
									<tr bgcolor="#EAEAEA">
										<td width="20%">
											<xsl:if test="position() = 1 or @target != preceding-sibling::CDR[1]/@target"  >
												<xsl:value-of select="@target"/>
											</xsl:if>
										</td>
										<td width="30%">
											<xsl:if test="position() = 1 or @target != preceding-sibling::CDR[1]/@target">
												<xsl:value-of select="@liDest1"/>
											</xsl:if>
										</td>
										<td width="10%" align="center">
											<xsl:value-of select="substring(@liDate,1,string-length (@liDate)-1)"/>
										</td>
										<td width="10%" align="center">
											<xsl:value-of select="@liTime"/>
										</td>
										<xsl:if test="$groupId='1'"  >
											<td width="10%" align="center">
												<xsl:value-of select="@liDura"/>
											</td>
										</xsl:if>
										<xsl:if test="$groupId='2'">
											<td width="10%" align="center">
												<xsl:value-of select="@units"/>
											</td>
										</xsl:if>
										<xsl:if test="$groupId='3'"  >
											<td width="10%" align="center">
												<xsl:value-of select="@units"/>
											</td>
										</xsl:if>
										<td width="5%" align="center">
											<xsl:value-of select="@liRate"/>
										</td>
										<td width="15%" align="right">
											<xsl:value-of select='format-number(@amt, "#.##0,0000", "european")' />
										</td>
									</tr>
								</xsl:if>
							</xsl:for-each>
						</xsl:if>	
					</xsl:for-each>
				</xsl:if>	
			</xsl:for-each>
		</table>
	</xsl:template>	
	<!-- FUNCTIONS -->
 
	<xsl:template name="RepeatStr">
	  <xsl:param name="output" />
	  <xsl:param name="count" />

	  <xsl:if test="$count &gt; 1">
		<xsl:value-of select="$output" />
		<xsl:call-template name="RepeatStr">
		  <xsl:with-param name="output" select="$output" />
		  <xsl:with-param name="count" select="$count - 1" />
		</xsl:call-template>
	  </xsl:if>
	</xsl:template>
  <xsl:template name="FormatDate">
    <xsl:param name="DateTime" />
	<!-- old date format 2006-01-14 -->
    <!-- new date format 14/01/2006 -->
    
	<xsl:variable name="year">
      <xsl:value-of select="substring($DateTime,1,4)" />
    </xsl:variable>
	<xsl:variable name="mm">
      <xsl:value-of select="substring($DateTime,6,2)" />
    </xsl:variable>
	<xsl:variable name="dd">
      <xsl:value-of select="substring($DateTime,9,2)" />
    </xsl:variable>
    
    <xsl:value-of select="$dd"/>
    <xsl:value-of select="'/'"/>
    <xsl:value-of select="$mm"/>
	<xsl:value-of select="'/'"/>
    <xsl:value-of select="$year"/>
  </xsl:template>
  
  <xsl:template name="FormatDateText">
    <xsl:param name="DateTime" />
	<!-- old date format 2006-01-14 -->
    <!-- new date format 14/01/2006 -->
	
	<xsl:variable name="mm">
      <xsl:value-of select="substring($DateTime,6,2)" />
    </xsl:variable>
	<xsl:variable name="dd">
      <xsl:value-of select="substring($DateTime,9,2)" />
    </xsl:variable>
	
	<xsl:value-of select='format-number($dd, "0", "european")' />
	<xsl:value-of select="'&#xa0;'"/>
    <xsl:choose>
      <xsl:when test="$mm= '01'">Ene.</xsl:when>
      <xsl:when test="$mm = '02'">Feb.</xsl:when>
      <xsl:when test="$mm = '03'">Mar.</xsl:when>
      <xsl:when test="$mm = '04'">Abr.</xsl:when>
      <xsl:when test="$mm = '05'">May.</xsl:when>
      <xsl:when test="$mm = '06'">Jun.</xsl:when>
      <xsl:when test="$mm = '07'">Jul.</xsl:when>
      <xsl:when test="$mm = '08'">Ago.</xsl:when>
      <xsl:when test="$mm = '09'">Sep.</xsl:when>
      <xsl:when test="$mm = '10'">Oct.</xsl:when>
      <xsl:when test="$mm = '11'">Nov.</xsl:when>
      <xsl:when test="$mm = '12'">Dic.</xsl:when>
    </xsl:choose>
  </xsl:template>
	
  <!--OLD INVOICE -->
  
  <!-- DATOS FACTURA-->
	<xsl:template match="datosFactura">
		<table width="70%">
			<tr>
				<td>
					<h1>Factura</h1>
				</td>
				<td align="right">
					<img width="180" height="33" src="{$zipDir}/Vodafone_300pp.gif"/>
				</td>
			</tr>
		</table>
		<table width="70%" bgcolor="#FFFFFF" cellspacing="0" cellpadding="0" border="0">
			<tr>
				<td height="2px" bgcolor="#FF0000"/>
				<td width="2px"/>
				<td height="2px" bgcolor="#FF0000"/>
			</tr>
			<tr>
				<td class="heading1" bgcolor="#EAEAEA">Número de Factura</td>
				<td width="2px"/>
				<td bgcolor="#EAEAEA">
					<xsl:value-of select="@numFactura"/>
				</td>
			</tr>
			<tr>
				<td class="heading1" bgcolor="#EAEAEA">Número de Cuenta</td>
				<td width="2px"/>
				<td bgcolor="#EAEAEA">9<xsl:value-of select="@numCuenta"/>
				</td>
			</tr>
			<tr>
				<td class="heading1" bgcolor="#EAEAEA">Fecha de Emisión</td>
				<td width="2px"/>
				<td bgcolor="#EAEAEA">
					<xsl:value-of select="@fechaEmision"/>
				</td>
			</tr>
			<tr>
				<td class="heading1" bgcolor="#EAEAEA">Lugar de Emisión</td>
				<td width="2px"/>
				<td bgcolor="#EAEAEA">
					<xsl:value-of select="@lugarEmision"/>
				</td>
			</tr>
			<tr>
				<td class="heading1" bgcolor="#EAEAEA">Fecha de Inicio de Facturación</td>
				<td width="2px"/>
				<td bgcolor="#EAEAEA">
					<xsl:value-of select="@fechaInicioFacturacion"/>
				</td>
			</tr>
			<tr>
				<td class="heading1" bgcolor="#EAEAEA">Fecha de Fin de Facturación</td>
				<td width="2px"/>
				<td bgcolor="#EAEAEA">
					<xsl:value-of select="@fechaFinFacturacion"/>
				</td>
			</tr>
			<tr>
				<td class="heading1" bgcolor="#EAEAEA">Total Factura</td>
				<td width="2px"/>
				<td bgcolor="#EAEAEA">
					<xsl:choose>
						<xsl:when test="//elementosCabecera/resumenFacturaEmpresas">
							<xsl:value-of select="//avisoPago/@totalPagar"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="//estadoCuenta/@totalFactura"/>						
						</xsl:otherwise>
					</xsl:choose>					
				</td>
			</tr>
			<tr>
				<td height="1px" bgcolor="#FF0000"/>
				<td width="2px"/>
				<td height="1px" bgcolor="#FF0000"/>
			</tr>
		</table>
	</xsl:template>
	
	<!-- ELEMENTOS CABECERA -->
	<xsl:template match="elementosCabecera">
		<br/>
		<br/>
		<table width="70%" bgcolor="#FFFFFF" cellspacing="0" cellpadding="0" border="0">
			<xsl:choose>
				<xsl:when test="//elementosCabecera/resumenFacturaEmpresas">
					<tr>
						<td>
							<xsl:apply-templates select="clienteEmpresa"/>
						</td>
					</tr>
					<tr>
						<td>
							<xsl:apply-templates select="avisoPago"/>
						</td>
					</tr>
					<tr>
						<td>					
							<xsl:apply-templates select="resumenFacturaEmpresas"/>
						</td>
					</tr>
					<tr>
						<td>
							<xsl:apply-templates select="loyalties"/>
						</td>
					</tr>
					<tr>
						<td>
							<xsl:apply-templates select="histograma"/>
						</td>
					</tr>
				</xsl:when>
				<xsl:otherwise>
					<tr>
						<td>
							<xsl:apply-templates select="clienteParticular"/>
							<xsl:apply-templates select="clienteEmpresa"/>
						</td>
					</tr>
					<tr>
						<td>
							<xsl:apply-templates select="avisoPago"/>
						</td>
					</tr>
					<tr>
						<td>					
							<xsl:apply-templates select="resumenFacturaParticulares"/>
						</td>
					</tr>
					<tr>
						<td>					
							<xsl:apply-templates select="../detallesImpuestos"/>
						</td>
					</tr>
					<tr>
						<td>
							<xsl:apply-templates select="estadoCuenta"/>
						</td>
					</tr>
					<tr>
						<td>					
							<xsl:apply-templates select="../detallesPagosAbonos"/>
						</td>
					</tr>
					<tr>
						<td>
							<xsl:apply-templates select="loyalties"/>
						</td>
					</tr>
					<tr>
						<td>
							<xsl:apply-templates select="histograma"/>
						</td>
					</tr>
					<tr>
						<td>
							<xsl:apply-templates select="InfPlanPrecios"/>
						</td>
					</tr>
					<tr>
						<td>
							<xsl:apply-templates select="resumenFactura"/>
						</td>
					</tr>
				</xsl:otherwise>
			</xsl:choose>					
		</table>
	</xsl:template>
	
	<xsl:template match="clienteParticular">
		<table width="100%" bgcolor="#FFFFFF" cellspacing="0" cellpadding="0" border="0">
			<tr>
				<td colspan="3" class="heading3">Datos del Cliente</td>
			</tr>
			<tr>
				<td height="2px" bgcolor="#FF0000"/>
				<td width="2px"/>
				<td height="2px" bgcolor="#FF0000"/>
			</tr>
			<tr>
				<td class="heading1" bgcolor="#EAEAEA">Nif</td>
				<td width="2px"/>
				<td bgcolor="#EAEAEA">
					<xsl:value-of select="@nifcif"/>
				</td>
			</tr>
			<tr>
				<td class="heading1" bgcolor="#EAEAEA">Nombre</td>
				<td width="2px"/>
				<td bgcolor="#EAEAEA">
					<xsl:value-of select="@nombreTitular"/>
				</td>
			</tr>
			<tr>
				<td height="1px" bgcolor="#FF0000"/>
				<td width="2px"/>
				<td height="1px" bgcolor="#FF0000"/>
			</tr>
			<xsl:apply-templates select="direccionEnvio"/>
		</table>
	</xsl:template>
	<xsl:template match="clienteEmpresa">
		<table width="100%" bgcolor="#FFFFFF" cellspacing="0" cellpadding="0" border="0">
			<tr>
				<td colspan="3" class="heading3">Datos del Cliente</td>
			</tr>
			<tr>
				<td height="2px" bgcolor="#FF0000"/>
				<td width="2px"/>
				<td height="2px" bgcolor="#FF0000"/>
			</tr>
			<tr>
				<td class="heading1" bgcolor="#EAEAEA">Cif</td>
				<td width="2px"/>
				<td bgcolor="#EAEAEA">
					<xsl:value-of select="@nifcif"/>
				</td>
			</tr>
			<tr>
				<td class="heading1" bgcolor="#EAEAEA">Nombre Empresa</td>
				<td width="2px"/>
				<td bgcolor="#EAEAEA">
					<xsl:value-of select="@nombreEmpresa"/>
				</td>
			</tr>
			<tr>
				<td class="heading1" bgcolor="#EAEAEA">Cargo Empresa</td>
				<td width="2px"/>
				<td bgcolor="#EAEAEA">
					<xsl:value-of select="@cargoEmpresa"/>
				</td>
			</tr>
			<tr>
				<td height="1px" bgcolor="#FF0000"/>
				<td width="2px"/>
				<td height="1px" bgcolor="#FF0000"/>
			</tr>
			<xsl:apply-templates select="direccionEnvio"/>
		</table>
	</xsl:template>
	<xsl:template match="direccionEnvio">
		<xsl:variable name="destinatario" select="normalize-space(@destinatario)"/>
		<xsl:variable name="lineaDestinatario1" select="normalize-space(substring-before($destinatario,	$stringSeparacionCampos))"/>
		<xsl:variable name="lineaDestinatario2" select="normalize-space(substring-after($destinatario,	$stringSeparacionCampos))"/>
		<xsl:variable name="lineaDireccion" select="normalize-space(@lineaDireccion)"/>
		<xsl:variable name="lineaDireccion1" select="normalize-space(substring-before($lineaDireccion,	$stringSeparacionCampos))"/>
		<xsl:variable name="lineaDireccion2" select="normalize-space(substring-before(substring-after	($lineaDireccion,$stringSeparacionCampos),$stringSeparacionCampos))"/>
		<xsl:variable name="lineaDireccion3" select="normalize-space(substring-after(substring-after	($lineaDireccion,$stringSeparacionCampos),$stringSeparacionCampos))"/>
		<tr>
			<td colspan="3" class="heading3">Dirección de Envío</td>
		</tr>
		<tr>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
		</tr>
		<tr>
			<td class="heading1" bgcolor="#EAEAEA">Destinatario</td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA">
				<xsl:if test="$lineaDestinatario1 != ''">
					<xsl:value-of select="$lineaDestinatario1"/>
				</xsl:if>
				<xsl:if test="$lineaDestinatario2 != ''">
					<xsl:value-of select="$lineaDestinatario2"/>
				</xsl:if>
			</td>
		</tr>
		<tr>
			<td class="heading1" bgcolor="#EAEAEA">Dirección</td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA">
				<xsl:if test="$lineaDireccion1 != ''">
					<xsl:value-of select="$lineaDireccion1"/>
				</xsl:if>
				<xsl:if test="$lineaDireccion2 != ''">
					<xsl:value-of select="$lineaDireccion2"/>
				</xsl:if>
				<xsl:if test="$lineaDireccion3 != ''">
					<xsl:value-of select="$lineaDireccion3"/>
				</xsl:if>
			</td>
		</tr>
		<tr>
			<td class="heading1" bgcolor="#EAEAEA">Ciudad</td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@ciudad"/>
			</td>
		</tr>
		<tr>
			<td class="heading1" bgcolor="#EAEAEA">Provincia</td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@provincia"/>
			</td>
		</tr>
		<tr>
			<td class="heading1" bgcolor="#EAEAEA">Código Postal</td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@codPostal"/>
			</td>
		</tr>
		<tr>
			<td class="heading1" bgcolor="#EAEAEA">País</td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@paisDesc"/>
			</td>
		</tr>
		<tr>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
		</tr>
	</xsl:template>
	<xsl:template match="avisoPago">
		<table width="100%" bgcolor="#FFFFFF" cellspacing="0" cellpadding="0" border="0">
			<tr>
				<td colspan="3" class="heading3">Aviso de Pago</td>
			</tr>
			<tr>
				<td height="2px" bgcolor="#FF0000"/>
				<td width="2px"/>
				<td height="2px" bgcolor="#FF0000"/>
			</tr>
			<tr>
				<td class="heading1" bgcolor="#EAEAEA">Forma de Pago</td>
				<td width="2">
					<img height="1px" width="1" src=""/>
				</td>
				<td bgcolor="#EAEAEA">
					<xsl:value-of select="@formaPagoDesc"/>
				</td>
			</tr>
			<tr>
				<td class="heading1" bgcolor="#EAEAEA">Entidad Bancaria</td>
				<td width="2">
					<img height="1px" width="1" src=""/>
				</td>
				<td bgcolor="#EAEAEA">
					<xsl:value-of select="@entidadBancaria"/>
				</td>
			</tr>
			<tr>
				<td class="heading1" bgcolor="#EAEAEA">Referencia</td>
				<td width="2">
					<img height="1px" width="1" src=""/>
				</td>
				<td bgcolor="#EAEAEA">
					<xsl:value-of select="@referencia"/>
				</td>
			</tr>
	<xsl:choose>
		<xsl:when test="//elementosCabecera/resumenFacturaEmpresas">
			<tr>
				<td class="heading1" bgcolor="#EAEAEA">Fecha de Vencimiento</td>
				<td width="2">
					<img height="1px" width="1" src=""/>
				</td>
				<td bgcolor="#EAEAEA">
					<xsl:value-of select="@fechaVencimiento"/>
				</td>
			</tr>
			<tr>
				<td bgcolor="#EAEAEA" colspan="3" height="10"> </td>
			</tr>
			<tr>
				<td class="heading1" bgcolor="#EAEAEA">Total (Base Imponible)</td>
				<td width="2">
					<img height="1px" width="1" src=""/>
				</td>
				<td bgcolor="#EAEAEA">
					<xsl:value-of select="@baseImponible"/>
				</td>
			</tr>
			<xsl:for-each select="//totalesImpuestos">
				<tr>
					<td class="heading1" bgcolor="#EAEAEA"><xsl:value-of select="@tipoImpuestos"/>(<xsl:value-of select="@porcentajeImpuestos"/>%)</td>
					<td width="2">
						<img height="1px" width="1" src=""/>
					</td>
					<td bgcolor="#EAEAEA">
						<xsl:value-of select="@impuestos"/>
					</td>
				</tr>
			</xsl:for-each>
			<tr>
				<td class="heading1" bgcolor="#EAEAEA">Total a Pagar</td>
				<td width="2">
					<img height="1px" width="1" src=""/>
				</td>
				<td bgcolor="#EAEAEA">
					<xsl:value-of select="@totalPagar"/>
				</td>
			</tr>				
		</xsl:when>
		<xsl:otherwise>
			<tr>
				<td class="heading1" bgcolor="#EAEAEA">Total a Pagar</td>
				<td width="2">
					<img height="1px" width="1" src=""/>
				</td>
				<td bgcolor="#EAEAEA">
					<xsl:value-of select="@totalPagar"/>
				</td>
			</tr>
			<tr>
				<td class="heading1" bgcolor="#EAEAEA">Fecha de Vencimiento</td>
				<td width="2">
					<img height="1px" width="1" src=""/>
				</td>
				<td bgcolor="#EAEAEA">
					<xsl:value-of select="@fechaVencimiento"/>
				</td>
			</tr>
		</xsl:otherwise>
	</xsl:choose>				
			<tr>
				<td height="1px" bgcolor="#FF0000"/>
				<td width="2px"/>
				<td height="1px" bgcolor="#FF0000"/>
			</tr>
		</table>
	</xsl:template>
	
	<xsl:template match="resumenFacturaEmpresas">
		  <tr>
				<td>
					<br/>
					<table width="100%" bgcolor="#FFFFFF" cellspacing="0" cellpadding="0" border="0">
						<tbody>
							<tr>
								<td class="heading3" width="320px">
									<xsl:text>Resumen de conceptos facturados</xsl:text>
								</td>
								<td width="2">
									<img src="" width="1" height="1px"/>
								</td>                                        
								<td class="heading1" width="64px">
									<xsl:text>Importe</xsl:text>
								</td>
							</tr>                                    
							<tr>
								<td height="2px" bgcolor="#FF0000"/>
								<td width="2px"/>
								<td height="2px" bgcolor="#FF0000"/>
							</tr>									                                    
						<xsl:apply-templates select="llamadasVideolla"/>
							<xsl:apply-templates select="Consumo"/>
							<xsl:apply-templates select="Llamadas"/>
							<xsl:apply-templates select="Mensajes"/>
							<xsl:apply-templates select="Datos"/>                                    
							<xsl:apply-templates select="ServiciosAvanzados"/>
							<xsl:apply-templates select="CuotasTarifasPlanasYCargos"/>
							<xsl:apply-templates select="Descuentos"/>
							<xsl:apply-templates select="AjusteConsumoMinimo"/>
							<xsl:apply-templates select="TotalBaseImponible"/>
							<xsl:apply-templates select="ImporteFacturaAnterior"/>
							<xsl:apply-templates select="Abonos"/>
							<!-- totalesImpuestos?, comprasVodafone?, progHogarDigital?, dtoVisaVodafone?)-->

							<!--Pinta la linea Roja del pie de la tabla -->
							<tr>
								<td height="1px" bgcolor="#FF0000"/>
								<td width="1px"/>
								<td height="1px" bgcolor="#FF0000"/>
								<td width="1px"/>
								<td height="1px" bgcolor="#FF0000"/>
							</tr>                  
						</tbody>
					</table>
				</td>
			</tr>				
    </xsl:template>	
	
	  <xsl:template match="Consumo">
			<tr>
				<td height="20" bgcolor="#EAEAEA" class="heading1">A - Consumo</td>
				<td width="2">
					<img src="" width="1" height="1px"/>
				</td>
				<td bgcolor="#EAEAEA" align="right">
					<xsl:value-of select="@importe"/>
				</td>
			</tr>
	  </xsl:template>
	  <xsl:template match="Llamadas">
			<tr>
				<td height="20" bgcolor="#EAEAEA" class="txtBlack">A.1 - Llamadas</td>
				<td width="2">
					<img src="" width="1" height="1px"/>
				</td>
				<td bgcolor="#EAEAEA" align="right">
					<xsl:value-of select="@importe"/>
				</td>
			</tr>
	  </xsl:template>
	  <xsl:template match="Mensajes">
			<tr>
				<td height="20" bgcolor="#EAEAEA" class="txtBlack">A.2 - Mensajes</td>
				<td width="2">
					<img src="" width="1" height="1px"/>
				</td>
				<td bgcolor="#EAEAEA" align="right">
					<xsl:value-of select="@importe"/>
				</td>
			</tr>
	  </xsl:template>
	  <xsl:template match="Datos">
			<tr>
				<td height="20" bgcolor="#EAEAEA" class="txtBlack">A.3 - Datos</td>
				<td width="2">
					<img src="" width="1" height="1px"/>
				</td>
				<td bgcolor="#EAEAEA" align="right">
					<xsl:value-of select="@importe"/>
				</td>
			</tr>
	  </xsl:template>
	  <xsl:template match="ServiciosAvanzados">
			<tr>
				<td height="20" bgcolor="#EAEAEA" class="txtBlack">A.4 - Servicios Avanzados</td>
				<td width="2">
					<img src="" width="1" height="1px"/>
				</td>
				<td bgcolor="#EAEAEA" align="right">
					<xsl:value-of select="@importe"/>
				</td>
			</tr>
	  </xsl:template>
	  <xsl:template match="CuotasTarifasPlanasYCargos">
			<tr>
				<td height="20" bgcolor="#EAEAEA" class="heading1">B - Cuotas, Tarifas Planas y Cargos</td>
				<td width="2">
					<img src="" width="1" height="1px"/>
				</td>
				<td bgcolor="#EAEAEA" align="right">
					<xsl:value-of select="@importe"/>
				</td>
			</tr>
	  </xsl:template>
	  <xsl:template match="Descuentos">
			<tr>
				<td height="20" bgcolor="#EAEAEA" class="heading1">C - Descuentos</td>
				<td width="2">
					<img src="" width="1" height="1px"/>
				</td>
				<td bgcolor="#EAEAEA" align="right">
					(-)<xsl:value-of select="@importe"/>
				</td>
			</tr>
	  </xsl:template>
	  <xsl:template match="AjusteConsumoMinimo">
			<tr>
				<td height="20" bgcolor="#EAEAEA" class="heading1">D- Ajuste hasta consumo mínimo</td>
				<td width="2">
					<img src="" width="1" height="1px"/>
				</td>
				<td bgcolor="#EAEAEA" align="right">
					<xsl:value-of select="@importe"/>
				</td>
			</tr>
	  </xsl:template>
	  <xsl:template match="TotalBaseImponible">
			<tr>
				<td height="20" bgcolor="#EAEAEA" class="heading1">Total (Base imponible)</td>
				<td width="2">
					<img src="" width="1" height="1px"/>
				</td>
				<td bgcolor="#EAEAEA" align="right">
					<xsl:value-of select="@importe"/>
				</td>
			</tr>
	  </xsl:template>
	  <xsl:template match="ImporteFacturaAnterior">
			<tr>
				<td height="20" bgcolor="#EAEAEA" class="heading1">Saldo pendiente de pago</td>
				<td width="2">
					<img src="" width="1" height="1px"/>
				</td>
				<td bgcolor="#EAEAEA" align="right">
					<xsl:value-of select="@importe"/>
				</td>
			</tr>
	  </xsl:template>
	  <xsl:template match="Abonos">
		<xsl:variable name="importeAbonos">
			<xsl:value-of select="@importe" />
		</xsl:variable>			
		<xsl:if test="number($importeAbonos) != 'NaN' and number($importeAbonos) != 0">
			<tr>
				<td height="20" bgcolor="#EAEAEA" class="heading1">Abonos</td>
				<td width="2">
					<img src="" width="1" height="1px"/>
				</td>
				<td bgcolor="#EAEAEA" align="right">
					<xsl:value-of select="@importe"/>
				</td>
			</tr>
		</xsl:if>	
      </xsl:template>	
	  
	<xsl:template match="resumenFacturaParticulares">
		<tr>
			<td>
				<br/>
				<table width="100%" bgcolor="#FFFFFF" cellspacing="0" cellpadding="0" border="0">
					<tbody>
						<tr>
							<td class="heading3" width="256px">
								<xsl:text>Resumen de la Factura</xsl:text>
							</td>
							<td width="2">
								<img src="" width="1" height="1px"/>
							</td>                                        
							<td class="heading1" width="64px">
								<xsl:text>Total</xsl:text>
							</td>
							<td width="2">
								<img src="" width="1" height="1px"/>
							</td>                                        
							<td class="heading1" width="64px">
								<xsl:text>Importe</xsl:text>
							</td>
						</tr>	
						<tr>
							<td height="2px" bgcolor="#FF0000"/>
							<td width="2px"/>
							<td height="2px" bgcolor="#FF0000"/>
							<td width="2px"/>
							<td height="2px" bgcolor="#FF0000"/>
						</tr>                                    
						<xsl:apply-templates select="llamadasVideolla"/>
						<xsl:apply-templates select="mensajes"/>
						<xsl:apply-templates select="conexionesLive"/>
						<xsl:apply-templates select="datosOtrosServicios"/>
						<xsl:apply-templates select="descuentos"/>                                    
						<!--Pinta la linea Roja del pie de la tabla -->
						<tr>
							<td height="1px" bgcolor="#FF0000"/>
							<td width="1px"/>
							<td height="1px" bgcolor="#FF0000"/>
							<td width="1px"/>
							<td height="1px" bgcolor="#FF0000"/>
						</tr>                  
						<xsl:variable name="baseImponible">
							<xsl:value-of select="//elementosCabecera/resumenFactura/totalesImpuestos/@baseImponible"/>
						</xsl:variable>                                    
						<xsl:if test="$baseImponible != ''">
							<tr>
								<td height="20" bgcolor="#EAEAEA" class="heading1">Total</td>
								<td width="2">
									<img src="" width="1" height="1px"/>
								</td>
								<td bgcolor="#EAEAEA">
									<img src="" width="1" height="1px"/>
								</td>
								<td width="2">
									<img src="" width="1" height="1px"/>
								</td>
								<td bgcolor="#EAEAEA" align="right">
									<xsl:value-of select="$baseImponible"/>
								</td>
							</tr>
						</xsl:if>
						<xsl:apply-templates select="totalImpuestos"/>
						<xsl:apply-templates select="pagosAbonos"/>
						<tr>
							<td height="1px" bgcolor="#FF0000"/>
							<td width="1px"/>
							<td height="1px" bgcolor="#FF0000"/>
							<td width="1px"/>
							<td height="1px" bgcolor="#FF0000"/>
						</tr>
						  <xsl:variable name="total_factura">
								<xsl:value-of select="//elementosCabecera/estadoCuenta/@totalFactura"/>
						  </xsl:variable>                                       
						<xsl:if test="$total_factura != ''">
							<tr>
								<td height="20" bgcolor="#EAEAEA" class="heading1">Total Factura</td>
								<td width="2">
									<img src="" width="1" height="1px"/>
								</td>
								<td bgcolor="#EAEAEA">
									<img src="" width="1" height="1px"/>
								</td>
								<td width="2">
									<img src="" width="1" height="1px"/>
								</td>
								<td bgcolor="#EAEAEA" align="right">
									<xsl:value-of select="$total_factura"/>
								</td>
							</tr>
						</xsl:if>
						<xsl:variable name="saldoAnterior">
							<xsl:value-of select="//elementosCabecera/estadoCuenta/@saldoAnterior"/>
						</xsl:variable>                                    
						<xsl:if test="$saldoAnterior != ''">
							<tr>
								<td height="20" bgcolor="#EAEAEA" class="heading1">
									<br/>
									Saldo periodo anterior
								</td>
								<td width="2">
									<br/>
									<img src="" width="1" height="1px"/>
								</td>
								<td bgcolor="#EAEAEA">
									<br/>
									<img src="" width="1" height="1px"/>
								</td>
								<td width="2">
									<br/>
									<img src="" width="1" height="1px"/>
								</td>
								<td bgcolor="#EAEAEA" align="right">
									<br/>
									<xsl:value-of select="$saldoAnterior"/>												
								</td>
							</tr>
							<tr>
								<td height="1px" bgcolor="#FF0000"/>
								<td width="1px"/>
								<td height="1px" bgcolor="#FF0000"/>
								<td width="1px"/>
								<td height="1px" bgcolor="#FF0000"/>
						    </tr>
						</xsl:if>  
                                    
						<xsl:variable name="saldoFinal">
							<xsl:value-of select="//elementosCabecera/estadoCuenta/@saldoFinal"/>
						</xsl:variable>                                    
						<xsl:if test="$saldoFinal != ''">
							<tr>
								<td height="20" bgcolor="#EAEAEA" class="heading1">												
									Total a Pagar
								</td>
								<td width="2">												
									<img src="" width="1" height="1px"/>
								</td>
								<td bgcolor="#EAEAEA">												
									<img src="" width="1" height="1px"/>
								</td>
								<td width="2">												
									<img src="" width="1" height="1px"/>
								</td>
								<td bgcolor="#EAEAEA" align="right">												
									<xsl:value-of select="$saldoFinal"/>												
								</td>
							</tr>
						</xsl:if>  
						<tr>
							<td height="1px" bgcolor="#FF0000"/>
							<td width="1px"/>
							<td height="1px" bgcolor="#FF0000"/>
							<td width="1px"/>
							<td height="1px" bgcolor="#FF0000"/>
						</tr>
										
                                                      
					</tbody>
				</table>
			</td>
		</tr>				
		<xsl:apply-templates select="abonoProxFactura"/>				
  </xsl:template>	
          
  <xsl:template match="llamadasVideolla">
		<tr>
			<td height="20" bgcolor="#EAEAEA" class="heading1">Llamadas y Videollamadas</td>
			<td width="2">
				<img src="" width="1" height="1px"/>
			</td>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@total"/>
			</td>
			<td width="2">
				<img src="" width="1" height="1px"/>
			</td>
			<td bgcolor="#EAEAEA" align="right">
				<xsl:value-of select="@importe"/>
			</td>
		</tr>
  </xsl:template>
  <xsl:template match="mensajes">
		<tr>
			<td height="20" bgcolor="#EAEAEA" class="heading1">Mensajes</td>
			<td width="2">
				<img src="" width="1" height="1px"/>
			</td>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@total"/>
			</td>
			<td width="2">
				<img src="" width="1" height="1px"/>
			</td>
			<td bgcolor="#EAEAEA" align="right">
				<xsl:value-of select="@importe"/>
			</td>
		</tr>
  </xsl:template>
  <xsl:template match="conexionesLive">
		<tr>
			<td height="20" bgcolor="#EAEAEA" class="heading1">Conexiones live! y Datos</td>
			<td width="2">
				<img src="" width="1" height="1px"/>
			</td>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@total"/>
			</td>
			<td width="2">
				<img src="" width="1" height="1px"/>
			</td>
			<td bgcolor="#EAEAEA" align="right">
				<xsl:value-of select="@importe"/>
			</td>
		</tr>
  </xsl:template>
  <xsl:template match="datosOtrosServicios">
		<tr>
			<td height="20" bgcolor="#EAEAEA" class="heading1">Otros Servicios</td>
			<td width="2">
				<img src="" width="1" height="1px"/>
			</td>
			<td bgcolor="#EAEAEA">
				<img src="" width="1" height="1px"/>
			</td>
			<td width="2">
				<img src="" width="1" height="1px"/>
			</td>
			<td bgcolor="#EAEAEA" align="right">
				<xsl:value-of select="@importe"/>
			</td>
		</tr>
  </xsl:template>
  <xsl:template match="descuentos">
		<tr>
			<td height="20" bgcolor="#EAEAEA" class="heading1">Descuentos</td>
			<td width="2">
				<img src="" width="1" height="1px"/>
			</td>
			<td bgcolor="#EAEAEA">
				<img src="" width="1" height="1px"/>
			</td>
			<td width="2">
				<img src="" width="1" height="1px"/>
			</td>
			<td bgcolor="#EAEAEA" align="right">
				<xsl:value-of select="@importe"/>
			</td>
		</tr>
  </xsl:template>
  <xsl:template match="totalImpuestos">
	<tr>
		<td height="20" bgcolor="#EAEAEA" class="heading1">Total Impuestos</td>
		<td width="2">
			<img src="" width="1" height="1px"/>
		</td>
		<td bgcolor="#EAEAEA">
			<img src="" width="1" height="1px"/>
		</td>
		<td width="2">
			<img src="" width="1" height="1px"/>
		</td>
		<td bgcolor="#EAEAEA" align="right">
			<xsl:value-of select="@importe"/>
		</td>
	</tr>            
  </xsl:template>
  <xsl:template match="pagosAbonos">
		<tr>
			<td height="20" bgcolor="#EAEAEA" class="heading1">
				<br/>
				Pagos / Abonos
			</td>
			<td width="2">
				<br/>
				<img src="" width="1" height="1px"/>
			</td>
			<td bgcolor="#EAEAEA">
				<br/>
				<img src="" width="1" height="1px"/>
			</td>
			<td width="2">
				<br/>
				<img src="" width="1" height="1px"/>
			</td>
			<td bgcolor="#EAEAEA" align="right">
				<br/>
				<xsl:value-of select="@importe"/>
			</td>
		</tr>
    </xsl:template>
    <xsl:template match="abonoProxFactura">          
		<xsl:variable name="importeProxFactura">
			<xsl:value-of select="@importe" />
		</xsl:variable>			
		<xsl:if test="number($importeProxFactura) != 'NaN' and number($importeProxFactura) != 0">
			<tr>
				<td class="heading1">
					<br/>
					<span style="font-size: x-small;">
						<xsl:text>Abono a su favor en la próxima factura </xsl:text>
						<xsl:value-of select="@importe"/>							
					</span>
					<br/>                
				</td>
			</tr>
		</xsl:if>
	</xsl:template>	  
	  
	<xsl:template match="loyalties">
		<table width="100%" bgcolor="#FFFFFF" cellspacing="0" cellpadding="0" border="0">
			<tr>
				<td colspan="3" class="heading3">
					<xsl:choose>
						<xsl:when test="//elementosCabecera/resumenFacturaEmpresas">
							Programa de Puntos Empresas
						</xsl:when>
						<xsl:otherwise>
							Puntos Vodafone
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
			<tr>
				<td height="2px" bgcolor="#FF0000"/>
				<td width="2px"/>
				<td height="2px" bgcolor="#FF0000"/>
			</tr>
			<tr>
				<td class="heading1" bgcolor="#EAEAEA">Disponibles a <xsl:value-of select="//datosFactura/@fechaFinFacturacion"/></td>
				<td width="2px"/>
				<td bgcolor="#EAEAEA">
					<xsl:choose>
						<xsl:when test="//elementosCabecera/resumenFacturaEmpresas">
							<xsl:value-of select="@disponibles1"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@saldoActualPuntos"/>
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
			<tr>
				<xsl:variable name="newDate">
					<xsl:choose>
						<xsl:when test="//elementosCabecera/resumenFacturaEmpresas">				
							<xsl:if test="@flagFechaCaducaran1 = '1'">
								<xsl:variable name="fechaCaducaran" select="@fechaCaducaran1"/>
								<xsl:if test="string-length($fechaCaducaran) = 8">
									<xsl:value-of select="substring($fechaCaducaran,1,4)"/>-<xsl:value-of select="substring($fechaCaducaran,5,2)"/>-<xsl:value-of select="substring($fechaCaducaran,7,2)"/>
								</xsl:if>
								<xsl:if test="not(string-length($fechaCaducaran) = 8)">
									<xsl:value-of select="$fechaCaducaran"/>
								</xsl:if>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="@flagFechaCaducaran = '1'">
								<xsl:variable name="fechaCaducaran" select="@fechaCaducaran"/>
								<xsl:if test="string-length($fechaCaducaran) = 8">
									<xsl:value-of select="substring($fechaCaducaran,1,4)"/>-<xsl:value-of select="substring($fechaCaducaran,5,2)"/>-<xsl:value-of select="substring($fechaCaducaran,7,2)"/>
								</xsl:if>
								<xsl:if test="not(string-length($fechaCaducaran) = 8)">
									<xsl:value-of select="$fechaCaducaran"/>
								</xsl:if>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<td class="heading1" bgcolor="#EAEAEA">Caducarán a <xsl:value-of select="$newDate"/></td>
				<td width="2px"/>
				<td bgcolor="#EAEAEA">
					<xsl:choose>
						<xsl:when test="//elementosCabecera/resumenFacturaEmpresas">
							<xsl:value-of select="@puntosAcaducar1"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@puntosCaducadosProxCiclo"/>
						</xsl:otherwise>
					</xsl:choose>				
				</td>
			</tr>
			<tr>
				<td height="1px" bgcolor="#FF0000"/>
				<td width="2px"/>
				<td height="1px" bgcolor="#FF0000"/>
			</tr>
		</table>
	</xsl:template>
	
	<xsl:template match="histograma">
		<table width="100%" bgcolor="#FFFFFF" cellspacing="0" cellpadding="0" border="0">
			<tr>
				<td colspan="3" class="heading3">Histograma</td>
			</tr>
			<tr>
				<td width="3" bgcolor="#FF0000">
					<img height="2px" width="3" src=""/>
				</td>
				<td width="2px"/>
				<td width="3" bgcolor="#FF0000">
					<img height="2px" width="1" src=""/>
				</td>
			</tr>
			<tr>
				<td class="heading1" bgcolor="#EAEAEA">Consumo Máximo</td>
				<td width="2px"/>
				<td bgcolor="#EAEAEA">
					<xsl:value-of select="@maxConsumo"/>
				</td>
			</tr>
			<tr>
				<td class="heading1" bgcolor="#EAEAEA">Consumos Históricos</td>
				<td width="2px"/>
				<td bgcolor="#EAEAEA">
					<xsl:value-of select="@consumosHistoricos"/>
				</td>
			</tr>
			<tr>
				<td class="heading1" bgcolor="#EAEAEA">Media de Consumo</td>
				<td width="2px"/>
				<td bgcolor="#EAEAEA">
					<xsl:value-of select="@mediaConsumoDiaria"/>
				</td>
			</tr>
			<tr>
				<td width="3" bgcolor="#FF0000">
					<img height="1px" width="3" src=""/>
				</td>
				<td width="2px"/>
				<td width="1" bgcolor="#FF0000">
					<img height="1px" width="1" src=""/>
				</td>
			</tr>
		</table>
	</xsl:template>	
	
	<!-- Información de Impuestos aplicados -->
    <xsl:template match="detallesImpuestos">		
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tbody>
			<tr>
				<td class="heading3" colspan="5">
					<xsl:text>Información de Impuestos aplicados</xsl:text>
				</td>
			</tr>
			<tr>
				<td height="2px" bgcolor="#FF0000"/>
				<td width="2px"/>
				<td height="2px" bgcolor="#FF0000"/>
				<td width="2px"/>
				<td height="2px" bgcolor="#FF0000"/>
			</tr>
			<tr>
				<td class="heading1" bgcolor="#EAEAEA">
					<xsl:text>Total Base Imponible</xsl:text>
				</td>
				<td width="2"/>
				<td class="heading1" bgcolor="#EAEAEA">
					<xsl:text>Tipo Impuesto</xsl:text>
				</td>
				<td width="2"/>
				<td class="heading1" bgcolor="#EAEAEA">
					<xsl:text>Total Impuesto</xsl:text>
				</td>
			</tr>
			<tr>
				<td height="1px" bgcolor="#FF0000"/>
				<td width="2px"/>
				<td height="1px" bgcolor="#FF0000"/>
				<td width="2px"/>
				<td height="1px" bgcolor="#FF0000"/>
			</tr>
			<xsl:apply-templates select="detImpuestos"/>
		</tbody>
		</table>
	</xsl:template>       
    <xsl:template match="detImpuestos">
		<tr>
			<td height="20" bgcolor="#EAEAEA">						
				<xsl:value-of select="@base_imp"/>
			</td>
            <td width="2"/>						
            <td bgcolor="#EAEAEA">
				<xsl:value-of select="@tipo_imp"/>
				<xsl:text>(</xsl:text>
				<xsl:value-of select="@porcentaje_imp"/>
				<xsl:text>%)</xsl:text>
            </td>
            <td width="2"/>						
            <td bgcolor="#EAEAEA">						
				<xsl:value-of select="@total_imp"/>
            </td>
        </tr>
    </xsl:template>
	
	<xsl:template match="estadoCuenta">
		<table width="100%" bgcolor="#FFFFFF" cellspacing="0" cellpadding="0" border="0">
			<tr>
				<td colspan="3" class="heading3">Estado de su Cuenta</td>
			</tr>
			<tr>
				<td height="2px" bgcolor="#FF0000" width="70%"/>
				<td width="0.5%"/>
				<td height="2px" bgcolor="#FF0000"/>
			</tr>
			<tr>
				<td class="heading1" bgcolor="#EAEAEA">Saldo anterior</td>
				<td width="2"/>
				<td bgcolor="#EAEAEA">
					<xsl:value-of select="@saldoAnterior"/>
				</td>
			</tr>
			<tr>
				<td class="heading1" bgcolor="#EAEAEA">Total Factura</td>
				<td width="2"/>
				<td bgcolor="#EAEAEA">
					<xsl:variable name="total_factura">
						<xsl:value-of select="//estadoCuenta/@totalFactura"/>
					</xsl:variable>				
					<xsl:value-of select="$total_factura"/>
				</td>
			</tr>
			<tr>
				<td bgcolor="#EAEAEA" height="3"></td>
				<td width="2" height="3"></td>
				<td bgcolor="#EAEAEA" height="3">					
				</td>
			</tr>
			<!--Datos Saldo Final-->
			<tr>
				<td class="heading1" bgcolor="#EAEAEA">Saldo Final</td>
				<td width="2"/>
				<td bgcolor="#EAEAEA">
					<xsl:value-of select="@saldoFinal"/>
				</td>
			</tr>
			<tr>
				<td height="1px" bgcolor="#FF0000"/>
				<td width="2"/>
				<td height="1px" bgcolor="#FF0000"/>
			</tr>
		</table>
	</xsl:template>

    <!-- Detalle Otros Pagos y Abonos-->  
    <xsl:template match="detallesPagosAbonos">
		<xsl:apply-templates select="detPagosAbonos"/>
    </xsl:template>
    <xsl:template match="detPagosAbonos">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tbody>
				<tr>
					<td class="heading3" width="332px">
						<xsl:text>Pagos y Abonos</xsl:text>
					</td>
					<td width="2"/>
                    <td class="heading3" width="64px">
						<xsl:text>Importe</xsl:text>
                    </td>								
				</tr>
				<tr>
					<td height="2px" bgcolor="#FF0000"/>
					<td width="2px"/>
					<td height="2px" bgcolor="#FF0000"/>
					<td width="2px"/>
					<td height="2px" bgcolor="#FF0000"/>
				</tr>
                <tr>
					<td class="heading1" bgcolor="#EAEAEA">
						<xsl:text>Programa Hogar Digital</xsl:text>
					</td>
					<td width="2"/>
                    <td bgcolor="#EAEAEA">
						<xsl:value-of select="@imp_ProgramaHogarDigital"/>
                    </td>								
				</tr>
				<tr>
					<td class="heading1" bgcolor="#EAEAEA">
						<xsl:text>Dto. Visa Vodafone</xsl:text>
					</td>
					<td width="2"/>
                    <td bgcolor="#EAEAEA">
						<xsl:value-of select="@imp_DtoVisaVodafone"/>
                    </td>								
				</tr>
				<tr>
					<td height="1px" bgcolor="#FF0000"/>
					<td width="2px"/>
					<td height="1px" bgcolor="#FF0000"/>
					<td width="2px"/>
					<td height="1px" bgcolor="#FF0000"/>
				</tr>
            </tbody>
        </table>
    </xsl:template>

	<xsl:template match="InfPlanPrecios">
		<table width="100%" bgcolor="#FFFFFF" cellspacing="0" cellpadding="0" border="0">
			<tr>
				<td colspan="3" class="heading3">Para que tengas siempre la mejor opción...</td>
			</tr>
			<tr>
				<td width="3" bgcolor="#FF0000">
					<img height="2px" width="3" src=""/>
				</td>
				<td width="2px" bgcolor="#FF0000"/>
				<td width="3" bgcolor="#FF0000">
					<img height="2px" width="1" src=""/>
				</td>
			</tr>
			<tr><td bgcolor="#EAEAEA" colspan="3" height="2"></td></tr>
			<tr>								
				<td bgcolor="#EAEAEA" colspan="3">
					<p>					
						<b><xsl:value-of select="@titulo"/></b><br/><br/>
						<xsl:variable name="tipoRegistro"><xsl:value-of select="@TipoRegistro"/></xsl:variable>				
						<xsl:if test="$tipoRegistro = 'OP'">
						<xsl:call-template name="replace-string">
							<xsl:with-param name="text">
								<xsl:call-template name="replace-string">
									<xsl:with-param name="text">
										<xsl:call-template name="replace-string">
											<xsl:with-param name="text">
												<xsl:call-template name="replace-string">
													<xsl:with-param name="text">
														<xsl:call-template name="replace-string">
															<xsl:with-param name="text">
																<xsl:call-template name="replace-string">
																	<xsl:with-param name="text">
																		<xsl:call-template name="replace-string">
																			<xsl:with-param name="text">
																				<xsl:call-template name="replace-string">
																					<xsl:with-param name="text">
																						<xsl:call-template name="replace-string">
																							<xsl:with-param name="text">
																								<xsl:call-template name="replace-string">
																									<xsl:with-param name="text">
																										<xsl:call-template name="replace-string">
																											<xsl:with-param name="text">
																												<xsl:call-template name="replace-string">
																													<xsl:with-param name="text" select="@textoGenerico"/>
																													<xsl:with-param name="from" select="'$Cuenta'"/>
																													<xsl:with-param name="to" select="@Cuenta"/>
																												</xsl:call-template>
																											</xsl:with-param>
																											<xsl:with-param name="from" select="'$Telefono'"/>
																											<xsl:with-param name="to" select="@Telefono"/>
																										</xsl:call-template>
																									</xsl:with-param>
																									<xsl:with-param name="from" select="'$PlanActual'"/>
																									<xsl:with-param name="to" select="@PlanActual"/>
																								</xsl:call-template>
																							</xsl:with-param>
																							<xsl:with-param name="from" select="'$PlanOptimo'"/>
																							<xsl:with-param name="to" select="@PlanOptimo"/>
																						</xsl:call-template>
																					</xsl:with-param>
																					<xsl:with-param name="from" select="'$ProdActual'"/>
																					<xsl:with-param name="to" select="@ProdActual"/>
																				</xsl:call-template>
																			</xsl:with-param>
																			<xsl:with-param name="from" select="'$ProdOptimo'"/>
																			<xsl:with-param name="to" select="@ProdOptimo"/>																
																		</xsl:call-template>
																	</xsl:with-param>
																	<xsl:with-param name="from" select="'$AhorroPorcentaje'"/>
																	<xsl:with-param name="to" select="@AhorroPorcentaje"/>
																</xsl:call-template>
															</xsl:with-param>
															<xsl:with-param name="from" select="'$AhorroEuros'"/>
															<xsl:with-param name="to" select="@AhorroEuros"/>
														</xsl:call-template>
													</xsl:with-param>
													<xsl:with-param name="from" select="'$Mes1'"/>
													<xsl:with-param name="to" select="@Mes1"/>
												</xsl:call-template>
											</xsl:with-param>
											<xsl:with-param name="from" select="'$Mes2'"/>
											<xsl:with-param name="to" select="@Mes2"/>
										</xsl:call-template>
									</xsl:with-param>
									<xsl:with-param name="from" select="'$ImpActual'"/>
									<xsl:with-param name="to" select="@ImpActual"/>
								</xsl:call-template>
							</xsl:with-param>
							<xsl:with-param name="from" select="'$ImpOptimo'"/>
							<xsl:with-param name="to" select="@ImpOptimo"/>
						</xsl:call-template>		
						</xsl:if>		
						<xsl:if test="$tipoRegistro='PP'">
							<xsl:call-template name="replace-string">
							<xsl:with-param name="text">
								<xsl:call-template name="replace-string">
									<xsl:with-param name="text">
										<xsl:call-template name="replace-string">
											<xsl:with-param name="text">
												<xsl:call-template name="replace-string">
													<xsl:with-param name="text">
														<xsl:call-template name="replace-string">
															<xsl:with-param name="text">
																<xsl:call-template name="replace-string">
																	<xsl:with-param name="text">
																		<xsl:call-template name="replace-string">
																			<xsl:with-param name="text">
																				<xsl:call-template name="replace-string">
																					<xsl:with-param name="text">
																						<xsl:call-template name="replace-string">
																							<xsl:with-param name="text">
																								<xsl:call-template name="replace-string">
																									<xsl:with-param name="text">
																										<xsl:call-template name="replace-string">
																											<xsl:with-param name="text">
																												<xsl:call-template name="replace-string">
																													<xsl:with-param name="text" select="@textoGenerico"/>
																													<xsl:with-param name="from" select="'$Cuenta'"/>
																													<xsl:with-param name="to" select="@Cuenta"/>
																												</xsl:call-template>
																											</xsl:with-param>
																											<xsl:with-param name="from" select="'$Telefono'"/>
																											<xsl:with-param name="to" select="@Telefono"/>
																										</xsl:call-template>
																									</xsl:with-param>
																									<xsl:with-param name="from" select="'$PlanActual'"/>
																									<xsl:with-param name="to" select="@PlanActual"/>
																								</xsl:call-template>
																							</xsl:with-param>
																							<xsl:with-param name="from" select="'$PlanOptimo'"/>
																							<xsl:with-param name="to" select="@PlanOptimo"/>
																						</xsl:call-template>
																					</xsl:with-param>
																					<xsl:with-param name="from" select="'$ProdActual'"/>
																					<xsl:with-param name="to" select="@ProdActual"/>
																				</xsl:call-template>
																			</xsl:with-param>
																			<xsl:with-param name="from" select="'$ProdOptimo'"/>
																			<xsl:with-param name="to" select="@ProdOptimo"/>																
																		</xsl:call-template>
																	</xsl:with-param>
																	<xsl:with-param name="from" select="'$AhorroPorcentaje'"/>
																	<xsl:with-param name="to" select="@AhorroPorcentaje"/>
																</xsl:call-template>
															</xsl:with-param>
															<xsl:with-param name="from" select="'$AhorroEuros'"/>
															<xsl:with-param name="to" select="@AhorroEuros"/>
														</xsl:call-template>
													</xsl:with-param>
													<xsl:with-param name="from" select="'$Mes1'"/>
													<xsl:with-param name="to" select="@Mes1"/>
												</xsl:call-template>
											</xsl:with-param>
											<xsl:with-param name="from" select="'$Mes2'"/>
											<xsl:with-param name="to" select="@Mes2"/>
										</xsl:call-template>
									</xsl:with-param>
									<xsl:with-param name="from" select="'$ImpActual'"/>
									<xsl:with-param name="to" select="@ImpActual"/>
								</xsl:call-template>
							</xsl:with-param>
							<xsl:with-param name="from" select="'$ImpOptimo'"/>
							<xsl:with-param name="to" select="@ImpOptimo"/>
						</xsl:call-template>
							<xsl:text> </xsl:text><a ><xsl:attribute name="href"><xsl:value-of select="@dirUrl"/></xsl:attribute>Haz click aquí</a>
						</xsl:if>
						<xsl:if test="$tipoRegistro='MG'">
							<xsl:call-template name="replace-string">
							<xsl:with-param name="text">
								<xsl:call-template name="replace-string">
									<xsl:with-param name="text">
										<xsl:call-template name="replace-string">
											<xsl:with-param name="text">
												<xsl:call-template name="replace-string">
													<xsl:with-param name="text">
														<xsl:call-template name="replace-string">
															<xsl:with-param name="text">
																<xsl:call-template name="replace-string">
																	<xsl:with-param name="text">
																		<xsl:call-template name="replace-string">
																			<xsl:with-param name="text">
																				<xsl:call-template name="replace-string">
																					<xsl:with-param name="text">
																						<xsl:call-template name="replace-string">
																							<xsl:with-param name="text">
																								<xsl:call-template name="replace-string">
																									<xsl:with-param name="text">
																										<xsl:call-template name="replace-string">
																											<xsl:with-param name="text">
																												<xsl:call-template name="replace-string">
																													<xsl:with-param name="text" select="@textoGenerico"/>
																													<xsl:with-param name="from" select="'$Cuenta'"/>
																													<xsl:with-param name="to" select="@Cuenta"/>
																												</xsl:call-template>
																											</xsl:with-param>
																											<xsl:with-param name="from" select="'$Telefono'"/>
																											<xsl:with-param name="to" select="@Telefono"/>
																										</xsl:call-template>
																									</xsl:with-param>
																									<xsl:with-param name="from" select="'$PlanActual'"/>
																									<xsl:with-param name="to" select="@PlanActual"/>
																								</xsl:call-template>
																							</xsl:with-param>
																							<xsl:with-param name="from" select="'$PlanOptimo'"/>
																							<xsl:with-param name="to" select="@PlanOptimo"/>
																						</xsl:call-template>
																					</xsl:with-param>
																					<xsl:with-param name="from" select="'$ProdActual'"/>
																					<xsl:with-param name="to" select="@ProdActual"/>
																				</xsl:call-template>
																			</xsl:with-param>
																			<xsl:with-param name="from" select="'$ProdOptimo'"/>
																			<xsl:with-param name="to" select="@ProdOptimo"/>																
																		</xsl:call-template>
																	</xsl:with-param>
																	<xsl:with-param name="from" select="'$AhorroPorcentaje'"/>
																	<xsl:with-param name="to" select="@AhorroPorcentaje"/>
																</xsl:call-template>
															</xsl:with-param>
															<xsl:with-param name="from" select="'$AhorroEuros'"/>
															<xsl:with-param name="to" select="@AhorroEuros"/>
														</xsl:call-template>
													</xsl:with-param>
													<xsl:with-param name="from" select="'$Mes1'"/>
													<xsl:with-param name="to" select="@Mes1"/>
												</xsl:call-template>
											</xsl:with-param>
											<xsl:with-param name="from" select="'$Mes2'"/>
											<xsl:with-param name="to" select="@Mes2"/>
										</xsl:call-template>
									</xsl:with-param>
									<xsl:with-param name="from" select="'$ImpActual'"/>
									<xsl:with-param name="to" select="@ImpActual"/>
								</xsl:call-template>
							</xsl:with-param>
							<xsl:with-param name="from" select="'$ImpOptimo'"/>
							<xsl:with-param name="to" select="@ImpOptimo"/>
						</xsl:call-template>
						</xsl:if>	
					</p>
				</td>
			</tr>			
			<tr><td bgcolor="#EAEAEA" colspan="3" height="2"></td></tr>
			<tr>
				<td width="3" bgcolor="#FF0000">
					<img height="1px" width="3" src=""/>
				</td>
				<td width="2px" bgcolor="#FF0000"/>
				<td width="1" bgcolor="#FF0000">
					<img height="1px" width="1" src=""/>
				</td>
			</tr>
		</table>
	</xsl:template>
	
	<xsl:template match="resumenFactura">
		<table width="100%" bgcolor="#FFFFFF" cellspacing="0" cellpadding="0" border="0">
			<tr>
				<td>
					<br/>
					<br/>
				</td>
			</tr>
			<tr>
				<td colspan="15" height="2px" bgcolor="#000000"/>
			</tr>
			<tr>
				<td colspan="15" class="heading3">Resumen Factura<br/>
					<br/>
				</td>
			</tr>
			<tr>
				<td align="center" valign="bottom" class="heading1">Línea de Producto</td>
				<td width="2px"/>
				<td align="center" valign="bottom" class="heading1">Cuota Mensual</td>
			    <td width="2px"/>				
				<td align="center" valign="bottom" class="heading1">Otras Cuotas</td>
				<td width="2px"/>
				<td align="center" valign="bottom" class="heading1">Consumo</td>
				<td width="2px"/>
				<td align="center" valign="bottom" class="heading1">Descuento</td>
				<td width="2px"/>
				<td align="center" valign="bottom" class="heading1">Otros Abonos</td>
				<td width="2px"/>
				<td align="center" valign="bottom" class="heading1">Otros Cargos</td>
				<td width="2px"/>
				<td align="center" valign="bottom" class="heading1">Total</td>
			</tr>
			<tr>
				<td height="2px" bgcolor="#FF0000"/>
				<td width="2px"/>
				<td height="2px" bgcolor="#FF0000"/>
				<td width="2px"/>
				<td height="2px" bgcolor="#FF0000"/>
				<td width="2px"/>
				<td height="2px" bgcolor="#FF0000"/>
				<td width="2px"/>
				<td height="2px" bgcolor="#FF0000"/>
				<td width="2px"/>
				<td height="2px" bgcolor="#FF0000"/>
				<td width="2px"/>
				<td height="2px" bgcolor="#FF0000"/>
				<td width="2px"/>
				<td height="2px" bgcolor="#FF0000"/>
			</tr>
			<xsl:apply-templates select="resLinProd"/>
			
			<xsl:if test="//factura/elementosCabecera/clienteEmpresa">
				<!-- APLICA TEMPLATE DE INTERESES DE DEMORA-->
				<xsl:apply-templates select="totInteresDemora"/> 

				<!-- APLICA TEMPLATE DE IMPUESTOS-->
				<xsl:apply-templates select="totalesImpuestos"/> 
			</xsl:if>	
		
			<tr>
				<td height="1px" bgcolor="#FF0000"/>
				<td width="2px"/>
				<td height="1px" bgcolor="#FF0000"/>
				<td width="2px"/>
				<td height="1px" bgcolor="#FF0000"/>
				<td width="2px"/>
				<td height="1px" bgcolor="#FF0000"/>
				<td width="2px"/>
				<td height="1px" bgcolor="#FF0000"/>									
				<td width="2px"/>		
				<td height="1px" bgcolor="#FF0000"/>									
				<td width="2px"/>		
				<td height="1px" bgcolor="#FF0000"/>									
				<td width="2px"/>		
				<td height="1px" bgcolor="#FF0000"/>
			</tr>
		</table>
	</xsl:template>	
	<xsl:template match="resLinProd">
		<tr>
			<td height="20" bgcolor="#EAEAEA">
				<xsl:value-of select="@linProdDesc"/>
			</td>
			<td></td>
			<td align="right" height="20" bgcolor="#EAEAEA">
				<xsl:value-of select="@cuMen"/>
			</td>
			<td></td>
			<td align="right" height="20" bgcolor="#EAEAEA">
				<xsl:value-of select="@otCuo"/>
			</td>
			<td></td>
			<td align="right" height="20" bgcolor="#EAEAEA">
				<xsl:value-of select="@cons"/>
			</td>
			<td></td>
			<td align="right" height="20" bgcolor="#EAEAEA">
				<xsl:value-of select="@desc"/>
			</td>
			<td></td>
			<td align="right" height="20" bgcolor="#EAEAEA">
				<xsl:value-of select="@otAb"/>
			</td>
			<td></td>
			<td align="right" height="20" bgcolor="#EAEAEA">
				<xsl:value-of select="@otCar"/>
			</td>
			<td></td>
			<td align="right" height="20" bgcolor="#EAEAEA">
				<xsl:value-of select="@total"/>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="totInteresDemora">
		<tr>
			<td height="20" bgcolor="#EAEAEA">
				Intereses de Demora Aplicados
			</td>
			<td></td>
			<td align="right" height="20" bgcolor="#EAEAEA">
			</td>
			<td></td>
			<td align="right" height="20" bgcolor="#EAEAEA">
				<xsl:value-of select="@importe"/>
			</td>
			<td></td>
			<td align="right" height="20" bgcolor="#EAEAEA">
			</td>
			<td></td>
			<td align="right" height="20" bgcolor="#EAEAEA">
			</td>	
			<td></td>			
			<td align="right" height="20" bgcolor="#EAEAEA">
			</td>
			<td></td>
			<td align="right" height="20" bgcolor="#EAEAEA">
			</td>
			<td></td>
			<td align="right" height="20" bgcolor="#EAEAEA">
				<xsl:value-of select="@importe"/>
			</td>		
		</tr>	
	</xsl:template>		

	<xsl:template match="totalesImpuestos">
		<tr>
			<td height="20" bgcolor="#EAEAEA">Base Imponible</td>
			<td></td>
			<td align="right" height="20" bgcolor="#EAEAEA"></td>	
			<td></td>
			<td align="right" height="20" bgcolor="#EAEAEA"></td>
			<td></td>
			<td align="right" height="20" bgcolor="#EAEAEA"></td>
			<td></td>
			<td align="right" height="20" bgcolor="#EAEAEA"></td>
			<td></td>
			<td align="right" height="20" bgcolor="#EAEAEA"></td>
			<td></td>
			<td align="right" height="20" bgcolor="#EAEAEA"></td>
			<td></td>
			<td align="right" height="20" bgcolor="#EAEAEA">			
			    <xsl:variable name="base_imponible">
					<xsl:value-of select="//totalesImpuestos/@baseImponible"/>
				</xsl:variable>		
				<xsl:value-of select="$base_imponible"/>
			</td>		
		</tr>		
		
		<tr>		
			<td height="20" bgcolor="#EAEAEA">Impuestos (IVA 
				<xsl:variable name="porcentaje_impuestos">
					<xsl:value-of select="//totalesImpuestos/@porcentajeImpuestos"/>
					</xsl:variable>		
					<xsl:value-of select="$porcentaje_impuestos"/>				
				)
			</td>				
			<td></td>
			<td align="right" height="20" bgcolor="#EAEAEA"></td>
			<td></td>
			<td align="right" height="20" bgcolor="#EAEAEA"></td>
			<td></td>
			<td align="right" height="20" bgcolor="#EAEAEA"></td>
			<td></td>
			<td align="right" height="20" bgcolor="#EAEAEA"></td>
			<td></td>
			<td align="right" height="20" bgcolor="#EAEAEA"></td>
			<td></td>
			<td align="right" height="20" bgcolor="#EAEAEA"></td>
			<td></td>
			<td align="right" height="20" bgcolor="#EAEAEA">			
			    <xsl:variable name="impuestos">
					<xsl:value-of select="//totalesImpuestos/@impuestos"/>
				</xsl:variable>		
				<xsl:value-of select="$impuestos"/>
			</td>		
		</tr>
			
		<tr>
			<td height="20" bgcolor="#EAEAEA">TOTAL FACTURA</td>
			<td></td>
			<td align="right" height="20" bgcolor="#EAEAEA"></td>
			<td></td>
			<td align="right" height="20" bgcolor="#EAEAEA"></td>
			<td></td>
			<td align="right" height="20" bgcolor="#EAEAEA"></td>
			<td></td>
			<td align="right" height="20" bgcolor="#EAEAEA"></td>
			<td></td>
			<td align="right" height="20" bgcolor="#EAEAEA"></td>
			<td></td>
			<td align="right" height="20" bgcolor="#EAEAEA"></td>
			<td></td>
			<td align="right" height="20" bgcolor="#EAEAEA">	
				<xsl:variable name="total_factura">
					<xsl:value-of select="//estadoCuenta/@totalFactura"/>
				</xsl:variable>				
				<xsl:value-of select="$total_factura"/>
			</td>
		</tr>
	</xsl:template>	
	
	<!-- TOTALES DE LLAMADAS POR  NUMEROS DE TELEFONO-->
	<xsl:template match="totalesLlamadasNumerosTelefono">
		<xsl:choose>
			<xsl:when test="//elementosCabecera/resumenFacturaEmpresas">
				<table width="70%" bgcolor="#FFFFFF" cellspacing="0" cellpadding="0" border="0">
					<tr>
						<td colspan="7">
							<br/><br/>
						</td>
					</tr>
					<tr>
						<td colspan="7" height="2px" bgcolor="#000000"/>
					</tr>
					<tr>
						<td colspan="7" class="heading3">A - Resumen de Consumo<br/><br/></td>
					</tr>
					<xsl:apply-templates select="lineaProductoTNT "/>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<table width="70%" bgcolor="#FFFFFF" cellspacing="0" cellpadding="0" border="0">
					<tr>
						<td>
							<br/>
							<br/>
						</td>
					</tr>
					<tr>
						<td colspan="13" height="2px" bgcolor="#000000"/>
					</tr>
					<tr>
						<td colspan="13" class="heading3">Totales de llamadas por número de Télefono<br/>
							<br/>
						</td>
					</tr>
					<xsl:apply-templates select="lineaProductoTNT "/>
				</table>
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:template>
	<xsl:template match="lineaProductoTNT">
		<xsl:choose>
			<xsl:when test="//elementosCabecera/resumenFacturaEmpresas">
				<xsl:apply-templates select="totLlamNumTelf "/>
			</xsl:when>
			<xsl:otherwise>
				<tr>
					<td colspan="11">
						<table width="100%" celpadding="0" cellspacing="0" border="0">
							<tr>
								<td height="2px" bgcolor="#FF0000"/>
								<td width="2px"/>
								<td height="2px" bgcolor="#FF0000"/>
							</tr>
							<tr>
								<td class="heading1" bgcolor="#EAEAEA">Línea de producto</td>
								<td width="2px"/>
								<td bgcolor="#EAEAEA">
									<xsl:choose>
										<xsl:when test="@codLinPro = 'TAD' and @subLinPro = '52'">
											<xsl:text>Telefonía Fija de Acceso Directo</xsl:text>
										</xsl:when>
										<xsl:when test="@codLinPro = 'TAD' and @subLinPro = 'A'">
											<xsl:text>Telefonía Móvil de Acceso Directo</xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="@codLinProDesc"/>
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
							<tr>
								<td height="1px" bgcolor="#FF0000"/>
								<td width="2px"/>
								<td height="1px" bgcolor="#FF0000"/>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<br/>
					</td>
				</tr>
				<tr>
					<td align="center" valign="bottom" class="heading1">Servicio</td>
					<td width="2px"/>
					<td align="center" valign="bottom" class="heading1">Descripción/Duración</td>
					<td width="2px"/>
					<td align="center" valign="bottom" class="heading1">Número de llamadas</td>
					<td width="2px"/>
					<td align="center" valign="bottom" class="heading1">Unidad de medida</td>
					<td width="2px"/>
					<td align="center" valign="bottom" class="heading1">Consumo</td>
					<td width="2px"/>
					<td align="center" valign="bottom" class="heading1">Importe</td>
				</tr>
				<tr>
					<td height="2px" bgcolor="#FF0000"/>
					<td width="2px"/>
					<td height="2px" bgcolor="#FF0000"/>
					<td width="2px"/>
					<td height="2px" bgcolor="#FF0000"/>
					<td width="2px"/>
					<td height="2px" bgcolor="#FF0000"/>
					<td width="2px"/>
					<td height="2px" bgcolor="#FF0000"/>
					<td width="2px"/>
					<td height="2px" bgcolor="#FF0000"/>
				</tr>
				<xsl:apply-templates select="totLlamNumTelf "/>
				<tr>
					<td height="1px" bgcolor="#FF0000"/>
					<td width="2px"/>
					<td height="1px" bgcolor="#FF0000"/>
					<td width="2px"/>
					<td height="1px" bgcolor="#FF0000"/>
					<td width="2px"/>
					<td height="1px" bgcolor="#FF0000"/>
					<td width="2px"/>
					<td height="1px" bgcolor="#FF0000"/>
					<td width="2px"/>
					<td height="1px" bgcolor="#FF0000"/>
				</tr>			
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:template>
	
	<xsl:template match="totLlamNumTelf">
		<xsl:choose>
			<xsl:when test="//elementosCabecera/resumenFacturaEmpresas">
			  <xsl:choose>
				<xsl:when test="@TipoTot = 60">
				  <xsl:choose>
					<xsl:when test="@TipoCons = 0">
						<tr>
							<td valign="bottom" class="heading1"><xsl:value-of select="@TipoTotDesc"/></td>
							<td width="2px"/>
							<td valign="bottom" class="heading1">Nº Llamadas</td>
							<td width="2px"/>
							<td valign="bottom" class="heading1">Minutos</td>
							<td width="2px"/>
							<td valign="bottom" class="heading1"><xsl:value-of select="@imp"/></td>
						</tr>
						<tr>
							<td height="2px" bgcolor="#FF0000"/>
							<td width="2px"/>
							<td height="2px" bgcolor="#FF0000"/>
							<td width="2px"/>
							<td height="2px" bgcolor="#FF0000"/>
							<td width="2px"/>
							<td height="2px" bgcolor="#FF0000"/>
						</tr>	
					</xsl:when>
					<xsl:when test="@tLlam = 0">
						<tr>
							<td valign="bottom" bgcolor="#EAEAEA" class="heading1"><xsl:value-of select="@TipoConsDesc"/></td>
							<td width="2px"/>
							<td valign="bottom" bgcolor="#EAEAEA" class="heading1"><xsl:value-of select="@nLlam"/></td>
							<td width="2px"/>
							<td valign="bottom" bgcolor="#EAEAEA" class="heading1"><xsl:value-of select="@cons"/></td>
							<td width="2px"/>
							<td valign="bottom" bgcolor="#EAEAEA" class="heading1"><xsl:value-of select="@imp"/></td>
						</tr>
					</xsl:when>
					<xsl:otherwise>
						<tr>
							<td><xsl:value-of select="@tLlamDesc"/></td>
							<td width="2px"/>
							<td><xsl:value-of select="@nLlam"/></td>
							<td width="2px"/>
							<td><xsl:value-of select="@cons"/></td>
							<td width="2px"/>
							<td><xsl:value-of select="@imp"/></td>
						</tr>
					</xsl:otherwise>
				  </xsl:choose>		
				</xsl:when>
				<xsl:when test="@TipoTot = 70">
				  <xsl:choose>
					<xsl:when test="@TipoCons = 0">
						<tr>
							<td valign="bottom" class="heading1"><xsl:value-of select="@TipoTotDesc"/></td>
							<td width="2px"/>
							<td valign="bottom" class="heading1">Nº Mensajes</td>
							<td width="2px"/>
							<td valign="bottom" class="heading1"></td>
							<td width="2px"/>
							<td valign="bottom" class="heading1"><xsl:value-of select="@imp"/></td>
						</tr>
						<tr>
							<td height="2px" bgcolor="#FF0000"/>
							<td width="2px"/>
							<td height="2px" bgcolor="#FF0000"/>
							<td width="2px"/>
							<td height="2px" bgcolor="#FF0000"/>
							<td width="2px"/>
							<td height="2px" bgcolor="#FF0000"/>
						</tr>	
					</xsl:when>
					<xsl:when test="@tLlam = 0">
						<tr>
							<td valign="bottom" bgcolor="#EAEAEA" class="heading1"><xsl:value-of select="@TipoConsDesc"/></td>
							<td width="2px"/>
							<td valign="bottom" bgcolor="#EAEAEA" class="heading1"><xsl:value-of select="@nLlam"/></td>
							<td width="2px"/>
							<td valign="bottom" bgcolor="#EAEAEA" class="heading1"></td>
							<td width="2px"/>
							<td valign="bottom" bgcolor="#EAEAEA" class="heading1"><xsl:value-of select="@imp"/></td>
						</tr>
					</xsl:when>
					<xsl:otherwise>
						<tr>
							<td><xsl:value-of select="@tLlamDesc"/></td>
							<td width="2px"/>
							<td><xsl:value-of select="@nLlam"/></td>
							<td width="2px"/>
							<td></td>
							<td width="2px"/>
							<td><xsl:value-of select="@imp"/></td>
						</tr>
					</xsl:otherwise>
				  </xsl:choose>			
				</xsl:when>
				<xsl:when test="@TipoTot = 80">
				  <xsl:choose>
					<xsl:when test="@TipoCons = 0">
						<tr>
							<td valign="bottom" class="heading1"><xsl:value-of select="@TipoTotDesc"/></td>
							<td width="2px"/>
							<td valign="bottom" class="heading1">Nº Conexiones</td>
							<td width="2px"/>
							<td valign="bottom" class="heading1">KBytes/Minutos</td>
							<td width="2px"/>
							<td valign="bottom" class="heading1"><xsl:value-of select="@imp"/></td>
						</tr>
						<tr>
							<td height="2px" bgcolor="#FF0000"/>
							<td width="2px"/>
							<td height="2px" bgcolor="#FF0000"/>
							<td width="2px"/>
							<td height="2px" bgcolor="#FF0000"/>
							<td width="2px"/>
							<td height="2px" bgcolor="#FF0000"/>
						</tr>	
					</xsl:when>
					<xsl:when test="@tLlam = 0">
						<tr>
							<td valign="bottom" bgcolor="#EAEAEA" class="heading1"><xsl:value-of select="@TipoConsDesc"/></td>
							<td width="2px"/>
							<td valign="bottom" bgcolor="#EAEAEA" class="heading1"><xsl:value-of select="@nLlam"/></td>
							<td width="2px"/>
							<td valign="bottom" bgcolor="#EAEAEA" class="heading1"><xsl:value-of select="@cons"/></td>
							<td width="2px"/>
							<td valign="bottom" bgcolor="#EAEAEA" class="heading1"><xsl:value-of select="@imp"/></td>
						</tr>
					</xsl:when>
					<xsl:otherwise>
						<tr>
							<td><xsl:value-of select="@tLlamDesc"/></td>
							<td width="2px"/>
							<td><xsl:value-of select="@nLlam"/></td>
							<td width="2px"/>
							<td><xsl:value-of select="@cons"/></td>
							<td width="2px"/>
							<td><xsl:value-of select="@imp"/></td>
						</tr>
					</xsl:otherwise>
				  </xsl:choose>			
				</xsl:when>
				<xsl:when test="@TipoTot = 90">
				  <xsl:choose>
					<xsl:when test="@TipoCons = 0">
						<tr>
							<td valign="bottom" class="heading1"><xsl:value-of select="@TipoTotDesc"/></td>
							<td width="2px"/>
							<td valign="bottom" class="heading1">Nº Servicios</td>
							<td width="2px"/>
							<td valign="bottom" class="heading1"></td>
							<td width="2px"/>
							<td valign="bottom" class="heading1"><xsl:value-of select="@imp"/></td>
						</tr>
						<tr>
							<td height="2px" bgcolor="#FF0000"/>
							<td width="2px"/>
							<td height="2px" bgcolor="#FF0000"/>
							<td width="2px"/>
							<td height="2px" bgcolor="#FF0000"/>
							<td width="2px"/>
							<td height="2px" bgcolor="#FF0000"/>
						</tr>	
					</xsl:when>
					<xsl:when test="@tLlam = 0">
						<tr>
							<td valign="bottom" bgcolor="#EAEAEA" class="heading1"><xsl:value-of select="@TipoConsDesc"/></td>
							<td width="2px"/>
							<td valign="bottom" bgcolor="#EAEAEA" class="heading1"><xsl:value-of select="@nLlam"/></td>
							<td width="2px"/>
							<td valign="bottom" bgcolor="#EAEAEA" class="heading1"></td>
							<td width="2px"/>
							<td valign="bottom" bgcolor="#EAEAEA" class="heading1"><xsl:value-of select="@imp"/></td>
						</tr>
					</xsl:when>
					<xsl:otherwise>
						<tr>
							<td><xsl:value-of select="@tLlamDesc"/></td>
							<td width="2px"/>
							<td><xsl:value-of select="@nLlam"/></td>
							<td width="2px"/>
							<td></td>
							<td width="2px"/>
							<td><xsl:value-of select="@imp"/></td>
						</tr>
					</xsl:otherwise>
				  </xsl:choose>			
				</xsl:when>
				<xsl:when test="@TipoTot = 'ZZ'">
					<tr>
						<td valign="bottom" bgcolor="#EAEAEA" class="heading2" colspan="2"><xsl:value-of select="@TipoConsDesc"/></td>
						<td valign="bottom" bgcolor="#EAEAEA" class="heading1" colspan="2"></td>
						<td valign="bottom" bgcolor="#EAEAEA" class="heading1" colspan="2"></td>
						<td valign="bottom" bgcolor="#EAEAEA" class="heading2"><xsl:value-of select="@imp"/></td>
					</tr>
					<tr>
						<td colspan="7"></td>
					</tr>
				</xsl:when>
			  </xsl:choose>		
			</xsl:when>
			<xsl:otherwise>
				<tr>
					<td bgcolor="#EAEAEA">
						<xsl:value-of select="@serv"/>
					</td>
					<td width="2px"/>
					<td bgcolor="#EAEAEA">
						<xsl:value-of select="@tLlamDesc"/>
					</td>
					<td width="2px"/>
					<td bgcolor="#EAEAEA">
						<xsl:value-of select="@nLlam"/>
					</td>
					<td width="2px"/>
					<td bgcolor="#EAEAEA">
						<xsl:value-of select="@uniConDesc"/>
					</td>
					<td width="2px"/>
					<td bgcolor="#EAEAEA">
						<xsl:value-of select="@cons"/>
					</td>
					<td width="2px"/>
					<td bgcolor="#EAEAEA">
						<xsl:value-of select="@imp"/>
					</td>
				</tr>			
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:template>

	<!-- RESUMEN DE CUOTAS, TARIFAS PLANAS Y CARGOS -->
	<xsl:template match="ResCuotasYCargosPorPlanesContratados">
		<table width="70%" bgcolor="#FFFFFF" cellspacing="0" cellpadding="0" border="0">
			<tr>
				<td colspan="5">
					<br/><br/>
				</td>
			</tr>
			<tr>
				<td colspan="5" height="2px" bgcolor="#000000"/>
			</tr>
			<tr>
				<td colspan="5" class="heading3">B - Resumen de Cuotas, Tarifas Planas y Cargos<br/><br/></td>
			</tr>
			<xsl:apply-templates select="ResCuotasYCargos "/>
		</table>
	</xsl:template>
	<xsl:template match="ResCuotasYCargos">
	  <xsl:choose>
		<xsl:when test="@TotCuota = 100">
		  <xsl:choose>
			<xsl:when test="@TipoCuota = 0">
				<tr>
					<td valign="bottom" class="heading1"><xsl:value-of select="@TotCuotaDesc"/></td>
					<td width="2px"/>
					<td valign="bottom" class="heading1">Nº de Servicios</td>
					<td width="2px"/>
					<td valign="bottom" class="heading1"><xsl:value-of select="@imp"/></td>
				</tr>
				<tr>
					<td height="2px" bgcolor="#FF0000"/>
					<td width="2px"/>
					<td height="2px" bgcolor="#FF0000"/>
					<td width="2px"/>
					<td height="2px" bgcolor="#FF0000"/>
				</tr>	
			</xsl:when>
			<xsl:when test="@TipoConcepto = 0">
				<tr>
					<td valign="bottom" bgcolor="#EAEAEA" class="heading1"><xsl:value-of select="@TipoCuotaDesc"/></td>
					<td width="2px"/>
					<td valign="bottom" bgcolor="#EAEAEA" class="heading1"></td>
					<td width="2px"/>
					<td valign="bottom" bgcolor="#EAEAEA" class="heading1"><xsl:value-of select="@Total"/></td>
				</tr>
			</xsl:when>
			<xsl:otherwise>
				<tr>
					<td><xsl:value-of select="@TipoConceptoDesc"/></td>
					<td width="2px"/>
					<td><xsl:value-of select="@NumServ"/></td>
					<td width="2px"/>
					<td><xsl:value-of select="@Total"/></td>
				</tr>
			</xsl:otherwise>
		  </xsl:choose>		
		</xsl:when>
		<xsl:when test="@TotCuota = 200">
		  <xsl:choose>
			<xsl:when test="@TipoCuota = 0">
				<tr>
					<td valign="bottom" class="heading1"><xsl:value-of select="@TotCuotaDesc"/></td>
					<td width="2px"/>
					<td valign="bottom" class="heading1"></td>
					<td width="2px"/>
					<td valign="bottom" class="heading1"><xsl:value-of select="@imp"/></td>
				</tr>
				<tr>
					<td height="2px" bgcolor="#FF0000"/>
					<td width="2px"/>
					<td height="2px" bgcolor="#FF0000"/>
					<td width="2px"/>
					<td height="2px" bgcolor="#FF0000"/>
				</tr>	
			</xsl:when>
			<xsl:when test="@TipoConcepto = 0">
				<tr>
					<td valign="bottom" bgcolor="#EAEAEA" class="heading1"><xsl:value-of select="@TipoCuotaDesc"/></td>
					<td width="2px"/>
					<td valign="bottom" bgcolor="#EAEAEA" class="heading1"></td>
					<td width="2px"/>
					<td valign="bottom" bgcolor="#EAEAEA" class="heading1"><xsl:value-of select="@Total"/></td>
				</tr>
			</xsl:when>
			<xsl:otherwise>
				<tr>
					<td><xsl:value-of select="@TipoConceptoDesc"/></td>
					<td width="2px"/>
					<td></td>
					<td width="2px"/>
					<td><xsl:value-of select="@Total"/></td>
				</tr>
			</xsl:otherwise>
		  </xsl:choose>		
		</xsl:when>
		<xsl:when test="@TotCuota = 'Total'">
			<tr>
				<td valign="bottom" bgcolor="#EAEAEA" class="heading2" colspan="2"><xsl:value-of select="@TotCuotaDesc"/></td>
				<td valign="bottom" bgcolor="#EAEAEA" class="heading1" colspan="2"></td>
				<td valign="bottom" bgcolor="#EAEAEA" class="heading2"><xsl:value-of select="@Total"/></td>
			</tr>
			<tr>
				<td colspan="5"></td>
			</tr>
		</xsl:when>
	  </xsl:choose>				
	</xsl:template>	
	
	<!-- RESUMEN DE DESCUENTOS -->
	<xsl:template match="ResDescuentos">
		<table width="70%" bgcolor="#FFFFFF" cellspacing="0" cellpadding="0" border="0">
			<tr>
				<td colspan="3">
					<br/><br/>
				</td>
			</tr>
			<tr>
				<td colspan="3" height="2px" bgcolor="#000000"/>
			</tr>
			<tr>
				<td colspan="3" class="heading3">C - Resumen Descuentos<br/><br/></td>
			</tr>
			<xsl:apply-templates select="ResDesc "/>
		</table>
	</xsl:template>
	<xsl:template match="ResDesc">
		<tr>
			<td class="heading1">A nivel línea</td>
			<td width="2px"/>
			<td><xsl:value-of select="@NivelLinea"/></td>
		</tr>
		<tr>
			<td class="heading1">A nivel cuenta</td>
			<td width="2px"/>
			<td><xsl:value-of select="@NivelDesc"/></td>
		</tr>
		<tr>
			<td valign="bottom" bgcolor="#EAEAEA" class="heading2">Total Descuentos</td>
			<td width="2px"/>
			<td valign="bottom" bgcolor="#EAEAEA" class="heading2"><xsl:value-of select="@Total"/></td>
		</tr>
		<tr>
			<td colspan="3"></td>
		</tr>
	</xsl:template>	
	
	<!-- AJUSTE HASTA CONSUMO MINIMO -->
	<xsl:template match="ResAjusteHastaConsumoMinimo">
		<xsl:if test="ResAjuste[number(@Total) != 0]">
			<table width="70%" bgcolor="#FFFFFF" cellspacing="0" cellpadding="0" border="0">
				<tr>
					<td colspan="3">
						<br/><br/>
					</td>
				</tr>
				<tr>
					<td colspan="3" height="2px" bgcolor="#000000"/>
				</tr>
				<tr>
					<td colspan="3" class="heading3">D - Ajuste hasta consumo mínimo<br/><br/></td>
				</tr>
				<xsl:apply-templates select="ResAjuste "/>
			</table>
		</xsl:if>
	</xsl:template>
	<xsl:template match="ResAjuste">
		<tr>
			<td class="heading1">A nivel línea</td>
			<td width="2px"/>
			<td><xsl:value-of select="@NivelLinea"/></td>
		</tr>
		<tr>
			<td class="heading1">A nivel cuenta</td>
			<td width="2px"/>
			<td><xsl:value-of select="@NivelDesc"/></td>
		</tr>
		<tr>
			<td valign="bottom" bgcolor="#EAEAEA" class="heading2">Total ajuste hasta consumo mínimo</td>
			<td width="2px"/>
			<td valign="bottom" bgcolor="#EAEAEA" class="heading2"><xsl:value-of select="@Total"/></td>
		</tr>
		<tr>
			<td colspan="3"></td>
		</tr>
	</xsl:template>				
	
	<!-- RESUMENES NUMEROS DE TELEFONO-->
	<xsl:template match="resumenesNumerosTelefono">
		<xsl:choose>
			<xsl:when test="//elementosCabecera/resumenFacturaEmpresas">
				<table width="70%" bgcolor="#FFFFFF" cellspacing="0" cellpadding="0" border="0">
					<tr>
						<td colspan="13">
							<br/><br/>
						</td>
					</tr>
					<tr>
						<td colspan="13" height="2px" bgcolor="#000000"/>
					</tr>
					<tr>
						<td colspan="13" class="heading3">Detalle de conceptos facturados<br/><br/></td>
					</tr>
					
					<xsl:if test="lineaProductoRNT[number(resNumTelf/@serv) = number(//datosFactura/@numCuenta) and resNumTelf/@FlagImp != 0]">
						<xsl:variable name="resumenNumeroTelefonoCuenta">cuenta</xsl:variable>	
						<xsl:call-template name="printLineaProductoRNT">
							<xsl:with-param name="value" select="$resumenNumeroTelefonoCuenta"/>
						</xsl:call-template>
						<xsl:for-each select="lineaProductoRNT[number(resNumTelf/@serv) = number(//datosFactura/@numCuenta) and resNumTelf/@FlagImp != 0]">
							<xsl:apply-templates select="resNumTelf"/>
						</xsl:for-each>
						<xsl:apply-templates select="resNumTelfSubtotalCuenta" />
					</xsl:if>
					
					<xsl:if test="lineaProductoRNT[number(resNumTelf/@serv) != number(//datosFactura/@numCuenta) and resNumTelf/@FlagImp != 0]">			
						<xsl:variable name="resumenNumeroTelefonoLinea">linea</xsl:variable>	
						<xsl:call-template name="printLineaProductoRNT">
							<xsl:with-param name="value" select="$resumenNumeroTelefonoLinea"/>
						</xsl:call-template>
						<xsl:for-each select="lineaProductoRNT[number(resNumTelf/@serv) != number(//datosFactura/@numCuenta) and resNumTelf/@FlagImp != 0]">
							<xsl:apply-templates select="resNumTelf"/>
						</xsl:for-each>			
						<xsl:apply-templates select="resNumTelfSubtotalLinea" />
					</xsl:if>
					
					<xsl:apply-templates select="resNumTelfTotal" />
				</table>
			</xsl:when>
			<xsl:otherwise>
				<table width="70%" bgcolor="#FFFFFF" cellspacing="0" cellpadding="0" border="0">
					<tr>
						<td>
							<br/>
							<br/>
						</td>
					</tr>
					<tr>
						<td colspan="19" height="2px" bgcolor="#000000"/>
					</tr>
					<tr>
						<td colspan="19" class="heading3">Resúmenes por Número de Teléfono<br/>
							<br/>
						</td>
					</tr>
					<xsl:apply-templates select="lineaProductoRNT">
						<xsl:sort select="@subLinPro"/>
					</xsl:apply-templates>
				</table>			
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:template>
	<xsl:template name="printLineaProductoRNT">
		<xsl:param name="value"/>
		<tr>
			<td align="center" valign="bottom" class="heading1">
				<xsl:choose>
				  <xsl:when test="$value = 'cuenta'">
					Cuenta
				  </xsl:when>
				  <xsl:otherwise>
					Linea
				  </xsl:otherwise>
				</xsl:choose>		
			</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">
				<xsl:choose>
				  <xsl:when test="$value = 'cuenta'">
				  </xsl:when>
				  <xsl:otherwise>
					Plan de Precios
				  </xsl:otherwise>
				</xsl:choose>		
			</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">
				<xsl:choose>
				  <xsl:when test="$value = 'cuenta'">
				  </xsl:when>
				  <xsl:otherwise>
					Consumo
				  </xsl:otherwise>
				</xsl:choose>		
			</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Cuotas y Tarifas Planas</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Descuentos</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Ajuste hasta consumo mínimo</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Importe</td>
		</tr>
		<tr>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
		</tr>				
	</xsl:template>
	<xsl:template match="lineaProductoRNT">
		<tr>
			<td colspan="17">
				<table width="100%" celpadding="0" cellspacing="0" border="0">
					<tr>
						<td height="2px" bgcolor="#FF0000"/>
						<td width="2px"/>
						<td height="2px" bgcolor="#FF0000"/>
					</tr>
					<tr>
						<td class="heading1" bgcolor="#EAEAEA">Línea de producto</td>
						<td width="2px"/>
						<td bgcolor="#EAEAEA">
							<xsl:choose>
						<xsl:when test="@codLinPro = 'TAD' and @subLinPro = '52'">
							<xsl:text>Telefonía Fija de Acceso Directo</xsl:text>
						</xsl:when>
						<xsl:when test="@codLinPro = 'TAD' and @subLinPro = 'A'">
							<xsl:text>Telefonía Móvil de Acceso Directo</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@codLinProDesc"/>
						</xsl:otherwise>
					</xsl:choose>
						</td>
					</tr>
					<tr>
						<td height="1px" bgcolor="#FF0000"/>
						<td width="2px"/>
						<td height="1px" bgcolor="#FF0000"/>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<br/>
			</td>
		</tr>
		<tr>
			<td align="center" valign="bottom" class="heading1">Servicio</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Plan de Precios</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Cuota Mensual</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Otras Cuotas</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Consumo</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Descuento</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Otros Abonos</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Otros Cargos</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Total</td>
		</tr>
		<tr>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
		</tr>
		<xsl:apply-templates select="resNumTelf"/>
		<tr>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
		</tr>
	</xsl:template>
	
	<xsl:template match="resNumTelf">
		<xsl:choose>
			<xsl:when test="//elementosCabecera/resumenFacturaEmpresas">
				<tr>
					<td>
						<xsl:value-of select="@serv"/>
					</td>
					<td width="2px"/>
					<td>
						<xsl:choose>
						  <xsl:when test="number(@serv) = number(//datosFactura/@numCuenta)">
							-
						  </xsl:when>
						  <xsl:otherwise>
							<xsl:value-of select="@plPrecDesc"/>
						  </xsl:otherwise>
						</xsl:choose>		
					</td>
					<td width="2px"/>
					<td>
						<xsl:choose>
						  <xsl:when test="number(@serv) = number(//datosFactura/@numCuenta)">
							-
						  </xsl:when>
						  <xsl:otherwise>
							<xsl:value-of select="@cons"/>
						  </xsl:otherwise>
						</xsl:choose>		
					</td>
					<td width="2px"/>
					<td>
						<xsl:value-of select="@CuoTarif"/>
					</td>
					<td width="2px"/>
					<td>
						<xsl:value-of select="@DescPapel"/>
					</td>
					<td width="2px"/>
					<td>
						<xsl:value-of select="@ConsMin"/>
					</td>
					<td width="2px"/>
					<td>
						<xsl:value-of select="@total"/>
					</td>
				</tr>
			</xsl:when>
			<xsl:otherwise>
				<tr>
					<td bgcolor="#EAEAEA">
						<xsl:value-of select="@serv"/>
					</td>
					<td width="2px"/>
					<td bgcolor="#EAEAEA">
						<xsl:value-of select="@plPrecDesc"/>
					</td>
					<td width="2px"/>
					<td bgcolor="#EAEAEA">
						<xsl:value-of select="@cuMen"/>
					</td>
					<td width="2px"/>
					<td bgcolor="#EAEAEA">
						<xsl:value-of select="@otCuo"/>
					</td>
					<td width="2px"/>
					<td bgcolor="#EAEAEA">
						<xsl:value-of select="@cons"/>
					</td>
					<td width="2px"/>
					<td bgcolor="#EAEAEA">
						<xsl:value-of select="@desc"/>
					</td>
					<td width="2px"/>
					<td bgcolor="#EAEAEA">
						<xsl:value-of select="@otAb"/>
					</td>
					<td width="2px"/>
					<td bgcolor="#EAEAEA">
						<xsl:value-of select="@otCar"/>
					</td>
					<td width="2px"/>
					<td bgcolor="#EAEAEA">
						<xsl:value-of select="@total"/>
					</td>
				</tr>		
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:template>
	<xsl:template match="resNumTelfSubtotalCuenta">
		<tr>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
		</tr>
		<tr>
			<td bgcolor="#EAEAEA"><b>Total factura por cuenta</b></td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"/>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"/>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"/>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"/>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"/>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"><b><xsl:value-of select="@totalCuentaLineaPapel"/></b></td>
		</tr>		
		<tr>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
		</tr>			
		<tr>
			<td colspan="13"><br/></td>
		</tr>
	</xsl:template>
	<xsl:template match="resNumTelfSubtotalLinea">
		<tr>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
		</tr>
		<tr>
			<td bgcolor="#EAEAEA"><b>Total factura por linea</b></td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"/>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"/>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"/>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"/>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"/>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"><b><xsl:value-of select="@totalCuentaLineaPapel"/></b></td>
		</tr>		
		<tr>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
		</tr>			
		<tr>
			<td colspan="13"><br/></td>
		</tr>
	</xsl:template>	
	<xsl:template match="resNumTelfTotal">
		<tr>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
		</tr>
		<tr>
			<td bgcolor="#EAEAEA"><b>Total factura</b></td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"/>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"><b><xsl:value-of select="@totalConsPapel"/></b></td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"><b><xsl:value-of select="@TotalCuoPapel"/></b></td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"><b><xsl:value-of select="@totalDescPapel"/></b></td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"><b>0.0000</b></td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"><b><xsl:value-of select="@total"/></b></td>
		</tr>		
		<tr>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
		</tr>				
	</xsl:template>
	
	<!-- DETALLES DE CUOTAS-->
	<xsl:template match="detallesCuotas">
		<xsl:choose>
			<xsl:when test="//elementosCabecera/resumenFacturaEmpresas">
				<table width="70%" bgcolor="#FFFFFF" cellspacing="0" cellpadding="0" border="0">
					<tr>
						<td colspan="5">
							<br/><br/>
						</td>
					</tr>
					<tr>
						<td colspan="5" height="2px" bgcolor="#000000"/>
					</tr>
					<tr>
						<td colspan="5" class="heading3">Detalle de Cuotas, Tarifas Planas y Cargos<br/>
							<br/>
						</td>
					</tr>
					
					<xsl:if test="lineaProductoDC[number(detCuot/@serv) = number(//datosFactura/@numCuenta) and detCuot/@FlagImp != 0]">
						<xsl:variable name="detalleCuotaCuenta">cuenta</xsl:variable>	
						<xsl:call-template name="printLineaProductoDC">
							<xsl:with-param name="value" select="$detalleCuotaCuenta"/>
						</xsl:call-template>
						<xsl:for-each select="lineaProductoDC[number(detCuot/@serv) = number(//datosFactura/@numCuenta) and detCuot/@FlagImp != 0]">
							<xsl:apply-templates select="detCuot"/>
						</xsl:for-each>
						<xsl:apply-templates select="detCuotSubtotalCuenta" />
					</xsl:if>
					
					<xsl:if test="lineaProductoDC[number(detCuot/@serv) != number(//datosFactura/@numCuenta) and detCuot/@FlagImp != 0]">
						<xsl:variable name="detalleCuotaLinea">linea</xsl:variable>	
						<xsl:call-template name="printLineaProductoDC">
							<xsl:with-param name="value" select="$detalleCuotaLinea"/>
						</xsl:call-template>
						<xsl:for-each select="lineaProductoDC[number(detCuot/@serv) != number(//datosFactura/@numCuenta) and detCuot/@FlagImp != 0]">
							<xsl:apply-templates select="detCuot"/>
						</xsl:for-each>			
						<xsl:apply-templates select="detCuotSubtotalLinea" />
					</xsl:if>
					
					<xsl:apply-templates select="detCuotTotal" />
				</table>
			</xsl:when>
			<xsl:otherwise>
				<table width="70%" bgcolor="#FFFFFF" cellspacing="0" cellpadding="0" border="0">
					<tr>
						<td>
							<br/>
							<br/>
						</td>
					</tr>
					<tr>
						<td colspan="7" height="2px" bgcolor="#000000"/>
					</tr>
					<tr>
						<td colspan="7" class="heading3">Detalle de Cuotas<br/>
							<br/>
						</td>
					</tr>
					<xsl:apply-templates select="lineaProductoDC "/>
				</table>		
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:template>

	<xsl:template name="printLineaProductoDC">
		<xsl:param name="value"/>
		<!--tr>
			<td colspan="5">
				<table width="100%" celpadding="0" cellspacing="0" border="0">
					<tr>
						<td height="2px" bgcolor="#FF0000"/>
						<td width="2px"/>
						<td height="2px" bgcolor="#FF0000"/>
					</tr>
					<tr>
						<td class="heading1" bgcolor="#EAEAEA">Línea de producto</td>
						<td width="2px"/>
						<td bgcolor="#EAEAEA">
							<xsl:choose>
								<xsl:when test="@codLinPro = 'TAD' and @subLinPro = '52'">
									<xsl:text>Telefonía Fija de Acceso Directo</xsl:text>
								</xsl:when>
								<xsl:when test="@codLinPro = 'TAD' and @subLinPro = 'A'">
									<xsl:text>Telefonía Móvil de Acceso Directo</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="@codLinProDesc"/>
								</xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>
					<tr>
						<td height="1px" bgcolor="#FF0000"/>
						<td width="2px"/>
						<td height="1px" bgcolor="#FF0000"/>
					</tr>
				</table>
			</td>
		</tr-->
		
		<tr>
			<td align="center" valign="bottom" class="heading1">
				<xsl:choose>
				  <xsl:when test="$value = 'cuenta'">
					Cuenta
				  </xsl:when>
				  <xsl:otherwise>
					Linea
				  </xsl:otherwise>
				</xsl:choose>		
			</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Cuotas, Tarifas Planas y Cargos</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Importe</td>
		</tr>
		<tr>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
		</tr>				
	</xsl:template>
	<xsl:template match="lineaProductoDC ">
		<tr>
			<td colspan="5">
				<table width="100%" celpadding="0" cellspacing="0" border="0">
					<tr>
						<td height="2px" bgcolor="#FF0000"/>
						<td width="2px"/>
						<td height="2px" bgcolor="#FF0000"/>
					</tr>
					<tr>
						<td class="heading1" bgcolor="#EAEAEA">Línea de producto</td>
						<td width="2px"/>
						<td bgcolor="#EAEAEA">
							<xsl:choose>
						<xsl:when test="@codLinPro = 'TAD' and @subLinPro = '52'">
							<xsl:text>Telefonía Fija de Acceso Directo</xsl:text>
						</xsl:when>
						<xsl:when test="@codLinPro = 'TAD' and @subLinPro = 'A'">
							<xsl:text>Telefonía Móvil de Acceso Directo</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@codLinProDesc"/>
						</xsl:otherwise>
					</xsl:choose>
						</td>
					</tr>
					<tr>
						<td height="1px" bgcolor="#FF0000"/>
						<td width="2px"/>
						<td height="1px" bgcolor="#FF0000"/>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<br/>
			</td>
		</tr>
		<tr>
			<td align="center" valign="bottom" class="heading1">Servicio</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Cuota</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Importe</td>
		</tr>
		<tr>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
		</tr>
		<xsl:apply-templates select="detCuot "/>
		<tr>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
		</tr>
	</xsl:template>
	
	<xsl:template match="detCuot">
		<xsl:choose>
			<xsl:when test="//elementosCabecera/resumenFacturaEmpresas">
				<tr>
					<td>
						<xsl:value-of select="@serv"/>
					</td>
					<td width="2px"/>
					<td>
						<xsl:value-of select="@cuotDesc"/>
					</td>
					<td width="2px"/>
					<td>
						<xsl:value-of select="@imp"/>
					</td>
				</tr>
			</xsl:when>
			<xsl:otherwise>
				<tr>
					<td bgcolor="#EAEAEA">
						<xsl:value-of select="@serv"/>
					</td>
					<td width="2px"/>
					<td bgcolor="#EAEAEA">
						<xsl:value-of select="@cuotDesc"/>
					</td>
					<td width="2px"/>
					<td bgcolor="#EAEAEA">
						<xsl:value-of select="@imp"/>
					</td>
				</tr>			
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:template>
	<xsl:template match="detCuotSubtotalCuenta">
		<tr>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
		</tr>
		<tr>
			<td bgcolor="#EAEAEA"><b>Total factura por cuenta</b></td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"/>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"><b><xsl:value-of select="@totalCuentaLinea"/></b></td>
		</tr>		
		<tr>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
		</tr>		
		<tr>
			<td colspan="5">
				<br/>
			</td>
		</tr>		
	</xsl:template>
	<xsl:template match="detCuotSubtotalLinea">	
		<tr>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
		</tr>
		<tr>
			<td bgcolor="#EAEAEA"><b>Total factura por linea</b></td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"/>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"><b><xsl:value-of select="@totalCuentaLinea"/></b></td>
		</tr>		
		<tr>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
		</tr>			
		<tr>
			<td colspan="5">
				<br/>
			</td>
		</tr>		
	</xsl:template>		
	<xsl:template match="detCuotTotal">
		<tr>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
		</tr>
		<tr>
			<td bgcolor="#EAEAEA"><b>Total Cuotas, Tarifas Planas y Cargos</b></td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"/>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"><b><xsl:value-of select="@total"/></b></td>
		</tr>		
		<tr>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
		</tr>				
	</xsl:template>
	
	<!-- RESUMENES POR GRUPO-->
	<xsl:template match="resumenesPorGrupo">
		<table width="70%" bgcolor="#FFFFFF" cellspacing="0" cellpadding="0" border="0">
			<tr>
				<td>
					<br/>
					<br/>
				</td>
			</tr>
			<tr>
				<td colspan="13" height="2px" bgcolor="#000000"/>
			</tr>
			<tr>
				<td colspan="13" class="heading3">Resúmenes de Cargos Facturados por Grupos<br/>
					<br/>
				</td>
			</tr>
			<xsl:apply-templates select="lineaProductoRG"/>
		</table>
	</xsl:template>
	<xsl:template match="lineaProductoRG">
		<tr>
			<td colspan="13">
				<table width="100%" celpadding="0" cellspacing="0" border="0">
					<tr>
						<td height="2px" bgcolor="#FF0000"/>
						<td width="2px"/>
						<td height="2px" bgcolor="#FF0000"/>
					</tr>
					<tr>
						<td class="heading1" bgcolor="#EAEAEA">Línea de producto</td>
						<td width="2px"/>
						<td bgcolor="#EAEAEA">
							<xsl:choose>
						<xsl:when test="@codLinPro = 'TAD' and @subLinPro = '52'">
							<xsl:text>Telefonía Fija de Acceso Directo</xsl:text>
						</xsl:when>
						<xsl:when test="@codLinPro = 'TAD' and @subLinPro = 'A'">
							<xsl:text>Telefonía Móvil de Acceso Directo</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@codLinProDesc"/>
						</xsl:otherwise>
					</xsl:choose>
						</td>
					</tr>
					<tr>
						<td height="1px" bgcolor="#FF0000"/>
						<td width="2px"/>
						<td height="1px" bgcolor="#FF0000"/>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<br/>
			</td>
		</tr>
		<tr>
			<td align="center" valign="bottom" class="heading1">Grupo</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">LLamadas mv. Vodafone</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">LLamadas mv. no Vodafone</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">LLamadas a Fijo</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">LLamadas Internacionales</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">LLamadas Roaming</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">LLamadas Especiales</td>
		</tr>
		<tr>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
		</tr>
		<xsl:apply-templates select="resGrupo "/>
		<tr>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
		</tr>
	</xsl:template>
	<xsl:template match="resGrupo">
		<tr>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@idG"/>
			</td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@llaVoda"/>
			</td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@llaNVoda"/>
			</td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@llFj"/>
			</td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@llaIntprov"/>
			</td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@llRoa"/>
			</td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@llEsp"/>
			</td>
		</tr>
	</xsl:template>
	
	<!-- TOTALES MENSAWEB-->
	<xsl:template match="totalesMensaWeb">
		<table width="70%" bgcolor="#FFFFFF" cellspacing="0" cellpadding="0" border="0">
			<tr>
				<td>
					<br/>
					<br/>
				</td>
			</tr>
			<tr>
				<td colspan="19" height="2px" bgcolor="#000000"/>
			</tr>
			<tr>
				<td colspan="19" class="heading3">Totales Mensajes Web<br/>
					<br/>
				</td>
			</tr>
			<xsl:apply-templates select="lineaProductoMWeb"/>
		</table>
	</xsl:template>
	<xsl:template match="lineaProductoMWeb">
		<tr>
			<td colspan="19">
				<table width="100%" celpadding="0" cellspacing="0" border="0">
					<tr>
						<td height="2px" bgcolor="#FF0000"/>
						<td width="2px"/>
						<td height="2px" bgcolor="#FF0000"/>
					</tr>
					<tr>
						<td class="heading1" bgcolor="#EAEAEA">Línea de producto</td>
						<td width="2px"/>
						<td bgcolor="#EAEAEA">
							<xsl:choose>
						<xsl:when test="@codLinPro = 'TAD' and @subLinPro = '52'">
							<xsl:text>Telefonía Fija de Acceso Directo</xsl:text>
						</xsl:when>
						<xsl:when test="@codLinPro = 'TAD' and @subLinPro = 'A'">
							<xsl:text>Telefonía Móvil de Acceso Directo</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@codLinProDesc"/>
						</xsl:otherwise>
					</xsl:choose>
						</td>
					</tr>
					<tr>
						<td height="1px" bgcolor="#FF0000"/>
						<td width="2px"/>
						<td height="1px" bgcolor="#FF0000"/>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<br/>
			</td>
		</tr>
		<tr>
			<td align="center" valign="bottom" class="heading1">Cuenta</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Usuario</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">LLamadas Vodafone</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">LLamadas no Vodafone</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">LLamadas Internacionales</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Total LLamadas</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Total Vodafone</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Total no Vodafone</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Total Internacional</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Importe Total</td>
		</tr>
		<tr>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
		</tr>
		<xsl:apply-templates select="totLLamMWeb "/>
		<tr>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
		</tr>
	</xsl:template>
	<xsl:template match="totLLamMWeb">
		<tr>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@cu"/>
			</td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@usu"/>
			</td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@llamVo"/>
			</td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@llamNoVo"/>
			</td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@llamInte"/>
			</td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@llamTot"/>
			</td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@totVo"/>
			</td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@totNoVo"/>
			</td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@totInte"/>
			</td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@totImp"/>
			</td>
		</tr>
	</xsl:template>
	
	<!-- DETALLES DE DESCUENTOS POR NUMERO DE TELEFONO-->
	<xsl:template match="detallesDescuentosNumerosTelefono">
		<xsl:choose>
			<xsl:when test="//elementosCabecera/resumenFacturaEmpresas">
				<table width="70%" bgcolor="#FFFFFF" cellspacing="0" cellpadding="0" border="0">
					<tr>
						<td colspan="9">
							<br/><br/>
						</td>
					</tr>
					<tr>
						<td colspan="9" height="2px" bgcolor="#000000"/>
					</tr>
					<tr>
						<td colspan="9" class="heading3">Detalle de descuento<br/>
							<br/>
						</td>
					</tr>
					
					<xsl:if test="number(detDescNumTelfSubtotalCuenta/@totalCuentaLineapapel) != 0">
						<xsl:if test="lineaProductoDDNT[number(detDescNumTelf/@serv) = number(//datosFactura/@numCuenta)]">
						  <xsl:variable name="detalleDescuentoCuenta">cuenta</xsl:variable>	
						  <xsl:call-template name="printLineaProductoDDNT">
							<xsl:with-param name="value" select="$detalleDescuentoCuenta"/>
						  </xsl:call-template>
						</xsl:if>
						<xsl:for-each select="lineaProductoDDNT[number(detDescNumTelf/@serv) = number(//datosFactura/@numCuenta)]">
							<xsl:apply-templates select="detDescNumTelf"/>
						</xsl:for-each>
						<xsl:apply-templates select="detDescNumTelfSubtotalCuenta" />
					</xsl:if>
					
					<xsl:if test="number(detDescNumTelfSubtotalLinea/@totalCuentaLineapapel) != 0">
						<xsl:if test="lineaProductoDDNT[number(detDescNumTelf/@serv) != number(//datosFactura/@numCuenta)]">
						  <xsl:variable name="detalleDescuentoLinea">linea</xsl:variable>	
						  <xsl:call-template name="printLineaProductoDDNT">
							<xsl:with-param name="value" select="$detalleDescuentoLinea"/>
						  </xsl:call-template>
						</xsl:if>
						<xsl:for-each select="lineaProductoDDNT[number(detDescNumTelf/@serv) != number(//datosFactura/@numCuenta)]">
							<xsl:apply-templates select="detDescNumTelf"/>
						</xsl:for-each>			
						<xsl:apply-templates select="detDescNumTelfSubtotalLinea" />
					</xsl:if>

					<xsl:apply-templates select="detDescNumTelfTotal" />
				</table>
			</xsl:when>
			<xsl:otherwise>
				<table width="70%" bgcolor="#FFFFFF" cellspacing="0" cellpadding="0" border="0">
					<tr>
						<td>
							<br/>
							<br/>
						</td>
					</tr>
					<tr>
						<td colspan="11" height="2px" bgcolor="#000000"/>
					</tr>
					<tr>
						<td colspan="11" class="heading3">Detalle de Descuentos por Número de Teléfono<br/>
							<br/>
						</td>
					</tr>
					<xsl:apply-templates select="lineaProductoDDNT "/>
				</table>	
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:template>
	<xsl:template name="printLineaProductoDDNT">
		<xsl:param name="value"/>
		<!--tr>
			<td colspan="5">
				<table width="100%" celpadding="0" cellspacing="0" border="0">
					<tr>
						<td height="2px" bgcolor="#FF0000"/>
						<td width="2px"/>
						<td height="2px" bgcolor="#FF0000"/>
					</tr>
					<tr>
						<td class="heading1" bgcolor="#EAEAEA">Línea de producto</td>
						<td width="2px"/>
						<td bgcolor="#EAEAEA">
							<xsl:choose>
								<xsl:when test="@codLinPro = 'TAD' and @subLinPro = '52'">
									<xsl:text>Telefonía Fija de Acceso Directo</xsl:text>
								</xsl:when>
								<xsl:when test="@codLinPro = 'TAD' and @subLinPro = 'A'">
									<xsl:text>Telefonía Móvil de Acceso Directo</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="@codLinProDesc"/>
								</xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>
					<tr>
						<td height="1px" bgcolor="#FF0000"/>
						<td width="2px"/>
						<td height="1px" bgcolor="#FF0000"/>
					</tr>
				</table>
			</td>
		</tr-->
		
		<tr>
			<td align="center" valign="bottom" class="heading1">
				<xsl:choose>
				  <xsl:when test="$value = 'cuenta'">
					Cuenta
				  </xsl:when>
				  <xsl:otherwise>
					Linea
				  </xsl:otherwise>
				</xsl:choose>		
			</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Descripción</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Cantidad</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Porcentaje</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Total</td>
		</tr>
		<tr>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
		</tr>				
	</xsl:template>
	<xsl:template match="lineaProductoDDNT">
		<tr>
			<td colspan="9">
				<table width="100%" celpadding="0" cellspacing="0" border="0">
					<tr>
						<td height="2px" bgcolor="#FF0000"/>
						<td width="2px"/>
						<td height="2px" bgcolor="#FF0000"/>
					</tr>
					<tr>
						<td class="heading1" bgcolor="#EAEAEA">Línea de producto</td>
						<td width="2px"/>
						<td bgcolor="#EAEAEA">
							<xsl:choose>
						<xsl:when test="@codLinPro = 'TAD' and @subLinPro = '52'">
							<xsl:text>Telefonía Fija de Acceso Directo</xsl:text>
						</xsl:when>
						<xsl:when test="@codLinPro = 'TAD' and @subLinPro = 'A'">
							<xsl:text>Telefonía Móvil de Acceso Directo</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@codLinProDesc"/>
						</xsl:otherwise>
					</xsl:choose>
						</td>
					</tr>
					<tr>
						<td height="1px" bgcolor="#FF0000"/>
						<td width="2px"/>
						<td height="1px" bgcolor="#FF0000"/>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<br/>
			</td>
		</tr>
		<tr>
			<td align="center" valign="bottom" class="heading1">Servicio</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Descripción</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Cantidad</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Porcentaje</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Total</td>
		</tr>
		<tr>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
		</tr>
		<xsl:apply-templates select="detDescNumTelf "/>
		<tr>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
		</tr>
	</xsl:template>
	
	<xsl:template match="detDescNumTelf">
		<xsl:choose>
			<xsl:when test="//elementosCabecera/resumenFacturaEmpresas">
				<xsl:if test="number(@totalpapel) != 0">
					<tr>
						<td>
							<xsl:value-of select="@serv"/>
						</td>
						<td width="2px"/>
						<td>
							<xsl:value-of select="@descDesDesc"/>
						</td>
						<td width="2px"/>
						<td>
							<xsl:value-of select="@cantpapel"/>
						</td>
						<td width="2px"/>
						<td>
							<xsl:value-of select="@porcjpapel"/>
						</td>
						<td width="2px"/>
						<td>
							<xsl:value-of select="@totalpapel"/>
						</td>
					</tr>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<tr>
					<td bgcolor="#EAEAEA">
						<xsl:value-of select="@serv"/>
					</td>
					<td width="2px"/>
					<td bgcolor="#EAEAEA">
						<xsl:value-of select="@descDesDesc"/>
					</td>
					<td width="2px"/>
					<td bgcolor="#EAEAEA">
						<xsl:value-of select="@cant"/>
					</td>
					<td width="2px"/>
					<td bgcolor="#EAEAEA">
						<xsl:value-of select="@porcj"/>
					</td>
					<td width="2px"/>
					<td bgcolor="#EAEAEA">
						<xsl:value-of select="@total"/>
					</td>
				</tr>		
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:template>
	<xsl:template match="detDescNumTelfSubtotalCuenta">
		<tr>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
		</tr>
		<tr>
			<td bgcolor="#EAEAEA"><b>Total descuento a nivel cuenta</b></td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"/>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"/>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"/>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"><b><xsl:value-of select="@totalCuentaLineapapel"/></b></td>
		</tr>		
		<tr>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
		</tr>		
		<tr>
			<td colspan="9">
				<br/>
			</td>
		</tr>		
	</xsl:template>
	<xsl:template match="detDescNumTelfSubtotalLinea">	
		<tr>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
		</tr>
		<tr>
			<td bgcolor="#EAEAEA"><b>Total descuento a nivel línea</b></td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"/>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"/>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"/>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"><b><xsl:value-of select="@totalCuentaLineapapel"/></b></td>
		</tr>		
		<tr>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
		</tr>			
		<tr>
			<td colspan="9">
				<br/>
			</td>
		</tr>		
	</xsl:template>		
	<xsl:template match="detDescNumTelfTotal">
		<tr>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
		</tr>
		<tr>
			<td bgcolor="#EAEAEA"><b>Total descuento</b></td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"/>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"/>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"/>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"><b><xsl:value-of select="@totalpapel"/></b></td>
		</tr>		
		<tr>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
		</tr>				
	</xsl:template>

	<!-- DETALLE DE COMPRAS VODAFONE-->
	<xsl:template match="detallesComprasVodafone">
		<table width="70%" bgcolor="#FFFFFF" cellspacing="0" cellpadding="0" border="0">
			<tr>
				<td coldspan="11">
					<br/>
					<br/>
				</td>
			</tr>
			<tr>
				<td colspan="11" height="2px" bgcolor="#000000"/>
			</tr>
			<tr>
				<td colspan="11" class="heading3">Compras Vodafone<br/>
					<br/>
				</td>
			</tr>
			<tr>
				<td align="center" valign="bottom" class="heading1">Fecha</td>
				<td width="2px"/>
				<td align="center" valign="bottom" class="heading1">Hora</td>
				<td width="2px"/>
				<td align="center" valign="bottom" class="heading1">Número de teléfono</td>
				<td width="2px"/>
				<td align="center" valign="bottom" class="heading1">Comercio</td>
				<td width="2px"/>
				<td align="center" valign="bottom" class="heading1">Producto</td>
				<td width="2px"/>
				<td align="center" valign="bottom" class="heading1">Importe</td>
			</tr>
			<tr>
				<td height="2px" bgcolor="#FF0000"/>
				<td width="2px"/>
				<td height="2px" bgcolor="#FF0000"/>
				<td width="2px"/>
				<td height="2px" bgcolor="#FF0000"/>
				<td width="2px"/>
				<td height="2px" bgcolor="#FF0000"/>
				<td width="2px"/>
				<td height="2px" bgcolor="#FF0000"/>
				<td width="2px"/>
				<td height="2px" bgcolor="#FF0000"/>
			</tr>
				<xsl:apply-templates select="detComprasVod"/>
			<tr>
				<td height="1px" bgcolor="#FF0000"/>
				<td width="2px"/>
				<td height="1px" bgcolor="#FF0000"/>
				<td width="2px"/>
				<td height="1px" bgcolor="#FF0000"/>
				<td width="2px"/>
				<td height="1px" bgcolor="#FF0000"/>
				<td width="2px"/>
				<td height="1px" bgcolor="#FF0000"/>
				<td width="2px"/>
				<td height="1px" bgcolor="#FF0000"/>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="detComprasVod">
		<tr>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@fec"/>
			</td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@hora"/>
			</td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@serv"/>
			</td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@comer"/>
			</td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@prodr"/>
			</td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@imp"/>
			</td>
		</tr>
	</xsl:template>
	
	<!-- DETALLES DE LLAMADAS-->
	<xsl:template match="detallesLlamadasNumerosTelefono">
		<table width="70%" bgcolor="#FFFFFF" cellspacing="0" cellpadding="0" border="0">
			<tr>
				<td colspan="17">
					<br/>
					<br/>
				</td>
			</tr>
			<tr>
				<td colspan="17" height="2px" bgcolor="#000000"/>
			</tr>
			<tr>
				<td colspan="17" class="heading3">Detalle de Llamadas de Teléfono<br/>
					<br/>
				</td>
			</tr>
			<xsl:apply-templates select="lineaProductoDNT"/>
		</table>
	</xsl:template>
	<xsl:template match="lineaProductoDNT">
		<tr>
			<td colspan="17">
				<table width="100%" celpadding="0" cellspacing="0" border="0">
					<tr>
						<td height="2px" bgcolor="#FF0000"/>
						<td width="2px"/>
						<td height="2px" bgcolor="#FF0000"/>
					</tr>
					<tr>
						<td class="heading1" bgcolor="#EAEAEA">Línea de producto</td>
						<td width="2px"/>
						<td bgcolor="#EAEAEA">
							<xsl:choose>
						<xsl:when test="@codLinPro = 'TAD' and @subLinPro = '52'">
							<xsl:text>Telefonía Fija de Acceso Directo</xsl:text>
						</xsl:when>
						<xsl:when test="@codLinPro = 'TAD' and @subLinPro = 'A'">
							<xsl:text>Telefonía Móvil de Acceso Directo</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@codLinProDesc"/>
						</xsl:otherwise>
					</xsl:choose>
						</td>
					</tr>
					<tr>
						<td height="1px" bgcolor="#FF0000"/>
						<td width="2px"/>
						<td height="1px" bgcolor="#FF0000"/>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td colspan="17">
				<br/>
			</td>
		</tr>
		<xsl:apply-templates select="detLlamNumTelf"/>
	</xsl:template>
	<xsl:template match="detLlamNumTelf">
		<xsl:variable name="codLinPro" select="parent::*/@codLinPro"/>
		<xsl:variable name="subLinPro" select="parent::*/@subLinPro"/>
		<tr>
			<td colspan="17">
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td height="2px" bgcolor="#FF0000"/>
						<td width="2px"/>
						<td height="2px" bgcolor="#FF0000"/>
						<td width="2px"/>
						<td height="2px" bgcolor="#FF0000"/>
						<td width="2px"/>
						<td height="2px" bgcolor="#FF0000"/>
					</tr>
					<tr>
						<td align="left" valign="bottom" class="heading1" bgcolor="#EAEAEA">Servicio</td>
						<td width="2px"/>
						<td bgcolor="#EAEAEA">
							<xsl:value-of select="@serv"/>
						</td>
						<td width="2px"/>
						<td align="left" valign="bottom" class="heading1" bgcolor="#EAEAEA">Plan de Precios</td>
						<td width="2px"/>
						<td bgcolor="#EAEAEA">
							<xsl:value-of select="@plPrecDesc"/>
						</td>
					</tr>
					<tr>
						<td height="1px" bgcolor="#FF0000"/>
						<td width="2px"/>
						<td height="1px" bgcolor="#FF0000"/>
						<td width="2px"/>
						<td height="1px" bgcolor="#FF0000"/>
						<td width="2px"/>
						<td height="1px" bgcolor="#FF0000"/>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td colspan="17">
				<br/>
			</td>
		</tr>
		<tr>
			<td align="center" valign="bottom" class="heading1">Fecha</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Hora</td>
			<td width="2px"/>
			<xsl:if test="$codLinPro = 'TAD' and $subLinPro = '52'">
				<td align="center" valign="bottom" class="heading1">Ext.origen</td>
				<td width="2px"/>
			</xsl:if>
			<xsl:if test="$codLinPro = 'TAD' and $subLinPro = 'A'">
				<td align="center" valign="bottom" class="heading1">Ext.origen</td>
				<td width="2px"/>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="$codLinPro = 'TM' and $subLinPro = '60'">
					<td align="center" valign="bottom" class="heading1">Duración Sesión</td>
				</xsl:when>
				<xsl:when test="$codLinPro = 'TM' and $subLinPro = '80'">
					<td align="center" valign="bottom" class="heading1">Receptor</td>
				</xsl:when>
				<xsl:otherwise>
					<td align="center" valign="bottom" class="heading1">Nº Receptor</td>
				</xsl:otherwise>
			</xsl:choose>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Tipo</td>
			<td width="2px"/>
			<xsl:choose>
				<xsl:when test="$codLinPro = 'TM' and $subLinPro = '80'">
					<td align="center" valign="bottom" class="heading1">Descripción</td>
				</xsl:when>
				<xsl:otherwise>
					<td align="center" valign="bottom" class="heading1">Destino</td>
				</xsl:otherwise>
			</xsl:choose>
			<td width="2px"/>
			<xsl:choose>
				<xsl:when test="$codLinPro = 'TM' and $subLinPro = '60'">
					<td align="center" valign="bottom" class="heading1">Volumen(KB)</td>
				</xsl:when>
				<xsl:when test="$codLinPro = 'TM' and $subLinPro = '80'">
					<td align="center" valign="bottom" class="heading1">Minutos/Kb</td>
				</xsl:when>
				<xsl:otherwise>
					<td align="center" valign="bottom" class="heading1">Duración</td>
				</xsl:otherwise>
			</xsl:choose>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Tarifa</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Importe</td>
		</tr>
		<tr>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<xsl:if test="($codLinPro = 'TAD' and $subLinPro = '52') or ($codLinPro = 'TAD' and $subLinPro = 'A')">
				<td width="2px"/>
				<td height="2px" bgcolor="#FF0000"/>
			</xsl:if>
		</tr>
		<xsl:apply-templates select="detLlam">
			<xsl:with-param name="codLinPro" select="$codLinPro"/>
			<xsl:with-param name="subLinPro" select="$subLinPro"/>
		</xsl:apply-templates>
		<tr>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<xsl:if test="($codLinPro = 'TAD' and $subLinPro = '52') or ($codLinPro = 'TAD' and $subLinPro = 'A')">
				<td width="2px"/>
				<td height="2px" bgcolor="#FF0000"/>
			</xsl:if>
		</tr>		
		<xsl:apply-templates select="detLlamTotal">
			<xsl:with-param name="codLinPro" select="$codLinPro"/>
			<xsl:with-param name="subLinPro" select="$subLinPro"/>
		</xsl:apply-templates>
		<xsl:if test="//elementosCabecera/resumenFacturaEmpresas">		
			<tr>
				<td colspan="17">
					<br/>
				</td>
			</tr>
			<tr>
				<td colspan="17">
					<br/>
				</td>
			</tr>
		</xsl:if>	
	</xsl:template>
	<xsl:template match="detLlam">
		<xsl:param name="codLinPro"/>
		<xsl:param name="subLinPro"/>
		<xsl:choose>
			<xsl:when test="//elementosCabecera/resumenFacturaEmpresas">
				<tr>
					<td>
						<xsl:value-of select="@fec"/>
					</td>
					<td width="2px"/>
					<td>
						<xsl:value-of select="@hor"/>
					</td>
					<td width="2px"/>
					<xsl:if test="$codLinPro = 'TAD' and $subLinPro = '52'">
						<td>
							<xsl:value-of select="@numOg"/>
						</td>
						<td width="2px"/>
					</xsl:if>
					<xsl:if test="$codLinPro = 'TAD' and $subLinPro = 'A'">
						<td>
							<xsl:value-of select="@numOg"/>
						</td>
						<td width="2px"/>
					</xsl:if>
					<td>
						<xsl:choose>
							<xsl:when test="$codLinPro = 'TM' and $subLinPro = '60'">
								<xsl:value-of select="@volGprs"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="@nRecp"/>
							</xsl:otherwise>
						</xsl:choose>
					</td>
					<td width="2px"/>
					<td>
						<xsl:value-of select="@tLlamDesc"/>
						<xsl:if test="@tAdcLlaDesc">
							<xsl:text>(*)</xsl:text>
						</xsl:if>
						<xsl:if test="@tipoPC='P'">
							<xsl:text> PC</xsl:text>
						</xsl:if>
					</td>
					<td width="2px"/>
					<td>
						<xsl:value-of select="@destDesc"/>
					</td>
					<td width="2px"/>
					<td>
						<xsl:value-of select="@cons"/>
					</td>
					<td width="2px"/>
					<td>
						<xsl:if test="@tarfSVADesc">
							<xsl:value-of select="@tarfSVADesc"/>
						</xsl:if>
						<xsl:if test="not(@tarfSVADesc)">
							<xsl:value-of select="@tarfDesc"/>
						</xsl:if>
					</td>
					<td width="2px"/>
					<td align="right">
						<xsl:value-of select="@imp"/>
					</td>
				</tr>		
			</xsl:when>
			<xsl:otherwise>
				<tr>
					<td bgcolor="#EAEAEA">
						<xsl:value-of select="@fec"/>
					</td>
					<td width="2px"/>
					<td bgcolor="#EAEAEA">
						<xsl:value-of select="@hor"/>
					</td>
					<td width="2px"/>
					<xsl:if test="$codLinPro = 'TAD' and $subLinPro = '52'">
						<td bgcolor="#EAEAEA">
							<xsl:value-of select="@numOg"/>
						</td>
						<td width="2px"/>
					</xsl:if>
					<xsl:if test="$codLinPro = 'TAD' and $subLinPro = 'A'">
						<td bgcolor="#EAEAEA">
							<xsl:value-of select="@numOg"/>
						</td>
						<td width="2px"/>
					</xsl:if>
					<td bgcolor="#EAEAEA">
						<xsl:choose>
							<xsl:when test="$codLinPro = 'TM' and $subLinPro = '60'">
								<xsl:value-of select="@volGprs"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="@nRecp"/>
							</xsl:otherwise>
						</xsl:choose>
					</td>
					<td width="2px"/>
					<td bgcolor="#EAEAEA">
						<xsl:value-of select="@tLlamDesc"/>
						<xsl:if test="@tAdcLlaDesc">
							<xsl:text>(*)</xsl:text>
						</xsl:if>
						<xsl:if test="@tipoPC='P'">
							<xsl:text> PC</xsl:text>
						</xsl:if>
					</td>
					<td width="2px"/>
					<td bgcolor="#EAEAEA">
						<xsl:value-of select="@destDesc"/>
					</td>
					<td width="2px"/>
					<td bgcolor="#EAEAEA">
						<xsl:value-of select="@cons"/>
					</td>
					<td width="2px"/>
					<td bgcolor="#EAEAEA">
						<xsl:if test="@tarfSVADesc">
							<xsl:value-of select="@tarfSVADesc"/>
						</xsl:if>
						<xsl:if test="not(@tarfSVADesc)">
							<xsl:value-of select="@tarfDesc"/>
						</xsl:if>
					</td>
					<td width="2px"/>
					<td bgcolor="#EAEAEA" align="right">
						<xsl:value-of select="@imp"/>
					</td>
				</tr>				
			</xsl:otherwise>
		</xsl:choose>		
	</xsl:template>

	<xsl:template match="detLlamTotal">
		<xsl:param name="codLinPro"/>
		<xsl:param name="subLinPro"/>
		<tr>
			<td bgcolor="#EAEAEA"><b>Total</b></td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"/>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"/>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"/>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"/>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"/>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"/>
			<xsl:if test="($codLinPro = 'TAD' and $subLinPro = '52') or ($codLinPro = 'TAD' and $subLinPro = 'A')">
				<td width="2px"/>
				<td bgcolor="#EAEAEA"/>
			</xsl:if>
			<td width="2px"/>
			<td bgcolor="#EAEAEA"><b><xsl:value-of select="@total"/></b></td>
        </tr>
		<tr>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<xsl:if test="($codLinPro = 'TAD' and $subLinPro = '52') or ($codLinPro = 'TAD' and $subLinPro = 'A')">
				<td width="2px"/>
				<td height="2px" bgcolor="#FF0000"/>
			</xsl:if>
		</tr>		
	</xsl:template>
	
	<!-- RESUMEN INFORMATIVO IMPORTES -->
	<xsl:template match="resumenInformativoImportes">
		<table width="70%" bgcolor="#FFFFFF" cellspacing="0" cellpadding="0" border="0">
			<tr>
				<td>
					<br/>
					<br/>
				</td>
			</tr>
			<tr>
				<td colspan="19" height="2px" bgcolor="#000000"/>
			</tr>
			<tr>
				<td colspan="19" class="heading3">Resumen Informativo de Importes<br/>
					<br/>
				</td>
			</tr>
			<tr>
				<td align="center" valign="bottom" class="heading1">Concepto</td>
				<td width="2px"/>
				<td align="center" valign="bottom" class="heading1">Importe</td>
			</tr>
			<tr>
				<td height="2px" bgcolor="#FF0000"/>
				<td width="2px"/>
				<td height="2px" bgcolor="#FF0000"/>
			</tr>
			<xsl:for-each select="totalInformativo">
				<tr>
					<td bgcolor="#EAEAEA">
						<xsl:value-of select="@conceptoDesc"/>
					</td>
					<td width="2px"/>
					<td bgcolor="#EAEAEA">
						<xsl:value-of select="@importe"/>
					</td>
				</tr>
			</xsl:for-each>
			<tr>
				<td height="1px" bgcolor="#FF0000"/>
				<td width="2px"/>
				<td height="1px" bgcolor="#FF0000"/>
			</tr>
		</table>
	</xsl:template>
	
    <xsl:template match="detInteresDemora">
		<tr>
			<td class="headding1" width="98px" bgcolor="#EAEAEA">
				<xsl:value-of select="@FactReferencia"/>
			</td>
			<td width="2"/>
			<td width="98px" bgcolor="#EAEAEA">
				<xsl:value-of select="@impDeudor"/>
			</td>
			<td width="2"/>
			<td width="98px" bgcolor="#EAEAEA">
				<xsl:value-of select="@porcentaje_InteresDemora"/>
				<xsl:text>%</xsl:text>
			</td>
			<td width="2"/>
			<td width="98px" bgcolor="#EAEAEA">
				<xsl:value-of select="@impCargo"/>
			</td>
		</tr>
    </xsl:template>   	
	
	<xsl:template match="lineaProductoDOC ">
		<tr>
			<td colspan="5">
				<table width="100%" celpadding="0" cellspacing="0" border="0">
					<tr>
						<td height="2px" bgcolor="#FF0000"/>
						<td width="2px"/>
						<td height="2px" bgcolor="#FF0000"/>
					</tr>
					<tr>
						<td class="heading1" bgcolor="#EAEAEA">Línea de producto</td>
						<td width="2px"/>
						<td bgcolor="#EAEAEA">
							<xsl:choose>
						<xsl:when test="@codLinPro = 'TAD' and @subLinPro = '52'">
							<xsl:text>Telefonía Fija de Acceso Directo</xsl:text>
						</xsl:when>
						<xsl:when test="@codLinPro = 'TAD' and @subLinPro = 'A'">
							<xsl:text>Telefonía Móvil de Acceso Directo</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@codLinProDesc"/>
						</xsl:otherwise>
					</xsl:choose>
						</td>
					</tr>
					<tr>
						<td height="1px" bgcolor="#FF0000"/>
						<td width="2px"/>
						<td height="1px" bgcolor="#FF0000"/>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<br/>
			</td>
		</tr>
		<tr>
			<td align="center" valign="bottom" class="heading1">Servicio</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Cuota</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Importe</td>
		</tr>
		<tr>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
		</tr>
		<xsl:apply-templates select="detOtrCuot "/>
		<tr>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
		</tr>
	</xsl:template>
	<xsl:template match="detOtrCuot ">
		<tr>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@serv"/>
			</td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@cuotDesc"/>
			</td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@imp"/>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="lineaProductoDOCA">
		<tr>
			<td colspan="7">
				<table width="100%" celpadding="0" cellspacing="0" border="0">
					<tr>
						<td height="2px" bgcolor="#FF0000"/>
						<td width="2px"/>
						<td height="2px" bgcolor="#FF0000"/>
					</tr>
					<tr>
						<td class="heading1" bgcolor="#EAEAEA">Línea de producto</td>
						<td width="2px"/>
						<td bgcolor="#EAEAEA">
							<xsl:choose>
						<xsl:when test="@codLinPro = 'TAD' and @subLinPro = '52'">
							<xsl:text>Telefonía Fija de Acceso Directo</xsl:text>
						</xsl:when>
						<xsl:when test="@codLinPro = 'TAD' and @subLinPro = 'A'">
							<xsl:text>Telefonía Móvil de Acceso Directo</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@codLinProDesc"/>
						</xsl:otherwise>
					</xsl:choose>
						</td>
					</tr>
					<tr>
						<td height="1px" bgcolor="#FF0000"/>
						<td width="2px"/>
						<td height="1px" bgcolor="#FF0000"/>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<br/>
			</td>
		</tr>
		<tr>
			<td align="center" valign="bottom" class="heading1">Servicio</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Descripción</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Tipo de Cargo/Ajuste</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Importe</td>
		</tr>
		<tr>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
		</tr>
		<xsl:apply-templates select="detOtrosCargAj "/>
		<tr>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
		</tr>
	</xsl:template>
	<xsl:template match="detOtrosCargAj">
		<tr>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@serv"/>
			</td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@descS"/>
			</td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@tCargAjusDesc"/>
			</td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@imp"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="lineaProductoDRT">
		<tr>
			<td align="center" valign="bottom" class="heading1">Fecha</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Hora</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Número de teléfono</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Tipo de cargo</td>
			<td width="2px"/>
			<td align="center" valign="bottom" class="heading1">Importe</td>
		</tr>
		<tr>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="2px" bgcolor="#FF0000"/>
		</tr>
		<xsl:apply-templates select="detRecargaTar"/>
		<tr>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
			<td width="2px"/>
			<td height="1px" bgcolor="#FF0000"/>
		</tr>
	</xsl:template>
	<xsl:template match="detRecargaTar">
		<tr>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@fec"/>
			</td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@hora"/>
			</td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@serv"/>
			</td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@tRecargaDesc"/>
			</td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@imp"/>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="pagoUltimaFactura">
		<tr>
			<td bgcolor="#EAEAEA">
				<xsl:value-of select="@fec"/>
			</td>
			<td width="2px"/>
			<td bgcolor="#EAEAEA" align="right">
				<xsl:value-of select="@imp"/>
			</td>
		</tr>
	</xsl:template>	
	
</xsl:stylesheet>
