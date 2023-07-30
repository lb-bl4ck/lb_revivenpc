# lb_revivenpc
## Introduction
A very simple script to let the people revive and heal themselves when there are no EMS in services.

The script it's decently optimized, idle `0.0ms`:

![lb_revivenpc-idle](https://github.com/lb-bl4ck/lb_revivenpc/assets/140919445/0e332804-2d02-4f9b-9bcd-fb2dc4c8cf00)

And when you're nex to the ped (TextUI active) `0.02 ~ 0.03ms`:

![lb_revivenpc-textui](https://github.com/lb-bl4ck/lb_revivenpc/assets/140919445/00fe27a1-6d9f-4d5b-bec7-95710d0af68f)

## Dependencies

- [esx_ambulancejob](https://github.com/esx-framework/esx_ambulancejob)
- [ox_lib](https://github.com/overextended/ox_lib) (notification and text ui system)

## Installation
1 - Download the latest [release](https://github.com/lb-bl4ck/lb_revivenpc/releases).

2 - Extract the file into your server.

3 - Remove `-main` from folder name.

4 - Add `ensure lb_revivenpc` to your server.cfg.
