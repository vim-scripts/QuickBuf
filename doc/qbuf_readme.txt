QuickBuf
Vim plugin helps navigate and manipulate buffers
Maintainer: palnart <palnart@gmail.com>
Last Change: 2007 Jun 3

Features:
In general, a quick, small, easy, elegant yet POWERFUL buffer manager for VIM!
Vim's users want a simple, efficient, and powerful way to manipulate buffers may
like this! It simply includes everything you need to manipulate buffers!

QuickBuf create no buffer, define no autocommand! It just "pop up" when you call!
Visually navigate buffers with j and k keys; view, delete, wipe out buffer with one
keystroke; even faster with operator-mode (like Vim); force an operation with '!'
modifier; switch between 'listed' and hidden 'unlisted' buffers with key l; only
sensible buffers were shown; undelete operation on 'unlisted' buffers to make them
become 'listed'!

Try it!
Bugs and suggestions please send to my email: palnart@gmail.com

Install:
+ Source it with ':so qbuf.vim' or simply put it in /plugin under Vim's folder.
+ To define hotkey for QuickBuf:
	Define g:qb_hotkey before source qbuf.vim, ex:
		let g:qb_hotkey = "<F3>"
	Or put that line in your _vimrc profile. Default, key "<F4>" is used.
	Whenever you change g:qb_hotkey, :so qbuf.vim again to update hotkey.

Using:
+ Press hotkey to activate QuickBuf. It doesn't create any buffer, doesn't
	define any auto-command. It appears at the command-line area of Vim just when
	you call.
+ When in QuickBuf:
	* mark current buffer, [+] mark modified buffer, a hilight bar mark your selection.
	Keys j and k move the 'select bar' down and up.
	Press <Enter> leave QuickBuf and edit the selected buffer.
	Press u to view, d to delete, w to wipe out the selected buffer without leave
		QuickBuf.
	For speed, keys '3<Enter>' operate as if you select 3'th line and then <Enter>!
		u, d, and w can also do the same. Try '1u', '2d' or '9w' !
	If a buffer operation causes an error, QuickBuf informs you about it! You can type
		a exclamation mark '!' right before <Enter> or u, d, w to force it success.
		For example, keys '!<Enter>' force switch to you selected buffer, keys '2!w'
		force wipe out the 2nd buffer.
	At begining, QuickBuf just lists the listed buffer. But you can press l to switch
		between 'listed' and 'unlisted' buffers. The list will be shown only if it has
		at least 1 buffer :), otherwise QuickBuf exits when you switch to the list.
	In the 'unlisted' mode, only buffers either 'loaded' or 'modifiable' are shown.
	In 'unlisted' mode, [+] indicates a 'loaded' buffer, not a modified buffer.
	In 'unlisted' mode, key d undeletes a buffer, that means, makes the buffer 'listed'.
	Everything about quick operation (ie. '3d') and force operation (use '!') still
		apply in 'unlisted' mode as in 'listed' mode.

	Keys <Esc> or q will exit QuickBuf without doing anything!

That's all! Any bug reports or suggestions please send to email address:
	palnart@gmail.com
