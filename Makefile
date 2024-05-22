APP_VERSION := $(shell sed -e '/"Version"/!d' -e 's/.*\: //' -e 's/,//' ./package/metadata.json | tr -d '"')
APP_ID := $(shell sed -e '/"Id"/!d' -e 's/.*\: //' -e 's/,//' ./package/metadata.json | tr -d '"')

view:
			plasmoidviewer --size 650x600 --applet package
qml:
			qmlscene ./package/contents/ui/Main.qml
install:
			kpackagetool6 -t Plasma/Applet --install package
upgrade:
			kpackagetool6 -t Plasma/Applet --upgrade package
remove:
			kpackagetool6 -t Plasma/Applet --remove $(APP_ID)
ls:
			kpackagetool6 --list --type Plasma/Applet

plasmoid:
			rm TimeKeeperEvolution*.plasmoid; cd package; zip -9 -r ../TimeKeeperEvolution-$(APP_VERSION).plasmoid *
7z:
			cd package; 7z a -tzip ../TimeKeeperEvolution-$(APP_VERSION).plasmoid *



clean:
			find . -type f -name '*.qmlc' -delete
			find . -type f -name '*.jsc'  -delete
