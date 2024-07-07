<?xml version="1.0"?>

<queryset>

    <fullquery name="tile::alerts::ws::get_published_news.get_public_group">
        <querytext>
            select g.group_id
            from groups           g
                join acs_objects  obj on g.group_id = obj.object_id
            where obj.object_type = :group_type_name
                and g.group_name  = :public_group
        </querytext>
    </fullquery>
</queryset>
