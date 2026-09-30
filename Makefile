APP_NAME      := DayNight
CONFIG        := release
BIN           := .build/$(CONFIG)/$(APP_NAME)
APP           := build/$(APP_NAME).app
ICON          := AppIcon.icns
INSTALL_DIR   ?= /Applications
# Ad-hoc signing keeps the app self-contained. Point SIGN_IDENTITY at a
# self-signed certificate to get a stable TCC identity across rebuilds.
SIGN_IDENTITY ?= -
# Install with AUTOLOAD=1 to add the app to Login Items.
AUTOLOAD      ?=

.PHONY: all build test app run install uninstall clean

all: app

build:
	swift build -c $(CONFIG)

test:
	swift test

app: build
	rm -rf "$(APP)"
	mkdir -p "$(APP)/Contents/MacOS" "$(APP)/Contents/Resources"
	cp "$(BIN)" "$(APP)/Contents/MacOS/$(APP_NAME)"
	cp "$(ICON)" "$(APP)/Contents/Resources/AppIcon.icns"
	cp Info.plist "$(APP)/Contents/Info.plist"
	printf 'APPL????' > "$(APP)/Contents/PkgInfo"
	codesign --force --sign "$(SIGN_IDENTITY)" "$(APP)"
	@echo "Built $(APP)"

run: app
	open "$(APP)"

install: app
	mkdir -p "$(INSTALL_DIR)"
	pkill -x $(APP_NAME) 2>/dev/null || true
	sleep 1
	rm -rf "$(INSTALL_DIR)/$(APP_NAME).app"
	ditto "$(APP)" "$(INSTALL_DIR)/$(APP_NAME).app"
ifeq ($(AUTOLOAD),1)
	@if osascript -e 'tell application "System Events" to get the name of every login item' 2>/dev/null \
		| tr ',' '\n' | sed 's/^ *//;s/ *$$//' | grep -qx '$(APP_NAME)'; then \
		echo "Already in Login Items"; \
	else \
		osascript -e 'tell application "System Events" to make login item at end with properties {path:"$(INSTALL_DIR)/$(APP_NAME).app", hidden:true}' >/dev/null; \
		echo "Added to Login Items"; \
	fi
endif
	open "$(INSTALL_DIR)/$(APP_NAME).app"
	@echo "Installed $(INSTALL_DIR)/$(APP_NAME).app"

uninstall:
	pkill -x $(APP_NAME) 2>/dev/null || true
	sleep 1
	@if osascript -e 'tell application "System Events" to get the name of every login item' 2>/dev/null \
		| tr ',' '\n' | sed 's/^ *//;s/ *$$//' | grep -qx '$(APP_NAME)'; then \
		osascript -e 'tell application "System Events" to delete login item "$(APP_NAME)"' >/dev/null; \
		echo "Removed login item"; \
	fi
	@if [ -d "$(INSTALL_DIR)/$(APP_NAME).app" ]; then \
		rm -rf "$(INSTALL_DIR)/$(APP_NAME).app"; \
		echo "Removed $(INSTALL_DIR)/$(APP_NAME).app"; \
	else \
		echo "Nothing to remove at $(INSTALL_DIR)/$(APP_NAME).app"; \
	fi

clean:
	swift package clean
	rm -rf build
