CLASS zcl_15592_custom DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_15592_custom IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    DATA: lt_response TYPE TABLE OF zce_custom_entity,
          ls_response TYPE zce_custom_entity.

    DATA: ls_docno TYPE if_rap_query_filter=>ty_range_option,
          lr_docno TYPE if_rap_query_filter=>tt_range_option,
          ls_supno TYPE if_rap_query_filter=>ty_range_option,
          lr_supno TYPE if_rap_query_filter=>tt_range_option.
    TRY.

        DATA(lv_data_req) = io_request->is_data_requested(  ).
        DATA(lv_top) = io_request->get_paging(  )->get_page_size(  ).
        DATA(lv_skip) = io_request->get_paging(  )->get_offset(  ).
        DATA(lt_fields) = io_request->get_requested_elements(  ).
        DATA(lt_sort) = io_request->get_sort_elements(  ).
        DATA(lv_page_size) = io_request->get_paging(  )->get_page_size( ).
        DATA(lv_max_row) = COND #( WHEN lv_page_size = if_rap_query_paging=>page_size_unlimited THEN 0 ELSE lv_page_size ).
        DATA(lv_condition) = io_request->get_filter(  )->get_as_ranges( iv_drop_null_comparisons = abap_true ).
        DATA(lv_filter_cond) = io_request->get_parameters(  ).

        lv_max_row = lv_skip + lv_top.
        IF lv_skip > 0.
          lv_skip = lv_skip + 1.
        ENDIF.

        SORT lv_condition BY name.

        READ TABLE lv_condition WITH KEY name = 'DOCUMENT_NUMBER' INTO DATA(ls_key) BINARY SEARCH.
        IF sy-subrc IS INITIAL AND lines( ls_key-range ) = 1.
          DATA(lt_range_value) = ls_key-range.
          LOOP AT lt_range_value INTO DATA(ls_range_value).

            ls_docno-sign = ls_range_value-sign.
            ls_docno-option = ls_range_value-option.
            ls_docno-low = ls_range_value-low.
            ls_docno-high = ls_range_value-high.

            APPEND ls_docno TO lr_docno.
          ENDLOOP.
        ENDIF.

        READ TABLE lv_condition WITH KEY name = 'SUPPLIER_NUMBER' INTO DATA(ls_data) BINARY SEARCH.
        IF sy-subrc IS INITIAL AND lines( ls_data-range ) = 1.
          DATA(lt_range) = ls_data-range.

          LOOP AT lt_range INTO DATA(ls_range).

            ls_supno-sign = ls_range-sign.
            ls_supno-option = ls_range-option.
            ls_supno-low = ls_range-low.
            ls_supno-high = ls_range-high.

            APPEND ls_supno TO lr_supno.
          ENDLOOP.
        ENDIF.

        SELECT a~document_number,
               a~company_code,
               a~purchase_org,
               a~currency,
               a~supplier_number,
               a~status,
               b~item_code,
               b~quantity,
               b~amount,
               b~tax_amt,
               c~city,
               c~country
         FROM zheader_15592_um AS a
        LEFT OUTER JOIN zitem_15592_um AS b
        ON b~document_number = a~document_number
        LEFT OUTER JOIN zadd_15592_um AS c
        ON c~document_number = a~document_number
        WHERE a~document_number IN @lr_docno
        AND a~supplier_number IN @lr_supno
        ORDER BY a~document_number ASCENDING
        INTO TABLE @DATA(lt_header).

        IF lv_data_req IS INITIAL.
          IF io_request->is_total_numb_of_rec_requested(  ).
            io_response->set_total_number_of_records( lines( lt_header ) ).
            RETURN.
          ENDIF.
        ENDIF.

        LOOP AT lt_header ASSIGNING FIELD-SYMBOL(<fs_output>)
        FROM lv_skip TO lv_max_row.
          MOVE-CORRESPONDING <fs_output> TO ls_response.
          APPEND ls_response TO lt_response.
          CLEAR ls_response.
        ENDLOOP.

        TRY.
            io_response->set_total_number_of_records( lines( lt_response ) ).
            io_response->set_data( lt_response ).
          CATCH cx_rap_query_provider INTO DATA(lx_new_root).
            DATA(lv_text2) = lx_new_root->get_text( ).
        ENDTRY.

      CATCH cx_root INTO DATA(cx_dest).
        DATA(lv_text) =  cx_dest->get_text(  ).
    ENDTRY.




  ENDMETHOD.
ENDCLASS.
