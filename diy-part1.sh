#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default

#echo 'src-git JohnnyDu0815 https://github.com/JohnnyDu0815/small-package' >>feeds.conf.default

#echo 'src-git JohnnyDu0815 https://github.com/JohnnyDu0815/openwrt-packages' >>feeds.conf.default

git clone https://github.com/JohnnyDu0815/luci-app-adguardhome.git package/luci-app-adguardhome
chmod -R 755 ./package/luci-app-adguardhome/*

#git clone https://github.com/vernesong/OpenClash.git package/luci-app-openclash
#rm -rf feeds/luci/applications/luci-app-openclash
