ad_library {
    Web Service API to handle mobile app ALERTS component in DGSOM App

    @author: weixiayu@mednet.ucla.edu
    @creation-date: 2020-11-09
}

namespace eval tile::alerts::ws {}

ad_proc -public tile::alerts::ws::get_published_news {
    -appCode:required
} {
    set response_code       ""
    set response_message    ""
    set response_body       ""
    set continue_p          1

    ctrl::oauth::check_auth_header
    set user_id     $user_info(user_id)
    set token_str   $user_info(cust_acc_token)

    set tile_id         [dap::tile::getIdFromAppCode -app_code $appCode]
    set news_package_id [dap::tile::getAppCustomProperty \
                            -tile_id $tile_id \
                            -property "refPackageId" \
                            -default_value [dap::tile::getTileInternalProperty -tile_id $tile_id -property "newsPackageId"]]

    if {$user_id eq "" || $user_id == 0} {
        set response_code       "INVALID"
        set response_message    "Unauthorized : Undefined user"
        set continue_p 0
    }

    if {$continue_p} {
        #set public_group    [parameter::get_from_package_key -package_key "ctrl-mobile-hub" -parameter "defaultPublicGroup"]
        #set group_type_name "dgsom_app"
        #set public_group_id [db_string get_public_group "" -default 0]

        set alerts_list_json [list]
        db_foreach select "" {
            set info_list [list [list "category"        ""] \
                                [list "title"           $publish_title] \
                                [list "body"            $publish_body] \
                                [list "image64"         ""] \
                                [list "image_caption"   ""] \
                                [list "publish_date"    $publish_date_ansi] \
                                [list "archive_date"    $archive_date_ansi] \
                                [list "creation_date"   $creation_date] \
                                [list "creator"         $item_creator] \
                                [list "revision_number" $revision_no]]

            lappend alerts_list_json  [list [ctrl::json::construct_record $info_list]]
        }
        set body                [ctrl::json::construct_record   [list [list "alertsList" "$alerts_list_json" "a"]]]
        set response_code       "Ok"
        set response_message    "Alerts List"
        set response_body       $body
    }

    if {$response_body eq ""} {
        set return_data_json [ctrl::restful::api_return -response_code      "$response_code" \
                                                        -response_message   "$response_message" \
                                                        -response_body      ""]
    } else {
        set return_data_json [ctrl::restful::api_return -response_code      "$response_code" \
                                                        -response_message   "$response_message" \
                                                        -response_body      "$response_body" \
                                                        -response_body_value_p f]
    }

    doc_return 200 application/json $return_data_json
    ad_script_abort
}
