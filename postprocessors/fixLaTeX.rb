#!/usr/bin/env ruby
#encoding: utf-8

# This tweaks several parts of the Pandoc LaTeX output
# VERSION: 1.0.3

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

output = $stdin.read

# make sure we perform font substitutions for characters that may not have a font entry
# fixfont uses Cambria Math with a huge glyph range
list = %w[⬄ ↔ ⇔ ⇄ ⇨ ⇦ → ← ⇳ Δ ⟳ ⟲ ‐ ⌲ ⌖ ⌽ ⌀ ⎆ ⎅ ⎌ ⎊ ⏎ ⌨︎]
list.each do |ch|
  output.gsub!(/(?<!fixfont\{)(#{ch})(?!\})/, "\\fixfont\{#{ch}\}")
end

# make sure we perform font substitutions for characters that may not have a font entry
# fixfontB uses Arial Unicode MS with a huge glyph range
list = %w[⌦ ⌫ ⌘ ✉ ☢︎ ✆ ☠︎ ✎ ♂︎ ♀︎ ☍ ☤ ☁︎]
list.each do |ch|
  output.gsub!(/(?<!fixfontB\{)(#{ch})(?!\})/, "\\fixfontB\{#{ch}\}")
end

# ensure correct titlecase for Neuroscience terms
list = %w[MT MST TEO TRN GABA GABAergic LGN dLGN V1 V2 V3 V4 V5 fMRI EEG MEG tDCS]
list.each do |phrase|
  output.gsub!(/\b#{phrase}\b/i, phrase)
end

# make quotes italicised
output.gsub!(/\\begin\{quote\}/, '\begin{quote}\emph{')
output.gsub!(/\\end\{quote\}/, '}\end{quote}')

# make isolated figures centered
output.gsub!(/^\\includegraphics{/, '\\includegraphics[center]{')
#output.gsub!(/^\\includegraphics\[([^\]]*)\]/, '\\includegraphics[\1,center]')

# make sure reference typography is small and sans-font
output.gsub!(/\\label{(.*(references|bibliography))}/, '\\label{\1}\\setstretch{0.75}\\sffamily\\small')

# simplify DOI links
output.gsub!(/\\url{https:\/\/doi.org\/([^\}]+)}/,'\\href{https://doi.org/\1}{doi:\1}')

puts output
