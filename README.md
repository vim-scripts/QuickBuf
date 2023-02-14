Copy by [vim-scripts/QuickBuf](http://www.vim.org/scripts/script.php?script_id=1910)

QuickBuf
---
>Vim plugin helps navigate and manipulate buffers

**Brief description:**
>While making the task of browsing and manipulating buffers visual and simple, QuickBuf also offers advanced abilities of dealing with buffers (ex: "unlisted" mode). It's unique among several other buffer managers for creating no dedicated buffer and defining no auto command, thus minimize its interference.

**Usage:**
>+ Press the assigned hotkey to activate QuickBuf (default <F4>). It brings out a list of buffers that you can browse and give commands on! Some indicators in the list:  
	- * : the buffer being opened in the active window  
	- = : a buffer being opened in a window, but not active  
	- [+] : modifed buffer  
>+ Use k/j or <Up>/<Down> keys to select the buffer.
>+ Press a key to give a command to the currently selected buffer  
	- d/D : del/!delete buffer  
	- w/W : wipe/!wipe out buffer  
	- s : open buffer in a new horizontally split window  
	- v : open buffer in a new vertically split window  
	- f : open buffer  
	- e : quickly switch buffer in current window  
	- <enter/space> : open buffer and leave QuickBuf; if the buffer is already opened in a window, switch to that window.  
>+ d, w, and <enter> operations may fail, You can use D, W force operation
>+ Instead of moving the selection bar around to select a buffer, you can use a number to specify a buffer. For example: '2d' will delete the second buffer in the list. Try '3f', '1w', '1!w' or '1W'
>+ Use 'l' key to toggle between LISTED and UNLISTED mode. Which mode QuickBuf enter first depends on the active buffer. While in UNLISTED mode, 'unlisted' buffers (the buffers you have deleted) are showed. Also:  
	- [+] indicates a loaded buffer  
	- 'd' command makes the selected buffer 'listed' again  
>+ Press \<esc\>/q key to leave QuickBuf

