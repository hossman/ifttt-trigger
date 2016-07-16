# ifttt-trigger

Trigger ifttt recipes easily from command line

https://github.com/hossman/ifttt-trigger

## Pre-Reqs

* You must have perl installed, along with the LWP::UserAgent & JSON::XS packages
* Create an IFTTT account if you don't already have one: http://ifttt.com/
* Active the Maker channel: https://ifttt.com/maker
  * Make note of the "key" assigned to you
  * In the Usage examples below we'll assume it's YOUR_LONG_KEY
* Create a Recipe that uses the Maker channel's "Recieve a web request" trigger
  * Chose an "Event Name" and make note of it
  * In the Usage examples below we'll assume it's EVENT_NAME

## Basic Usage

```bash
$ ifttt-trigger.pl YOUR_LONG_KEY EVENT_NAME EVENT_NAME "This string will be the 'value1' input to your IFTTT Action"
```

```bash
$ ifttt-trigger.pl YOUR_LONG_KEY EVENT_NAME EVENT_NAME "You may have" "at most three" "input values"
```

```bash
# There's no requirement that any input values be specified if don't need them in your recipe
$ ifttt-trigger.pl YOUR_LONG_KEY EVENT_NAME EVENT_NAME
```

## Suggested Usage

If you have the "IF" App installed on your phone, and an IFTTT recipe that sends notifications to your phone using the message of `{{Value1}}` then you can add something like this to your `.bashrc`:

```bash
# send alerts to phone via ifttt, or via notify-send if it fails for some reason
function phone-alert {
    output=$($HOME/code/ifttt-trigger/ifttt-trigger.pl YOUR_LONG_KEY EVENT_NAME "$*");
    if [ "$?" -ne 0 ]; then
	notify-send -i computer-fail-symbolic "$output (phone alert failed)"
    fi
}
```

And then use it to make an alert pop up on your phone you when some long running commands finish:

```bash
$ ant run-really-long-tests; phone-alert "Tests are done"
```

Or to send diff messages based on the results:

```bash
$ ant run-really-long-tests && phone-alert "Tests are done" || phone-alert "Tests failed"
```

## Error Handling

If there is an error of any kind:

* Detailed failure information is written to STDERR
* The input arguments are written to STDOUT
* A Non-0 exit status is returned.

As shown in the "Suggested Usage" above, this allows you to chain this scipt with other fall back mechanisms for sending alerting you.

## License

Copyright 2016 Chris Hostetter

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
