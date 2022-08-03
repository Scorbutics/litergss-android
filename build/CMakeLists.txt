
MACRO(SUBDIRLIST result curdir)
	FILE(GLOB children RELATIVE ${curdir} ${curdir}/*)
	SET(dirlist "")
	FOREACH(child ${children})
		IF(IS_DIRECTORY ${curdir}/${child})
			LIST(APPEND dirlist ${child})
		ENDIF()
	ENDFOREACH()
	SET(${result} ${dirlist})
ENDMACRO()

SUBDIRLIST(SUBDIRS "${CMAKE_CURRENT_SOURCE_DIR}")
string(REGEX REPLACE "CMakeFiles;" "" SUBDIRS "${SUBDIRS}")

FOREACH(subdir ${SUBDIRS})
	if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${subdir}/cmake.conf")
		set(${subdir}_build_dir "${CMAKE_CURRENT_SOURCE_DIR}/${subdir}/build_dir")
		file(MAKE_DIRECTORY ${${subdir}_build_dir})

		include(${CMAKE_CURRENT_SOURCE_DIR}/${subdir}/cmake.conf)

		set(${subdir}_downloaded_target ${CMAKE_SOURCE_DIR}/download/${subdir}-${${subdir}_version}*)
		add_custom_target(${subdir}_download COMMAND if ls ${${subdir}_downloaded_target} >/dev/null\; then exit 0\; fi\; ${${subdir}_download_command}
			WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/download
		)

		if(NOT DEFINED ${subdir}_extract_command)
			set(${subdir}_extract_command tar -zxf ${${subdir}_downloaded_target})
		endif()
		add_custom_target(${subdir}_extract COMMAND if test -d '${subdir}-${${subdir}_version}'\; then exit 0\; fi\; ${${subdir}_extract_command}
			WORKING_DIRECTORY ${${subdir}_build_dir}
			DEPENDS ${subdir}_download
		)

		FILE(GLOB ${subdir}_patch_files ${CMAKE_CURRENT_SOURCE_DIR}/${subdir}/patches/*)
		add_custom_target(${subdir}_patch COMMAND if test -f '../.patch.done'\; then exit 0\; fi\; cd ${${subdir}_build_dir}/${subdir}-${${subdir}_version} && for p in `ls ${CMAKE_CURRENT_SOURCE_DIR}/${subdir}/patches/`\; do echo \$\$p && patch -p1 < ${CMAKE_CURRENT_SOURCE_DIR}/${subdir}/patches/\$\$p\; done && touch ../.patch.done
			WORKING_DIRECTORY ${${subdir}_build_dir}/${subdir}-${${subdir}_version}	
			DEPENDS ${subdir}_extract
		)

		add_custom_target(${subdir}_configure COMMAND if test -f '../.configure.done'\; then exit 0\; fi\; ${${subdir}_configure_command} && touch ../.configure.done
			WORKING_DIRECTORY ${${subdir}_build_dir}/${subdir}-${${subdir}_version}
			DEPENDS ${subdir}_patch
		)

		if(NOT DEFINED ${subdir}_build_command)
			set(${subdir}_build_command make)
		endif()
		add_custom_target(${subdir}_build COMMAND if test -f '../.build.done'\; then exit 0\; fi\; ${${subdir}_build_command} && touch ../.build.done
			WORKING_DIRECTORY ${${subdir}_build_dir}/${subdir}-${${subdir}_version}
			DEPENDS ${subdir}_configure
		)

		if(NOT DEFINED ${subdir}_install_command)
			set(${subdir}_install_command make install DESTDIR=${CMAKE_SOURCE_DIR}/target)
		endif()
		add_custom_target(${subdir}_install COMMAND if test -f '../.install.done'\; then exit 0\; fi\; ${${subdir}_install_command} && touch ../.install.done
			WORKING_DIRECTORY ${${subdir}_build_dir}/${subdir}-${${subdir}_version}
			DEPENDS ${subdir}_build
		)

		add_dependencies(${subdir} ${subdir}_install)

		if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${subdir}/cmake-final.conf")
			include(${CMAKE_CURRENT_SOURCE_DIR}/${subdir}/cmake-final.conf)
		endif()
	endif()
ENDFOREACH()

add_custom_target(raw ALL 
	COMMAND
	mkdir -p raw &&
	cp -P usr/lib/*.so* raw/ &&
	cp -P usr/local/lib/*.so* raw/ &&
	cp -P usr/local/lib/libsfml-main.a raw/ &&
	cp -P -r usr/local/lib/ruby raw/
	WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/target
	DEPENDS litergss2 rubyfull)

add_custom_target(android-app ALL 
	COMMAND
	mkdir -p android/app/lib/arm64-v8a/ && cd android &&
	cp ../raw/libssl.so.*.* app/lib/arm64-v8a/ &&
	cp ../raw/libruby.so.*.* app/lib/arm64-v8a/ && rm app/lib/arm64-v8a/libruby.so.*.*.* &&
	cp ../raw/libreadline.so.* app/lib/arm64-v8a/ && rm app/lib/arm64-v8a/libreadline.so.*.* &&
	cp ../raw/libpanel.so.* app/lib/arm64-v8a/ && rm app/lib/arm64-v8a/libpanel.so.*.* &&
	cp ../raw/libncurses.so.* app/lib/arm64-v8a/ && rm app/lib/arm64-v8a/libncurses.so.*.* &&
	cp ../raw/libmenu.so.* app/lib/arm64-v8a/ && rm app/lib/arm64-v8a/libmenu.so.*.* &&
	cp ../raw/libhistory.so.* app/lib/arm64-v8a/ && rm app/lib/arm64-v8a/libhistory.so.*.* &&
	cp ../raw/libgdbm_compat.so.* app/lib/arm64-v8a/ && rm app/lib/arm64-v8a/libgdbm_compat.so.*.*.* &&
	cp ../raw/libgdbm.so.* app/lib/arm64-v8a/ && rm app/lib/arm64-v8a/libgdbm.so.*.*.* &&
	cp ../raw/libform.so.* app/lib/arm64-v8a/ && rm app/lib/arm64-v8a/libform.so.*.* &&
	cp ../raw/libcurses.so app/lib/arm64-v8a/ &&
	cp ../raw/libcrypto.so.*.* app/lib/arm64-v8a/ &&
	(cd app/ && zip -r --symlinks ../arm64-v8a.jar *) &&
	mkdir -p ext-native-libs/arm64-v8a/ ext-native-libs/include/ &&
	cp ../raw/libFLAC.so ext-native-libs/arm64-v8a/ &&
	cp ../raw/libFLAC++.so ext-native-libs/arm64-v8a/ &&
	cp ../raw/libfreetype.so ext-native-libs/arm64-v8a/ &&
	cp ../raw/libogg.so ext-native-libs/arm64-v8a/ &&
	cp ../raw/libopenal.so ext-native-libs/arm64-v8a/ &&
	cp ../raw/libruby.so ext-native-libs/arm64-v8a/ &&
	cp ../raw/libvorbis.so ext-native-libs/arm64-v8a/ &&
	cp ../raw/libvorbisenc.so ext-native-libs/arm64-v8a/ &&
	cp ../raw/libvorbisfile.so ext-native-libs/arm64-v8a/ &&
	cp ../raw/libsfml-*.so ext-native-libs/arm64-v8a/ &&
	cp ../raw/libsfml-*.a ext-native-libs/arm64-v8a/ &&
	cp -r ../usr/local/include/ruby ext-native-libs/include/ &&
	cp -r ../usr/local/include/SFML ext-native-libs/include/ &&
	mkdir -p engine-libs/ &&
	cp ../raw/LiteRGSS.so engine-libs/ && 
	mkdir -p app-internal/ruby &&
	cp -r ../raw/ruby/* app-internal/ruby/ && 
	(cd app-internal && zip -r --symlinks ../app-internal.zip *)
	WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/target
	DEPENDS raw)

add_custom_target(raw-zip 
	COMMAND
	(cd raw && zip -r --symlinks ../app.zip *)
	WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/target
	DEPENDS raw)
