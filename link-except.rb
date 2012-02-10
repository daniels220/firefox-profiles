#!/usr/bin/env ruby

require 'pathname'

class Pathname
	alias_method :rpf, :relative_path_from
	def components
		comps = []
		each_filename { |f| comps.push(f) }
		comps
	end
end

def link(from,to); to.make_symlink(from); end
# if (ARGV[0] == '-h')
# 	ARGV.shift
# 	def link(from,to); to.make_link(from); end
# else
# 	def link(from,to); to.make_symlink(from); end
# end

$from = Pathname.new(ARGV.shift)
$to = Pathname.new(ARGV.shift)
$to.mkdir
$to = $to.realpath
$except = ARGV.map { |f| ex = Pathname.new(f); $to+(ex.relative? ? ex : ex.rpf($from)) }
$from = $from.realpath

def dir_recurse(dir)
	dir.each_child do |from_f|
		to_f = $to+from_f.rpf($from)
		next if $except.include?(to_f)
		if from_f.file? || (!$except.empty? && $except.all? { |f| f.rpf(to_f).components[0] == '..' })
			link(from_f,to_f)
		elsif from_f.directory?
			to_f.mkdir
			dir_recurse(from_f)
		else
		end
	end
end

dir_recurse($from)