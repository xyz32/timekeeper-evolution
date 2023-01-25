APP_VERSION := $(shell grep "X-KDE-PluginInfo-Version" ./package/metadata.desktop | sed -E  's/(.*)=(.*)/\2/')
APP_ID := $(shell grep "X-KDE-PluginInfo-Name" ./package/metadata.desktop | sed -E  's/(.*)=(.*)/\2/')

view:
			plasmoidviewer --size 650x600 --applet package
qml:
			qmlscene ./package/contents/ui/Main.qml
install:
			kpackagetool5 -t Plasma/Applet --install package
upgrade:
			kpackagetool5 -t Plasma/Applet --upgrade package
remove:
			kpackagetool5 -t Plasma/Applet --remove $(APP_ID)
ls:
			kpackagetool5 --list --type Plasma/Applet

plasmoid:
			rm TimeKeeperEvolution*.plasmoid; cd package; zip -9 -r ../TimeKeeperEvolution-$(APP_VERSION).plasmoid *
7z:
			cd package; 7z a -tzip ../TimeKeeperEvolution-$(APP_VERSION).plasmoid *



clean:
			find . -type f -name '*.qmlc' -delete
			find . -type f -name '*.jsc'  -delete
