function php_refactoring_toolbox#extract_variable#execute()
    if visualmode() != 'v'
        call s:PhpEchoError('Extract variable only works in Visual mode, not in Visual Line or Visual block')
        return
    endif

    " input
    let l:name = input('Name of new variable: ')

    " add marker
    let l:backupPosition = getcurpos()

    let l:codeToExtract = s:cutCodeToExtractAndMoveToInsertPosition()

    " type variable name
    call s:writeText('$'.l:name)

    " go to start on selection
    call setpos('.', l:backupPosition)

    call s:writeDefinition(l:name, l:codeToExtract)

    " go to start on selection
    call setpos('.', l:backupPosition)
endfunction

function! s:PhpEchoError(message) " {{{
    echohl ErrorMsg
    echomsg a:message
    echohl NONE
endfunction
" }}}

function! s:cutCodeToExtractAndMoveToInsertPosition()
    normal! gv"xs

    return @x
endfunction

function! s:writeText(text)
    if 1 == &l:paste
        let l:backuppaste = 'paste'
    else
        let l:backuppaste = 'nopaste'
    endif
    setlocal paste

    exec 'normal! a' . a:text

    exec 'setlocal '.l:backuppaste
endfunction

function s:writeDefinition(name, value)
    call s:moveOnTopOfArray()

    call s:backwardOneLine()
    call s:addAndMoveOnNewLine()

    call s:backwardOneLine()
    call s:addAndMoveOnNewLine()

    let l:indent = s:getIndentOfNextNonBlankLine()

    call s:writeText(l:indent.'$'.a:name.' = '.a:value.';')
endfunction

function! s:backwardOneLine() " {{{
    call cursor(line('.') - 1, 0)
endfunction
" }}}

function s:moveOnTopOfArray()
    while s:currentLineEndsWith(',')
        call s:backwardOneLine()
    endwhile
endfunction

function! s:currentLineEndsWith(char) " {{{
    return a:char == trim(getline(line('.')))[-1:]
endfunction
" }}}

function s:addAndMoveOnNewLine()
    call append(line('.'), '')
    call s:forwardOneLine()
endfunction

function! s:forwardOneLine() " {{{
    call cursor(line('.') + 1, 0)
endfunction
" }}}

function s:getIndentOfNextNonBlankLine()
    return s:getBaseIndentOfText(getline(nextnonblank(line('.'))))
endfunction

function! s:getBaseIndentOfText(text)
    return substitute(a:text, '\S.*', '', '')
endfunction
