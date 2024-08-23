#!/bin/bash

# Add a feed source

cd package
git clone https://github.com/kenzok8/small.git
git clone https://github.com/kuoruan/openwrt-frp.git
git clone https://github.com/xiaoxiao29/luci-app-adguardhome.git
git clone https://github.com/jerrykuku/lua-maxminddb.git
git clone https://github.com/immortalwrt/homeproxy.git

wget https://github.com/kkstone/Actions-RAX3000M-eMMC/raw/main/luci-packages/luci-app-frp.zip
unzip luci-app-frp.zip && rm -rf luci-app-frp.zip
wget https://github.com/kkstone/Actions-RAX3000M-eMMC/raw/main/luci-packages/luci-app-wolplus.zip
unzip luci-app-wolplus.zip && rm -rf luci-app-wolplus.zip
