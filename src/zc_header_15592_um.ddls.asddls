@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection for header CDS'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity Zc_HEADER_15592_um as projection on Zi_HEADER_15592_um
{
    key DocumentNumber,
    CompanyCode,
    PurchaseOrg,
    Currency,
    SupplierNumber,
    Status,
    ChangedAt,
    CreatedAt,
    CreatedBy,
    lastLocalChangedAt,
    _item : redirected to composition child Zc_ITEM_15592_um,
    _add : redirected to composition child zc_add_15592_um
}
