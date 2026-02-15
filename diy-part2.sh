#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate

#sed -i 's/ci-llvm=true/ci-llvm=false/g' feeds/packages/lang/rust/Makefile

# 1. 找出所有在 Makefile 里定义了依赖 rust 的包并强制删除它们
find feeds/ -name Makefile -exec grep -l "DEPENDS:=.*rust" {} + | xargs rm -rf

# 2. 彻底屏蔽 Rust 相关的配置条目
sed -i 's/CONFIG_PACKAGE_rust=y/# CONFIG_PACKAGE_rust is not set/g' .config
sed -i 's/CONFIG_PACKAGE_librsvg=y/# CONFIG_PACKAGE_librsvg is not set/g' .config
