<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
	xmlns:eno="http://xml.insee.fr/apps/eno" xmlns:enoodt="http://xml.insee.fr/apps/eno/out/odt"
	xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
	xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0"
	exclude-result-prefixes="xs fn xd eno enoodt"
	version="2.0">

	<xsl:import href="../../../styles/style.xsl"/>

	<xsl:param name="properties-file"/>

	<xsl:variable name="properties" select="doc($properties-file)"/>
	<xsl:param name="office-headers">office-headers.xml</xsl:param>

	<!-- Forces the traversal of the whole driver tree. Must be present once in the transformation. -->
	<xsl:template match="*" mode="model" priority="-1">
		<xsl:param name="source-context" as="item()" tunnel="yes"/>
		<xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
			<xsl:with-param name="driver" select="." tunnel="yes"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- Match on the Form driver: write the root of the document with the main title -->
	<xsl:template match="Form" mode="model">
		<xsl:param name="source-context" as="item()" tunnel="yes"/>
		<xsl:variable name="languages" select="enoodt:get-form-languages($source-context)" as="xs:string +"/>

		<office:document office:version="1.2" office:mimetype="application/vnd.oasis.opendocument.text">
			<office:font-face-decls>
				<style:font-face style:name="Arial" svg:font-family="Arial" style:font-family-generic="system" style:font-pitch="variable"/>
			</office:font-face-decls>

    <office:styles>
        <style:style style:name="Standard" style:family="paragraph" style:class="text"/>
        <style:style style:name="Title" style:family="paragraph" style:class="chapter">
            <style:paragraph-properties fo:text-align="center" fo:margin-top="3cm" style:justify-single-word="false"/>
            <style:text-properties fo:font-size="36pt" fo:font-weight="bold" fo:color="#7b7c7c"/>
        </style:style>
        <style:style style:name="TitleComment" style:family="paragraph">
            <style:paragraph-properties fo:text-align="center" fo:margin-top="3cm" style:justify-single-word="false"/>
            <style:text-properties fo:font-size="22pt" fo:font-weight="bold"/>
        </style:style>
        <style:style style:name="Module" style:family="paragraph" style:default-outline-level="1" style:class="text">
            <style:paragraph-properties fo:text-align="left" fo:break-before="page"/>
            <style:text-properties fo:font-size="24pt" fo:font-weight="bold"/>
        </style:style>
        <style:style style:name="SubModule" style:family="paragraph" style:default-outline-level="2" style:class="text">
            <style:paragraph-properties fo:text-align="left"/>
            <style:text-properties fo:font-size="20pt" fo:font-weight="bold" fo:color="#ff3333"/>
        </style:style>
        <style:style style:name="Question" style:family="paragraph" style:default-outline-level="2" style:class="text">
            <style:paragraph-properties fo:text-align="left"/>
            <style:text-properties fo:font-size="14pt" fo:font-weight="bold" fo:color="#6666ff"/>
        </style:style>
        <style:style style:name="QuestionSelect" style:family="paragraph" style:default-outline-level="2" style:class="text">
            <style:paragraph-properties fo:text-align="left"/>
            <style:text-properties fo:font-size="14pt" fo:font-weight="bold" fo:color="#a5106c"/>
        </style:style>
        <style:style style:name="ModuleInstruction" style:family="paragraph" style:default-outline-level="2" style:class="text">
            <style:paragraph-properties fo:text-align="right"/>
            <style:text-properties fo:font-size="14pt" fo:font-weight="bold" style:text-underline-style="solid"/>
        </style:style>
        <style:style style:name="OtherInstruction" style:family="paragraph" style:default-outline-level="2" style:class="text">
            <style:paragraph-properties fo:text-align="right"/>
            <style:text-properties fo:font-size="14pt" fo:font-weight="bold"/>
        </style:style>
        <style:style style:name="CodeItem" style:family="paragraph" style:default-outline-level="2" style:class="text">
            <style:text-properties fo:font-size="12pt" fo:background-color="#d3d3d3"/>
        </style:style>
    </office:styles>
			
			<office:body>
				<office:text>
					<text:p text:style-name="Title"><xsl:value-of select="enoodt:get-label($source-context, $languages[1])"/></text:p>
					<text:p text:style-name="TitleComment">Specification generated</text:p>
				</office:text>
				<!-- Returns to the parent -->
				<xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
					<xsl:with-param name="driver" select="." tunnel="yes"/>
				</xsl:apply-templates>
			</office:body>
		</office:document>
	</xsl:template>

	<!-- Match on the Module driver: write the module label -->
	<xsl:template match="Module" mode="model">
		<xsl:param name="source-context" as="item()" tunnel="yes"/>
		<xsl:variable name="languages" select="enoodt:get-form-languages($source-context)" as="xs:string +"/>
		<office:text>
			<text:p text:style-name="Module"><xsl:value-of select="enoodt:get-label($source-context, $languages[1])"/></text:p>
		</office:text>
		<!-- Returns to the parent -->
		<xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
			<xsl:with-param name="driver" select="." tunnel="yes"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- Match on the SubModule driver: write the sub-module label -->
	<xsl:template match="SubModule" mode="model">
		<xsl:param name="source-context" as="item()" tunnel="yes"/>
		<xsl:variable name="languages" select="enoodt:get-form-languages($source-context)" as="xs:string +"/>
		<office:text>
			<text:p text:style-name="SubModule"><xsl:value-of select="enoodt:get-label($source-context, $languages[1])"/></text:p>
		</office:text>
		<!-- Returns to the parent -->
		<xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
			<xsl:with-param name="driver" select="." tunnel="yes"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- Match on the xf-input driver: write the question label (does not seem to match anything in the Simpson questionnaire) -->
	<xsl:template match="xf-input" mode="model">
		<xsl:param name="source-context" as="item()" tunnel="yes"/>
		<xsl:variable name="languages" select="enoodt:get-form-languages($source-context)" as="xs:string +"/>

		<office:text>
			<text:p text:style-name="Question"><xsl:value-of select="enoodt:get-label($source-context, $languages[1])"/></text:p>
		</office:text>

		<!-- Returns to the parent -->
		<xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
			<xsl:with-param name="driver" select="." tunnel="yes"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- Match on the xf-select driver: write the question label -->
	<xsl:template match="xf-select1" mode="model">
		<xsl:param name="source-context" as="item()" tunnel="yes"/>
		<xsl:variable name="languages" select="enoodt:get-form-languages($source-context)" as="xs:string +"/>
		
		<office:text>
			<text:p text:style-name="QuestionSelect"><xsl:value-of select="enoodt:get-label($source-context, $languages[1])"/></text:p>
		</office:text>
		
		<!-- Returns to the parent -->
		<xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
			<xsl:with-param name="driver" select="." tunnel="yes"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- Match on the Table driver: write the question label -->
	<xsl:template match="Table" mode="model">
		<xsl:param name="source-context" as="item()" tunnel="yes"/>
		<xsl:variable name="languages" select="enoodt:get-form-languages($source-context)" as="xs:string +"/>
		
		<office:text>
			<text:p text:style-name="Question"><xsl:value-of select="enoodt:get-label($source-context, $languages[1])"/></text:p>
		</office:text>
		
		<!-- Returns to the parent -->
		<xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
			<xsl:with-param name="driver" select="." tunnel="yes"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- Match on the xf-item driver: write the code value and label -->
	<xsl:template match="xf-item" mode="model">
		<xsl:param name="source-context" as="item()" tunnel="yes"/>
		<xsl:variable name="languages" select="enoodt:get-form-languages($source-context)" as="xs:string +"/>

		<office:text>
			<text:p text:style-name="CodeItem">
				<xsl:value-of select="fn:concat(enoodt:get-value($source-context), ' - ', enoodt:get-label($source-context, $languages[1]))"/>
			</text:p>
		</office:text>
		
		<!-- Returns to the parent -->
		<xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
			<xsl:with-param name="driver" select="." tunnel="yes"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- Match on the xf-output driver: write the instruction text, with a different styles for module and question instructions -->
	<xsl:template match="xf-output" mode="model">
		<xsl:param name="source-context" as="item()" tunnel="yes"/>
		<xsl:variable name="languages" select="enoodt:get-form-languages($source-context)" as="xs:string +"/>

		<xsl:choose>
			<xsl:when test="parent::Module"> <!-- Test if parent is a module -->
				<office:text>
					<text:p text:style-name="ModuleInstruction"><xsl:value-of select="enoodt:get-label($source-context, $languages[1])"/></text:p>
					<text:p text:style-name="ModuleInstruction"><xsl:value-of select="enoodt:get-format($source-context)"/></text:p>
				</office:text>				
			</xsl:when>
			<xsl:otherwise>
				<office:text>
					<text:p text:style-name="OtherInstruction"><xsl:value-of select="enoodt:get-label($source-context, $languages[1])"/></text:p>
					<text:p text:style-name="OtherInstruction"><xsl:value-of select="enoodt:get-format($source-context)"/></text:p>
				</office:text>
			</xsl:otherwise>
		</xsl:choose>
		<!-- Returns to the parent -->
		<xsl:apply-templates select="eno:child-fields($source-context)" mode="source">
			<xsl:with-param name="driver" select="." tunnel="yes"/>
		</xsl:apply-templates>

	</xsl:template>

</xsl:stylesheet>
