try
    call refactoring_toolbox#adaptor#vim#begin_ftplugin('refactoring_toolbox')
catch /plugin_loaded/
    finish
endtry

function s:registerMappings()
    if s:mappingIsEnabled()
        call s:addBufferVisualMapping(
            \ '<LocalLeader>em',
            \ '<Plug>refactoring_toolbox_typescript_ExtractMethod',
            \ 'refactoring_toolbox#extract_method#main#extractMethodForTypescript()'
        \ )

        call s:addBufferVisualMapping(
            \ '<LocalLeader>ev',
            \ '<Plug>refactoring_toolbox_typescript_ExtractVariable',
            \ 'refactoring_toolbox#extract_variable#main#extractVariableForTypescript()'
        \ )

        call s:addBufferNormalMapping(
            \ '<LocalLeader>iv',
            \ '<Plug>refactoring_toolbox_typescript_InlineVariable',
            \ 'refactoring_toolbox#inline_variable#main#inlineVariableForTypescript()'
        \ )

        call s:addBufferNormalMapping(
            \ '<LocalLeader>rv',
            \ '<Plug>refactoring_toolbox_typescript_RenameVariable',
            \ 'refactoring_toolbox#rename_variable#main#renameVariableForTypescript()'
        \ )
    endif
endfunction

function s:mappingIsEnabled()
    return !exists('no_plugin_maps') && !exists('no_typescript_maps')
endfunction

function s:addBufferNormalMapping(keys, name, executeFunction)
    if !hasmapto(a:name, 'n')
        call s:addUniqueBufferNormalMapping(a:keys, a:name)
    endif

    call s:addUniqueScriptAndBufferNormalMapping(a:name, ':call '.a:executeFunction.'<Enter>')
endfunction

function s:addUniqueBufferNormalMapping(left, right)
    execute 'nmap <buffer> <unique> '.a:left.' '.a:right

    call refactoring_toolbox#adaptor#vim#appendFileTypeUndo('nunmap <buffer> '.a:left)
endfunction

function s:addUniqueScriptAndBufferNormalMapping(left, right)
    execute 'nnoremap <script> <buffer> <unique> '.a:left.' '.a:right

    call refactoring_toolbox#adaptor#vim#appendFileTypeUndo('nunmap <script> <buffer> '.a:left)
endfunction

function s:addBufferVisualMapping(keys, name, executeFunction)
    if !hasmapto(a:name, 'v')
        call s:addUniqueBufferVisualMapping(a:keys, a:name)
    endif

    call s:addUniqueScriptAndBufferVisualMapping(a:name, ':call '.a:executeFunction.'<Enter>')
endfunction

function s:addUniqueBufferVisualMapping(left, right)
    execute 'vmap <buffer> <unique> '.a:left.' '.a:right

    call refactoring_toolbox#adaptor#vim#appendFileTypeUndo('vunmap <buffer> '.a:left)
endfunction

function s:addUniqueScriptAndBufferVisualMapping(left, right)
    execute 'vnoremap <script> <buffer> <unique> '.a:left.' '.a:right

    call refactoring_toolbox#adaptor#vim#appendFileTypeUndo('vunmap <script> <buffer> '.a:left)
endfunction

call s:registerMappings()

call refactoring_toolbox#adaptor#vim#end_ftplugin()
