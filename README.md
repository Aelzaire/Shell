[![Ceasefire Now](https://badge.techforpalestine.org/default)](https://techforpalestine.org/learn-more)

[![Build](../../actions/workflows/build.yml/badge.svg)](../../actions/workflows/build.yml)

# Shell for Windows 11

A community-updated version of [Nilesoft Shell](https://github.com/moudey/Shell), a
replacement for the Windows File Explorer context menu, brought up to date for
current Windows 11 builds (24H2/25H2). It replaces the stock menu completely: every
Windows command is still there, so you never need "Show more options".

The original project's last code changes date from early 2026, and its open
pull requests are not being merged. This fork collects those fixes, adds new ones,
and builds them for you.

### What's different from upstream 1.9.19

* **"Edit with Notepad++" works again.** It is no longer greyed out or dead: a
  bug in Shell's duplicate removal is fixed, and the entry now starts Notepad++
  directly.
* **"Send to" and "New" show all their items** again.
* **Windows 11-style archive commands**: *Compress to* ZIP / 7z / TAR, *Extract
  here*, and *Extract to "name\"* for zip, 7z, rar, tar, iso and more. They use
  Windows' built-in `tar.exe`, so nothing extra is needed.
* **Nothing from the Windows menu is removed.** Rarely used items go into *More
  options* instead.
* Correct colours on 24H2/25H2, mixed-DPI and multi-monitor fixes, and Pin to
  Start recognised in every language.
* **Copy hash** (SHA-256/SHA-1/SHA-512/MD5), plus PowerShell 7, Git Bash and
  WSL in the Terminal menu.
* Security and stability fixes: no DLL planting, no world-writable install
  folder, no COM work under the loader lock.

The full list, with credits for every fix, is in [CHANGELOG-win11.md](CHANGELOG-win11.md).

### Install

1. Download the build for your PC (**x64** for most PCs, **arm64** for
   Snapdragon/ARM) from [Releases](../../releases), or the latest automatic
   build from the [Actions](../../actions/workflows/build.yml) tab.
2. Uninstall any other copy of Nilesoft Shell first.
3. Either run `setup-x64.msi` (or `setup-arm64.msi`), or extract the zip to
   a permanent folder such as `C:\Program Files\Nilesoft Shell`, open Terminal
   **as administrator** in that folder, and run:
   ```
   .\shell.exe -register -restart
   ```
4. To remove it: `.\shell.exe -unregister -restart`, or uninstall the MSI.

If Explorer misbehaves after installing, press Ctrl+Shift+Esc, choose **Run new
task**, tick *Create this task with administrative privileges*, and run
`"C:\Program Files\Nilesoft Shell\shell.exe" -unregister -restart`.

The menu is configured in plain text: `shell.nss` and the files in `imports\`.
After editing, hold CTRL and right-click the desktop or taskbar to reload it. For
the syntax, see the [documentation](https://nilesoft.org/docs).

### Credits

Shell was created by [Moudey (Nilesoft)](https://github.com/moudey/Shell) and is MIT
licensed. This fork includes fixes by v4806, MissinLinkk05551, loliri, TCNOco,
opj161 and Abdullah-Masood-05, credited in each commit. If you like Shell, consider
supporting the original author (see *Donate* below).

---

*The original project README follows.*

## Details
<p>
Shell is a context menu extender that lets you handpick the items to integrate into the Windows File Explorer context menu, create custom commands to access all your favorite web pages, files, and folders, and launch any application directly from the context menu.<br>
It also provides you a convenient solution to modify or remove any context menu item added by the system or third-party software.
</p>

Features
------------------
* Lightweight, portable, and relatively easy to use.
* Fully customize the appearance.
* Adding new custom items such as (sub-menu, menu-items, and separator).
* Modify or remove items that already exist.
* Support all file system objects, including files, folders, desktop, and the taskbar.
* Support expressions syntax. with built-in functions and predefined variables.
* Support colors, glyphs, SVG, embedded icons, and image files such as .ico, .png or .bmp.
* Support search and filter.
* Support for complex nested menus.
* Support multiple columns.
* Quickly and easily configure file in plain text.
* Minimal resource usage.
* No limitations.


Requirements
------------------
  * Microsoft Windows 7/8/10/11 


Documentation
------------------
Browse the [online documentation here.](https://nilesoft.org/docs)

[<img src="https://devin.ai/assets/deepwiki-badge.png" alt="Ask DeepWiki.com" height="20"/>](https://deepwiki.com/moudey/Shell)

Download
------------------
This fork: [Releases](../../releases).
Original version: https://nilesoft.org/download

Screenshots
------------------
<p align="center">
<img src="/screenshots/folder-back.png"><img src="/screenshots/file-manage.png"><br>
<img src="/screenshots/view.png"><img src="/screenshots/edit.png"><br>
<img src="/screenshots/terminal.png"><img src="/screenshots/taskbar.png"><br>
<img src="/screenshots/goto2.png"><img src="/screenshots/gradient.png"><br>
<img src="/screenshots/acrylic.png"><br>

<br>
<br>
</p>

Donate
------------------
If you really love Shell and would like to see it continue to improve.

[![Paypal](https://img.shields.io/badge/Donate-PayPal-blue.svg)](https://www.paypal.me/nilesoft)
[![BuyMeACoffee](https://img.shields.io/badge/Donate-BuyMeACoffee-yellow.svg)](https://www.buymeacoffee.com/moudey)


