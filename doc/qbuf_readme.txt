Vim plugin helps navigate and manipulate opening, listed buffers
Maintainer: palnart <palnart@gmail.com>
Last Change: 2007 Jun 2

Features:
+	Quickly navigate 'listed' buffers with keys j and k
+ Operations on buffers include showing, deleting, wipping out
	with a single key-stroke
+	Create no buffer, no auto-command, activated with a hotkey when needed
+ Quick mode like 'operator' of Vim, '12d' to delete the 12'th buffer
+	SMALL, FAST, NICE and USEFUL! INTERESTING!

Using:
Copy to plugin directory or source it! :so bufsw.vim

Asign a hotkey (default <F4>, modify to whatever you like) to activate.
Press <F4> to show the list of all 'listed' buffers, with one selected
	at the command-line area, the area is expanded to fit the list
Press j move 'select bar' down, k move up, wrap around at two ends
Press <Enter> edit selected buffer, hide the buffer list
Press u switch to view the selected buffer, but don't leave the list
Press d to delete, w to wipe out a buffer, if error, you see it
Press q or <Esc> to leave
You can use quick method, press '9<Enter>' to switch to the 9'th buffer
	press '3d' to delete the 3'th buffer (not the Vim's buffer number)

Bugs:
+	If there isn't enough space (screen line) to show the list, it ends
	up in a ugly error message about a exception not caught. Don't worry!
	Just ignore, close some Vim's windows to make place and try :)
+ Sometimes, mainly because of too long messages, the plugin doesn't well
	display something. Keep your Vim's window at reasonable size :)

Todo:
+ Implement U, D and W to force switch, delete and wipeout buffers
+ Simulate scrollable buffer list when Vim's window too small

Changed 2007 Jun 2:
+ Add a plus (+) to indicate changed buffer
+ Error message when buffer list doesn't fit Vim's shell more readable
