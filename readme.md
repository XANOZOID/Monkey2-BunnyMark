# Monkey2 Bunnymark  ![](https://upload.wikimedia.org/wikipedia/commons/thumb/4/48/Emojione_1F412.svg/90px-Emojione_1F412.svg.png)

A simple bunnymark to test the rendering capabilities of Monkey2.

## Changelog
### 2017.12.1
- implemented a single textured mode
- now loads images under one atlas image using a generic XML atlas file
- include an atlas project file for the program "texture packer"
- minor code improvements + suggestions (thanks Ethernaut for forked repo)

# Structure

- OOP Design
- Bunnymark is a controller which handles update, drawing, and mouse input
- **CONTROLS** Left click: 10 bunnies, Right click: 1000 bunnies, middle click -1000 bunnnies
- The Bunnyclass simply holds position, velocities, textures, and handles bounce logic.

# Contribution
____
Want to fix any mistakes or add improvements? Please do! This test is supposed to be as generic as possible. "Micro-optimizations" aren't desired but, if available, create a second file for the "super-optimized" version. 
- Just open a pull request and it will more than likely be merged!

- Want to add your own benchmarks? Like IOS, ANDROID, or MAC? Just post an issue and we can work together quickly!  
  - If you want to add a benchmark for a seperate operating system, and it hasn't been made yet, please add a <system-name>-benchmark.md and include a table of the results including pictures.
  - The range should include: A low count, the max 60fps count, and the dropping frames count
- Please also add system specifications to your benchmark




# _OLD_ Results
___
| Bunnies | AVG FPS | |
| ------ | ------ | ------ |
| 100 | 60 |  <img src="./readme.assets/bunnies100.png" width="450"> |
| 500 | 60 |  <img src="./readme.assets/bunnies500.png" width="450"> |
| 1000 | 60 | <img src="./readme.assets/bunnies1000.png" width="450"> |
| 2000 | 60 | <img src="./readme.assets/bunnies2000.png" width="450"> |
| 3000 | 60 | <img src="./readme.assets/bunnies3000.png" width="450"> |
| 3400 | 58 | <img src="./readme.assets/bunnies3400.png" width="450"> |
| 4000 | 49 | <img src="./readme.assets/bunnies4000.png" width="450"> |
#### *System Specs for this test:*
| spec | value |
| ---- | ---- |
| GPU | [NVIDIA GTX 960m](https://www.geforce.com/hardware/notebook-gpus/geforce-gtx-960m/specifications) |
| PROC | [Intel i7 6700HQ x64 @ **2.4GHz-3.50Ghz**](https://ark.intel.com/products/88967/Intel-Core-i7-6700HQ-Processor-6M-Cache-up-to-3_50-GHz) |
| RAM | 8GB  |
| OS | WIN10 64 |
