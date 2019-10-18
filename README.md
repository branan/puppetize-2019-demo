# Puppetize 2019 Plans Demo

This is both a Bolt project and a Vagrant project, and can be used to
reproduce my Puppetize 2019 Plans in PE Demo environment.

## Prerequisites

* Vagrant, with Virtualbox. Other providers will require updates to the `Vagrantfile`
* Bolt
* A Puppet Enterprise installer tarball, unpacked into `puppet-enterprise` instead of its normal versioned directory

## Setup

1. `bolt puppetfile install`
2. `./run.sh`

## The Console

There are two users in the console.

1. `admin`
2. `someone_else`

Both have the password "A Password!"

## Running the demo

See `outline.org`

## Resetting the environment

The demo involves making a couple of changes to the environment.

1. The `Another Team` role has a permission added to it
2. The version of apache is updated on all nodes.

`bolt plan run demo::setup` will reset apache on a random subset of
the nodes. `bolt plan run demo::setup allow_none=true` will
additionally make some of the nodes have no apache installed, to make
the output more interesting.

There is no automation to reset the console permission. Just remove it
yourself :)