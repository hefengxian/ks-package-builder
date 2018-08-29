### 生成数据库 DDL 步骤

1. 生成 mysqldump 语句，配置好数据库信息，复制下面的 mysqldump 语句（已经排除无用的表）导出一个 DDL
2. 重置 `Auto_Increment` ，一般使用编辑器中的正则替换 `AUTO_INCREMENT=(\d+)` 生成的 DDL 文件
3. 删除无用的 Event （由于 mysqldump 没有过滤 Events/Triggers/Routines 的选项，所以只能手工删除）,搜索包含 `ev_sp_sync` 的 Event，一般这些语句在可执行注释里
4. 删除无用的 Routine ，搜索包含 `sp_sync` 的存储过程，然后删除，注意可执行注释里的也要删掉
5. 视情况是否要删除表的分区语句（可以不删），初始化数据库不需要分区，如果要删除可以使用 `/\*\!50500(\S*\s*\w+\S*\s*)+\*\/` 替换


### 使用 DDL 初始化 Data 目录

1. 清空 MySQL 配置的 Data 目录
2. 使用命令 `mysqld --initialize-insecure` 初始化 Data 目录
3. 启动 MySQL， 可以先建立服务再启动，或者直接使用 `mysqld --console` 启动
4. 修改 root 密码，顺便创建 mmt_app 用户
    1. `mysql -uroot --skip-password`
    2. 创建 mmt_app 用户 
        1. `CREATE USER 'mmt_app'@'%' IDENTIFIED WITH mysql_native_password BY 'poms@db';`
        2. `GRANT ALL ON *.* TO 'mmt_app'@'%';`
    3. 修改 root 用户
        1. `ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'poms@db';`
        2. `RENAME USER 'root'@'localhost' TO 'root'@'%';`
    4. `FLUSH PRIVILEGES;`
5. 导入 DDL 建立表结构 `mysql -uroot -ppoms@db --default-character-set utf8 < /path/to/mymonitor_ddl.sql`
6. 导入初始数据，复制初始数据中的 mysqldump 语句进行生成
7. Data 目录到此初始化完成
