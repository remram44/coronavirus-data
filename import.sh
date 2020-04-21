#!/bin/sh

set -eu

git fetch -p origin

# Write header
ORIG_HEADER="MODZCTA,Positive,Total,zcta_cum.perc_pos"
echo "date,${ORIG_HEADER}"

# Loop on the commits to tests-by-zcta.csv
git log --reverse --format="%H %aI" origin/master -- tests-by-zcta.csv | while read commit date; do
    echo "Importing ${commit}" >&2
    # Write the file, without the header, with date prepended, to the output
    if [ "${commit}" = "097cbd70aa00eb635b17b177bc4546b2fce21895" ]; then
        # This commit is missing a field
        git show ${commit}:tests-by-zcta.csv | tail -n +2 | (while read l; do echo "${date},${l},"; done)
    else
        git show ${commit}:tests-by-zcta.csv | tail -n +2 | (while read l; do echo "${date},${l}"; done)
    fi
done
