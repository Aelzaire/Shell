menu(type='*' where=(sel.count or wnd.is_taskbar or wnd.is_edit) title=title.terminal sep=sep.top image=icon.run_with_powershell)
{
	$tip_run_admin=["\xE1A7 Press [SHIFT key] or [RIGHT-CLICK] to run " + this.title + " as administrator", tip.warning, 1.0]
	$has_admin=key.shift() or key.rbutton()
	// "\." keeps a drive root such as C:\ from ending in \" on the command line.
	$term_dir=sel.dir + '\.'
	$pwsh=sys.prog + '\PowerShell\7\pwsh.exe'
	$git_bash=sys.prog + '\Git\git-bash.exe'

	item(where=package.exists("WindowsTerminal")
			title=title.Windows_Terminal
			tip=tip_run_admin
			admin=has_admin
			image='@package.path("WindowsTerminal")\WindowsTerminal.exe'
			cmd="wt.exe"
			arg=`-d "@sel.path\."`)
	item(title=title.command_prompt tip=tip_run_admin admin=has_admin image cmd-prompt=`/K TITLE Command Prompt &ver& PUSHD "@sel.dir"`)
	item(title=title.windows_powershell admin=has_admin tip=tip_run_admin image cmd-ps=`-noexit -command Set-Location -LiteralPath '@str.replace(sel.dir, "'", "''")'`)
	item(where=path.exists(pwsh) title='PowerShell 7' tip=tip_run_admin admin=has_admin image=pwsh
			cmd=pwsh args=`-NoExit -WorkingDirectory "@term_dir"`)
	item(where=path.exists(git_bash) title='Git Bash' tip=tip_run_admin admin=has_admin image=git_bash
			cmd=git_bash args=`--cd="@term_dir"`)
	item(where=reg.exists('HKCU\Software\Microsoft\Windows\CurrentVersion\Lxss') and path.exists(sys.bin + '\wsl.exe')
			title='WSL' tip=tip_run_admin admin=has_admin image=sys.bin + '\wsl.exe'
			cmd=sys.bin + '\wsl.exe' args=`--cd "@term_dir"`)
}
