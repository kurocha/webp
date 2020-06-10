
#
#  This file is part of the "Teapot" project, and is released under the MIT license.
#

teapot_version "3.0"

webp_libraries = [
	"lib/libwebp.a",
	"lib/libwebpdecoder.a",
	"lib/libwebpdemux.a",
	"lib/libwebpmux.a",
]

define_target "webp" do |target|
	target.depends :platform
	
	target.depends "Build/Make"
	target.depends "Build/CMake"
	
	target.provides "Library/webp" do
		source_files = target.package.path + "libwebp"
		cache_prefix = environment[:build_prefix] / environment.checksum + "webp"
		package_files = cache_prefix.list(*webp_libraries)
		
		cmake source: source_files, install_prefix: cache_prefix, arguments: [
			"-DBUILD_SHARED_LIBS=OFF",
		], package_files: package_files
		
		append linkflags package_files
		append header_search_paths cache_prefix + "include"
	end
end

define_configuration 'test' do |configuration|
	configuration[:source] = "https://github.com/kurocha/"
	
	configuration.require "platforms"
	
	configuration.require "build-make"
	configuration.require "build-cmake"
end
