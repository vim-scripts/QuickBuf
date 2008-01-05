QuickBuf
Vim plugin helps navigate and manipulate buffers
Maintainer: palnart <palnart@gmail.com>

Brief description:
While making the task of browsing and manipulating buffers visual and simple,
QuickBuf also offers advanced abilities of dealing with buffers (ex: "unlisted" mode).
It's unique among several other buffer managers for creating no dedicated buffer and
defining no auto command, thus minimize its interference.

Give it a try and you may find it all you need to work with Vim's buffers!
Any bugs or suggestions, please mail to: palnart@gmail.com

Usage:
+ Press the assigned hotkey to activate QuickBuf (default <F4>).
It brings out a list of buffers that you can browse and give commands on!
Some indicators in the list:
	- * : the buffer being opened in the active window
	- = : a buffer being opened in a window, but not active
	- [+] : modifed buffer

+ Use k/j or <Up>/<Down> keys to select the buffer.
Initially, the active buffer is selected.

+ Press a key to give a command to the currently selected buffer
	- d : delete buffer
	- w : wipe out buffer
	- s : open buffer in a new horizontally split window
	- u : open buffer
	- <enter> : open buffer and leave QuickBuf; if the	buffer is already opened in a window, switch to that window.

+ d, w, and <enter> operations may fail (ex: delete a modified buffer), QuickBuf will
inform you so that you can force them by preceding the above characters with an
exclamation mark ('!'). Ex: !d, !w, !<enter>

+ Instead of moving the selection bar around to select a buffer, you can use a number
to specify a buffer. For example: '2d' will delete the second buffer in the list. Try '3<enter>', '1w', '1!w'

+ Use 'l' key to toggle between LISTED and UNLISTED mode. Which mode QuickBuf enter first
depends on the active buffer. While in UNLISTED mode, 'unlisted' buffers (the buffers you have deleted) are showed.
Also:
	- [+] indicates a loaded buffer
	- 'd' command makes the selected buffer 'listed' again

+ Press <esc> or the hotkey again to leave QuickBuf

Install:
+ Source qbuf.vim with ':so qbuf.vim' or simply put it in /plugin under Vim's folder.
+ To define hotkey for QuickBuf:
	Define g:qb_hotkey before source qbuf.vim, ex:
		let g:qb_hotkey = "<F3>"
	Or put that line in your _vimrc profile. Default, key <F4> is used.
	Whenever you change g:qb_hotkey, :so qbuf.vim again to update hotkey.
