This is a hex edited version of aBadAvatar/BadUpdate to work off of Memory Unit's! You'd need a 256MB or 512MB for it to work and must plug it into the first slot as I have shown in releases. Apparently the Memory Unit calls are hard coded per port (Mu0 and Mu1). Please put your dashboards on your HDD's or elsewhere. Aurora took up over 300MB's with its data from cover arts and such.


# Below is the aBadAvatar README

A real README will come shortly, but until then:
- Ensure your console has the Avatar update data. If you don't have an HDD, you may need to install the official offline System Update 17559 on a formatted USB. **Don't use LIVE to update, just in case Microsoft decides to patch this.**
- No xex is included. You'll need to put an xex that does what you wish in the BadUpdatePayload folder (odds are, this is XeUnshackle or FreeMyXe)
- You can tell if the exploit is running by moving the cursor on the profile select screen. Additionally, the 2 LEDs on the ROL will occasionally swap. Attempting to back out of the selection screen or log in at this point will interfere with the exploit.
- Don't log in to the exploit profile, **especially while on LIVE**. There is a PIN set to prevent accidental logins.
- You should ensure that you are disconnected from both Wi-Fi and Ethernet before using this exploit to prevent LIVE bans. Ethernet is easy, but Wi-Fi requires you to either disconnect before turning off your console, or sacrifice the cold boot aspect (or just don't hook up the 360 to the internet at all).
- Stage 2 is fully buildable start-to-finish without any trickery. If you want to modify stage1, hexedit the output into the avatar item from the release profile at address 0x2200. Stage0 is tricky to modify due to compression, but only shows the anti-scam text and performs a stack pivot and can safely be considered static.
- Stage 3 should be built at 0x90110000 instead of 0x98030000. Additionally, you should pad up to 0x10000 bytes with `4E 80 00 20` to ensure the module used in the exploit can be properly unloaded.

# Below is the original Bad Update README

![banner](https://github.com/user-attachments/assets/e9684c9d-d4db-48a8-9661-53629c20e22e)

Bad Update is a non-persistent software only hypervisor exploit for Xbox 360 that works on the latest (17559) software version. This repository contains the exploit files that can be used on an Xbox 360 console to run unsigned code. This exploit can be triggered using one of the following games:
- Tony Hawk's American Wasteland (NTSC/PAL/RF see [here](https://github.com/grimdoomer/Xbox360BadUpdate/wiki/Tony-Hawk's-American-Wasteland#compatible-versions) for how to identify your version/region)
- Rock Band Blitz (trial or full game, see [here](https://github.com/grimdoomer/Xbox360BadUpdate/wiki/Rock-Band-Blitz) for more information)

**This exploit is NOT persistent!** This means your console will only be in a hacked state (able to run homebrew/unsigned code) for as long as it's kept on. **Once you reboot or power off your console you'll need to run the exploit again**. The exploit cannot be made persistent.

**Your Xbox 360 console must be on dashboard version 17559 in order to use this exploit**. While the exploit can be ported to any system software version I have only built the exploit for the 17559 dashboard version.

For information on how to use the exploit see the Quick Start section below. For information on how the exploit works or how to compile it from scratch see the following wiki pages:
- [Compiling](https://github.com/grimdoomer/Xbox360BadUpdate/wiki/Compiling)
- [Exploit Details](https://github.com/grimdoomer/Xbox360BadUpdate/wiki/Exploit-Details)

# Quick Start
To run the Bad Update exploit you'll need one of the supported games listed above and a USB stick. The following steps give a brief overview of how to run the exploit, for more detailed steps please see the [How To Use](https://github.com/grimdoomer/Xbox360BadUpdate/wiki/How-To-Use) wiki page.
1. Download the Xbox360BadUpdate-Retail-USB.zip file from the releases section and extract the files.
2. Format a USB stick to FAT32.
3. Copy the contents of the folder matching the game you want to use for the exploit to the root of the USB stick.
    * If you're using Tony Hawk's American Wasteland copy the contents of the Tony Hawk's American Wasteland folder to the root of the USB stick.
    * If you're using Rock Band Blitz copy the contents of the Rock Band Blitz folder to the root of the USB stick.
    * The root of the USB stick should contain the following files/folders: BadUpdatePayload, Content, name.txt.
4. Place the unsigned executable you want to run when the exploit triggers into the BadUpdatePayload folder on the USB stick and name it "default.xex" (replace any existing file in the folder). This xex file must be in retail format and have all restrictions removed (see the wiki for how to do this).
5. Insert the USB stick into your Xbox 360 console and power it on.
6. Sign into the Player 1 profile and run the game you're using to trigger the exploit.
    * If you're using Rock Band Blitz, there is no profile included. You can use any local/offline profile, or run the game completely signed out.
7. Follow the instructions for the game you chose to load the hacked game save file and begin the exploit process.
8. The console's ring of light will flash different colors/segments during the exploit process to indicate progress. For information on what the different values mean see the [LED Patterns and Meanings](https://github.com/grimdoomer/Xbox360BadUpdate/wiki/How-To-Use#led-patterns-and-meanings) section of the wiki.
9. Once the exploit triggers successfully the RoL should be fully lit in green. The hypervisor has now been patched to run unsigned executables and your unsigned default.xex file will be run.

The exploit has a 30% success rate and can take up to 20 minutes to trigger successfully. If after 20 minutes the exploit hasn't triggered you'll need to power off your Xbox 360 console and repeat the process from step 5.

# Contributing
Due to continuous spam and lack of moderation controls on GitHub's side I've decided to make this repository read-only. If anyone has any meaningful contributions to make you can contact me directly. Do **NOT** contact me for general support questions or low effort contributions (spelling mistakes, verbiage, etc.), I will not respond and you will be blocked.

# FAQ
**Q: Why do I have to re-run the exploit every time I turn my console on?**  
A: The exploit is not-persistent, it only works for as long as the console is kept on. Once the console is turned off or rebooted you'll need to run the exploit again.

**Q: What does this provide over the RGH Hack/should I use this instead of RGH?**  
A: This is a software only exploit that doesn't require you open your console or perform any soldering to use. Other than that it's inferior to the RGH exploit in every way and should be considered a "proof of concept" and not something you use in place of RGH.

**Q: Can this be turned into a softmod?**  
A: No, the Xbox 360 boot chain is very secure with no attack surface to try and exploit. There will never exist a software only boot-to-hacked-state exploit akin to a "softmod".

**Q: Does this work on winchester consoles?**  
A: Yes it has been confirmed to work on winchester consoles.

**Q: Does this work with the Original Xbox version of Tony Hawk's American Wasteland?**  
A: No, it only works with the Xbox 360 version.

**Q: Can \<insert other skateboarding game here> be used with this?**  
A: No, the Tony Hawk save game exploit is specific to Tony Hawk's American Wasteland and has nothing to do with it being a skateboarding game.

**Q: Can \<insert other music game here> be used with this?**  
A: No, the Rock Band save game exploit is specific to Rock Band Blitz and has nothing to do with it being a music game.

**Q: I ran the exploit and nothing happened?**  
A: The exploit has a 30% success rate. If after running for 20 minutes the exploit hasn't triggered you'll need to reboot your console and try again.

**Q: Why does the exploit only run a single unsigned xex?**  
A: My goal was to hack the hypervisor, not to develop a robust all-in-one homebrew solution. Someone else will need to develop a post-exploit executable that patches in all the quality of life things you would get from something like the RGH exploit.

**Q: Why does the exploit take so long to trigger/have a low success rate?**  
A: The exploit is a race condition that requires precise timing and several other conditions to be met for it to trigger successfully. As such it can take a while for that to happen.
