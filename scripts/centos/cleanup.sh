#!/usr/bin/env bash

yum clean all

dd if=/dev/zero of=/filljunk bs=1M
rm -f /filljunk
sync

rm -f ~/.bash_history
