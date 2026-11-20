extends Node
# App-lifetime owner: plain data only, released with the SceneTree.
# Avoid static script caches retained by Godot 4.4 during shutdown.
var catalogs: Dictionary = {}
var definitions: Dictionary = {}
var dialogues: Dictionary = {}
var recruitment: Dictionary = {}
