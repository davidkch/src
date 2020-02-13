<?xml version="1.0" encoding="utf-8"?>
<!--
<copyright file="PORtoIBB.xslt" company="Microsoft">
Copyright (c) Microsoft Corporation.  All rights reserved.
summary: This XSL transformation is for the Purchase Order data that Async Service receives
:::::::: so that the transformed XML is in a format eligible to be sent to IBB
Author: vaishb
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns:poeds="http://MS.IT.POEDS.Contracts/2009/06"
    exclude-result-prefixes="msxsl poeds">
  <xsl:output method="xml" encoding="UTF-16" indent="yes"/>

  <xsl:template match="poeds:MessageData/poeds:Request/poeds:PurchaseOrderResponse">
    <ns0:ProcessPurchaseOrder SystemEnvironmentCode="Production" LanguageCode="en-US" xmlns:ns0="http://MS.IT.Fulfillment.IBB.BODEnvelope/1/MS.IT.Fulfillment.PurchaseOrder/1">
      <ApplicationArea>
        <Sender>
          <PublisherID>MS.IT.Fulfillment.POEDS</PublisherID>
          <InstanceID>
            <xsl:value-of select="@FulfillmentRegionCode"/>
          </InstanceID>
          <ComponentID></ComponentID>
          <TaskID></TaskID>
          <ReferenceID></ReferenceID>
          <ConfirmationCode></ConfirmationCode>
        </Sender>
        <CreationDateTime>
          <xsl:value-of select="../../poeds:PropertyBagItems/poeds:PropertyBagItem[@Key='CreationDateTime']/@Value"/>
        </CreationDateTime>
        <BODID>
          <xsl:value-of select="../../@ContextId"/>
        </BODID>
        <UserArea />
      </ApplicationArea>
      <DataArea>
        <PurchaseOrder>
          <MSPurchaseOrderID>
            <xsl:value-of select="@MSPurchaseOrderId"/>
          </MSPurchaseOrderID>
          <ExternalOrderNumber>
            <xsl:value-of select="@ExternalOrderNumber"/>
          </ExternalOrderNumber>
          <DocumentDateTime>
            <xsl:value-of select="poeds:PropertyBagItems/poeds:PropertyBagItem[@Key='DocumentDateTime']/@Value"/>
          </DocumentDateTime>
            <OrderValue>
              <xsl:value-of select="poeds:PropertyBagItems/poeds:PropertyBagItem[@Key='OrderValue']/@Value"/>
            </OrderValue>
          <EndCustomerParty>
            <BillToCountry>
              <xsl:value-of select="@ISOCountryCode"/>
            </BillToCountry>
            <SourceCurrencyCode>
              <xsl:value-of select="poeds:PropertyBagItems/poeds:PropertyBagItem[@Key='SourceCurrencyCode']/@Value"/>
            </SourceCurrencyCode>
            <xsl:if test="poeds:PropertyBagItems/poeds:PropertyBagItem[@Key='AccountId']/@Value !=''">
              <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
              <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
              <AccountID>
                <xsl:attribute name="Type">
                  <xsl:value-of select="translate(poeds:PropertyBagItems/poeds:PropertyBagItem[@Key='AccountIdType']/@Value, $smallcase, $uppercase)"/>
                </xsl:attribute>
                <xsl:value-of select="poeds:PropertyBagItems/poeds:PropertyBagItem[@Key='AccountId']/@Value"/>
              </AccountID>
            </xsl:if>
          </EndCustomerParty>
          <SoldToBuyerParty>
            <CustomerID>
              <xsl:value-of select="@DdspId"/>
            </CustomerID>
            <PriceListID>
              <xsl:value-of select="poeds:PropertyBagItems/poeds:PropertyBagItem[@Key='PriceListId']/@Value"/>
            </PriceListID>
            <StoreID>
              <xsl:value-of select="poeds:PropertyBagItems/poeds:PropertyBagItem[@Key='StoreId']/@Value"/>
            </StoreID>
          </SoldToBuyerParty>
          <!-- Order Lines -->
          <xsl:for-each select="poeds:Lines/poeds:OrderLine">
            <OrderLine>
              <LineNumber>
                <!--BUG fix 137884. Changing to InternalLineNumber-->
                <!--LineNumber is of Length 6. Getting data from right most side. Adding 1 as SubString is non Zero based. -->
                <xsl:value-of select="substring(@InternalLineNumber, string-length(@InternalLineNumber) - 6 + 1)"/>
              </LineNumber>
              <Quantity>
                <xsl:value-of select="@Quantity"/>
              </Quantity>
              <ProductOfferID>
                <xsl:value-of select="@ProductOfferId"/>
              </ProductOfferID>

              <xsl:if test="poeds:PropertyBagItems/poeds:PropertyBagItem[@Key='SecondaryLicenseTypeCode']/@Value !=''">
                <SecondaryLicenseTypeCode>
                  <xsl:value-of select="poeds:PropertyBagItems/poeds:PropertyBagItem[@Key='SecondaryLicenseTypeCode']/@Value"/>
                </SecondaryLicenseTypeCode>
              </xsl:if>

              <EndCustomerPartyPrice>
                <UnitValue>
                  <xsl:value-of select="poeds:PropertyBagItems/poeds:PropertyBagItem[@Key='UnitValue']/@Value"/>
                </UnitValue>
                <xsl:if test="poeds:PropertyBagItems/poeds:PropertyBagItem[@Key='LineValue']/@Value !=''">
                  <LineValue>
                    <xsl:value-of select="poeds:PropertyBagItems/poeds:PropertyBagItem[@Key='LineValue']/@Value"/>
                  </LineValue>
                </xsl:if>

                <TotalLineItemValue>
                  <xsl:value-of select="poeds:PropertyBagItems/poeds:PropertyBagItem[@Key='TotalLineItemValue']/@Value"/>
                </TotalLineItemValue>

                <xsl:if test="poeds:PropertyBagItems/poeds:PropertyBagItem[@Key='SpecialPriceAuthorizationCode']/@Value !=''">
                  <SpecialPriceAuthorizationCode>
                    <xsl:value-of select="poeds:PropertyBagItems/poeds:PropertyBagItem[@Key='SpecialPriceAuthorizationCode']/@Value"/>
                  </SpecialPriceAuthorizationCode>
                </xsl:if>

              </EndCustomerPartyPrice>

              <!-- it is sufficient to check taxValue for non-emptiness, If tax value is present then Taxcalculation Type should be present as per poeds parameter validation -->
              <xsl:if test ="poeds:PropertyBagItems/poeds:PropertyBagItem[@Key='TaxValue']/@Value !=''">
                <LineTax>
                  <TaxValue>
                    <xsl:attribute name="CalculationType">
                      <xsl:value-of select="poeds:PropertyBagItems/poeds:PropertyBagItem[@Key='TaxCalculationType']/@Value"/>
                    </xsl:attribute>
                    <xsl:value-of select="poeds:PropertyBagItems/poeds:PropertyBagItem[@Key='TaxValue']/@Value"/>
                  </TaxValue>
                </LineTax>
              </xsl:if>

              <xsl:if test ="poeds:PropertyBagItems/poeds:PropertyBagItem[@Key='MarketingProgramId']/@Value !=''">
                <MarketingProgramID>
                  <xsl:value-of select="poeds:PropertyBagItems/poeds:PropertyBagItem[@Key='MarketingProgramId']/@Value"/>
                </MarketingProgramID>
              </xsl:if>

              <xsl:for-each select="poeds:LineItems/poeds:OrderLineItem">
                <xsl:variable name="oliID" select="@OrderLineItemID" />
                <Fulfillment>
                  <xsl:attribute name="ID">
                    <xsl:value-of select="$oliID"/>
                  </xsl:attribute>
                  <xsl:for-each select="poeds:Parts/poeds:POEBase">
                    <Part>
                      <xsl:attribute name="PartNumber">
                        <xsl:value-of select="@PartNumber"/>
                      </xsl:attribute>
                      <xsl:attribute name="RegionCode">
                        <xsl:value-of select="@RegionID"/>
                      </xsl:attribute>
                    </Part>
                  </xsl:for-each>
                </Fulfillment>
              </xsl:for-each>
            </OrderLine>
          </xsl:for-each>
        </PurchaseOrder>
      </DataArea>
    </ns0:ProcessPurchaseOrder>
  </xsl:template>
</xsl:stylesheet>