#!/usr/bin/env bash


printf "Name your build file : "
read name_build

printf "Message to sign 🖊 : "
read message

pipeline="Nargo" # Use nargo for now until WASM is bumped to 5.0.0
# echo "How do you wish to compile?"
# select pipeline in "Nargo" "WASM"; do
#     case $pipeline in
#     Nargo)
#         pipeline="Nargo"
#         break
#         ;;
#     WASM)
#         pipeline="WASM"
#         break
#         ;;
#     esac
# done

cd circuits/

printf "\n💻 nargo check 💻\n\n"
nargo check

printf "\n💻 nargo compile 💻\n\n"
nargo compile ${name_build}

printf "\n💻 generateSigProof script 💻\n\n"
npx ts-node ../node-scripts/generateProof.ts ${pipeline} Nargo ${message}

if [ $pipeline = "Nargo" ]; then
    printf "\n💻 nargo prove 💻\n\n"
    nargo prove ${name_build}

    printf "\n💻 nargo verify 💻\n\n"
    nargo verify ${name_build}
fi
