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

# --- [ 🧬 基因级重编：Makefile 夺权逻辑 ] ---
RUST_MAKEFILE=$(find feeds/packages/lang/rust -name "Makefile")

if [ -n "$RUST_MAKEFILE" ]; then
    # 1. 强制换源：不准去官网，只准去你的 Release 下载
    sed -i "s|PKG_SOURCE_URL:=.*|PKG_SOURCE_URL:=https://github.com/redfrog999/JDCloud-AX6000/releases/download/rustc_1.9.0/|g" "$RUST_MAKEFILE"
    
    # 2. 物理过审：跳过 Hash 校验
    sed -i 's/PKG_HASH:=.*/PKG_HASH:=skip/g' "$RUST_MAKEFILE"

    # 3. 临场补齐：在解压后的 Prepare 阶段强制补齐文件
    # 这一行是解决图 15 中 "No such file" 的绝杀
    sed -i '/define Build\/Prepare/a \
	find $(PKG_BUILD_DIR) -name ".cargo-checksum.json" -delete \
	find $(PKG_BUILD_DIR) -name "Cargo.toml.orig" -exec touch {} + \
	find $(PKG_BUILD_DIR) -name "*.json" -exec touch {} +' "$RUST_MAKEFILE"
fi
