#!/bin/bash

#  Copyright (C) 2020 Mik BRY                                         
#  mbry@miklabs.com
# LICENCE MIT
# See LICENSE.md

# The Docker backend entrypoint

if [ -n "$PORT" ]; then
  # Special case for Heroku
  export APP_BACKEND_PORT="$PORT"
fi

exec "$@"