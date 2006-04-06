ad_page_contract {

    Multiple move page.
    Supports any file-storage supported content_item
    Allows move of single or multiple items

    @author Dave Bauer dave@thedesignexperience.org
    
} -query {
    object_id:notnull,integer,multiple
    folder_id:integer,optional
    {return_url ""}
    {root_folder_id ""}
    {redirect_to_folder:boolean 0}
    {show_items:boolean 0}
} -errors {object_id:,notnull,integer,multiple {Please select at least one item to move.}
}

set objects_to_move $object_id
set object_id_list [join $object_id ","]

set user_id [ad_conn user_id]

set allowed_count 0
set not_allowed_count 0

db_multirow -extend {move_message} move_objects get_move_objects "" {
    if {$move_p} {
	set move_message ""
	incr allowed_count
    } else {
	set move_message [_ file_storage.Not_Allowed]
	incr not_allowed_count
    }
  
}

set total_count [template::multirow size move_objects]

if {$not_allowed_count > 0} {
    set show_items 1
}

if {[info exists folder_id]} {

     permission::require_permission \
 	-party_id $user_id \
 	-object_id $folder_id \
 	-privilege "write"


    # check for WRTIE permission on each object to be moved
    # DaveB: I think it should be DELETE instead of WRITE
    # but the existing file-move page checks for WRITE
     set error_items [list]
    template::multirow foreach move_objects {
	db_transaction {
	    db_exec_plsql move_item {}
	} on_error {
	    lappend error_items $name
	}
    }    
     if {[llength $error_items]} {
	 set message "There was a problem moving the following items: [join $error_items ", "]"
     } else {
	 set message "Selected items moved"
     }
     ad_returnredirect -message $message $return_url
     ad_script_abort

 } else {

    template::list::create \
	-name move_objects \
	-multirow move_objects \
	-elements {
	    name {label \#file-storage.Files_to_be_moved\#}
	    move_message {}
	}
    
    template::list::create \
        -name folder_tree \
        -pass_properties { item_id redirect_to_folder return_url } \
        -multirow folder_tree \
        -key folder_id \
	-no_data [_ file-storage.No_valid_destination_folders_exist] \
        -elements {
            label {
                label "\#file-storage.Choose_Destination_Folder\#"
                link_url_col move_url
		link_html {title "\#file-storage.Move_to_folder_title\#"}
		display_template {<div style="text-indent: @folder_tree.level_num@em;">@folder_tree.label@</div>} 
            }
        }

    if {[empty_string_p $root_folder_id]} {
	set root_folder_id [fs::get_root_folder]
    }
    set object_id $objects_to_move
    db_multirow -extend {move_url level} folder_tree get_folder_tree "" {
	# teadams 2003-08-22 - change level to level num to avoid 
	# Oracle issue with key words.

	set move_url [export_vars -base "move" { object_id:multiple folder_id return_url }]

	
    }

}

set context [list "\#file-storage.Move\#"]
set title "\#file-storage.Move\#"
