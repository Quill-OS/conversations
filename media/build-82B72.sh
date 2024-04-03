#!/bin/bash
# ./configure -list-features

# Im not sure about:
# linguist
# poll-exit-on-error but added
#  -qt-zlib \
#  -no-feature-animation \ // Needed by qml animation which is needed by qt quick

# https://doc.qt.io/qt-6/configure-options.html
# https://doc.qt.io/qt-6/configure-linux-device.html
# https://wiki.qt.io/Cross-compiling_Qt_6.5_for_both_armhf_and_aarch64_architectures_for_Raspberry_Pi_OS

# install qt6-base qt6-shadertools

clear

QT_SRC_DIR=qt-everywhere-src-6.6.1

PATH=$PATH:/home/build/inkbox/compiled-binaries/arm-kobo-linux-gnueabihf/bin/
SYSROOT=/home/build/inkbox/compiled-binaries/arm-kobo-linux-gnueabihf/arm-kobo-linux-gnueabihf/sysroot
QT_DIR=qt-linux-6.5-kobo
QT_INSTALL_PATH=/home/build/inkbox/compiled-binaries/qt-bin/$QT_DIR
QT_HOST_PATH=/home/build/inkbox/compiled-binaries/qt-bin/$QT_DIR-host

mkdir -p ${QT_INSTALL_PATH}
mkdir -p ${QT_HOST_PATH}

cp -r linux-kobo-gnueabihf-g++ $QT_SRC_DIR/qtbase/mkspecs
cd $QT_SRC_DIR
cmake --build . --target clean
rm CMakeCache.txt

./configure -opensource -confirm-license -release -verbose \
 -prefix /mnt/onboard/.adds/${QTDIR} \
 -extprefix ${QT_INSTALL_PATH} \
 -qt-host-path ${QT_HOST_PATH} \
 -device linux-kobo-gnueabihf-g++ \
 -platform linux-kobo-gnueabihf-g++ \
 -openssl-linked OPENSSL_PREFIX="${SYSROOT}/usr" \
 -device-option CROSS_COMPILE=/home/build/inkbox/compiled-binaries/arm-kobo-linux-gnueabihf/bin/arm-kobo-linux-gnueabihf- \
 -opengl es2 \
 -skip qtquick3dphysics \
 -skip qtspeech \
 -skip qttranslations \
 -skip qtvirtualkeyboard \
 -skip qtwebengine \
 -skip qtserialport \
 -skip qtdoc \
 -skip qtgrpc \
 -skip qtopcua \
 -skip qtgraphs \
 -skip qtremoteobjects \
 -skip qtscxml \
 -skip qtwebview \
 -skip qtlocation \
 -skip qtserialbus \
 -skip qtlottie \
 -skip qtquick3d \
 -qt-libjpeg \
 -qt-libpng \
 -qt-freetype \
 -qt-pcre \
 -qt-harfbuzz \
 -no-feature-androiddeployqt \
 -no-feature-appstore-compliant \
 -no-feature-assistant \
 -no-feature-batch_test_support \
 -no-feature-brotli \
 -no-feature-cpp-winrt \
 -no-feature-cups \
 -no-feature-desktopservices \
 -no-feature-jalalicalendar \
 -no-feature-macdeployqt \
 -no-feature-modbus-serialport \
 -no-feature-poll-exit-on-error \
 -no-feature-printdialog \
 -no-feature-printer \
 -no-feature-printpreviewdialog \
 -no-feature-printpreviewwidget \
 -no-feature-qdbus \
 -no-feature-qt3d-opengl-renderer \
 -no-feature-qt3d-rhi-renderer \
 -no-feature-qtprotobufgen \
 -no-feature-qtwebengine-build \
 -no-feature-qtwebengine-core-build \
 -no-feature-qtwebengine-quick-build \
 -no-feature-qtwebengine-widgets-build \
 -no-feature-wasm-exceptions \
 -no-feature-wasm-simd128 \
 -no-feature-wayland-compositor-quick \
 -no-feature-wayland-text-input-v4-wip \
 -no-feature-webengine-developer-build \
 -no-feature-webengine-embedded-build \
 -no-feature-webengine-extensions \
 -no-feature-webengine-full-debug-info \
 -no-feature-webengine-jumbo-build \
 -no-feature-webengine-kerberos \
 -no-feature-webengine-native-spellchecker \
 -no-feature-webengine-pepper-plugins \
 -no-feature-webengine-printing-and-pdf \
 -no-feature-webengine-proprietary-codecs \
 -no-feature-webengine-sanitizer \
 -no-feature-webengine-spellchecker \
 -no-feature-webengine-vulkan \
 -no-feature-webengine-webchannel \
 -no-feature-webengine-webrtc \
 -no-feature-webengine-webrtc-pipewire \
 -feature-animation \
 -feature-qml-animation \
 -nomake examples \
 -nomake tests \
 -nomake benchmarks \
 -nomake manual-tests \
 -nomake minimal-static-tests \
 -- -DCMAKE_TOOLCHAIN_FILE=/mnt/data/projects/kobo.cmake \
 -DQt6_DIR=/usr/lib/cmake/Qt6 \
 -DQt6Gui_DIR=/usr/lib/cmake/Qt6Gui \
 -DQt6Core_DIR=/usr/lib/cmake/Qt6Core \
 -DQt6BuildInternals_DIR=/usr/lib/cmake/Qt6BuildInternals \
 -DQt6Bundled_Clip2Tri_DIR=/usr/lib/cmake/Qt6Bundled_Clip2Tri \
 -DQt6BundledEmbree_DIR=/usr/lib/cmake/Qt6BundledEmbree \
 -DQt6BundledOpenwnn_DIR=/usr/lib/cmake/Qt6BundledOpenwnn \
 -DQt6BundledPinyin_DIR=/usr/lib/cmake/Qt6BundledPinyin \
 -DQt6BundledResonanceAudio_DIR=/usr/lib/cmake/Qt6BundledResonanceAudio \
 -DQt6BundledTcime_DIR=/usr/lib/cmake/Qt6BundledTcime \
 -DQt6Concurrent_DIR=/usr/lib/cmake/Qt6Concurrent \
 -DQt6Core5Compat_DIR=/usr/lib/cmake/Qt6Core5Compat \
 -DQt6CoreTools_DIR=/usr/lib/cmake/Qt6CoreTools \
 -DQt6DBus_DIR=/usr/lib/cmake/Qt6DBus \
 -DQt6DBusTools_DIR=/usr/lib/cmake/Qt6DBusTools \
 -DQt6Designer_DIR=/usr/lib/cmake/Qt6Designer \
 -DQt6DesignerComponentsPrivate_DIR=/usr/lib/cmake/Qt6DesignerComponentsPrivate \
 -DQt6DeviceDiscoverySupportPrivate_DIR=/usr/lib/cmake/Qt6DeviceDiscoverySupportPrivate \
 -DQt6EglFSDeviceIntegrationPrivate_DIR=/usr/lib/cmake/Qt6EglFSDeviceIntegrationPrivate \
 -DQt6EglFsKmsGbmSupportPrivate_DIR=/usr/lib/cmake/Qt6EglFsKmsGbmSupportPrivate \
 -DQt6EglFsKmsSupportPrivate_DIR=/usr/lib/cmake/Qt6EglFsKmsSupportPrivate \
 -DQt6ExampleIconsPrivate_DIR=/usr/lib/cmake/Qt6ExampleIconsPrivate \
 -DQt6FbSupportPrivate_DIR=/usr/lib/cmake/Qt6FbSupportPrivate \
 -DQt6GuiTools_DIR=/usr/lib/cmake/Qt6GuiTools \
 -DQt6Help_DIR=/usr/lib/cmake/Qt6Help \
 -DQt6HostInfo_DIR=/usr/lib/cmake/Qt6HostInfo \
 -DQt6HunspellInputMethod_DIR=/usr/lib/cmake/Qt6HunspellInputMethod \
 -DQt6InputSupportPrivate_DIR=/usr/lib/cmake/Qt6InputSupportPrivate \
 -DQt6KmsSupportPrivate_DIR=/usr/lib/cmake/Qt6KmsSupportPrivate \
 -DQt6LabsAnimation_DIR=/usr/lib/cmake/Qt6LabsAnimation \
 -DQt6LabsFolderListModel_DIR=/usr/lib/cmake/Qt6LabsFolderListModel \
 -DQt6LabsQmlModels_DIR=/usr/lib/cmake/Qt6LabsQmlModels \
 -DQt6LabsSettings_DIR=/usr/lib/cmake/Qt6LabsSettings \
 -DQt6LabsSharedImage_DIR=/usr/lib/cmake/Qt6LabsSharedImage \
 -DQt6LabsWavefrontMesh_DIR=/usr/lib/cmake/Qt6LabsWavefrontMesh \
 -DQt6Linguist_DIR=/usr/lib/cmake/Qt6Linguist \
 -DQt6LinguistTools_DIR=/usr/lib/cmake/Qt6LinguistTools \
 -DQt6Multimedia_DIR=/usr/lib/cmake/Qt6Multimedia \
 -DQt6MultimediaQuickPrivate_DIR=/usr/lib/cmake/Qt6MultimediaQuickPrivate \
 -DQt6MultimediaWidgets_DIR=/usr/lib/cmake/Qt6MultimediaWidgets \
 -DQt6Network_DIR=/usr/lib/cmake/Qt6Network \
 -DQt6OpenGL_DIR=/usr/lib/cmake/Qt6OpenGL \
 -DQt6OpenGLWidgets_DIR=/usr/lib/cmake/Qt6OpenGLWidgets \
 -DQt6PacketProtocolPrivate_DIR=/usr/lib/cmake/Qt6PacketProtocolPrivate \
 -DQt6Pdf_DIR=/usr/lib/cmake/Qt6Pdf \
 -DQt6PdfQuick_DIR=/usr/lib/cmake/Qt6PdfQuick \
 -DQt6PdfWidgets_DIR=/usr/lib/cmake/Qt6PdfWidgets \
 -DQt6Positioning_DIR=/usr/lib/cmake/Qt6Positioning \
 -DQt6PositioningQuick_DIR=/usr/lib/cmake/Qt6PositioningQuick \
 -DQt6PrintSupport_DIR=/usr/lib/cmake/Qt6PrintSupport \
 -DQt6QDocCatchConversionsPrivate_DIR=/usr/lib/cmake/Qt6QDocCatchConversionsPrivate \
 -DQt6QDocCatchGeneratorsPrivate_DIR=/usr/lib/cmake/Qt6QDocCatchGeneratorsPrivate \
 -DQt6QDocCatchPrivate_DIR=/usr/lib/cmake/Qt6QDocCatchPrivate \
 -DQt6Qml_DIR=/usr/lib/cmake/Qt6Qml \
 -DQt6QmlCompiler_DIR=/usr/lib/cmake/Qt6QmlCompiler \
 -DQt6QmlCore_DIR=/usr/lib/cmake/Qt6QmlCore \
 -DQt6QmlDebugPrivate_DIR=/usr/lib/cmake/Qt6QmlDebugPrivate \
 -DQt6QmlDomPrivate_DIR=/usr/lib/cmake/Qt6QmlDomPrivate \
 -DQt6QmlImportScanner_DIR=/usr/lib/cmake/Qt6QmlImportScanner \
 -DQt6QmlIntegration_DIR=/usr/lib/cmake/Qt6QmlIntegration \
 -DQt6QmlLocalStorage_DIR=/usr/lib/cmake/Qt6QmlLocalStorage \
 -DQt6QmlLSPrivate_DIR=/usr/lib/cmake/Qt6QmlLSPrivate \
 -DQt6QmlModels_DIR=/usr/lib/cmake/Qt6QmlModels \
 -DQt6QmlToolingSettingsPrivate_DIR=/usr/lib/cmake/Qt6QmlToolingSettingsPrivate \
 -DQt6QmlTools_DIR=/usr/lib/cmake/Qt6QmlTools \
 -DQt6QmlTypeRegistrarPrivate_DIR=/usr/lib/cmake/Qt6QmlTypeRegistrarPrivate \
 -DQt6QmlWorkerScript_DIR=/usr/lib/cmake/Qt6QmlWorkerScript \
 -DQt6QmlXmlListModel_DIR=/usr/lib/cmake/Qt6QmlXmlListModel \
 -DQt6Quick_DIR=/usr/lib/cmake/Qt6Quick \
 -DQt6Quick3D_DIR=/usr/lib/cmake/Qt6Quick3D \
 -DQt6Quick3DAssetImport_DIR=/usr/lib/cmake/Qt6Quick3DAssetImport \
 -DQt6Quick3DAssetUtils_DIR=/usr/lib/cmake/Qt6Quick3DAssetUtils \
 -DQt6Quick3DEffects_DIR=/usr/lib/cmake/Qt6Quick3DEffects \
 -DQt6Quick3DGlslParserPrivate_DIR=/usr/lib/cmake/Qt6Quick3DGlslParserPrivate \
 -DQt6Quick3DHelpers_DIR=/usr/lib/cmake/Qt6Quick3DHelpers \
 -DQt6Quick3DHelpersImpl_DIR=/usr/lib/cmake/Qt6Quick3DHelpersImpl \
 -DQt6Quick3DIblBaker_DIR=/usr/lib/cmake/Qt6Quick3DIblBaker \
 -DQt6Quick3DParticleEffects_DIR=/usr/lib/cmake/Qt6Quick3DParticleEffects \
 -DQt6Quick3DParticles_DIR=/usr/lib/cmake/Qt6Quick3DParticles \
 -DQt6Quick3DRuntimeRender_DIR=/usr/lib/cmake/Qt6Quick3DRuntimeRender \
 -DQt6Quick3DSpatialAudioPrivate_DIR=/usr/lib/cmake/Qt6Quick3DSpatialAudioPrivate \
 -DQt6Quick3DTools_DIR=/usr/lib/cmake/Qt6Quick3DTools \
 -DQt6Quick3DUtils_DIR=/usr/lib/cmake/Qt6Quick3DUtils \
 -DQt6QuickControls2_DIR=/usr/lib/cmake/Qt6QuickControls2 \
 -DQt6QuickControls2Impl_DIR=/usr/lib/cmake/Qt6QuickControls2Impl \
 -DQt6QuickControlsTestUtilsPrivate_DIR=/usr/lib/cmake/Qt6QuickControlsTestUtilsPrivate \
 -DQt6QuickDialogs2_DIR=/usr/lib/cmake/Qt6QuickDialogs2 \
 -DQt6QuickDialogs2QuickImpl_DIR=/usr/lib/cmake/Qt6QuickDialogs2QuickImpl \
 -DQt6QuickDialogs2Utils_DIR=/usr/lib/cmake/Qt6QuickDialogs2Utils \
 -DQt6QuickEffectsPrivate_DIR=/usr/lib/cmake/Qt6QuickEffectsPrivate \
 -DQt6QuickLayouts_DIR=/usr/lib/cmake/Qt6QuickLayouts \
 -DQt6QuickParticlesPrivate_DIR=/usr/lib/cmake/Qt6QuickParticlesPrivate \
 -DQt6QuickShapesPrivate_DIR=/usr/lib/cmake/Qt6QuickShapesPrivate \
 -DQt6QuickTemplates2_DIR=/usr/lib/cmake/Qt6QuickTemplates2 \
 -DQt6QuickTest_DIR=/usr/lib/cmake/Qt6QuickTest \
 -DQt6QuickTestUtilsPrivate_DIR=/usr/lib/cmake/Qt6QuickTestUtilsPrivate \
 -DQt6QuickTimeline_DIR=/usr/lib/cmake/Qt6QuickTimeline \
 -DQt6QuickWidgets_DIR=/usr/lib/cmake/Qt6QuickWidgets \
 -DQt6Sensors_DIR=/usr/lib/cmake/Qt6Sensors \
 -DQt6SensorsQuick_DIR=/usr/lib/cmake/Qt6SensorsQuick \
 -DQt6SerialPort_DIR=/usr/lib/cmake/Qt6SerialPort \
 -DQt6ShaderTools_DIR=/usr/lib/cmake/Qt6ShaderTools \
 -DQt6ShaderToolsTools_DIR=/usr/lib/cmake/Qt6ShaderToolsTools \
 -DQt6SpatialAudio_DIR=/usr/lib/cmake/Qt6SpatialAudio \
 -DQt6Sql_DIR=/usr/lib/cmake/Qt6Sql \
 -DQt6Svg_DIR=/usr/lib/cmake/Qt6Svg \
 -DQt6SvgWidgets_DIR=/usr/lib/cmake/Qt6SvgWidgets \
 -DQt6Test_DIR=/usr/lib/cmake/Qt6Test \
 -DQt6TextToSpeech_DIR=/usr/lib/cmake/Qt6TextToSpeech \
 -DQt6Tools_DIR=/usr/lib/cmake/Qt6Tools \
 -DQt6ToolsTools_DIR=/usr/lib/cmake/Qt6ToolsTools \
 -DQt6UiPlugin_DIR=/usr/lib/cmake/Qt6UiPlugin \
 -DQt6UiTools_DIR=/usr/lib/cmake/Qt6UiTools \
 -DQt6VirtualKeyboard_DIR=/usr/lib/cmake/Qt6VirtualKeyboard \
 -DQt6WaylandClient_DIR=/usr/lib/cmake/Qt6WaylandClient \
 -DQt6WaylandCompositor_DIR=/usr/lib/cmake/Qt6WaylandCompositor \
 -DQt6WaylandEglClientHwIntegrationPrivate_DIR=/usr/lib/cmake/Qt6WaylandEglClientHwIntegrationPrivate \
 -DQt6WaylandEglCompositorHwIntegrationPrivate_DIR=/usr/lib/cmake/Qt6WaylandEglCompositorHwIntegrationPrivate \
 -DQt6WaylandGlobalPrivate_DIR=/usr/lib/cmake/Qt6WaylandGlobalPrivate \
 -DQt6WaylandScannerTools_DIR=/usr/lib/cmake/Qt6WaylandScannerTools \
 -DQt6WebChannel_DIR=/usr/lib/cmake/Qt6WebChannel \
 -DQt6WebChannelQuick_DIR=/usr/lib/cmake/Qt6WebChannelQuick \
 -DQt6WebEngineCore_DIR=/usr/lib/cmake/Qt6WebEngineCore \
 -DQt6WebEngineCoreTools_DIR=/usr/lib/cmake/Qt6WebEngineCoreTools \
 -DQt6WebEngineQuick_DIR=/usr/lib/cmake/Qt6WebEngineQuick \
 -DQt6WebEngineQuickDelegatesQml_DIR=/usr/lib/cmake/Qt6WebEngineQuickDelegatesQml \
 -DQt6WebEngineWidgets_DIR=/usr/lib/cmake/Qt6WebEngineWidgets \
 -DQt6WebSockets_DIR=/usr/lib/cmake/Qt6WebSockets \
 -DQt6WebView_DIR=/usr/lib/cmake/Qt6WebView \
 -DQt6WebViewQuick_DIR=/usr/lib/cmake/Qt6WebViewQuick \
 -DQt6Widgets_DIR=/usr/lib/cmake/Qt6Widgets \
 -DQt6WidgetsTools_DIR=/usr/lib/cmake/Qt6WidgetsTools \
 -DQt6WlShellIntegrationPrivate_DIR=/usr/lib/cmake/Qt6WlShellIntegrationPrivate \
 -DQt6XcbQpaPrivate_DIR=/usr/lib/cmake/Qt6XcbQpaPrivate \
 -DQt6Xml_DIR=/usr/lib/cmake/Qt6Xml \
 -DCMAKE_PREFIX_PATH=/usr/lib/cmake \
 -DQT_NO_PACKAGE_VERSION_CHECK=TRUE \
 -DQT_NO_PACKAGE_VERSION_INCOMPATIBLE_WARNING=TRUE


cd ../

# cmake --build . --parallel
