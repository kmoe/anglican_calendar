#!/usr/bin/env bash
# reset
export BASE=$(git rev-parse --show-toplevel)
if [[ "$BASE" == "" ]]; then
    echo "need to be in the git repository"
    exit 1
fi
cd $BASE
echo "formatting..."
cargo fmt --all
echo "building..."
cargo build
RES=$?
if [[ $RES != 0 ]]; then
    echo "build result" $RES
    exit 2
fi
echo "testing..."
cargo test

for D in edit_data reports; do
    echo "building" $D
    if [[ ! -d $BASE/$SD ]]; then
        echo $SD "does not exist to be built"
    fi
    cd $BASE/$D
    cargo fmt
    cargo build
    RES=$?
    if [[ $RES != 0 ]]; then
        echo "build result" $RES
        exit 3
    fi
done

echo "build complete"
