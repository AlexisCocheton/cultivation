"""Run campaign regressions in an isolated Godot profile; fail on script errors."""
import json, os, subprocess, sys
from pathlib import Path
ROOT = Path(__file__).resolve().parent.parent
TESTS = ["test_input_localization", "test_card_effects_parity", "test_card_data_rules", "test_combat_parity", "test_encounter_engine", "test_audit_fixes", "test_reliability", "test_card_ways", "test_combat_ui", "test_ink_combat_ui", "test_team_hand", "test_team_guard_rules", "test_team_tricks", "test_team_battle", "test_recruitment", "test_story_route", "test_day7_territory", "test_day4_merchant", "test_spy_arrival", "test_orthodox", "test_deck_manhua", "test_jun_progression"]
def main():
    env = os.environ.copy()
    env["APPDATA"] = str(ROOT / "tools/regression-user")
    results = []
    for name in TESTS:
        try:
            process = subprocess.run([str(ROOT / "tools/godot/Godot_v4.4.1-stable_win64_console.exe"), "--headless", "--path", str(ROOT), "--script", f"tests/{name}.gd"], cwd=ROOT, env=env, capture_output=True, timeout=60)
            exit_code = process.returncode
            log = (process.stdout + process.stderr).decode("utf-8", "replace")
            status = "pass" if process.returncode == 0 and "SCRIPT ERROR" not in log and "ERROR:" not in log else "failure"
        except subprocess.TimeoutExpired as exc:
            log = ((exc.stdout or b"") + (exc.stderr or b"")).decode("utf-8", "replace")
            status = "timeout"
            exit_code = None
        results.append({"test": name, "status": status, "exit_code": exit_code, "output": log})
        print(name + ": " + status, flush=True)
        (ROOT / "tests/regression_results.json").write_text(json.dumps(results, ensure_ascii=False, indent=2), encoding="utf-8")
    return int(any(item["status"] != "pass" for item in results))
if __name__ == "__main__":
    sys.exit(main())


