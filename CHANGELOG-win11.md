# Windows 11 modernization

Changes on the `win11-modernize` branch, on top of upstream `moudey/Shell` main
(last merge 2026-02-09, version 1.9.19). The goal: a context menu that works on
current Windows 11 builds (24H2/25H2) and replaces the stock menu completely, so
"Show more options" is never needed.

Fixes taken from other people's work are credited in each commit, with a link to
the original. The C++ changes were compiled and linked (shell.dll and shell.exe,
x64) with clang-cl against the Windows SDK. The default configuration was
checked with Shell's own parser, run under Wine. **None of this has been run on
Windows yet. Test it on a real Windows 11 machine before release.**

## Notepad++ ("Edit with Notepad++" greyed out or doing nothing)

There were two causes:

1. **Shell bug: duplicate removal kept the wrong item.** With
   `modify.remove.duplicate=1` (the default since 1.9.0), the scan index was
   advanced after the loop instead of inside it, so it was always 0. When a
   disabled item came before its enabled twin, the enabled one overwrote the
   first menu entry (usually *Open*) and the disabled one stayed. Notepad++'s
   NppShell creates exactly that pair on Windows 11: a classic handler and a
   packaged one, each hiding itself depending on which one Windows asked last.
   The index is fixed, the replaced item is freed, and the path map is kept
   consistent.
2. **Config: the menu entry no longer depends on NppShell.** The new
   `imports/editors.nss` finds `notepad++.exe` (registry, Program Files,
   per-user, scoop, or a path you set) and starts it directly. All selected
   files open in one window, and holding SHIFT runs it as administrator.
   NppShell's own entries are hidden only when `notepad++.exe` was found.

Shell's own commands also had a problem: they run on a worker thread that
never initialised COM, which `ShellExecuteEx` requires, and the `SEE_MASK`
flags overwrote each other. Some items did nothing, now and then. Both are
fixed.

## Windows 11 fixes in shell.dll

- **Send to / New submenus missing items** (#749, #815, #464, #614). shell32
  fills these lazily, after Shell has taken its snapshot. They are now read
  again when they open, and modify rules are applied again.
- **Broken colours on 24H2/25H2.** The fallback to system colours, used when
  the theme API fails, ran only on Canary/Dev builds. It now runs on all
  Windows 11 builds. Dark mode keeps the dark preset.
- **Pin to Start / Pin to Quick access not recognised** on non-English
  Windows 11 (Windows 11 uses newer shell32 strings).
- **Wrong menu scaling with mixed DPI.** The DPI now comes from the window,
  not the monitor.
- **Menus and tooltips on the wrong screen** when a monitor sits left of or
  above the primary one (negative coordinates).
- **Stray separators** at the top of the menu after items were moved.
- **Long item titles cut at 259 characters.** For example, archiver
  "Add to …" items.

## Stability and security

- Shell no longer changes Explorer's working directory on every right-click.
  The working directory is shared by the whole process, which could keep
  folders "in use". Relative paths in `io.*` functions still resolve against
  the folder you right-clicked.
- Shell no longer initialises COM inside `DllMain` (under the loader lock), a
  likely cause of Explorer hangs.
- Registration no longer tries to give *Users* full control of the install
  folder. That would let any user replace a DLL that Explorer loads.
- Windows DLLs are loaded from System32 only, never from the search path, so
  no DLL can be planted in the current folder.
- A config that imports itself can no longer crash Explorer (import depth is
  limited).
- A broken config is retried after you save it again. Before, Explorer had to
  be restarted.
- Shell no longer turns the user's *selection fade* setting off and on with
  every click.
- UTF-8 conversion always failed, so `sel.tofile()` and similar wrote empty
  files. `io.file.write` and `io.file.append` encoded characters at U+8000 and
  above incorrectly. Both are fixed.
- The language file is now picked automatically. It always fell back to
  English, because the check used a relative path. It now tries the exact
  locale, then the base language (`de-DE` → `de`), then English. `ua.nss` is
  renamed to `uk.nss`, and the old name still works.

## Default menu (src/bin)

- **Compress to → ZIP / 7z / TAR**, as in Windows 11, plus **Extract here** and
  **Extract to "name\\"** for zip, 7z, rar, tar.*, cab, iso and more. These use
  the `tar.exe` that ships with Windows, so nothing needs installing. 7z
  creation is offered on build 26100 (24H2) and later. Failures show a message
  box.
- **Terminal**: Windows Terminal comes first. PowerShell 7, Git Bash and WSL
  appear when installed. PowerShell handles paths with `[`, `]` or `'`.
- **File manage → Copy hash** copies the SHA-256, SHA-1, SHA-512 or MD5 hash
  to the clipboard.
- **Nothing from the Windows menu is deleted any more.** Before, *Restore
  previous versions* and *Cast to device* were removed. Low-use items now go
  into *More options*. Send to, Share, Create shortcut, Print, Rotate, Set as
  background, Eject and Format stay at the top level, where Windows 11 shows
  them.
- **Develop**: removed the hard-coded `D:\config\…` tools, which only existed
  on the original author's PC. VS Code and VS Code Insiders are detected
  instead of relying on `code` being in PATH. `dotnet` shows only when it is
  installed. Notepad opens each selected file.

## Building

Open `src/Shell.sln` in Visual Studio 2022 and build *release | x64*, or push the
branch and let `.github/workflows/build.yml` build x64, x86 and ARM64.

## Not addressed

- Taskbar menu not appearing on some 25H2 builds (#802). The cause is unknown
  and needs debugging on an affected machine.
