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

    BITRISE_APP_SLUG=d3d618764c9a906d
    BITRISE_PERSONAL_ACCESS_TOKEN=AsREb-FpCM4IBy1yJ3zgKY9q-tAoPqdwv-9cQwucgNjeXjbzxwHXfFAxLVkVls2C00h5iEUPWphe11xsnlmqhg

    running_builds=$(curl -s "https://api.bitrise.io/v0.1/apps/${BITRISE_APP_SLUG}/builds?status=0" -H "accept: application/json" -H "Authorization: $BITRISE_PERSONAL_ACCESS_TOKEN" | jq ".data | .[] | .machine_type_id" | grep -c "g2.$core_count" || true)
    

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