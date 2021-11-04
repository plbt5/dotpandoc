#!/usr/bin/env ruby
# testing filter, uses byebug to remote debug

# DEBUG BLOCK START
require 'debug/open_nonstop' # debug gem https://github.com/ruby/debug
require 'paru/filter'

testKey = 'author'
pmaticKey = 'pandocomatic-fileinfo'
insertKey = 'testname'

Paru::Filter.run do
  binding.break # we will halt here, connect with `rdbg -A` or use VS Code
  if metadata.key?(testKey) 
    if metadata.key?(pmaticKey) && (metadata[pmaticKey]['to'].match(/docx|odt/))
      stop!
    end
    au = metadata[testKey]
    if au.is_a?(String)
      nau = [ Hash[ insertKey => au ] ]
    elsif au.is_a?(Array)
      if au[0].is_a?(String)
        nau = Array.new(au.length) {Hash.new}
        au.each_index { |i| 
          cp = au[i].match(/\^[\d\s\,§†\*]+\^/)
          if cp.nil?
            nau[i] = Hash[ insertKey => au[i] ] 
          else
            nau[i] = Hash[ insertKey => cp.pre_match, 'affiliation' => cp.to_s ] 
          end
        }
      elsif au[0].is_a?(Hash)
        nau = [ Hash[ insertKey => au[0]['name'] ] ]
      end
    end
    if not nau.nil?
      metadata['testFilterOutput'] = nau
    end
  end
  if metadata['keywords']
    metadata['tags'] = metadata['keywords']
  end
  stop!
end
