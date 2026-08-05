#!/bin/bash
#
# Beach startup script for Snipe-IT
#
# Executed by the Beach PHP image on every instance start, provided that
# BEACH_APPLICATION_CUSTOM_STARTUP_SCRIPTS_ENABLE is set to "true".
#
# Note: the exit code of this script is not evaluated by Beach. A failing
# migration does NOT prevent the instance from starting up, so always check
# the instance log after a deployment.
#

set -o pipefail

cd /application || exit 1

echo "Snipe-IT: Running database migrations ..."
php artisan migrate --force --no-interaction

echo "Snipe-IT: Clearing configuration cache ..."
php artisan config:clear --no-interaction

echo "Snipe-IT: Startup completed."
