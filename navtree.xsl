<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="1.0"
    xmlns:xml="http://www.w3.org/XML/1998/namespace"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    >

    <xsl:output indent="yes" omit-xml-declaration="yes"/>

    <xsl:param name="base" select="''"/>
    <xsl:param name="id" select="'id4567'"/>
    <xsl:param name="topLevel" select="1"/>
    <xsl:param name="bottomLevel" select="0"/>
    <xsl:param name="includeTop" select="true()"/>

    <xsl:variable name="current" select="id($id)"/>
    <xsl:variable name="ancestors" select="$current/ancestor::*"/>
    <xsl:variable name="currentpath" select="$current/ancestor-or-self::*"/>


    <xsl:template match="*">
        <xsl:param name="level" select="0"/>
        <xsl:choose>
            <xsl:when test="$level = $topLevel">
                <xsl:apply-templates select="." mode="top"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="*[count(.|$currentpath)=count($currentpath)]">
                    <xsl:with-param name="level" select="$level+1"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*" mode="top">
        <xsl:param name="navTreeLevel" select="0"/>
        <xsl:if test="*">
            <ul class="navTree navTreeLevel{$navTreeLevel}">
                <xsl:if test="$includeTop">
                    <xsl:variable name="navTreeCurrentNode">
                        <xsl:if test="$current = ."> navTreeCurrentNode</xsl:if>
                    </xsl:variable>
                    <li class="navTreeItem navTreeTopNode{$navTreeCurrentNode}"><xsl:copy-of select="@xml:id"/>
                        <div>
                            <a href="{$base}{@p}" class="contenttype-{@ct}" title="{@d}">
                                <xsl:value-of select="@t"/>
                            </a>
                        </div>
                    </li>
                </xsl:if>
                <xsl:apply-templates select="*" mode="navtree">
                    <xsl:with-param name="navTreeLevel" select="$navTreeLevel+1"/>
                </xsl:apply-templates>
            </ul>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*" mode="navtree">
        <xsl:param name="navTreeLevel" select="0"/>
        <xsl:variable name="this" select="@xml:id"/>
        <xsl:variable name="navTreeFolderish">
            <xsl:if test="@f"> navTreeFolderish</xsl:if>
        </xsl:variable>
        <xsl:variable name="navTreeItemInPath">
            <xsl:if test="$ancestors[@xml:id = $this]"> navTreeItemInPath</xsl:if>
        </xsl:variable>
        <xsl:variable name="navTreeCurrentNode">
            <xsl:if test="$current = ."> navTreeCurrentNode</xsl:if>
        </xsl:variable>
        <xsl:variable name="navTreeCurrentItem">
            <xsl:if test="$current = ."> navTreeCurrentItem</xsl:if>
        </xsl:variable>
        <li class="navTreeItem visualNoMarker section-{@n}{navTreeItemInPath}{navTreeCurrentNode}{navTreeFolderish}"><xsl:copy-of select="@xml:id"/>
            <a href="{$base}{@p}" class="state-{@s} contenttype-{@ct}{navTreeItemInPath}{navTreeCurrentItem}{navTreeCurrentNode}{navTreeFolderish}" title="{@d}">
                <span><xsl:value-of select="@t"/></span>
            </a>
            <xsl:if test="(not($bottomLevel) or $navTreeLevel &lt; $bottomLevel) and $currentpath[@xml:id = $this]">
                <ul class="navTree navTreeLevel{$navTreeLevel}">
                    <xsl:apply-templates select="*" mode="navtree">
                        <xsl:with-param name="navTreeLevel" select="$navTreeLevel+1"/>
                    </xsl:apply-templates>
                </ul>
            </xsl:if>
        </li>
    </xsl:template>

</xsl:stylesheet>
