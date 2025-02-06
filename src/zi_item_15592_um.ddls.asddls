@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'item cds'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Zi_ITEM_15592_um as select from zitem_15592_um
association to parent zi_header_15592_um as _header on $projection.DocumentNumber = _header.DocumentNumber
{
    key document_number as DocumentNumber,
    key item_code as ItemCode,
    status as Status,
    quantity as Quantity,
    currency as Currency,
    @Semantics.amount.currencyCode : 'Currency'
    amount as Amount,
     @Semantics.amount.currencyCode : 'Currency'
    tax_amt as TaxAmt,
    changed_at as ChangedAt,
    created_at as CreatedAt,
    created_by as CreatedBy,
    _header
}
