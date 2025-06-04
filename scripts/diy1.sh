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
wget -N -O feeds/packages/net/tcping/Makefile https://cdn.jsdelivr.net/gh/immortalwrt/packages@master/net/tcping/Makefile
wget -r -np -nH --cut-dirs=4 -P feeds/packages/net/ https://cdn.jsdelivr.net/gh/immortalwrt/packages@master/net/tcping/ && find feeds/packages/net/tcping -type f -name "index.html*" -exec rm {} \;
wget -r -np -nH --cut-dirs=4 -P feeds/packages/net/ https://cdn.jsdelivr.net/gh/immortalwrt/packages@master/net/natmap/ && find feeds/packages/net/natmap -type f -name "index.html*" -exec rm {} \;
wget -r -np -nH --cut-dirs=4 -P feeds/packages/net/ https://cdn.jsdelivr.net/gh/immortalwrt/packages@master/net/ddns-go/ && find feeds/packages/net/ddns-go -type f -name "index.html*" -exec rm {} \;
wget -r -np -nH --cut-dirs=4 -P feeds/packages/utils/ https://cdn.jsdelivr.net/gh/immortalwrt/packages@master/utils/ttyd/ && find feeds/packages/utils/ttyd -type f -name "index.html*" -exec rm {} \;
wget -r -np -nH --cut-dirs=4 -P feeds/packages/utils/ https://cdn.jsdelivr.net/gh/immortalwrt/packages@master/utils/7z/ && find feeds/packages/utils/7z -type f -name "index.html*" -exec rm {} \;

unzip -d ./ $GITHUB_WORKSPACE/luci-packages/luci-app-frp.zip
unzip -d ./ $GITHUB_WORKSPACE/luci-packages/luci-app-wolplus.zip
