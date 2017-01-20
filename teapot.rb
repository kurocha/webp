
#
#  This file is part of the "Teapot" project, and is released under the MIT license.
#

teapot_version "1.0.0"

define_target "webp" do |target|
	target.build do
		source_files = Files::Directory.join(target.package.path, "libwebp")
		cache_prefix = Path.join(environment[:build_prefix], "libwebp-#{environment.checksum}")
		package_files = Path.join(environment[:install_prefix], "lib/libwebp.a")
		
		copy source: source_files, prefix: cache_prefix
		
		configure prefix: cache_prefix do
			run! "./autogen.sh", chdir: cache_prefix
			
			run! "./configure",
				"--prefix=#{environment[:install_prefix]}",
				"--enable-shared=no",
				"--enable-static=yes",
				*environment[:configure],
				chdir: cache_prefix
		end
		
		make prefix: cache_prefix, package_files: package_files
	end
	
	target.depends :platform
	target.depends "Build/Files"
	target.depends "Build/Make"
	
	target.provides "Library/webp" do
		append linkflags ->{install_prefix + "lib/libwebp.a"}
	end
end

define_configuration 'test' do |configuration|
	configuration[:source] = "https://github.com/kurocha"
	
	configuration.require 'platforms'
	configuration.require 'build-make'
end
