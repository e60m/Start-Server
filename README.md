VorteX RP Server Auto Starter
Overview
The VorteX RP Server Auto Starter script is designed to automate the process of starting and ensuring essential resources for a FiveM server. This Lua script executes a series of commands to make sure that the required resources are either started or loaded before running the server, improving the server setup and management process.

It is primarily useful for automating the startup of a roleplay server with multiple scripts and resources, ensuring that all necessary dependencies are ready to go without manual intervention.

Features
Automatic Resource Management: Automatically starts or ensures resources when the server starts.

Command Execution: Runs a series of ensure and start commands to initialize various resources and scripts.

Built-in Delays: Includes specific delays between some commands to prevent server overload and ensure smooth startup.

Customizable Commands: Easily customizable to include any additional resources you wish to start or ensure.

Script Workflow
Resource Start Event Listener:

The script listens for the onResourceStart event. When the resource starts, it triggers the execution of the predefined commands.

Command Execution:

The script executes a list of commands to either ensure or start resources.

It waits for 6 seconds between each command and longer waits for certain commands to ensure proper loading.

Console Output:

The script prints detailed logs to the console, showing which commands were executed and confirming successful execution.

Final Confirmation:

Once all commands are executed, it prints a final message confirming the successful execution of all commands.

Resources Managed
Here is a list of the commands that will be executed by the script:

lua
Copy
Edit
local commands = {
    "ensure spawnmanager",
    "ensure hardcap",
    "ensure bob74_ipl",
}
This list includes commands to manage various resources related to gameplay, UI, chat systems, vehicles, and server management.

Usage
Installation
Clone the repository or download the script files.

Place the script in your resources directory on your FiveM server.

Add the resource to your server configuration:

Open your server.cfg file and add the following line:

plaintext
Copy
Edit
start VorteXStartServer
Set up ACE Permissions (optional):
To ensure the correct permissions, add the following ACE permissions to your server configuration:

plaintext
Copy
Edit
add_ace resource.VorteXStartServer command.start allow
add_ace resource.VorteXStartServer command.ensure allow
add_ace resource.VorteXStartServer command.stop allow
How It Works
When the resource VorteXStartServer starts, the script automatically begins executing the commands listed in the commands array.

Each command is executed with a delay to ensure that previous resources are properly loaded before starting new ones.

The script prints a log of the execution process, and once all commands are finished, a message confirms that the process has been completed successfully.

Customization
You can customize the script by editing the commands array. Simply add or remove commands based on the resources you want to manage on your server.

Example:

Add a new command to start a resource:

lua
Copy
Edit
"start [NewResource]"
Remove a command from the list if it's not needed:


-- "start [OldResource]" -- Comment this line out if not needed
Contributing
Fork the repository.

Create your feature branch (git checkout -b feature-name).

Commit your changes (git commit -m 'Add new feature').

Push to the branch (git push origin feature-name).

Open a pull request.

License
This project is licensed under the MIT License - see the LICENSE file for details.

Acknowledgements
Thanks to the FiveM community for their resources and contributions.

Special thanks to the developers of various FiveM resources used in the script.
