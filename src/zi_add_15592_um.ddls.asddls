@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Address CDS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_add_15592_um as select from zadd_15592_um
association to parent Zi_HEADER_15592_um as _header on $projection.DocumentNumber = _header.DocumentNumber
{
    key document_number as DocumentNumber,
    @EndUserText.label: 'House Number'
    key address_number as AddressNumber,
    name as Name,
    street_address as StreetAddress,
    city as City,
    country as Country,
    contact_number as ContactNumber,
    _header
}
