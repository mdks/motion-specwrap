module Bacon
  def self.context_did_finish(context)
    handle_specification_end
    Counter[:context_depth] -= 1
    if (@current_context_index + 1) < @contexts.size
      @current_context_index += 1
      run
    else
      # DONE
      handle_summary
      status_code = Counter.values_at(:failed, :errors).inject(:+)
      puts "Specwrap captured exit status code: #{status_code}"
      exit(status_code)
    end
  end
end
