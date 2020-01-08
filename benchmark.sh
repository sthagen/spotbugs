#!/usr/bin/env bash

echo '# parallel, worker API, time [ms]'
for (( i = 0; i < 1000; i++ )); do
  start_ms=$(ruby -e 'puts (Time.now.to_f * 1000).to_i')
  ./gradlew --no-build-cache spotbugsMain > /dev/null
  if [ $? -eq 0 ]; then
    end_ms=$(ruby -e 'puts (Time.now.to_f * 1000).to_i')
    elapsed_ms=$((end_ms - start_ms))
    echo "false,false,${elapsed_ms}"
  fi
  sleep 1

  start_ms=$(ruby -e 'puts (Time.now.to_f * 1000).to_i')
  ./gradlew --no-build-cache --parallel spotbugsMain > /dev/null
  if [ $? -eq 0 ]; then
    end_ms=$(ruby -e 'puts (Time.now.to_f * 1000).to_i')
    elapsed_ms=$((end_ms - start_ms))
    echo "true,false,${elapsed_ms}"
  fi
  sleep 1

  start_ms=$(ruby -e 'puts (Time.now.to_f * 1000).to_i')
  ./gradlew --no-build-cache -Pcom.github.spotbugs.snom.worker=true spotbugsMain > /dev/null
  if [ $? -eq 0 ]; then
    end_ms=$(ruby -e 'puts (Time.now.to_f * 1000).to_i')
    elapsed_ms=$((end_ms - start_ms))
    echo "false,true,${elapsed_ms}"
  fi
  sleep 1

  start_ms=$(ruby -e 'puts (Time.now.to_f * 1000).to_i')
  ./gradlew --no-build-cache --parallel -Pcom.github.spotbugs.snom.worker=true spotbugsMain > /dev/null
  if [ $? -eq 0 ]; then
    end_ms=$(ruby -e 'puts (Time.now.to_f * 1000).to_i')
    elapsed_ms=$((end_ms - start_ms))
    echo "true,true,${elapsed_ms}"
  fi
  sleep 1
done
