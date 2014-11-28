#!/bin/sh

[ -e ~/.rails-templates ] && mv -v ~/.rails-templates ~/.rails-templates.bak
ln -svf $PWD ~/.rails-templates
ln -svf $PWD/railsrc ~/.railsrc
