@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'projection for Address'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity zc_add_15592_um as projection on zi_add_15592_um
{
    key DocumentNumber,
    key AddressNumber,
    Name,
    StreetAddress,
    City,
    Country,
    ContactNumber,

    /* Associations */
    _header : redirected to parent Zc_HEADER_15592_um
}
