/*
	archive.nss - Windows 11-style "Compress to" and "Extract" commands.

	Uses tar.exe (bsdtar/libarchive), which ships with Windows 10 1803 and
	later, so nothing extra needs to be installed. Creating 7z archives is
	offered from Windows 11 24H2 (build 26100), where Windows itself creates
	them. If tar.exe fails, a message box says so instead of failing silently.

	"Extract All..." from Windows stays where it is; these add one-click
	"Extract here" and "Extract to <name>\" for every format tar.exe reads.
*/

menu(type='file|dir' mode=mode.multiple where=path.exists(sys.bin + '\tar.exe')
	title=loc.compress_to image=icon.compressed)
{
	$arc_tar = sys.bin + '\tar.exe'
	$arc_ps = sys.bin + '\WindowsPowerShell\v1.0\powershell.exe'
	$arc_fail = `"@arc_ps" -NoProfile -NonInteractive -WindowStyle Hidden -Command "[void](New-Object -ComObject WScript.Shell).Popup('@loc.archive_failed',0,'@app.name',16)"`
	// tar runs in the selection's folder, so the archive stores relative names.
	$arc_dir = str.trimend(sel.parent, '\')
	$arc_names = str.replace(sel(true, ' '), '"' + arc_dir + '\', '"')
	$arc_title = if(sel.count == 1,
		if(io.attribute.directory(sel.path), sel.name, sel.title),
		if(str.len(sel.parent.name) > 0, sel.parent.name, 'Archive'))
	$arc_base = arc_dir + '\' + arc_title
	$arc_stamp = ' (' + sys.datetime('ymdHMS') + ')'
	$arc_zip = arc_base + if(path.exists(arc_base + '.zip'), arc_stamp, '') + '.zip'
	$arc_7z = arc_base + if(path.exists(arc_base + '.7z'), arc_stamp, '') + '.7z'
	$arc_tarfile = arc_base + if(path.exists(arc_base + '.tar'), arc_stamp, '') + '.tar'

	item(title=loc.zip_file image=inherit window=hidden dir=sel.parent
		cmd=sys.bin + '\cmd.exe'
		args=`/d /c ""@arc_tar" -a -c -f "@arc_zip" @arc_names || @arc_fail"`)

	item(title=loc.seven_zip_file where=sys.ver.build >= 26100 image=inherit window=hidden dir=sel.parent
		cmd=sys.bin + '\cmd.exe'
		args=`/d /c ""@arc_tar" -a -c -f "@arc_7z" @arc_names || @arc_fail"`)

	item(title=loc.tar_file image=inherit window=hidden dir=sel.parent
		cmd=sys.bin + '\cmd.exe'
		args=`/d /c ""@arc_tar" -c -f "@arc_tarfile" @arc_names || @arc_fail"`)
}

menu(type='file' mode=mode.multiple expanded=true where=path.exists(sys.bin + '\tar.exe')
	find='.zip|.7z|.rar|.tar|.tgz|.gz|.tbz|.tbz2|.bz2|.txz|.xz|.tzst|.zst|.lz|.lzma|.cab|.iso|.cpio|.xar|.lha|.lzh|.ar|.deb|.rpm')
{
	$arc_tar = sys.bin + '\tar.exe'
	$arc_ps = sys.bin + '\WindowsPowerShell\v1.0\powershell.exe'
	$arc_fail = `"@arc_ps" -NoProfile -NonInteractive -WindowStyle Hidden -Command "[void](New-Object -ComObject WScript.Shell).Popup('@loc.extract_failed',0,'@app.name',16)"`
	// "photos.tar.gz" extracts to "photos\", like Windows does.
	$arc_folder = if(str.end(str.lower(sel.title), '.tar'), str.left(sel.title, str.len(sel.title) - 4), sel.title)

	item(title=loc.extract_here image=icon.extract_all invoke=multiple window=hidden sep=sep.before
		cmd=sys.bin + '\cmd.exe'
		args=`/d /c ""@arc_tar" -x -f "@sel.path" -C "@sel.parent" || @arc_fail"`)

	item(mode=mode.single title=loc.extract_to + ' "' + arc_folder + '\"' image=icon.extract_to window=hidden sep=sep.after
		cmd=sys.bin + '\cmd.exe'
		args=`/d /c "mkdir "@sel.parent\@arc_folder" 2>nul & "@arc_tar" -x -f "@sel.path" -C "@sel.parent\@arc_folder" || @arc_fail"`)
}

// If this Windows build also lists its own "Compress to" in the classic menu, keep only one.
modify(type='file|dir' where=this.type == 1 find='"compress to"' vis=vis.remove)
