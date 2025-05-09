<h1 align="center">🚀 VorteX RP Server Auto Starter</h1>

<p align="center">
  <img src="https://img.shields.io/badge/FiveM-Script-blue?style=for-the-badge" alt="FiveM Script">
  <img src="https://img.shields.io/badge/Language-Lua-yellow?style=for-the-badge" alt="Lua">
  <img src="https://img.shields.io/badge/Version-1.0-green?style=for-the-badge" alt="Version">
</p>

<p align="center">
  🔥 A simple auto-starter script for FiveM servers to automatically <b>ensure</b> and <b>start</b> your essential resources on server launch.
</p>

---

## 📂 About

This script **automatically starts & ensures** all your server resources when the server boots up.

✅ No manual typing of commands  
✅ Includes **delays to avoid crashes**  
✅ Logs every command in the console  


## ⚙️ Installation (Quick Setup)

1. 📝 Place the script folder in your `resources` directory.
2. Add this line in your `server.cfg`:
3.✅ Add permissions (optional but recommended):
```
start VorteXStartServer
add_ace resource.VorteXStartServer command.start allow
add_ace resource.VorteXStartServer command.ensure allow
add_ace resource.VorteXStartServer command.stop allow
```
🎉 Done! The script will auto-run when the server starts.
💻 How it works?
When the server starts → Script triggers onResourceStart.

It loops through all the commands like:

```
ensure spawnmanager
start [Cars]
ensure [core]
```
Executes each command with a delay (6s + extra delays for heavy resources).
Prints logs like:

```
[Executed] ensure spawnmanager
[Executed] start [Cars]
```
✅ Fully automatic.

📜 Commands List
<details> <summary>Click to view commands</summary>
```
local commands = {
  "ensure spawnmanager",
  "ensure hardcap",
  "ensure bob74_ipl",
}
```
</details>
✏️ Customization
Want to add/remove resources?
Just edit this part in commands array in the Lua file.

Example:
✅ Add:
```
"start [NewScript]",
```
❌ Remove:
```
-- "start [OldScript]",
```
💬 Support
For issues or suggestions, open an issue on GitHub or contact me via Discord: Ameer Mahdi#1234

📄 License
MIT License © 2025 | Developed by Ameer Mahdi

🎉 Enjoy easy auto-starting your FiveM server!
