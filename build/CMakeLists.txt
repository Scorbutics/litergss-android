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
		set(${subdir}_build_dir "${CMAKE_BINARY_DIR}/${subdir}/build_dir")
		file(MAKE_DIRECTORY ${${subdir}_build_dir})

		include(${CMAKE_CURRENT_SOURCE_DIR}/${subdir}/cmake.conf)

		set(${subdir}_downloaded_target ${CMAKE_BINARY_DIR}/download/${subdir}-${${subdir}_version}*)
		add_custom_target(${subdir}_download COMMAND if ls ${${subdir}_downloaded_target} >/dev/null\; then exit 0\; fi\; ${${subdir}_download_command}
			WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/download
		)

		if(NOT DEFINED ${subdir}_extract_command)
			set(${subdir}_extract_command tar -zxf ${${subdir}_downloaded_target})
		endif()
		add_custom_target(${subdir}_extract COMMAND if test -d '${subdir}-${${subdir}_version}'\; then exit 0\; fi\; ${${subdir}_extract_command}
			WORKING_DIRECTORY ${${subdir}_build_dir}
			DEPENDS ${subdir}_download
		)

		add_custom_target(${subdir}_patch COMMAND if test -f '../.patch.done'\; then exit 0\; fi\; cd ${${subdir}_build_dir}/${subdir}-${${subdir}_version} && for p in `find ${CMAKE_CURRENT_SOURCE_DIR}/${subdir}/patches-${${subdir}_version}/ -type f 2>/dev/null \; find ${CMAKE_CURRENT_SOURCE_DIR}/${subdir}/patches/ -type f 2>/dev/null`\; do echo \$\$p && patch -p1 < \$\$p\; done && touch ../.patch.done
			WORKING_DIRECTORY ${${subdir}_build_dir}/${subdir}-${${subdir}_version}
			DEPENDS ${subdir}_extract
		)

		add_custom_target(${subdir}_configure COMMAND if test -f '../.configure.done'\; then exit 0\; fi\; echo 'Using toolchain file ${TOOLCHAIN_FILE}' && ${${subdir}_configure_command} && touch ../.configure.done
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
			set(${subdir}_install_command make install DESTDIR=${CMAKE_BINARY_DIR}/target)
		endif()
		add_custom_target(${subdir}_install COMMAND if test -f '../.install.done'\; then exit 0\; fi\; ${${subdir}_install_command} && touch ../.install.done
			WORKING_DIRECTORY ${${subdir}_build_dir}/${subdir}-${${subdir}_version}
			DEPENDS ${subdir}_build
		)

		add_dependencies(${subdir} ${subdir}_install)

		add_custom_target(${subdir}_clean
			COMMAND ${CMAKE_COMMAND} -E remove_directory ${${subdir}_build_dir}
			COMMAND ${CMAKE_COMMAND} -E make_directory ${${subdir}_build_dir}
			WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
		)

		if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${subdir}/cmake-final.conf")
			include(${CMAKE_CURRENT_SOURCE_DIR}/${subdir}/cmake-final.conf)
		endif()
	endif()
ENDFOREACH()

add_custom_target(raw
	COMMAND
	mkdir -p raw &&
	cp -P usr/lib/*.so* raw/ &&
	cp -P usr/local/lib/*.so* raw/ &&
	cp -P usr/local/lib/libsfml-main*.a raw/ &&
	cp -P -r usr/local/lib/ruby raw/
	WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/target
	DEPENDS litergss2 ruby-sfml-audio rubyfull)

add_custom_target(android-app
	COMMAND
	mkdir -p android/app/lib/${ANDROID_ABI}/ && cd android &&
	cp ../raw/libssl.so app/lib/${ANDROID_ABI}/ &&
	cp ../raw/libreadline.so app/lib/${ANDROID_ABI}/ &&
	cp ../raw/libpanel.so app/lib/${ANDROID_ABI}/ &&
	cp ../raw/libncurses.so app/lib/${ANDROID_ABI}/ &&
	cp ../raw/libmenu.so app/lib/${ANDROID_ABI}/ &&
	cp ../raw/libhistory.so app/lib/${ANDROID_ABI}/ &&
	cp ../raw/libgdbm_compat.so app/lib/${ANDROID_ABI}/ &&
	cp ../raw/libgdbm.so app/lib/${ANDROID_ABI}/ &&
	cp ../raw/libform.so app/lib/${ANDROID_ABI}/ &&
	cp ../raw/libcurses.so app/lib/${ANDROID_ABI}/ &&
	cp ../raw/libcrypto.so app/lib/${ANDROID_ABI}/ &&
	mkdir -p include/ lib/ assets &&
	(cd app/ && cp -r lib/* ../lib/ ) &&
	rm -r app/ &&
	cp ../raw/libFLAC.so lib/${ANDROID_ABI}/ &&
	cp ../raw/libFLAC++.so lib/${ANDROID_ABI}/ &&
	cp ../raw/libfreetype.so lib/${ANDROID_ABI}/ &&
	cp ../raw/libogg.so lib/${ANDROID_ABI}/ &&
	cp ../raw/libopenal.so lib/${ANDROID_ABI}/ &&
	cp ../raw/libruby.so lib/${ANDROID_ABI}/ &&
	cp ../raw/libvorbis.so lib/${ANDROID_ABI}/ &&
	cp ../raw/libvorbisenc.so lib/${ANDROID_ABI}/ &&
	cp ../raw/libvorbisfile.so lib/${ANDROID_ABI}/ &&
	cp ../raw/libsfml-*.so lib/${ANDROID_ABI}/ &&
	cp ../raw/libsfml-*.a lib/${ANDROID_ABI}/ &&
	mkdir -p include/${ANDROID_ABI} &&
	cp -r ../usr/local/include/${HOST}-*/* include/${ANDROID_ABI} &&
	cp -r ../usr/local/include/ruby include/ &&
	cp -r ../usr/local/include/SFML include/ &&
	cp ../raw/libLiteRGSS.so lib/${ANDROID_ABI}/libLiteRGSS.so &&
	cp ../raw/libSFMLAudio.so lib/${ANDROID_ABI}/libSFMLAudio.so &&
	(cd ../raw && 
		mkdir -p ../android/assets/${ANDROID_ABI} &&
		zip -r -q --symlinks ../android/assets/ruby-stdlib.zip ruby -x ruby/*/${HOST}-* &&
		zip -r -q --symlinks ../android/assets/${ANDROID_ABI}/ruby-stdlib-ext.zip ruby/*/${HOST}-*
	)
	WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/target
	DEPENDS raw)

add_custom_target(raw-zip
	COMMAND true &&
	( cd raw && zip -r --symlinks ../app.zip * )
	WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/target
	DEPENDS raw)

add_custom_target(build DEPENDS host android-app)
