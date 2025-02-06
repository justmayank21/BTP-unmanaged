CLASS lhc_header DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PUBLIC SECTION.
    CLASS-DATA:
      mt_root_to_create TYPE STANDARD TABLE OF zheader_15592_um WITH NON-UNIQUE DEFAULT KEY,
      ms_root_to_create TYPE zheader_15592_um,
      mt_item           TYPE STANDARD TABLE OF zitem_15592_um WITH NON-UNIQUE DEFAULT KEY,
      ms_item           TYPE zitem_15592_um,
      mt_add           TYPE STANDARD TABLE OF zadd_15592_um WITH NON-UNIQUE DEFAULT KEY,
      ms_add           TYPE zadd_15592_um,
      mt_root_to_delete TYPE STANDARD TABLE OF zheader_15592_um WITH NON-UNIQUE DEFAULT KEY,
      ms_del            TYPE zheader_15592_um,
      mt_root_to_update TYPE STANDARD TABLE OF zheader_15592_um WITH NON-UNIQUE DEFAULT KEY,
      ms_root_to_update TYPE zheader_15592_um,
      wa_header         TYPE zheader_15592_um,
      mt_action         TYPE STANDARD TABLE OF zheader_15592_um WITH NON-UNIQUE DEFAULT KEY.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR header RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE header.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE header.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE header.

    METHODS read FOR READ
      IMPORTING keys FOR READ header RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK header.

    METHODS rba_Item FOR READ
      IMPORTING keys_rba FOR READ header\_Item FULL result_requested RESULT result LINK association_links.

    METHODS cba_Item FOR MODIFY
      IMPORTING entities_cba FOR CREATE header\_Item.

      METHODS rba_Add FOR READ
      IMPORTING keys_rba FOR READ header\_Add FULL result_requested RESULT result LINK association_links.

    METHODS cba_Add FOR MODIFY
      IMPORTING entities_cba FOR CREATE header\_Add.

*    METHODS reject FOR MODIFY
*      IMPORTING keys FOR ACTION header~reject RESULT result.

*    METHODS status FOR MODIFY
*      IMPORTING keys FOR ACTION header~status RESULT result.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR header RESULT result.

    METHODS set_status FOR MODIFY
      IMPORTING keys FOR ACTION header~set_status RESULT result.

    METHODS reject FOR MODIFY
      IMPORTING keys FOR ACTION header~reject RESULT result.

ENDCLASS.

CLASS lhc_header IMPLEMENTATION.

  METHOD get_instance_authorizations.

*    DATA(lv_doc) = keys[ 1 ].

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_data>).
      SELECT SINGLE * FROM zheader_15592_um WHERE document_number = @<ls_data>-DocumentNumber INTO  @DATA(ls_hdr).

      DATA(lv_allowed) =  COND #( WHEN ls_hdr-status = 'Active'
                               THEN if_abap_behv=>auth-allowed

                                WHEN ls_hdr-status = 'Rejected'
                               THEN if_abap_behv=>auth-allowed

                               ELSE if_abap_behv=>auth-unauthorized
                               ).

      APPEND VALUE #( DocumentNumber = <ls_data>-DocumentNumber %action-set_status = lv_allowed   ) TO result.

*      IF ls_hdr IS NOT INITIAL.
*        CLEAR ls_hdr.
*      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD create.

    GET TIME STAMP FIELD DATA(lv_timestamp).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_data>).
      MOVE-CORRESPONDING <ls_data> TO ms_root_to_create.

      DATA lv_max_document_number TYPE zheader_15592_um-document_number.

      SELECT MAX( document_number )
      FROM zheader_15592_um
        INTO @lv_max_document_number.

      IF lv_max_document_number IS INITIAL.
        lv_max_document_number = 1.
      ELSE.
        lv_max_document_number = lv_max_document_number + 1.
      ENDIF.
*INSERT VALUE #( document_number = lv_max_document_number
*                    status = <ls_data>-Status
*                    purchase_org = <ls_data>-PurchaseOrg
*                    company_code = <ls_data>-CompanyCode
*                    currency = <ls_data>-Currency
*                    supplier_number = <ls_data>-SupplierNumber
*                    changed_at = <ls_data>-ChangedAt
*                    created_at = <ls_data>-CreatedAt
*                    created_by = <ls_data>-CreatedBy )
*      INTO TABLE mt_root_to_create.

      ms_root_to_create-document_number = lv_max_document_number.

*      ms_root_to_create-document_number = <ls_data>-DocumentNumber.
      ms_root_to_create-status = <ls_data>-Status.
      ms_root_to_create-company_code = <ls_data>-CompanyCode.
      ms_root_to_create-purchase_org = <ls_data>-PurchaseOrg.
      ms_root_to_create-currency = <ls_data>-Currency.
      ms_root_to_create-supplier_number = <ls_data>-SupplierNumber.
      ms_root_to_create-changed_at = <ls_data>-ChangedAt.
      ms_root_to_create-created_at = <ls_data>-CreatedAt.
      ms_root_to_create-created_by = <ls_data>-CreatedBy.
      ms_root_to_create-lastlocalchangedat = lv_timestamp.



      INSERT CORRESPONDING #( <ls_data> ) INTO TABLE mapped-header.
      INSERT CORRESPONDING #( ms_root_to_create ) INTO TABLE mt_root_to_create.



    ENDLOOP.


  ENDMETHOD.



  METHOD update.

    GET TIME STAMP FIELD DATA(lv_timestamp).

    DATA(lv_result) = entities[ 1 ].

    SELECT * FROM zheader_15592_um
     WHERE document_number = @lv_result-DocumentNumber
     INTO @DATA(wa_header).
    ENDSELECT.


    LOOP AT entities INTO DATA(ls_entity).
*    MOVE-CORRESPONDING ls_entity to wa_header.

      IF wa_header IS NOT INITIAL.
        DATA(ls_control) = ls_entity-%control.

    if ls_control-DocumentNumber is NOT INITIAL.
    ms_root_to_update-document_number = ls_control-DocumentNumber.
    ENDIF.

        IF ls_control-CompanyCode IS NOT INITIAL.
          wa_header-company_code = ls_entity-CompanyCode.
        ENDIF.

        IF ls_control-Status IS NOT INITIAL.
          wa_header-status = ls_entity-Status.
        ENDIF.

        IF ls_control-PurchaseOrg IS NOT INITIAL.
          wa_header-purchase_org = ls_entity-PurchaseOrg.
        ENDIF.

        IF ls_control-Currency IS NOT INITIAL.
          wa_header-currency = ls_entity-Currency.
        ENDIF.

        IF ls_control-SupplierNumber IS NOT INITIAL.
          wa_header-supplier_number = ls_entity-SupplierNumber.
        ENDIF.

        IF ls_control-ChangedAt IS NOT INITIAL.
          wa_header-changed_at = ls_entity-ChangedAt.
        ENDIF.

        IF ls_control-CreatedAt IS NOT INITIAL.
          wa_header-created_at = ls_entity-CreatedAt.
        ENDIF.

        IF ls_control-CreatedBy IS NOT INITIAL.
          wa_header-created_by = ls_entity-CreatedBy.
        ENDIF.


      ENDIF.
      wa_header-lastlocalchangedat = lv_timestamp.
      INSERT CORRESPONDING #( wa_header ) INTO TABLE mt_root_to_update.

    ENDLOOP.

*    SELECT * from zheader_15592_um
*    where document_number = @ls_entity-DocumentNumber
*    into @data(wa_header).
*    ENDSELECT.
*
*
*        if ls_entity-DocumentNumber is not INITIAL.
*        wa_header-document_number = ls_entity-DocumentNumber.
*        ENDIF.
*
*      IF ls_entity-Status IS NOT INITIAL.
*         wa_header-status = ls_entity-Status.
*      ENDIF.
*
*      IF ls_entity-CompanyCode IS NOT INITIAL.
*         wa_header-company_code = ls_entity-CompanyCode.
*      ENDIF.
*
*      IF ls_entity-PurchaseOrg IS NOT INITIAL.
*         wa_header-purchase_org = ls_entity-PurchaseOrg.
*      ENDIF.
*
*      IF ls_entity-Currency IS NOT INITIAL.
*         wa_header-currency = ls_entity-Currency.
*      ENDIF.
*
*      IF ls_entity-SupplierNumber IS NOT INITIAL.
*         wa_header-supplier_number = ls_entity-SupplierNumber.
*      ENDIF.
*
*      IF ls_entity-ChangedAt IS NOT INITIAL.
*         wa_header-changed_at = ls_entity-ChangedAt.
*      ENDIF.
*
*      IF ls_entity-CreatedAt IS NOT INITIAL.
*         wa_header-created_at = ls_entity-CreatedAt.
*      ENDIF.
*
*      IF ls_entity-CreatedBy IS NOT INITIAL.
*         wa_header-created_by = ls_entity-CreatedBy.
*      ENDIF.


*  MODIFY mt_root_to_update FROM ms_root_to_update.
*      INSERT CORRESPONDING #( wa_header ) INTO TABLE mt_root_to_update.
*    ENDLOOP.


  ENDMETHOD.

  METHOD delete.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_del>).
      ms_del-document_number = <ls_del>-DocumentNumber.
      INSERT CORRESPONDING #( ms_del ) INTO TABLE mt_root_to_delete.
    ENDLOOP.


  ENDMETHOD.

  METHOD read.

    SELECT * FROM zi_header_15592_um
          FOR ALL ENTRIES IN @keys
          WHERE DocumentNumber = @keys-DocumentNumber
          INTO CORRESPONDING FIELDS OF TABLE @result.


  ENDMETHOD.

  METHOD lock.

    TRY.

        DATA(lock) = cl_abap_lock_object_factory=>get_instance( iv_name = 'EZHEADER_15592' ).

      CATCH cx_abap_lock_failure INTO DATA(exception).
        RAISE SHORTDUMP exception.
    ENDTRY.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_key>).

      TRY.

          lock->enqueue(
                  it_parameter = VALUE #( ( name = 'DOCUMENT_NUMBER' value = REF #( <fs_key>-DocumentNumber )  ) )
          ).
        CATCH cx_abap_foreign_lock INTO DATA(foreign_lock).
          DATA(lv_user) = foreign_lock->user_name.
          DATA(lv_doc_num) = <fs_key>-DocumentNumber.


*          APPEND VALUE #( %key = keys[ 1 ]-%key
*                        %msg = new_message_with_text(
*                        text = lv_text1
*                        severity = if_abap_behv_message=>severity-error
*                        )   ) TO reported-zc_header_15592.
          DATA(lv_text) = 'This Object Is Locked By Mayank, Do not Change It'.
          APPEND VALUE #( %key = keys[ 1 ]-DocumentNumber
                          %msg = new_message_with_text(
                          text = lv_text
                          severity = if_abap_behv_message=>severity-error
                          )
           ) TO reported-header.


        CATCH cx_abap_lock_failure INTO exception.
          RAISE SHORTDUMP exception.
      ENDTRY.

    ENDLOOP.

  ENDMETHOD.

  METHOD rba_Item.
  ENDMETHOD.

  METHOD cba_Item.

    LOOP AT entities_cba ASSIGNING FIELD-SYMBOL(<ls_item>).
      LOOP AT <ls_item>-%target ASSIGNING FIELD-SYMBOL(<fs_item>).
        MOVE-CORRESPONDING <fs_item> TO ms_item.

        ms_item-document_number = <ls_item>-DocumentNumber.
        ms_item-item_code = <fs_item>-ItemCode.
        ms_item-status = <fs_item>-Status.
        ms_item-quantity = <fs_item>-Quantity.
        ms_item-currency = <fs_item>-Currency.
        ms_item-amount = <fs_item>-Amount.
        ms_item-tax_amt = <fs_item>-TaxAmt.
        ms_item-changed_at = <fs_item>-ChangedAt.
        ms_item-created_at = <fs_item>-CreatedAt.
        ms_item-created_by = <fs_item>-CreatedBy.

        APPEND ms_item TO mt_item.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.

*  METHOD reject.
*
*    DATA(lv_doc) = keys[ 1 ]-DocumentNumber.
*
*    SELECT * FROM zheader_15592_um WHERE document_number = @lv_doc INTO TABLE @DATA(lt_data).
*
*    LOOP AT lt_data INTO DATA(ls_data).
*      MOVE-CORRESPONDING ls_data TO ms_root_to_create.
*      ms_root_to_create-status = 'Rejected'.
*      INSERT CORRESPONDING #( ms_root_to_create ) INTO TABLE mt_action.
*
*    ENDLOOP.
*
*
*  ENDMETHOD.

*  METHOD status.
*
*    DATA(lv_doc) = keys[ 1 ]-DocumentNumber.
*
*    SELECT * FROM zheader_15592_um WHERE document_number = @lv_doc INTO TABLE @DATA(lt_data).
*
*    LOOP AT lt_data INTO DATA(ls_data).
*      MOVE-CORRESPONDING ls_data TO ms_root_to_create.
*      ms_root_to_create-status = 'Approved'.
*      INSERT CORRESPONDING #( ms_root_to_create ) INTO TABLE mt_action.
*
*    ENDLOOP.
*
*
*  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITIES OF zi_header_15592_um IN LOCAL MODE
      ENTITY header
         FIELDS (  DocumentNumber Status )
         WITH CORRESPONDING #( keys )
       RESULT DATA(lt_result)
       FAILED failed.

    result =
      VALUE #( FOR ls_stat IN lt_result
        ( %key = ls_stat-%key
          %features = VALUE #(
                                                        %action-reject = COND #( WHEN ls_stat-Status = 'Rejected'
                                                                                 or ls_stat-Status = 'Submitted'
                                                                                 or ls_stat-Status = 'Archived'
                                                        THEN if_abap_behv=>fc-o-disabled
                                                        ELSE if_abap_behv=>fc-o-enabled
                                                         )
                                                         )
         ) ).

*         %action-set_status = COND #( WHEN ls_stat-Status = 'Approved'
*                                                        THEN if_abap_behv=>fc-o-disabled
*                                                        ELSE if_abap_behv=>fc-o-enabled
*                                                         )
  ENDMETHOD.

  METHOD set_status.

    DATA(lv_doc) = keys[ 1 ]-DocumentNumber.

    SELECT * FROM zheader_15592_um WHERE document_number = @lv_doc INTO TABLE @DATA(lt_data).

    LOOP AT lt_data INTO DATA(ls_data).
      MOVE-CORRESPONDING ls_data TO ms_root_to_create.
      ms_root_to_create-status = 'Approved'.
      INSERT CORRESPONDING #( ms_root_to_create ) INTO TABLE mt_action.

    ENDLOOP.


  ENDMETHOD.

  METHOD reject.

    DATA(lv_doc) = keys[ 1 ]-DocumentNumber.

    SELECT * FROM zheader_15592_um WHERE document_number = @lv_doc INTO TABLE @DATA(lt_data).

    LOOP AT lt_data INTO DATA(ls_data).
      MOVE-CORRESPONDING ls_data TO ms_root_to_create.
      ms_root_to_create-status = 'Rejected'.
      INSERT CORRESPONDING #( ms_root_to_create ) INTO TABLE mt_action.
    ENDLOOP.

  ENDMETHOD.

  METHOD cba_add.

  LOOP AT entities_cba ASSIGNING FIELD-SYMBOL(<ls_add>).
      LOOP AT <ls_add>-%target ASSIGNING FIELD-SYMBOL(<fs_add>).
        MOVE-CORRESPONDING <fs_add> TO ms_add.

        ms_add-document_number = <ls_add>-DocumentNumber.
        ms_add-address_number = <fs_add>-AddressNumber.
        ms_add-name = <fs_add>-Name.
        ms_add-street_address = <fs_add>-StreetAddress.
        ms_add-city = <fs_add>-City.
        ms_add-country = <fs_add>-Country.
        ms_add-contact_number = <fs_add>-ContactNumber.

        APPEND ms_add TO mt_add.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.

  METHOD rba_add.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_item DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PUBLIC SECTION.
    CLASS-DATA: ls_del    TYPE zitem_15592_um,
                lt_del    TYPE STANDARD TABLE OF zitem_15592_um,
                mt_update TYPE STANDARD TABLE OF zitem_15592_um WITH NON-UNIQUE DEFAULT KEY.

  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE item.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE item.

    METHODS read FOR READ
      IMPORTING keys FOR READ item RESULT result.

    METHODS rba_Header FOR READ
      IMPORTING keys_rba FOR READ item\_Header FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_item IMPLEMENTATION.

  METHOD update.

    DATA(lv_result) = entities[ 1 ].

    SELECT * FROM zitem_15592_um
     WHERE document_number = @lv_result-DocumentNumber
     AND item_code = @lv_result-ItemCode
     INTO @DATA(wa_item).
    ENDSELECT.


    LOOP AT entities INTO DATA(ls_entity).
*    MOVE-CORRESPONDING ls_entity to wa_header.

      IF wa_item IS NOT INITIAL.
        DATA(ls_control) = ls_entity-%control.

*    if ls_control-DocumentNumber is NOT INITIAL.
*    ms_root_to_update-document_number = ls_control-DocumentNumber.
*    ENDIF.

        IF ls_control-ItemCode IS NOT INITIAL.
          wa_item-item_code = ls_entity-ItemCode.
        ENDIF.

        IF ls_control-Status IS NOT INITIAL.
          wa_item-status = ls_entity-Status.
        ENDIF.

        IF ls_control-Quantity IS NOT INITIAL.
          wa_item-quantity = ls_entity-Quantity.
        ENDIF.

        IF ls_control-Currency IS NOT INITIAL.
          wa_item-currency = ls_entity-Currency.
        ENDIF.

        IF ls_control-Amount IS NOT INITIAL.
          wa_item-amount = ls_entity-Amount.
        ENDIF.

        IF ls_control-TaxAmt IS NOT INITIAL.
          wa_item-tax_amt = ls_entity-TaxAmt.
        ENDIF.

        IF ls_control-ChangedAt IS NOT INITIAL.
          wa_item-changed_at = ls_entity-ChangedAt.
        ENDIF.

        IF ls_control-CreatedAt IS NOT INITIAL.
          wa_item-created_at = ls_entity-CreatedAt.
        ENDIF.

        IF ls_control-CreatedBy IS NOT INITIAL.
          wa_item-created_by = ls_entity-CreatedBy.
        ENDIF.


      ENDIF.

      INSERT CORRESPONDING #( wa_item ) INTO TABLE mt_update.

    ENDLOOP.


  ENDMETHOD.

  METHOD delete.

*LOOP AT keys ASSIGNING FIELD-SYMBOL(<ms_del>).
*    CLEAR ls_del. " Ensure no residual data in the structure
*    MOVE-CORRESPONDING <ms_del> TO ls_del. " Copy relevant key fields
*    APPEND ls_del TO lt_del. " Add to deletion table
*  ENDLOOP.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ms_del>).
      ls_del-document_number = <ms_del>-DocumentNumber.
      ls_del-item_code = <ms_del>-ItemCode.
      INSERT CORRESPONDING #( ls_del ) INTO TABLE lt_del.
    ENDLOOP.

  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_Header.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_add DEFINITION INHERITING FROM cl_abap_behavior_handler.
PUBLIC SECTION.
    CLASS-DATA: ls_del_add    TYPE zadd_15592_um,
                lt_del_add   TYPE STANDARD TABLE OF zadd_15592_um,
                mt_update_add TYPE STANDARD TABLE OF zadd_15592_um WITH NON-UNIQUE DEFAULT KEY.

PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE add.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE add.

    METHODS read FOR READ
      IMPORTING keys FOR READ add RESULT result.

    METHODS rba_Header FOR READ
      IMPORTING keys_rba FOR READ add\_Header FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_add IMPLEMENTATION.

METHOD update.

DATA(lv_result) = entities[ 1 ].

    SELECT * FROM zadd_15592_um
     WHERE document_number = @lv_result-DocumentNumber
     AND address_number = @lv_result-AddressNumber
     INTO @DATA(wa_add).
    ENDSELECT.


    LOOP AT entities INTO DATA(ls_entity).


      IF wa_add IS NOT INITIAL.
        DATA(ls_control) = ls_entity-%control.


        IF ls_control-AddressNumber IS NOT INITIAL.
          wa_add-address_number = ls_entity-AddressNumber.
        ENDIF.

        IF ls_control-Name IS NOT INITIAL.
          wa_add-name = ls_entity-Name.
        ENDIF.

        IF ls_control-StreetAddress IS NOT INITIAL.
          wa_add-street_address = ls_entity-StreetAddress.
        ENDIF.

        IF ls_control-City IS NOT INITIAL.
          wa_add-city = ls_entity-City.
        ENDIF.

        IF ls_control-Country IS NOT INITIAL.
          wa_add-country = ls_entity-Country.
        ENDIF.

        IF ls_control-ContactNumber IS NOT INITIAL.
          wa_add-contact_number = ls_entity-ContactNumber.
        ENDIF.


      ENDIF.

      INSERT CORRESPONDING #( wa_add ) INTO TABLE mt_update_add.

    ENDLOOP.

ENDMETHOD.

METHOD delete.

LOOP AT keys ASSIGNING FIELD-SYMBOL(<ms_del>).
      ls_del_add-document_number = <ms_del>-DocumentNumber.
      ls_del_add-address_number = <ms_del>-AddressNumber.
      INSERT CORRESPONDING #( ls_del_add ) INTO TABLE lt_del_add.
    ENDLOOP.

ENDMETHOD.

METHOD read.
  ENDMETHOD.

  METHOD rba_Header.
  ENDMETHOD.


ENDCLASS.


CLASS lsc_header DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_header IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.

    IF lhc_header=>mt_root_to_create IS NOT INITIAL.
      MODIFY zheader_15592_um FROM TABLE @lhc_header=>mt_root_to_create.
    ENDIF.

    IF lhc_header=>mt_item IS NOT INITIAL.
      MODIFY zitem_15592_um FROM TABLE @lhc_header=>mt_item.
    ENDIF.

    IF lhc_header=>mt_add IS NOT INITIAL.
      MODIFY zadd_15592_um FROM TABLE @lhc_header=>mt_add.
    ENDIF.

    IF lhc_header=>mt_root_to_update IS NOT INITIAL.
      MODIFY zheader_15592_um FROM TABLE @lhc_header=>mt_root_to_update.
    ENDIF.

    IF lhc_item=>mt_update IS NOT INITIAL.
      MODIFY zitem_15592_um FROM TABLE @lhc_item=>mt_update.
    ENDIF.

    IF lhc_add=>mt_update_add IS NOT INITIAL.
      MODIFY zadd_15592_um FROM TABLE @lhc_add=>mt_update_add.
    ENDIF.

    IF lhc_header=>mt_root_to_delete IS NOT INITIAL.
      DELETE zheader_15592_um FROM TABLE @lhc_header=>mt_root_to_delete.
      DELETE zitem_15592_um FROM TABLE @lhc_header=>mt_root_to_delete.
      DELETE zadd_15592_um FROM TABLE @lhc_header=>mt_root_to_delete.
    ENDIF.

    IF lhc_item=>lt_del IS NOT INITIAL.
      DELETE zitem_15592_um FROM TABLE @lhc_item=>lt_del.
    ENDIF.

    IF lhc_add=>lt_del_add IS NOT INITIAL.
      DELETE zadd_15592_um FROM TABLE @lhc_add=>lt_del_add.
    ENDIF.



    IF lhc_header=>mt_action IS NOT INITIAL.
      MODIFY zheader_15592_um FROM TABLE @lhc_header=>mt_action.
    ENDIF.


  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
