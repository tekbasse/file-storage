<?xml version="1.0"?>
<queryset>

<fullquery name="duplicate_check">      
      <querytext>
      
    select count(*)
    from   cr_items
    where  name = :name
    and    parent_id = :parent_id
      </querytext>
</fullquery>

 
</queryset>
