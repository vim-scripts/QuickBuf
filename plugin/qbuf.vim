if exists("g:buf_switcher_loaded") && g:buf_switcher_loaded
	finish
endif
let g:buf_switcher_loaded = 1
nnoremap <F4> :cal <SID>init(1)<cr>:cal SBRun()<cr>

function! s:rebuild()
	redir @y | silent ls | redir END
	let s:buflist = []
	let s:blen = 0

	for l:theline in split(@y,"\n")
		let s:blen += 1
		let l:fname = matchstr(l:theline, '"\zs[^"]*')
		let l:bufnum = matchstr(l:theline, '^ *\zs\d*')
		call add(s:buflist, s:blen . ( (l:bufnum == bufnr('')) ? "* " : "  " )
					\.fnamemodify(l:fname,":t") . l:theline[7]
					\." <" . l:bufnum . "> "
					\.fnamemodify(l:fname,":h"))
	endfor

	let l:alignsize = max(map(copy(s:buflist),'stridx(v:val,">")'))
	call map(s:buflist, 'substitute(v:val, " <", repeat(" ",l:alignsize-stridx(v:val,">"))." <", "")')
	call map(s:buflist, 'strpart(v:val, 0, &columns-3)')

	if !exists("s:cursel") || (s:cursel >= s:blen)
		let s:cursel = s:blen-1
	endif
endfunc


function! SBRun()
	for l:idx in range(s:blen)
		if l:idx != s:cursel
			echo "  " . s:buflist[l:idx]
		else
			echoh DiffText | echo "> " . s:buflist[l:idx] | echoh None
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
	if a:height > &lines - winnr('$') * (&winminheight+1) - 1
		call s:init(0)
		echo "\r" | echoerr "QuickBuf: No room to display buffer list"
	else
		exe "set cmdheight=".a:height
	endif
endfunc

