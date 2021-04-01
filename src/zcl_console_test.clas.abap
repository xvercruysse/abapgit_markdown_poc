CLASS zcl_console_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_console_test IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

DATA: ls_entity_key     TYPE ZPM_PRIORITIES,
      ls_business_data  TYPE ZPM_PRIORITIES,
      lo_http_client    TYPE REF TO if_web_http_client,
      lo_client_proxy   TYPE REF TO /iwbep/if_cp_client_proxy,
      lo_resource       TYPE REF TO /iwbep/if_cp_resource_entity,
      lo_request        TYPE REF TO /iwbep/if_cp_request_read,
      lo_response       TYPE REF TO /iwbep/if_cp_response_read.


  TRY.
    " Create http client
    " Details depend on your connection settings
    "lo_http_client = cl_web_http_client_manager=>create_by_http_destination(
    "                          cl_http_destination_provider=>create_by_cloud_destination(
    "                                  i_name                  = '<Name of Cloud Destination>'
    "                                  i_service_instance_name = '<Service Instance Name>' ) ).

    lo_client_proxy = cl_web_odata_client_factory=>create_v2_remote_proxy(
      EXPORTING
        iv_service_definition_name = 'ZZ1_SC_PM_NOTIFICATION_BE'
        io_http_client             = lo_http_client
        iv_relative_service_root   = '/sap/opu/odata/sap/ZZ1_PM_NOTIFICATION/' ).


    " Set entity key
    "ls_entity_key = value #(
    "                    id = 'Id'
    "                    description = 'Description'
    "                 ).


    " Navigate to the resource
    lo_resource = lo_client_proxy->create_resource_for_entity_set( 'PRIORITIES' )->navigate_with_key( ls_entity_key ).

    " Execute the request and retrieve the business data
    lo_response = lo_resource->create_request_for_read( )->execute( ).
    lo_response->get_business_data( IMPORTING es_business_data = ls_business_data ).

  CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
    " Handle remote Exception
    " It contains details about the problems of your http(s) connection

  CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
    " Handle Exception

ENDTRY.
  ENDMETHOD.
ENDCLASS.
