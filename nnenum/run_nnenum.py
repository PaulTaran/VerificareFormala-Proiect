from pathlib import Path
import subprocess
import time
import csv
import argparse

def run_tool(instances_path: str, script_path: str, benchmark_path: str) -> list[dict]:
    results: list[dict] = []
    output_dir = Path("output")
    output_dir.mkdir(parents=True, exist_ok=True)  
    with Path(instances_path).open("r") as f:
        reader = csv.reader(f)
        for idx, row in enumerate(reader):
            onnx, vnnlib, timeout = row
            start = time.perf_counter()
            output_file = output_dir / f"{idx}.txt"
            subprocess.call(
                [
                    "sh",
                    script_path,
                    "v1",
                    "tllverifybench",
                    f"{benchmark_path}/{onnx}",
                    f"{benchmark_path}/{vnnlib}",
                    str(output_file),
                    timeout,
                ]
            )
            end = time.perf_counter()
            results.append({
                'idx': idx,
                'duration': end - start
            })
    return results

def get_results(results: list[dict]) -> list[dict]:
    output_dir = Path("output")
    for result in results:
        try:
            with (output_dir / f'{result["idx"]}.txt').open('r') as f:
                result['result'] = f.readline()
        except FileNotFoundError:
            continue
    return results

def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-i", "--instances", required=True, help="instances.csv file to process."
    )
    parser.add_argument(
        "-s", "--script", required=True, help="Shell script to run the tool."
    )
    parser.add_argument(
        "-p",
        "--path_to_benchmark",
        required=True,
        help="Path to the benchmark containing the 'onnx' and 'vnnlib' folders.",
    )
    args = parser.parse_args()
    results = run_tool(args.instances, args.script, args.path_to_benchmark)
    results = get_results(results)
    print(results)

if __name__ == "__main__":
    main()

