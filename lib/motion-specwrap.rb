require "motion-specwrap/version"
require 'tempfile'
require 'open3'

module Motion
  module SpecWrap
    REGEXP = / (\d*) failures, (\d*) errors/

    class << self

      def watch_for(file, pattern)
        linebuf = ""
        f = File.open(file,"r")
        f.seek(0,IO::SEEK_END)
        while $Run do
          select([f])
          line = f.gets
          if !line.nil?
            if (matches = line.match(pattern))
              exit_value = matches[1].to_i+matches[2].to_i
              puts line
              puts " * motion-specwrap read the summary to exit(#{exit_value})"
              exit(exit_value)
            else
              if line.include? "\n"
                puts linebuf + line
                linebuf.clear
              else
                linebuf << line
              end
            end
          end
        end
        puts " * motion-specwrap did not see a summary. will now exit(1)"
        exit(1)
      end

      def run
        @Run = true
        file = Tempfile.new "motion-specwrap"
        begin
          file_watch_thread = Thread.new do
            watch_for(file.path, REGEXP)
          end
          Open3.popen2e("rake spec > #{file.path}") do |stdin, out_and_err, wait_thr|
            while (line = out_and_err.gets)
              puts line
            end
            @Run = false
          end
        rescue => ex
          puts ex
        ensure
          file_watch_thread.join
          file.close
          file.unlink
        end
      end

    end
  end
end
