# Aseprite Assets

This repo is a collection of Aseprite related assets:

## File Structure

### 📁 **canvas/**

- **16x9/** - Canvas templates for 16:9 aspect ratio
  - `160x90.aseprite` - Small 16:9 canvas (160x90 pixels)
  - `180x320.aseprite` - Portrait 16:9 canvas (180x320 pixels)
  - `320x180.aseprite` - Landscape 16:9 canvas (320x180 pixels)
  - `90x160.aseprite` - Portrait 16:9 canvas (90x160 pixels)

### 📁 **guides/**

- **panels/** - UI panel design guides and templates

  - `panels-16x16.aseprite` & `panels-16x16.png` - 16x16 panel templates
  - `panels-32x32.aseprite` & `panels-32x32.png` - 32x32 panel templates
  - `panels-32x48.aseprite` & `panels-32x48.png` - 32x48 panel templates
  - `panels-48x32.aseprite` & `panels-48x32.png` - 48x32 panel templates
  - `panels-various.aseprite` & `panels-various.png` - Various panel sizes
  - `README.md` - Documentation for panel guides

- **platformer/** - Platformer game development assets
  - **characters/silhouette/** - Character silhouette templates
    - `adventure-game-32x32.aseprite` - 32x32 adventure game character
    - `platformer-16x16.aseprite` - 16x16 platformer character
    - `platformer-32x32.aseprite` - 32x32 platformer character
  - **tiles/** - Tile design guides and templates
    - `godot-autotile-guide.aseprite` - Godot autotile implementation guide
    - `platformer-basic-tiles.aseprite` - Basic platformer tile set
    - `platformer-tiles-guide.aseprite` - Platformer tile design guide
    - `PlatformTileGuide.png` - Platformer tile guide reference

### 📁 **items/**

- **equipment/** - Weapons and armor assets
  - `WeaponsAndArmor.aseprite` & `WeaponsAndArmor.png` - Equipment sprites
- **food/** - Food and consumable items
  - `FruitAndVegetable.aseprite` & `FruitAndVegetable.png` - Food sprites
- **money/** - Currency and collectible items
  - `Coin.aseprite` - Basic coin sprite
  - `Diamond.aseprite` - Diamond gem sprite
  - `RoundCoin.aseprite` - Round coin variant

### 📁 **palette/**

- `EGA.aseprite` - EGA (Enhanced Graphics Adapter) color palette
- `Natural.aseprite` - Natural color palette
- `thanksgiving.png` - Thanksgiving-themed color palette

### 📁 **scenes/**

- **adventure-game/** - Adventure game scene assets
  - **EGA/** - EGA color palette scenes
    - `base-scene.aseprite` - Base adventure game scene template

### 📁 **scripts/**

- `Cel Opacity Wave.lua` - Lua script for cel opacity animation
- `Export Palette To Json.lua` - Lua script to export palettes as JSON
- `Export Tilemap.lua` - Lua script to export tilemaps

### 📁 **tilemaps/**

- **platformer/** - Platformer game tilemaps
  - `platformer-grass-dirt-tiles.aseprite` - Grass and dirt tile set
  - `platformer-tiles.aseprite` & `platformer-tiles.png` - Complete platformer tile set
- **topdown/** - Top-down game tilemaps
  - `topdown-tiles.aseprite` & `topdown-tiles.png` - Top-down perspective tiles

### 📁 **ui/**

- **Caramel Bubble/** - UI bubble design
  - `Caramel Bubble.aseprite` & `Caramel Bubble.png` - Caramel-themed bubble UI element

## Description

This repository contains a comprehensive collection of Aseprite assets organized for game development and pixel art creation. The assets include:

- **Canvas templates** for different aspect ratios and sizes
- **Design guides** for UI panels and platformer game elements
- **Game assets** including items, equipment, and characters
- **Color palettes** for different art styles and themes
- **Scene templates** for adventure games
- **Lua scripts** for automation and export functionality
- **Tilemaps** for both platformer and top-down games
- **UI elements** for interface design

All assets are provided in both Aseprite format (`.aseprite`) and PNG format for easy use in game engines and other applications.
