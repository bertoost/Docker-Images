#!/bin/bash

options=$(ls -1 /usr/local/lib/php/extensions/no-debug-non-zts-20170718| \

    grep --invert-match xdebug| \

    # remove problematic extensions
    egrep --invert-match 'wddx|pgsql|iconv|mbstring|opcache|blackfire|pdo\.so|sodium\.a'| \

    sed --expression 's/\(.*\)/ --define extension=\1/'| \

    # join everything together back in one big line
    tr --delete '\n'
)

# build the final command line
/usr/local/bin/php --no-php-ini -d date.timezone=${PHP_DATE_TIMEZONE} -d memory_limit=-1 -d sendmail_path="/usr/sbin/ssmtp -t" $options $*