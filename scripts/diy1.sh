#!/bin/bash

# Add a feed source

cd package
git clone https://github.com/xiaorouji/openwrt-passwall.git
git clone https://github.com/xiaorouji/openwrt-passwall-packages.git
git clone https://github.com/kuoruan/openwrt-frp.git
git clone https://github.com/xiaoxiao29/luci-app-adguardhome.git
git clone https://github.com/jerrykuku/lua-maxminddb.git
git clone https://github.com/mwarning/zerotier-openwrt.git

unzip -d ./ $GITHUB_WORKSPACE/luci-packages/luci-app-frp.zip
unzip -d ./ $GITHUB_WORKSPACE/luci-packages/luci-app-wolplus.zip
