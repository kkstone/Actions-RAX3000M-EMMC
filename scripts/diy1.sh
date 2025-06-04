#!/bin/bash

# Add a feed source

cd package
rm -rf feeds/packages/net/{xray-core,v2ray-core,v2ray-geodata,sing-box,frp,smartdns,zerotier,natmap,ddns-go}
rm -rf feeds/luci/luci-app-frp*
rm -rf feeds/packages/utils/{ttyd,7z}

git clone https://github.com/xiaorouji/openwrt-passwall.git
git clone https://github.com/xiaorouji/openwrt-passwall-packages.git
git clone https://github.com/kuoruan/openwrt-frp.git
git clone https://github.com/xiaoxiao29/luci-app-adguardhome.git
git clone https://github.com/jerrykuku/lua-maxminddb.git
git clone https://github.com/mwarning/zerotier-openwrt.git
git clone https://github.com/pymumu/openwrt-smartdns.git
wget -O -N feeds/packages/net/tcping/Makefile https://cdn.jsdelivr.net/gh/immortalwrt/packages@master/net/tcping/Makefile
wget -r --no-parent https://cdn.jsdelivr.net/gh/immortalwrt/packages@master/net/natmap/ && cp -rf cdn.jsdelivr.net/gh/immortalwrt/packages@master/net/natmap feeds/packages/net/natmap/ && rm -rf cdn.jsdelivr.net && find feeds/packages/net/natmap -name index.html -exec rm {} \;
wget -r --no-parent https://cdn.jsdelivr.net/gh/immortalwrt/packages@master/net/ddns-go/ && cp -rf cdn.jsdelivr.net/gh/immortalwrt/packages@master/net/ddns-go feeds/packages/net/ddns-go/ && rm -rf cdn.jsdelivr.net && find feeds/packages/net/ddns-go -name index.html -exec rm {} \;
wget -r --no-parent https://cdn.jsdelivr.net/gh/immortalwrt/packages@master/utils/ttyd/ && cp -rf cdn.jsdelivr.net/gh/immortalwrt/packages@master/utils/ttyd feeds/packages/utils/ttyd/ && rm -rf cdn.jsdelivr.net && find feeds/packages/utils/ttyd -name index.html -exec rm {} \;
wget -r --no-parent https://cdn.jsdelivr.net/gh/immortalwrt/packages@master/utils/7z/ && cp -rf cdn.jsdelivr.net/gh/immortalwrt/packages@master/utils/7z feeds/packages/utils/7z/ && rm -rf cdn.jsdelivr.net && find feeds/packages/utils/7z -name index.html -exec rm {} \;

unzip -d ./ $GITHUB_WORKSPACE/luci-packages/luci-app-frp.zip
unzip -d ./ $GITHUB_WORKSPACE/luci-packages/luci-app-wolplus.zip
