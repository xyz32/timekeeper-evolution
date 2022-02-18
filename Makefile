VER = 1.4
ID = kde.plasma.timekeeper

view:
			plasmoidviewer --size 650x600 --applet package
qml:
			qmlscene ./package/contents/ui/Main.qml
install: version
			kpackagetool5 -t Plasma/Applet --install package
upgrade: version
			kpackagetool5 -t Plasma/Applet --upgrade package
remove:
			kpackagetool5 -t Plasma/Applet --remove $(ID)
ls:
			kpackagetool5 --list --type Plasma/Applet


version:
			sed -i 's/^X-KDE-PluginInfo-Version=.*$$/X-KDE-PluginInfo-Version=$(VER)/' package/metadata.desktop
			sed -i 's/^X-KDE-PluginInfo-Name=.*$$/X-KDE-PluginInfo-Name=$(ID)/' package/metadata.desktop


plasmoid: version
			rm TimeKeeperEvolution*.plasmoid; cd package; zip -9 -r ../TimeKeeperEvolution-$(VER).plasmoid *
7z: version
			cd package; 7z a -tzip ../TimeKeeperEvolution-$(VER).plasmoid *



clear:
			find . -type f -name '*.qmlc' -delete
			find . -type f -name '*.jsc'  -delete
