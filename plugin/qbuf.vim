if !exists("g:qb_hotkey") || g:qb_hotkey == ""
	let g:qb_hotkey = "<F4>"
endif
exe "nnoremap <unique> " . g:qb_hotkey . " :cal <SID>init(1)<cr>:cal SBRun()<cr>"
exe "imap <unique> " . g:qb_hotkey . " <Esc>" . g:qb_hotkey

if exists("g:qb_loaded") && g:qb_loaded
	finish
endif
let g:qb_loaded = 1

com -nargs=1 -bang QBufdcmd if s:unlisted | bu<bang> <args> | set buflisted
			\ | else | bd<bang> <args> | endif

let s:action2cmd = { "u": "bu ", "!u": "bu! ",
			\"d": "QBufdcmd ", "!d": "QBufdcmd! ",
			\"w": "bw ", "!w": "bw! ",
			\"l": "let s:unlisted = 1 - s:unlisted \" " }

function s:rebuild()
	redir @y | silent ls! | redir END
	let s:buflist = []
	let s:blen = 0

	for l:theline in split(@y,"\n")
		if s:unlisted && l:theline[3] == "u" && (l:theline[6] != "-" || l:theline[5] != " ")
					\ || !s:unlisted && l:theline[3] != "u"
			if s:unlisted
				let l:moreinfo = substitute(l:theline[5], '[ah]', " [+]", "")
			else
				let l:moreinfo = substitute(l:theline[7], "+", " [+]", "")
			endif
			let s:blen += 1
			let l:fname = matchstr(l:theline, '"\zs[^"]*')
			let l:bufnum = matchstr(l:theline, '^ *\zs\d*')
			call add(s:buflist, s:blen . ( (l:bufnum == bufnr('')) ? "* " : "  " )
						\.fnamemodify(l:fname,":t") . l:moreinfo
						\." <" . l:bufnum . "> "
						\.fnamemodify(l:fname,":h"))
		endif
	endfor

	let l:alignsize = max(map(copy(s:buflist),'stridx(v:val,">")'))
	call map(s:buflist, 'substitute(v:val, " <", repeat(" ",l:alignsize-stridx(v:val,">"))." <", "")')
	call map(s:buflist, 'strpart(v:val, 0, &columns-3)')

	if !exists("s:cursel") || (s:cursel >= s:blen) || (s:cursel < 0)
		let s:cursel = s:blen-1
	endif
endfunc


function SBRun()
	if s:blen < 1
		call s:init(0)
		return
	endif
	for l:idx in range(s:blen)
		if l:idx != s:cursel
			echo "  " . s:buflist[l:idx]
		else
			echoh DiffText | echo "> " . s:buflist[l:idx] | echoh None
		endif
	endfor

	let l:pkey = input(s:unlisted ? "UNLISTED ([+] loaded):" : "LISTED ([+] dirty):" , " ")
	if l:pkey =~ "j$"
		let s:cursel = (s:cursel+1) % s:blen
	elseif l:pkey =~ "k$"
		if s:cursel == 0
			let s:cursel = s:blen - 1
		else
			let s:cursel -= 1
		endif
	elseif s:update_buf(l:pkey)
		call s:init(0)
		return
	endif
	call s:setcmdh(s:blen+1)	
endfunc

function s:init(onStart)
	if a:onStart
		let s:unlisted = 0
		let s:cursorbg = synIDattr(hlID("Cursor"),"bg")
		let s:cursorfg = synIDattr(hlID("Cursor"),"fg")
		let s:cmdh = &cmdheight
		hi Cursor guibg=NONE guifg=NONE

		cnoremap j j<cr>:cal SBRun()<cr>
		cnoremap k k<cr>:cal SBRun()<cr>
		cnoremap u u<cr>:cal SBRun()<cr>
		cnoremap d d<cr>:cal SBRun()<cr>
		cnoremap w w<cr>:cal SBRun()<cr>
		cnoremap l l<cr>:cal SBRun()<cr>
		cnoremap q q<cr>

		call s:rebuild()
		call s:setcmdh(s:blen+1)
	else
		call s:setcmdh(s:cmdh)
		cunmap j|cunmap k|cunmap u|cunmap d|cunmap w|cunmap l|cunmap q
		exe "hi Cursor guibg=" . s:cursorbg . " guifg="
					\ .((s:cursorfg == "") ? "NONE" : s:cursorfg)
	endif
endfunc

function s:update_buf(cmd)
	if a:cmd != "" && a:cmd =~ '^ *\d*!\?\a\?$'
		let l:bufidx = str2nr(a:cmd) - 1
		if l:bufidx == -1
			let l:bufidx = s:cursel
		endif

		if l:bufidx >= 0 && l:bufidx < s:blen
			let l:action = matchstr(a:cmd, '!\?\a\?$')
			let l:has_action = (matchstr(a:cmd, '\a$') != "")
			if !l:has_action
				let l:action .= "u"
			endif

			if has_key(s:action2cmd, l:action)
				try
					exe s:action2cmd[l:action] . matchstr(s:buflist[l:bufidx], '<\zs\d\+\ze>')
					if l:has_action
						call s:rebuild()
					endif
				catch
					echoh ErrorMsg | echo "\r" matchstr(v:exception, '^Vim(\a*):\zs.*') | echoh None
					call inputsave() | call getchar() | call inputrestore()
				endtry
			endif
		endif
	endif
	return (a:cmd !~ '[udwl]$')
endfunc

function s:setcmdh(height)
	if a:height > &lines - winnr('$') * (&winminheight+1) - 1
		call s:init(0)
		echo "\r" | echoerr "QuickBuf: No room to display buffer list"
	else
		exe "set cmdheight=".a:height
	endif
endfunc
