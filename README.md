## Advent of code 2021

Solutions to the advent of code 2021 in a variety of languages/tools

### jq
Pipe the input data into relevant `jq/part-*` file e.g.
```bash
cat input.txt | jq/part-1
```

### OPA/Rego
Evaluate the part using `opa eval` e.g.:
```bash
opa eval part_1 --package aoc -d rego/policy.rego -f values -i input.txt
```
