" normal
highlight jsGlobalObjects gui=bold guifg='#839496'
highlight Special gui=italic guifg='#839496'
highlight jsFuncName guifg='#839496'
"highlight jsSpecial gui=bold guifg='#839496'

" dark normal
highlight jsStringS guifg='#AA924B'

" dark blue
highlight Noise guifg='#416A86'
highlight jsBraces guifg='#416A86'
highlight jsFuncBraces guifg='#416A86'
highlight jsParens guifg='#416A86'

" green
highlight Statement guifg='#72A974'
highlight Boolean  guifg='#72A974'
highlight javaScriptLogicSymbols  guifg='#72A974'
highlight jsOperator  guifg='#72A974'
highlight link jsThis Keyword
highlight link jsSuper Keyword

" blue
highlight jsFunction  guifg='#2E5F82'
highlight jsStorageClass  guifg='#268bd2'

if !has('gui_running')
    highlight link jsStorageClass Keyword
    highlight jsObjectKey cterm=bold
endif
