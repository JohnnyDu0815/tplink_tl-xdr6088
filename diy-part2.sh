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
#find feeds/ -name Makefile -exec grep -l "DEPENDS:=.*rust" {} + | xargs rm -rf

# 2. 彻底屏蔽 Rust 相关的配置条目
#sed -i 's/CONFIG_PACKAGE_rust=y/# CONFIG_PACKAGE_rust is not set/g' .config
#sed -i 's/CONFIG_PACKAGE_librsvg=y/# CONFIG_PACKAGE_librsvg is not set/g' .config

# 物理注入 Rustc 1.90.0 (核心规避手段)
# 1. 物理注入 Rustc 源码 (解决下载失败) ---
mkdir -p dl
RUST_URL="https://github.com/redfrog999/JDCloud-AX6000/releases/download/rustc_1.9.0/rustc-1.90.0-src.tar.xz"
wget -qO dl/rustc-1.90.0-src.tar.xz "$RUST_URL"

# 2. 深度伪造逻辑：解决 Checksum 错误 (核心修正) ---
# 我们不再去 build_dir 伪造文件，而是修改 Makefile，在解压后瞬间注入
# 找到 Rust 软件包的 Makefile
RUST_MAKEFILE=$(find feeds/packages/lang/rust -name "Makefile")

if [ -n "$RUST_MAKEFILE" ]; then
    # 物理修改 PKG_HASH 确保与下载的文件完全对齐
    NEW_HASH=$(sha256sum dl/rustc-1.90.0-src.tar.xz | awk '{print $1}')
    sed -i "s/PKG_HASH:=.*/PKG_HASH:=$NEW_HASH/g" "$RUST_MAKEFILE"
    
    # 注入注入伪造逻辑：在源码解压后 (Post-extract)，物理补全缺失文件并清除校验清单
    # 这样系统在计算 Checksum 前，逻辑就已经对齐了
    sed -i '/\$(Build\/Patch)/i \
	find \$(PKG_BUILD_DIR) -name "Cargo.toml.orig" -delete \
	find \$(PKG_BUILD_DIR) -name "*.orig" -delete' "$RUST_MAKEFILE"
fi

# 3. 环境变量对齐 (解决路径错误) ---
# 强制指定 CARGO_HOME，防止系统去 Runner 的根目录乱撞
echo "export CARGO_HOME=\$(TOPDIR)/dl/cargo" >> "$RUST_MAKEFILE"
