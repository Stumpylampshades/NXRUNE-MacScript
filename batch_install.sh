#!/usr/bin/env bash

read -r -p "Please enter DELTARUNE's install path: " gamePath

fail()
{
  echo "[ERROR] $1"
  exit 1
}

patch_file() {
  local name="$1"
  local subDir="$2"
  local patch="$3"
  
  local source
  if [[ "$subDir" == "." ]]; then
	source="$gamePath"
  else
	source="$gamePath/$subDir"
  fi

  [[ -f "$source/game.ios" ]] || fail "Source file '$source/game.ios' not found."
  [[ -f "$patch" ]] || fail "Patch file '$patch' not found."

  echo "Patching $name..."
  if ! ./UTMTMacCLI/UndertaleModCli load "$source/game.ios" -s "$patch" -o "$source/game_patched.ios"; then
    echo "Failed to patch $name."
    return 1
  fi
  
  rm -f "$source/game.ios"
  mv "$source/game_patched.ios" "$source/game.ios"
}

SCRIPTHOME="$( cd "$(dirname "$0")" ; pwd -P )"
cd $SCRIPTHOME
#retrieve actual directory of script (where csx files and border images should be) and cd to there

[[ -d "$gamePath" ]] || gamePath=${gamePath//\'/}
#strip out the single quotes that will almost certainly show up when getting the path to the game in Finder. (Default Steam path includes space in "~/Library/Application Support")

[[ -d "$gamePath" ]] || fail "Path $gamePath does not exist."

if [[ $gamePath == */"DELTARUNE.app" ]]; then
    gamePath="$gamePath/Contents/Resources"
fi
#typical Mac user probably doesn't realize that the true game directory is inside the .app package, so this updates the $gamePath variable to be the actual game directory if the user passes the .app path.
patch_file "Chapter Select" "." NXRUNE.csx
patch_file "Chapter 1" "chapter1_mac" NXRUNE_CH1.csx
patch_file "Chapter 2" "chapter2_mac" NXRUNE_CH2.csx
patch_file "Chapter 3" "chapter3_mac" NXRUNE_CH3.csx
patch_file "Chapter 4" "chapter4_mac" NXRUNE_CH4.csx
patch_file "Chapter 5" "chapter5_mac" NXRUNE_CH5.csx

echo "All done! :3"
