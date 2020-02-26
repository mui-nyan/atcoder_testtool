#!/bin/bash

SRC_FILE="$1"
DATA_FILE="$2"

INPUT=""
EXPECT=""
MODE="IN"
FIRST=1

cat "$DATA_FILE" | tr -d "\r" | while read LINE || [ -n "${LINE}" ]; do
    # echo "LINE: $LINE MODE:$MODE"

    if [ "$LINE" = "---" ]; then
        # echo "change to OUT mode."
        MODE="OUT"
        FIRST=1
        continue
    fi

    if [ "$MODE" = "IN" ]; then
        # echo "INPUT add $LINE"
        if [ "$FIRST" -eq 1 ]; then
            INPUT="$LINE"
            FIRST=0
        else
            INPUT="${INPUT}\n${LINE}"
        fi
    else
        if [ "$LINE" = "===" ]; then
            START=$(date +%s%3N)
            OUTPUT=$(echo -e "$INPUT" | python "$SRC_FILE" | tr -d "\r" 2>/dev/null ); STATUS=$?
            DURATION=$(( $(date +%s%3N) - $START ))
            if [ "$STATUS" -ne 0 ]; then
                echo -e "Runtime Error on Input:\n$INPUT"
            elif [ "$DURATION" -ge 2000 ]; then
                echo TLE ${DURATION}ms Expect: $EXPECT Actual: $OUTPUT
            elif [ "$OUTPUT" = "$EXPECT" ]; then
                echo AC ${DURATION}ms Expect: $EXPECT Actual: $OUTPUT
            else
                echo WA ${DURATION}ms Expect: $EXPECT Actual: $OUTPUT
            fi
            INPUT=""
            EXPECT=""
            MODE="IN"
            FIRST=1
        else
            # echo "EXPECT add $LINE"
            if [ "$FIRST" -eq 1 ]; then
                EXPECT="$LINE"
                FIRST=0
            else
                EXPECT=$(echo -e "${EXPECT}\n${LINE}")
            fi
        fi
    fi
done