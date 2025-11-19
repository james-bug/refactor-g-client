# Copyright (C) 2025 Gaming System Project
# This is free software, licensed under the GPL-2.0

include $(TOPDIR)/rules.mk

PKG_NAME:=gaming-core
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

PKG_MAINTAINER:=Gaming System Team
PKG_LICENSE:=GPL-2.0

include $(INCLUDE_DIR)/package.mk


define Package/gaming-core
  SECTION:=BenQ
  CATEGORY:=BenQ
  TITLE:=Gaming System Core Library
  SUBMENU:=Applications
  DEPENDS:=+libc +libuci +libubox +libubus
endef


define Package/gaming-core/description
  Gaming System Core Library provides hardware abstraction layer (HAL),
  GPIO control, LED controller, ADC reader, logger, config parser,
  and socket helper for gaming-client and gaming-server packages.
  
  Features:
  - HAL (Hardware Abstraction Layer)
  - GPIO Library with interrupt support
  - RGB LED Controller (PWM)
  - ADC Reader for device type detection
  - Logger (syslog integration)
  - UCI Config Parser
  - Socket Helper (Unix/TCP)
  - Unified Init Script with device detection
endef

define Package/gaming-core/conffiles
/etc/config/gaming
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

define Build/Compile
	$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) \
		-fPIC -shared \
		-I$(PKG_BUILD_DIR) \
		$(PKG_BUILD_DIR)/logger.c \
		$(PKG_BUILD_DIR)/config_parser.c \
		$(PKG_BUILD_DIR)/socket_helper.c \
		-o $(PKG_BUILD_DIR)/libgaming-core.so \
		-luci -lubox -lubus
endef

define Package/gaming-core/install
	# 安裝共享庫
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/libgaming-core.so $(1)/usr/lib/
	
	# 安裝標頭檔 (供其他套件使用)
	$(INSTALL_DIR) $(1)/usr/include/gaming
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/gaming_common.h $(1)/usr/include/gaming/
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/logger.h $(1)/usr/include/gaming/
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/config_parser.h $(1)/usr/include/gaming/
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/socket_helper.h $(1)/usr/include/gaming/
	
	
endef

$(eval $(call BuildPackage,gaming-core))
