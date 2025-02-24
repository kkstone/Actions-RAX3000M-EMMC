#!/bin/bash

#更改默认地址为192.168.6.1
sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate

#更改默认源地址为上海交大源
sed -i "s,mirrors.vsean.net/openwrt,mirrors.sdu.edu.cn/immortalwrt,g" package/emortal/default-settings/files/99-default-settings-chinese

#添加kmod-ipt-socket等Passwall必须模块
cp -rf $GITHUB_WORKSPACE/patchs/iptables-makefile.patch $GITHUB_WORKSPACE/openwrt/p1.patch
patch -p1 < $GITHUB_WORKSPACE/openwrt/p1.patch
cp -rf $GITHUB_WORKSPACE/patchs/netfilter.patch $GITHUB_WORKSPACE/openwrt/p2.patch
patch -p1 < $GITHUB_WORKSPACE/openwrt/p2.patch
