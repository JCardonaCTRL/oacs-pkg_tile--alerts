<?xml version="1.0"?>

<queryset>
    <fullquery name="tile::alerts::ws::get_published_news.select">
        <querytext>
            select
                item_id,
                publish_title,
                publish_body,
                to_char(publish_date, 'YYYY-MM-DD') as publish_date_ansi,
                to_char(archive_date, 'YYYY-MM-DD') as archive_date_ansi,
                to_char(creation_date, 'YYYY-MM-DD') as creation_date,
                content_revision__get_number(live_revision) as revision_no,
                status,
                news_id,
                item_creator
            from
                news_items_live_or_submitted
            where
                package_id = :news_package_id and status like 'published%'
            order by publish_date_ansi desc
        </querytext>
    </fullquery>
</queryset>
