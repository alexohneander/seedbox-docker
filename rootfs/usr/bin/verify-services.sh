#!/usr/bin/env bash

# Restarting Services if dead
systemctl is-active --quiet rtorrent.service || systemctl restart rtorrent.service
systemctl is-active --quiet flood.service || systemctl restart flood.service