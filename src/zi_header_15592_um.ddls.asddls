@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'header CDS'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity Zi_HEADER_15592_um as select from zheader_15592_um
composition [0..*] of Zi_ITEM_15592_um as _item
composition [0..*] of Zi_add_15592_um as _add
//association [1] to zstatus_15592 as _statusText on  _statusText.status   = zheader_15592.status
//                                                     and _statusText.language = $session.system_language
                                                     
{
@EndUserText.label: 'Document Number'
    key document_number as DocumentNumber,
    @EndUserText.label: 'Company Code'
    company_code as CompanyCode,
    @EndUserText.label: 'Purchase Org.'
    purchase_org as PurchaseOrg,
    @EndUserText.label: 'Currency'
    currency as Currency,
    @EndUserText.label: 'Supplier Number'
    supplier_number as SupplierNumber,
    @EndUserText.label: 'Status'
    status as Status,
    @EndUserText.label: 'Changed At'
    changed_at as ChangedAt,
    @EndUserText.label: 'Created At'
    created_at as CreatedAt,
    @EndUserText.label: 'Created By'
    created_by as CreatedBy,
    lastlocalchangedat as lastLocalChangedAt,
    _item,
    _add
}
