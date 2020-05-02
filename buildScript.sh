#!/bin/sh

#  buildScript.sh
#  EvomoUnitySDK
#
#  Created by Jakob Wowy on 02.05.20.
#  Copyright © 2020 evomo. All rights reserved.

pod lib lint

git add -A && git commit -m "Release 0.0.1."
git tag '0.0.1'
git push --tags
