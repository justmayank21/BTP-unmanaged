@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'projection for item'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity Zc_ITEM_15592_um as projection on Zi_ITEM_15592_um
{
    key DocumentNumber,
    key ItemCode,
    Status,
    Quantity,
    Currency,
    @Semantics.amount.currencyCode: 'Currency'
    Amount,
    @Semantics.amount.currencyCode: 'Currency'
    TaxAmt,
    ChangedAt,
    CreatedAt,
    CreatedBy,
    _header : redirected to parent Zc_HEADER_15592_um
}
