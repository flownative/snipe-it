#!/bin/bash
#
# Beach cron script for Snipe-IT
#
# Executed by the Beach PHP image once per hour at minute 15, provided that
# cron jobs are enabled for this instance (BEACH_CRON_ENABLE).
#
# Snipe-IT registers its scheduled tasks as ->daily() and ->weekly(), which
# Laravel evaluates against minute 00. Running "php artisan schedule:run" here
# would therefore never trigger anything, so the commands are invoked directly.
#

cd /application || exit 1

CURRENT_HOUR=$(date +"%H")

# Notification mails: expiring licenses and warranties, assets due for check-in
# and upcoming audits. Recipient and lead time are configured in Snipe-IT under
# Settings > Alerts.
if [ "${CURRENT_HOUR}" == "06" ] ; then
    echo "Snipe-IT: Sending inventory and expiration alerts ..."
    php artisan snipeit:inventory-alerts --no-interaction
    php artisan snipeit:expiring-alerts --no-interaction
    php artisan snipeit:expected-checkin --no-interaction
    php artisan snipeit:upcoming-audits --no-interaction
fi

# Housekeeping: remove expired password reset tokens.
php artisan auth:clear-resets --no-interaction

# Note: "snipeit:backup" is deliberately not run here. Beach backs up the
# database, and Snipe-IT would write its dumps into storage/, which is not
# persistent on Beach.
