

export default {
    full: [
        {
            name: 'app_parameter',
        },
        /*{
            name: 'black_list',
        },
        {
            name: 'black_word',
        },*/
        {
            name: 'city',
        },
        {
            name: 'column_keyword',
        },
        {
            name: 'db_check_sql',
        },
        {
            name: 'db_check_sql_group',
        },
        {
            name: 'district',
        },
        {
            name: 'disturb_word',
        },
        {
            name: 'domain',
        },
        {
            name: 'email_attachment',
        },
        {
            name: 'extract_config',
        },
        {
            name: 'industry',
        },
        {
            name: 'junk_word',
        },
        {
            name: 'junk_word_class',
        },
        {
            name: 'keyword_disturb_word',
        },
        {
            name: 'list_page_type_to_website',
        },
        {
            name: 'listpage_url',
        },
        {
            name: 'media_type',
        },
        {
            name: 'node_group',
        },
        {
            name: 'operation_object',
        },
        {
            name: 'private_word',
        },
        {
            name: 'privilege',
        },
        {
            name: 'province',
        },
        {
            name: 'reject_domain',
        },
        {
            name: 'reject_domain_class',
        },
        {
            name: 'reject_url',
        },
        {
            name: 'report_template',
        },
        {
            name: 'report_variable_meta',
        },
        {
            name: 'role',
        },
        {
            name: 'select_sql',
        },
        {
            name: 'server_log_file',
        },
        {
            name: 'service_type',
        },
        {
            name: 'subject_classify_rule',
        },
        {
            name: 'subject_search_rule',
        },
        {
            name: 'system_version_history',
        },
        {
            name: 'task_schedule',
        },
        {
            name: 'website',
        },
        {
            name: 'website_group',
        },
        {
            name: 'website_run_batch_file',
        },
    ],
    part: [
        {
            name: 'client',
            where: 'Client_ID=24',
        },
        /*{
            name: 'client_black_list',
            where: '',
        },
        {
            name: 'client_list_page',
            where: '',
        },
        {
            name: 'client_ui',
            where: '',
        },*/
        {
            name: 'client_word_lib',
            where: 'Client_ID=24',
        },
        /*{
            name: 'subject_category',
            where: '',
        },*/
        {
            name: 'users',
            where: 'User_ID=1',
        },
        {
            name: 'word',
            where: 'Word_Lib_ID IN(SELECT Word_Lib_ID FROM word_lib WHERE Client_ID=24)',
        },
        {
            name: 'word_lib',
            where: 'Client_ID=24',
        },
    ]
}