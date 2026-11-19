"""Extract existing authored poses for the explicitly requested Forge comparison.

No generation, API calls, interpolation or replacement of production assets.
"""
from pathlib import Path
import hashlib
import json
from PIL import Image

ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / "tests/spriteforge"
SOURCE = ROOT / "assets/manhua_combat.png"
image = Image.open(SOURCE).convert("RGBA")
strip = image.crop((0, 0, image.width, round(image.height / 4)))
strip.save(OUT / "recruit-attack-source.png")
(OUT / "provenance.json").write_text(json.dumps({
    "source": "assets/manhua_combat.png",
    "source_sha256": hashlib.sha256(SOURCE.read_bytes()).hexdigest(),
    "art_source": "existing",
    "operation": "First row crop only; four original attack poses.",
    "forge_revision": "25203d03900b46b444bdd72a75768c33d1895ad6",
    "additional_generation": False,
    "paid_requests": 0,
    "cost_eur": 0,
    "original_duration_ms": [150, 100, 160, 150],
    "original_contact_ms": 250,
}, indent=2), encoding="utf-8")
print(f"Extracted {strip.size}; source unchanged.")
