# imageTowebp

This script turns png and jpg (jpeg) into webp.

## Usage

Download the script and run it in a linux enviroment.

```bash
bash script.sh sourcefolder targetfolder
```
args:
- sourcefolder
  - default: ./
- targetfolder
  - default: ./webp_output/

deps:
- gnu parallel
- ffmpeg
