<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:exkt="http://www.exaktime.com">
  <xsl:output method="text" indent="no" encoding="UTF-8" media-type="text/plain"/>
  <xsl:strip-space elements="*"/>
  <xsl:variable name="Qualifier">
    <xsl:choose>
      <xsl:when test="exists(/ExporterData/row[1]/@SET_textDelimiter)">
        <xsl:choose>
          <xsl:when test="string-length(/ExporterData/row[1]/@SET_textDelimiter) > 0 and upper-case(/ExporterData/row[1]/@SET_textDelimiter)!= '&lt;NONE&gt;'">
            <xsl:value-of select="/ExporterData/row[1]/@SET_textDelimiter"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:otherwise>
        <xsl:text>&#34;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="apos">
    <xsl:text>&#8217;</xsl:text>
  </xsl:variable>

  <xsl:variable name="Delimiter">
    <xsl:text>&#44;</xsl:text>
  </xsl:variable>

  <xsl:variable name="QDQ">
    <xsl:value-of select="$Qualifier"/>
    <xsl:value-of select="$Delimiter"/>
    <xsl:value-of select="$Qualifier"/>
  </xsl:variable>

  <xsl:variable name="vShift">
    <xsl:choose>
      <xsl:when test="exists(/ExporterData/row[1]/@SET_exportShiftAssignments)">
        <xsl:choose>
          <xsl:when test="/ExporterData/row[1]/@SET_exportShiftAssignments = 'True'">
            <xsl:text>T</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>F</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>F</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:function name="exkt:GetMappingValue">
    <xsl:param name="SettingName"/>
    <xsl:param name="Row"/>
    <xsl:variable name="v_udf">
      <xsl:choose>
        <xsl:when test="exists($Row/@*[name() = $SettingName]) and upper-case($Row/@*[name() = $SettingName])!= '&lt;NONE&gt;'">
          <xsl:value-of select="substring-after($Row/@*[name() = $SettingName], '|')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="''"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="string-length($v_udf)>0">
        <xsl:choose>
          <xsl:when test="exists($Row/@*[name() = $v_udf]) and string-length($Row/@*[name() = $v_udf])>0">
            <xsl:value-of select="$Row/@*[name() = $v_udf]"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="''"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="exkt:PayID">
    <xsl:param name="PayTypeDesc"/>
    <xsl:param name="PayTypeSettingsCode"/>
    <xsl:param name="Row"/>

    <!--Either mapped or set PayID-->
    <xsl:choose>
      <!--Site-->
      <xsl:when test="$vAltPayID = 'Site|udfsAlternativePayIDReg'">
        <xsl:choose>
          <xsl:when test="$PayTypeDesc = 'R'">
            <xsl:choose>
              <xsl:when test="exists($Row/@udfsAlternativePayIDReg) and string-length($Row/@udfsAlternativePayIDReg)  > 0">
                <xsl:value-of select="normalize-space($Row/@udfsAlternativePayIDReg)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="normalize-space($PayTypeSettingsCode)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$PayTypeDesc = 'O'">
            <xsl:choose>
              <xsl:when test="exists($Row/@udfsAlternativePayIDOT) and string-length($Row/@udfsAlternativePayIDOT) > 0">
                <xsl:value-of select="normalize-space($Row/@udfsAlternativePayIDOT)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="normalize-space($PayTypeSettingsCode)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$PayTypeDesc = 'O2'">
            <xsl:choose>
              <xsl:when test="exists($Row/@udfsAlternativePayIDOT2) and string-length($Row/@udfsAlternativePayIDOT2) > 0">
                <xsl:value-of select="normalize-space($Row/@udfsAlternativePayIDOT2)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="normalize-space($PayTypeSettingsCode)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <!--Employee-->
      <xsl:when test="$vAltPayID = 'Employee|udfeAlternativePayIDReg'">
        <xsl:choose>
          <xsl:when test="$PayTypeDesc = 'R'">
            <xsl:choose>
              <xsl:when test="exists($Row/@udfeAlternativePayIDReg) and string-length($Row/@udfeAlternativePayIDReg) > 0">
                <xsl:value-of select="normalize-space($Row/@udfeAlternativePayIDReg)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="normalize-space($PayTypeSettingsCode)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$PayTypeDesc = 'O'">
            <xsl:choose>
              <xsl:when test="exists($Row/@udfeAlternativePayIDOT) and string-length($Row/@udfeAlternativePayIDOT) > 0">
                <xsl:value-of select="normalize-space($Row/@udfeAlternativePayIDOT)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="normalize-space($PayTypeSettingsCode)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$PayTypeDesc = 'O2'">
            <xsl:choose>
              <xsl:when test="exists($Row/@udfeAlternativePayIDOT2) and string-length($Row/@udfeAlternativePayIDOT2) > 0">
                <xsl:value-of select="normalize-space($Row/@udfeAlternativePayIDOT2)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="normalize-space($PayTypeSettingsCode)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <!--Cost Code-->
      <xsl:when test="$vAltPayID = 'Activities|udfaAlternativePayIDReg'">
        <xsl:choose>
          <xsl:when test="$PayTypeDesc = 'R'">
            <xsl:choose>
              <xsl:when test="exists($Row/@udfaAlternativePayIDReg) and string-length($Row/@udfaAlternativePayIDReg) > 0">
                <xsl:value-of select="normalize-space($Row/@udfaAlternativePayIDReg)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="normalize-space($PayTypeSettingsCode)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$PayTypeDesc = 'O'">
            <xsl:choose>
              <xsl:when test="exists($Row/@udfaAlternativePayIDOT) and string-length($Row/@udfaAlternativePayIDOT) > 0">
                <xsl:value-of select="normalize-space($Row/@udfaAlternativePayIDOT)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="normalize-space($PayTypeSettingsCode)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$PayTypeDesc = 'O2'">
            <xsl:choose>
              <xsl:when test="exists($Row/@udfaAlternativePayIDOT2) and string-length($Row/@udfaAlternativePayIDOT2) > 0">
                <xsl:value-of select="normalize-space($Row/@udfaAlternativePayIDOT2)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="normalize-space($PayTypeSettingsCode)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="normalize-space($PayTypeSettingsCode)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:variable name="vAltPayID">
    <xsl:choose>
      <xsl:when test="exists(/ExporterData/row[1]/@SET_alternativePayIDReg) and upper-case(/ExporterData/row[1]/@SET_alternativePayIDReg)!= '&lt;NONE&gt;'">
        <xsl:value-of select="/ExporterData/row[1]/@SET_alternativePayIDReg"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:template match="ExporterData">
    <xsl:for-each select="/ExporterData/row">
      <xsl:sort select="@udfEmployeeNumber" order="ascending"></xsl:sort>
      <xsl:sort select="@WorkDate" order="ascending"/>
      <xsl:if test="@Regular>0">
        <xsl:call-template name="exporterRecord">
          <xsl:with-param name="hours" select="xs:double(normalize-space(translate(@Regular, ',', '')))"/>
          <xsl:with-param name="payType" select="exkt:PayID('R',normalize-space(@SET_regularPayID),self::node())"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="@OT1>0">
        <xsl:call-template name="exporterRecord">
          <xsl:with-param name="hours" select="xs:double(normalize-space(translate(@OT1, ',', '')))"/>
          <xsl:with-param name="payType" select="exkt:PayID('O', normalize-space(@SET_overtimePayID),self::node())"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="@OT2>0">
        <xsl:call-template name="exporterRecord">
          <xsl:with-param name="hours" select="xs:double(normalize-space(translate(@OT2, ',', '')))"/>
          <xsl:with-param name="payType" select="exkt:PayID('O2', normalize-space(@SET_overtime2PayID),self::node())"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:for-each>

  </xsl:template>

  <xsl:template name="exporterRecord">
    <xsl:param name="hours"/>
    <xsl:param name="payType"/>

    <!-- Employee First Name -->
    <xsl:value-of select="$Qualifier"/>
    <xsl:choose>
      <xsl:when test="exists(@FirstName)">
        <xsl:value-of select="normalize-space(translate(@FirstName, $apos, ''))"/>
      </xsl:when>
    </xsl:choose>
    <xsl:value-of select="$QDQ"/>

    <!-- Employee Last Name and Suffix -->
    <xsl:choose>
      <xsl:when test="exists(@LastName)">
        <xsl:value-of select="normalize-space(translate(concat(@LastName, ' ', @Suffix), $apos, ''))"/>
      </xsl:when>
    </xsl:choose>
    <xsl:value-of select="$QDQ"/>

    <!-- Employee Number -->
    <xsl:choose>
      <xsl:when test="exists(@udfEmployeeNumber)">
        <xsl:value-of select="normalize-space(@udfEmployeeNumber)"/>
      </xsl:when>
    </xsl:choose>
    <xsl:value-of select="$QDQ"/>

    <!-- Earnings Code -->
    <xsl:value-of select="$payType"/>
    <xsl:value-of select="$QDQ"/>

    <!--Hours Worked -->
    <xsl:choose>
      <xsl:when test="exists($hours) and $hours>0">
        <xsl:value-of select="normalize-space(xs:string(format-number($hours, '#0.00')))"/>
      </xsl:when>
    </xsl:choose>
    <xsl:value-of select="$QDQ"/>

    <!--Date Worked-->
    <xsl:choose>
      <xsl:when test="string-length(@WorkDate) > 0">
        <xsl:value-of select="normalize-space(format-dateTime(@WorkDate ,'[M01]/[D01]/[Y0001]'))"/>
      </xsl:when>
    </xsl:choose>
    <xsl:value-of select="$QDQ"/>

    <!--Blank-->
    <xsl:value-of select="$QDQ"/>

    <!--Blank-->
    <xsl:value-of select="$QDQ"/>

    <!--Cost Code-->
    <xsl:text>500</xsl:text>
    <xsl:value-of select="$QDQ"/>

    <!-- Jobsite # -->
    <xsl:choose>
      <xsl:when test="exists(@udfJobsiteNumber)">
        <xsl:value-of select="normalize-space(@udfJobsiteNumber)"/>
      </xsl:when>
    </xsl:choose>
    <xsl:value-of select="$QDQ"/>

    <!--Phase Cost Code-->
    <xsl:choose>
      <xsl:when test="exists(@udfCostCode)">
        <xsl:value-of select="normalize-space(translate(@udfCostCode, $apos, ''))"/>
      </xsl:when>
    </xsl:choose>

    <xsl:value-of select="$Qualifier"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template name="ColumnHeaders">
    <xsl:value-of select="$Qualifier"/>
    <xsl:text>Employee</xsl:text>
    <xsl:value-of select="$QDQ"/>
    <xsl:text>Employee Last</xsl:text>
    <xsl:value-of select="$QDQ"/>
    <xsl:text>EMP ID</xsl:text>
    <xsl:value-of select="$QDQ"/>
    <xsl:text>Earnings Code</xsl:text>
    <xsl:value-of select="$QDQ"/>
    <xsl:text>Hours</xsl:text>
    <xsl:value-of select="$QDQ"/>
    <xsl:text>Date Worked</xsl:text>
    <xsl:value-of select="$QDQ"/>
    <xsl:text>Blank</xsl:text>
    <xsl:value-of select="$QDQ"/>
    <xsl:text>Blank</xsl:text>
    <xsl:value-of select="$QDQ"/>
    <xsl:text>Cost Code</xsl:text>
    <xsl:value-of select="$QDQ"/>
    <xsl:text>Job #</xsl:text>
    <xsl:value-of select="$QDQ"/>
    <xsl:text>Phase</xsl:text>
    <xsl:if test="$vShift = 'T'">
      <xsl:value-of select="$QDQ"/>
      <xsl:text>Shift</xsl:text>
    </xsl:if>
    <xsl:value-of select="$Qualifier"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>
</xsl:stylesheet>