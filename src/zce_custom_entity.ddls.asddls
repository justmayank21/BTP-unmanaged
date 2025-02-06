@EndUserText.label: 'header and item  custom entity'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_15592_CUSTOM'

@UI:{
  headerInfo :{
    typeName : 'Custom Report',
    typeNamePlural: 'Custom Report'
  }
}

define custom entity zce_custom_entity
{

      @EndUserText.label: 'Document Number'

      @UI             : { lineItem: [
        {position     : 10 , importance: #HIGH, label : 'Document Number'}
        ]}
      @UI.selectionField: [{ position: 10 }]
      @Search.fuzzinessThreshold: 0.8
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'zi_header_15592_um', element: 'DocumentNumber'}  }]
  key document_number : zdocu_num;

      @UI             : { lineItem: [
      {position       : 11 , importance: #HIGH, label : 'Item Number'}
      ]}
      //@UI.selectionField: [{ position: 11 }]
  key item_code       : znumc5;

      @UI             : { lineItem: [
      {position       : 12 , importance: #HIGH, label : 'Company Code'}
      ]}
      //@UI.selectionField: [{ position: 12 }]
      company_code    : zchar4;

      @UI             : { lineItem: [
      {position       : 13 , importance: #HIGH, label : 'Purchase Organisation'}
      ]}
      //@UI.selectionField: [{ position: 13 }]
      purchase_org    : zchar4;

      @UI             : { lineItem: [
      {position       : 14 , importance: #HIGH, label : 'Currency'}
      ]}
      //@UI.selectionField: [{ position: 14 }]
      currency        : abap.cuky;

      @EndUserText.label: 'Supplier Number'
      @UI             : { lineItem: [
      {position       : 15 , importance: #HIGH, label : 'Supplier Number'}
      ]}
      @UI.selectionField: [{ position: 15 }]
      @Search.fuzzinessThreshold: 0.8
      supplier_number : znumc10;

      @UI             : { lineItem: [
      {position       : 16 , importance: #HIGH, label : 'Status'}
      ]}
      //@UI.selectionField: [{ position: 16 }]
      status          : zchar10;

      @UI             : { lineItem: [
      {position       : 17 , importance: #HIGH, label : 'Quantity'}
      ]}
      //@UI.selectionField: [{ position: 17 }]
      quantity        : znumc5;

      @UI             : { lineItem: [
      {position       : 18 , importance: #HIGH, label : 'Amount'}
      ]}
      //@UI.selectionField: [{ position: 18 }]
      @Semantics.amount.currencyCode : 'currency'
      amount          : abap.curr(13,2);

      @UI             : { lineItem: [
      {position       : 19 , importance: #HIGH, label : 'Tax Amount'}
      ]}
      //@UI.selectionField: [{ position: 19 }]
      @Semantics.amount.currencyCode : 'currency'
      tax_amt         : abap.curr(10,2);

      @UI             : { lineItem: [
       {position      : 20 , importance: #HIGH, label : 'City'}
       ]}
      city            : zchar40;
      @EndUserText.label: 'Country'
      @UI             : { lineItem: [
      {position       : 21 , importance: #HIGH, label : 'Country'}
      ]}
      @UI.selectionField: [{ position: 21 }]
      country         : zchar20;



}
