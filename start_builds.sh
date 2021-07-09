#!/usr/bin/env bash
# fail if any commands fails
set -e
# debug log
set -x


core_count=$1

end=$((SECONDS+24*60*60))

while [ $SECONDS -lt $end ]; do
    echo "*****"

    echo "Timeout: $SECONDS elapsed out of $end allotted "

    running_builds=$(curl -s "https://api.bitrise.io/v0.1/apps/${BITRISE_APP_SLUG}/builds?status=0" -H "accept: application/json" -H "Authorization: $BITRISE_PERSONAL_ACCESS_TOKEN" | jq ".data | .[] | .machine_type_id" | grep -c -q "g2.$core_count")
    

    if [[ "$running_builds" -gt '0' ]]; then
    echo "There are still running builds. Not starting more"
    sleep 30
    continue
    fi

    echo "Starting builds" 

    for workflow_suffix in xcode13.0-6_sims xcode12.5-6_sims xcode12.4-6_sims xcode12.3-6_sims xcode12.2-6_sims xcode12.1-6_sims xcode12.0-6_sims xcode11.7-6_sims
    do
    curl https://app.bitrise.io/app/${BITRISE_APP_SLUG}/build/start.json --data "{\"hook_info\":{\"type\":\"bitrise\",\"build_trigger_token\":\"${BUILD_TRIGGER_TOKEN}\"},\"build_params\":{\"branch\":\"many_ui_tests\",\"workflow_id\":\"clone_test-gen2-${core_count}_core-$workflow_suffix\"},\"triggered_by\":\"curl\"}"
    sleep 15
    done
done