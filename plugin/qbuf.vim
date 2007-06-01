" Vim plugin helps navigate and manipulate opening, listed buffers
" Maintainer: palnart <palnart@gmail.com>
" Last Change: 2007 Jun 2
"
" Features:
" +	Quickly navigate 'listed' buffers with keys j and k
" + Operations on buffers include showing, deleting, wipping out
" 	with a single key-stroke
" +	Create no buffer, no auto-command, activated with a hotkey when needed
" + Quick mode like 'operator' of Vim, '12d' to delete the 12'th buffer
" +	SMALL, FAST, NICE and USEFUL! INTERESTING!
"
" Using:
" Copy to plugin directory or source it! :so bufsw.vim
"
" Asign a hotkey (default <F4>, modify to whatever you like) to activate.
" Press <F4> to show the list of all 'listed' buffers, with one selected
" 	at the command-line area, the area is expanded to fit the list
" Press j move 'select bar' down, k move up, wrap around at two ends
" Press <Enter> edit selected buffer, hide the buffer list
" Press u switch to view the selected buffer, but don't leave the list
" Press d to delete, w to wipe out a buffer, if error, you see it
" Press q or <Esc> to leave
" You can use quick method, press '9<Enter>' to switch to the 9'th buffer
" 	press '3d' to delete the 3'th buffer (not the Vim's buffer number)
" 
" Bugs:
" +	If there isn't enough space (screen line) to show the list, it ends
" 	up in a ugly error message about a exception not caught. Don't worry!
" 	Just ignore, close some Vim's windows to make place and try :)
" + Sometimes, mainly because of too long messages, the plugin doesn't well
" 	display something. Keep your Vim's window at reasonable size :)
" 
" Todo:
" + Implement U, D and W to force switch, delete and wipeout buffers
" +	Simulate scrollable buffer list when Vim's window too small

if exists("g:buf_switcher_loaded") && g:buf_switcher_loaded
	finish
endif
let g:buf_switcher_loaded = 1
nnoremap <F4> :cal <SID>init(1)<cr>:cal SBRun()<cr>


" update the buffer list to be shown to users
" s:buflist hold the list itself
" s:blen hold the number of bufer
" this function is assumed never to fail
function! s:rebuild()
	redir @y | silent ls | redir END
	let s:buflist = []
	let s:blen = 0

	" after this 'for' loop, s:buflist contains lines of the form below
	" 5. somefile.vim  <8>  ~\docs
	for l:theline in split(@y,"\n")
		let s:blen += 1
		let l:fname = matchstr(l:theline, '"\zs[^"]*')
		let l:bufnum = matchstr(l:theline, '^ *\zs\d*')
		call add(s:buflist, s:blen . ( (l:bufnum == bufnr('')) ? ".*" : ". " )
					\.fnamemodify(l:fname,":t") . " <" . l:bufnum . "> "
					\.fnamemodify(l:fname,":h"))
	endfor

	" beautify the list to be printed
	" include aligning, and, truncating to fit screen line
	let l:alignsize = max(map(copy(s:buflist),'stridx(v:val,">")'))
	call map(s:buflist, 'substitute(v:val, " <", repeat(" ",l:alignsize-stridx(v:val,">"))."  <", "")')
	call map(s:buflist, 'strpart(v:val, 0, &columns-3)')

	" if the value of current selection is invalid (when 'bd','bw',...), fix it
	" s:cursel is zero-base
	if !exists("s:cursel") || (s:cursel >= s:blen)
		let s:cursel = s:blen-1
	endif
endfunc


" this function is repetedly run as ':call SBRun()' through keymap
" use of conlon-command is a trick to get Vim redraw command-area as expected
function! SBRun()
	for l:idx in range(s:blen)
		if l:idx != s:cursel
			echo "  " . s:buflist[l:idx]
		else
			echoh DiffChange | echo "> " . s:buflist[l:idx] | echoh None
		endif
	endfor

	let l:pkey = input(" Buffer [" . getcwd() . "]:", " ")
	let l:actkey = l:pkey[-1:-1]
	if l:actkey == 'j'
		let s:cursel = (s:cursel+1) % s:blen
	elseif l:actkey == 'k'
		if s:cursel == 0
			let s:cursel = s:blen - 1
		else
			let s:cursel -= 1
		endif
	else
		if (l:pkey != "" && l:pkey =~ '^ *[dwu]\?$')
			let l:pkey = substitute(l:pkey, '^ *', s:cursel+1,"")
		else
			let l:pkey = substitute(l:pkey, '^ \+', "", "")
		endif

		let l:bufidx = str2nr(l:pkey)
		if (l:bufidx > 0 && l:bufidx <= s:blen)
			let l:action = strpart(l:pkey, strlen(l:bufidx))
			try
				if l:action =~ "^[dwu]$"
					exe "b".l:action." ".matchstr(s:buflist[l:bufidx-1], '<\zs\d*\ze>')
					call s:rebuild()
				elseif l:action == ""
					exe "b ".matchstr(s:buflist[l:bufidx-1], '<\zs\d*\ze>')
				endif
			catch /^Vim\%((\a\+)\)\=:E/
				echohl ErrorMsg|echon "\r" v:exception|echohl None
				call inputsave()
				call getchar() 
				call inputrestore()
			endtry 
		endif

		" ends ONLY here, cleanup and MUST return
		if (l:actkey !~ "^[dwu]")
			call s:init(0)
			return
		endif
	endif
	call s:setcmdh(s:blen+1)	
endfunc

function! s:init(onStart)
	if a:onStart
		let s:cursorbg = synIDattr(hlID("Cursor"),"bg")
		let s:cursorfg = synIDattr(hlID("Cursor"),"fg")
		let s:cmdh = &cmdheight
		hi Cursor guibg=NONE guifg=NONE

		cnoremap j j<cr>:cal SBRun()<cr>
		cnoremap k k<cr>:cal SBRun()<cr>
		cnoremap u u<cr>:cal SBRun()<cr>
		cnoremap d d<cr>:cal SBRun()<cr>
		cnoremap w w<cr>:cal SBRun()<cr>
		cnoremap q q<cr>

		call s:rebuild()
		call s:setcmdh(s:blen+1)
	else
		exe "hi Cursor guibg=".s:cursorbg." guifg=".s:cursorfg
		cunmap j|cunmap k|cunmap u|cunmap d|cunmap w|cunmap q
		call s:setcmdh(s:cmdh)
	endif
endfunc

function! s:setcmdh(height)
	if a:height > &lines - winnr('$') * (&winminheight+1)
		call s:init(0)
		throw "E-BufSwitch: No room to list buffers!"
	endif
	exe "set cmdheight=".a:height
endfunc

