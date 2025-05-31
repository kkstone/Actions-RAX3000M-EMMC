#!/bin/bash

#更改默认地址为192.168.6.1
#sed -i 's/192.168.1.1/192.168.6.1/g' package/base-files/files/bin/config_generate

#更改默认源地址为上海交大源
sed -i "s,mirrors.vsean.net/openwrt,mirrors.sjtug.sjtu.edu.cn/immortalwrt,g" package/emortal/default-settings/files/99-default-settings-chinese
