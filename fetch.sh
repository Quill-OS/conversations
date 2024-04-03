#!/bin/bash
token=$(cat token)

# We don't clean media because we reuse resources. I HOPE this works that way
# rm -rf media/*

rm -rf html/*
cd html
discord-chat-exporter-plus-cli exportguild -t $token --media --reuse-media  --media-dir "../media" --include-threads "All" --guild 809205711778480158 --format "HtmlDark"
cd ../

rm -rf json/*
cd json
discord-chat-exporter-plus-cli exportguild -t $token --media --reuse-media --media-dir "../media" --include-threads "All" --guild 809205711778480158 --format "Json"
cd ../

rm -rf text/*
cd text
discord-chat-exporter-plus-cli exportguild -t $token --media --reuse-media --media-dir "../media" --include-threads "All" --guild 809205711778480158 --format "PlainText"
cd ../