
### 任务计划 XML 文件说明

由于通过 `SchTasks` 创建任务计划无法添加描述信息，所以使用导出已经创建的任务计划导出为 XML；
但是导出之后 XML 需要一定的处理才能使用

+ 更新作者信息，需要统一为 `Knowlesys`
    - `<RegistrationInfo>` 下的 `<Author>` 节点值
+ 去掉 `<Principals>` 节点内的内容
+ 将启用改为禁用
    - 修改 `<Settings>` 节点下的 `<Enabled>` 节点的值为 `false` 