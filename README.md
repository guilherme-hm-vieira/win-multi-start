# win-multi-start

Launch multiple development services in separate colored terminal windows on Windows — configured from a single JSON file.

## How it works

- **Single service** → runs in the current terminal window
- **Multiple services** → opens a separate colored `cmd` window for each one

All services are defined in `services.json`. No need to touch `run.bat` or `run.ps1` to add or change a service.

## Requirements

- Windows 10/11
- PowerShell 5.1+

## Setup

1. Clone the repository somewhere on your machine.
2. Add the folder to your system `PATH` so `run` is available anywhere.
3. Edit `services.json` with your services (see [Configuration](#configuration)).

## Usage

```bat
run                     # show available services
run api                 # run one service in the current window
run api frontend        # open each service in its own colored window
```

## Configuration

Edit `services.json` to add, remove, or change services. Each entry has four fields:

| Field     | Description                                              |
|-----------|----------------------------------------------------------|
| `name`    | The name used as the command argument                    |
| `color`   | Windows CMD color code (e.g. `0A` = black bg + green fg) |
| `path`    | Absolute path to the project directory                   |
| `command` | The command to run inside that directory                 |

**Example:**
```json
[
  {
    "name": "api",
    "color": "0A",
    "path": "C:\\Projects\\my-api",
    "command": ".\\gradlew bootRunDebug"
  },
  {
    "name": "frontend",
    "color": "0B",
    "path": "C:\\Projects\\my-frontend",
    "command": "npm run dev"
  }
]
```

### CMD color codes

The first digit is the background, the second is the text color.

| Code | Color        |
|------|--------------|
| `0`  | Black        |
| `1`  | Dark Blue    |
| `2`  | Dark Green   |
| `3`  | Dark Cyan    |
| `4`  | Dark Red     |
| `5`  | Dark Magenta |
| `6`  | Dark Yellow  |
| `7`  | Gray         |
| `8`  | Dark Gray    |
| `9`  | Blue         |
| `A`  | Green        |
| `B`  | Cyan         |
| `C`  | Red          |
| `D`  | Magenta      |
| `E`  | Yellow       |
| `F`  | White        |

## Files

| File            | Purpose                                       |
|-----------------|-----------------------------------------------|
| `run.bat`       | Entry point — thin wrapper that calls run.ps1 |
| `run.ps1`       | Main logic (reads JSON, launches services)    |
| `services.json` | Service definitions (the only file you edit)  |
