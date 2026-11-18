menu(mode="multiple" title=loc.develop sep=sep.bottom image=\uE26E)
{
	$vscode = if(path.exists(user.localappdata + '\Programs\Microsoft VS Code\Code.exe'), user.localappdata + '\Programs\Microsoft VS Code\Code.exe',
		if(path.exists(sys.prog + '\Microsoft VS Code\Code.exe'), sys.prog + '\Microsoft VS Code\Code.exe', ''))
	$vscode_insiders = if(path.exists(user.localappdata + '\Programs\Microsoft VS Code Insiders\Code - Insiders.exe'), user.localappdata + '\Programs\Microsoft VS Code Insiders\Code - Insiders.exe',
		if(path.exists(sys.prog + '\Microsoft VS Code Insiders\Code - Insiders.exe'), sys.prog + '\Microsoft VS Code Insiders\Code - Insiders.exe', ''))
	$dotnet = sys.prog + '\dotnet\dotnet.exe'

	menu(mode="multiple" title=loc.editors image=\uE17A)
	{
		item(where=path.exists(vscode) title='Visual Studio Code' image=vscode cmd=vscode args=sel(true))
		item(where=path.exists(vscode_insiders) title='Visual Studio Code - Insiders' image=vscode_insiders cmd=vscode_insiders args=sel(true))
		separator
		item(type='file' title=loc.windows_notepad image invoke=multiple cmd='@sys.bin\notepad.exe' args='@sel.path.quote')
	}

	menu(mode="multiple" where=path.exists(dotnet) title='dotnet' image=\uE143)
	{
		item(title='run' cmd-line='/K dotnet run' image=\uE149)
		item(title='watch' cmd-line='/K dotnet watch')
		item(title='clean' image=\uE0CE cmd-line='/K dotnet clean')
		separator
		item(title='build debug' cmd-line='/K dotnet build')
		item(title='build release' cmd-line='/K dotnet build -c release /p:DebugType=None')

		menu(mode="multiple" sep="both" title='publish' image=\uE11F)
		{
			$publish='dotnet publish -r win-x64 -c release --output publish /*/p:CopyOutputSymbolsToPublishDirectory=false*/'
			item(title='publish single file' sep="after" cmd-line='/K @publish --no-self-contained /p:PublishSingleFile=true')
			item(title='framework-dependent deployment' cmd-line='/K @publish')
			item(title='framework-dependent executable' cmd-line='/K @publish --self-contained false')
			item(title='self-contained deployment' cmd-line='/K @publish --self-contained true')
			item(title='single-file' cmd-line='/K @publish /p:PublishSingleFile=true /p:PublishTrimmed=false')
			item(title='single-file-trimmed' cmd-line='/K @publish /p:PublishSingleFile=true /p:PublishTrimmed=true')
		}

		item(title='ef migrations add InitialCreate' cmd-line='/K dotnet ef migrations add InitialCreate')
		item(title='ef database update' cmd-line='/K dotnet ef database update')
		separator
		item(title='help' image=\uE136 cmd-line='/k dotnet -h')
		item(title='version' cmd-line='/k dotnet --info')
	}
}
