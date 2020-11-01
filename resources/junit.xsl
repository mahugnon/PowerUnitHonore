<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">	
    <xsl:output method="xml"/>	
    <xsl:param name="applicationPath">./</xsl:param>
    <xsl:template match="/">
        <xsl:variable name="tests.root" select="cruisecontrol//pbunit-test-results" />
       
        <xsl:apply-templates select="$tests.root" />     
    </xsl:template>
    
    <!-- Test suites template -->
    <xsl:template match="pbunit-test-results">
        <xsl:variable name="test.suites.id" select="generate-id()" />
        <xsl:variable name="test.suite.name" select="./@name"/>
        <xsl:variable name="test.count" select="count(.//results/test-case)" />
        <xsl:variable name="failure.count" select="count(.//results/test-case[@success='False'])" />
        <xsl:variable name="ignored.count" select="count(.//results/test-case[@executed='False'])" />
      <xsl:variable name="test.time" select="sum(number(.//results/test-case/@time))" />
        <testsuites>

            <xsl:attribute name="id">
                <xsl:value-of select="$test.suites.id"/>
                
            </xsl:attribute>
            <xsl:attribute name="name">
                <xsl:value-of select="$test.suite.name" />
            </xsl:attribute>
            <xsl:attribute name="tests">
                <xsl:value-of select="$test.count"/>
            </xsl:attribute>
            <xsl:attribute name="failures">
                <xsl:value-of select="$failure.count"/>
            </xsl:attribute>
            <xsl:attribute name="time">
                <xsl:value-of select="$test.time"/>
            </xsl:attribute>
            <xsl:text>
</xsl:text>
            <xsl:apply-templates select=".//test-suite">
                <xsl:sort select="@name" order="ascending" data-type="text"/>
            </xsl:apply-templates>
        </testsuites>
    </xsl:template>
    
    <!-- Test suit template -->
    <xsl:template match="test-suite">
        <xsl:variable name="passedtests.list" select="results/test-case[@success='True']"/>
        <xsl:variable name="ignoredtests.list" select="results/test-case[@executed='False']"/>
        <xsl:variable name="failedtests.list" select="results/test-case[@success='False']"/>
        <xsl:variable name="tests.count" select="count(results/test-case)"/>
        <xsl:variable name="test.suite.id" select="generate-id()" />
        <xsl:variable name="tests.time" select="sum(number(results/test-case/@time))"/>
        <xsl:variable name="passedtests.count" select="count($passedtests.list)"/>
        <xsl:variable name="ignoredtests.count" select="count($ignoredtests.list)"/>
        <xsl:variable name="failedtests.count" select="count($failedtests.list)"/>
        <testsuite>
            <xsl:attribute name="id">
                <xsl:value-of select="$test.suite.id"/>
            </xsl:attribute>
            <xsl:attribute name="name">
                <xsl:value-of select="@name"/>
            </xsl:attribute>
            <xsl:attribute name="tests">
                <xsl:value-of select="$tests.count"/>
            </xsl:attribute>
            <xsl:attribute name="failures">
                <xsl:value-of select="$failedtests.count"/>
            </xsl:attribute>
            <xsl:attribute name="time">
                <xsl:value-of select="$tests.time"/>
            </xsl:attribute>
            <xsl:text>
</xsl:text>
            <xsl:apply-templates select="$failedtests.list"/>

            <xsl:apply-templates select="$ignoredtests.list"/>

            <xsl:apply-templates select="$passedtests.list"/>

        </testsuite>
        <xsl:text>
</xsl:text>
    </xsl:template>
    
    <!-- Successfull test cases template -->  
    
    <xsl:template match="test-case[@success='True']">
        <xsl:variable name="test.case.id" select="generate-id()" />
        
        <testcase>
            <xsl:attribute name="id">
                <xsl:value-of select="$test.case.id"/>
            </xsl:attribute>
            <xsl:attribute name="name">
                <xsl:call-template name="getTestName">
                    <xsl:with-param name="name" select="@name"/>
                </xsl:call-template>
            </xsl:attribute>
            <xsl:attribute name="time">
               <xsl:value-of select="@time"/>
            </xsl:attribute>
        </testcase>
        <xsl:text>
</xsl:text>
    </xsl:template>
    
    
  <!-- Failed test cases template -->  
    <xsl:template match="test-case[@success='False']">
        <xsl:variable name="test.case.id" select="generate-id()" />
        <xsl:variable name="faillure.text" select="normalize-space(failure/message)"/>
        <xsl:variable name="stack-trace" select="normalize-space(failure/stack-trace)"/>
        <testcase>
            <xsl:attribute name="id">
                <xsl:value-of select="$test.case.id"/>
            </xsl:attribute>
            <xsl:attribute name="name">
                <xsl:call-template name="getTestName">
                    <xsl:with-param name="name" select="@name"/>
                </xsl:call-template>
            </xsl:attribute>
            <xsl:attribute name="time">
                <xsl:value-of select="@time"/>
            </xsl:attribute>
            <xsl:text>
</xsl:text>
            <failure>
                <xsl:attribute name="message">
 
                    <xsl:apply-templates select="$faillure.text"/>
                   <br/>
                    
                    <xsl:value-of select="$stack-trace"/>
				
                 
                </xsl:attribute>
                <xsl:attribute name="type">
                    <xsl:if test="$stack-trace=''">
                        <xsl:text>failure </xsl:text>   
                    </xsl:if>
                    <xsl:if test="$stack-trace!=''">
                        <xsl:text>error </xsl:text> 
                    </xsl:if>
                </xsl:attribute>
            </failure>
        </testcase>
        <xsl:text>
</xsl:text>
    </xsl:template>
    <xsl:template name="getTestName">
        
        <xsl:param name="name"/>
        <xsl:choose>
            <xsl:when test="contains($name, '.')">
                <xsl:call-template name="getTestName">
                    <xsl:with-param name="name" select="substring-after($name, '.')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$name"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
   
</xsl:stylesheet>