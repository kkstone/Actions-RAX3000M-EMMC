#!/bin/bash

# Add a feed source

cd package
git clone https://github.com/xiaorouji/openwrt-passwall.git
git clone https://github.com/xiaorouji/openwrt-passwall-packages.git && rm -rf openwrt-passwall-packages/tcping
git clone https://github.com/xiaoxiao29/luci-app-adguardhome.git
git clone https://github.com/jerrykuku/lua-maxminddb.git
git clone https://github.com/kuoruan/openwrt-frp.git -b releases/v0.63.0-1
git clone https://github.com/mwarning/zerotier-openwrt.git -b 1.14.2 && rm -rf zerotier-openwrt/zerotier/files/etc/init.d/zerotier
git clone https://github.com/kkstone/7zz-openwrt.git

unzip -d ./ $GITHUB_WORKSPACE/luci-packages/luci-app-frp.zip
unzip -d ./ $GITHUB_WORKSPACE/luci-packages/luci-app-wolplus.zip
