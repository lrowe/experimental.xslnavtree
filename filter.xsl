<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="1.0"
    xmlns:xml="http://www.w3.org/XML/1998/namespace"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    >

    <xsl:output indent="yes" omit-xml-declaration="yes"/>

    <xsl:param name="base" select="''"/>
    <xsl:param name="id" select="'id4567'"/>
    <xsl:param name="top" select="1"/>
    <xsl:param name="bottom" select="0"/>

    <xsl:variable name="target" select="id($id)"/>
    <xsl:variable name="ancestors" select ="$target/ancestor-or-self::*"/>


    <xsl:template match="*">
        <xsl:param name="level" select="0"/>
        <xsl:choose>
            <xsl:when test="$level = $top">
                <xsl:apply-templates select="." mode="output">
                    <xsl:with-param name="level" select="$level"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="*[count(.|$ancestors)=count($ancestors)]">
                    <xsl:with-param name="level" select="$level+1"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*" mode="output">
        <xsl:param name="level"/>
        <xsl:param name="navTreeLevel" select="0"/>
        <xsl:variable name="this" select="@xml:id"/>
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="navTreeLevel"><xsl:value-of select="$navTreeLevel"/></xsl:attribute>
            <xsl:attribute name="level"><xsl:value-of select="$level"/></xsl:attribute>
            <xsl:if test="$ancestors[@xml:id = $this]">
                <xsl:apply-templates select="*" mode="output">
                    <xsl:with-param name="level" select="$level+1"/>
                    <xsl:with-param name="navTreeLevel" select="$navTreeLevel+1"/>
                </xsl:apply-templates>
            </xsl:if>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
