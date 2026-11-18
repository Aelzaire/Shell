/*
	editors.nss - "Edit with ..." entries that start the editor directly.

	Notepad++
	On Windows 11, Notepad++'s shell extension (NppShell) registers two
	"Edit with Notepad++" handlers: a classic one and a packaged one for the new
	menu. Each one hides itself depending on which was asked last, so a classic
	menu can end up with a greyed-out or non-working entry. The entry below
	starts notepad++.exe itself, so it works whatever state NppShell is in, and
	it opens every selected file in one window. Hold SHIFT to open as
	administrator.

	NppShell's own entries are hidden only when notepad++.exe was found here,
	so nothing disappears if Notepad++ lives somewhere else. Set npp_custom to
	the full path of notepad++.exe for portable or unusual installs.
*/

$npp_custom = ''
$npp_reg = reg.get('HKLM\SOFTWARE\Notepad++')
$npp_reg32 = reg.get('HKLM\SOFTWARE\WOW6432Node\Notepad++')
$npp = if(path.exists(npp_custom), npp_custom,
	if(path.exists(npp_reg + '\notepad++.exe'), npp_reg + '\notepad++.exe',
	if(path.exists(npp_reg32 + '\notepad++.exe'), npp_reg32 + '\notepad++.exe',
	if(path.exists(sys.prog + '\Notepad++\notepad++.exe'), sys.prog + '\Notepad++\notepad++.exe',
	if(path.exists(sys.prog32 + '\Notepad++\notepad++.exe'), sys.prog32 + '\Notepad++\notepad++.exe',
	if(path.exists(user.localappdata + '\Programs\Notepad++\notepad++.exe'), user.localappdata + '\Programs\Notepad++\notepad++.exe',
	if(path.exists(user.home + '\scoop\apps\notepadplusplus\current\notepad++.exe'), user.home + '\scoop\apps\notepadplusplus\current\notepad++.exe',
	'')))))))

// Hide NppShell's entries (classic and packaged, any language) at the top level only;
// "Open with > Notepad++" is inside a submenu and is not affected.
modify(mode=mode.multiple where=path.exists(npp) find='notepad++' vis=vis.remove)

item(type='file' mode=mode.multiple where=path.exists(npp)
	title=loc.edit_with_notepadpp
	tip=[loc.tip_shift_admin, tip.info, 1.0]
	image=npp
	admin=key.shift()
	cmd=npp
	args=sel(true))

item(type='dir|back.dir|back.drive' mode=mode.single where=path.exists(npp) and key.shift()
	title=loc.open_folder_in_notepadpp
	image=npp
	cmd=npp
	args='-openFoldersAsWorkspace @sel.path.quote')
