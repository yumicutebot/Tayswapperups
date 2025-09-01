#!/bin/bash

cd "$(pwd)/TaysSwapper/Assets.xcassets"

# Remove the broken ClassIcons.imageset
echo "Removing broken ClassIcons.imageset..."
rm -rf ClassIcons.imageset

# Create individual image sets
echo "Creating individual image sets..."
mkdir -p DeathKnightIcon.imageset DemonHunterIcon.imageset DruidIcon.imageset EvokerIcon.imageset HunterIcon.imageset MageIcon.imageset MonkIcon.imageset PaladinIcon.imageset PriestIcon.imageset RogueIcon.imageset ShamanIcon.imageset WarlockIcon.imageset WarriorIcon.imageset

# Create Contents.json for Death Knight
cat > DeathKnightIcon.imageset/Contents.json << 'INNER_EOF'
{
  "images" : [
    {
      "filename" : "death_knight.png",
      "idiom" : "universal"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
INNER_EOF

# Copy the image files to their new locations
echo "Moving image files..."
find . -name "death_knight.png" -exec cp {} DeathKnightIcon.imageset/ \;
find . -name "demon_hunter.png" -exec cp {} DemonHunterIcon.imageset/ \;
find . -name "druid.png" -exec cp {} DruidIcon.imageset/ \;
find . -name "evoker.png" -exec cp {} EvokerIcon.imageset/ \;
find . -name "hunter.png" -exec cp {} HunterIcon.imageset/ \;
find . -name "mage.png" -exec cp {} MageIcon.imageset/ \;
find . -name "monk.png" -exec cp {} MonkIcon.imageset/ \;
find . -name "paladin.png" -exec cp {} PaladinIcon.imageset/ \;
find . -name "priest.png" -exec cp {} PriestIcon.imageset/ \;
find . -name "rogue.png" -exec cp {} RogueIcon.imageset/ \;
find . -name "shaman.png" -exec cp {} ShamanIcon.imageset/ \;
find . -name "warlock.png" -exec cp {} WarlockIcon.imageset/ \;
find . -name "warrior.png" -exec cp {} WarriorIcon.imageset/ \;

echo "Icon setup complete!"
