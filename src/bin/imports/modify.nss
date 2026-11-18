// modify items
// Nothing from the Windows menu is removed: rarely used items go into "More options"
// (at the bottom of this file), so "Show more options" is never needed.

modify(type="recyclebin" where=window.is_desktop and this.id==id.empty_recycle_bin pos=1 sep)

modify(find="unpin*" pos="bottom" menu="Pin/Unpin")
modify(find="pin*" pos="top" menu="Pin/Unpin")

modify(where=this.id==id.copy_as_path menu="file manage")
modify(type="dir.back|drive.back" where=this.id==id.customize_this_folder pos=1 sep="top" menu="file manage")

modify(where=str.equals(this.name, ["open in terminal", "open linux shell here"]) || this.id==id.open_powershell_window_here
	pos="bottom" menu="Terminal")

// Low-use Windows items, kept one click away instead of removed.
// Send to, Share, Create shortcut, Print, Rotate, Set as background, Eject and Format
// stay at the top level, where Windows 11 itself shows them.
modify(mode=mode.multiple
	where=this.id(
		id.restore_previous_versions,
		id.cast_to_device,
		id.give_access_to,
		id.include_in_library,
		id.map_network_drive,
		id.disconnect_network_drive,
		id.make_available_offline,
		id.make_available_online,
		id.troubleshoot_compatibility
	)
	pos=1 menu=title.more_options)
