#!/usr/bin/env bash

# Copyright (c) 2016 Clément Pit-Claudel
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE

: ${BASEDIR:=/vagrant}
export LOGFILE="$BASEDIR/provision.log"
export DEBIAN_FRONTEND=noninteractive

echo "" > $LOGFILE
echo "* Starting; see ${LOGFILE} for details."

echo ""
echo '*********************************'
echo '***  Installing dependencies  ***'
echo '*********************************'

echo '* apt-get update'
sudo add-apt-repository -y ppa:hvr/ghc >> $LOGFILE 2>&1
sudo add-apt-repository -y ppa:ubuntu-elisp/ppa >> $LOGFILE 2>&1
sudo apt-get -qq update >> $LOGFILE 2>&1
echo '* apt-get install (VBox extensions)'
sudo apt-get -qq install virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11 >> $LOGFILE 2>&1
echo '* apt-get install (Dependencies)'
sudo apt-get -qq install git emacs-snapshot mercurial ghc-7.10.3 >> $LOGFILE 2>&1

echo 'export TERM=xterm-256color' >> ~/.profile

echo ""
echo '*********************************'
echo '*** Downloading and building  ***'
echo '*********************************'

echo '* wget z3'
wget --quiet -O /tmp/z3.zip https://github.com/Z3Prover/z3/releases/download/z3-4.4.0/z3-4.4.0-x64-ubuntu-14.04.zip >> $LOGFILE

echo '* hg clone synquid'
hg clone --quiet https://bitbucket.org/nadiapolikarpova/synquid synquid >> $LOGFILE

echo '* git clone synquid-mode'
git clone --quiet https://github.com/cpitclaudel/synquid-mode/ ~/.emacs.d/lisp/synquid-mode/ >> $LOGFILE

echo '* setup (z3)'
unzip -o /tmp/z3.zip -d ~/MSR >> $LOGFILE
mv -T ~/MSR/z3-4.4.0-x64-ubuntu-14.04 ~/MSR/z3 >> $LOGFILE

echo '* setup (Synquid)'
cd ~/synquid
cabal install >> $LOGFILE

echo ""
echo '*********************************'
echo '***      Setting up Emacs     ***'
echo '*********************************'

echo '* font setup'
mkdir -p ~/.fonts >> $LOGFILE
wget --quiet -O ~/.fonts/symbola-monospace.ttf https://raw.githubusercontent.com/cpitclaudel/monospacifier/master/fonts/Symbola_monospacified_for_UbuntuMono.ttf >> $LOGFILE
wget --quiet -O /tmp/ubuntu-fonts.zip http://font.ubuntu.com/download/ubuntu-font-family-0.83.zip >> $LOGFILE
unzip -o /tmp/ubuntu-fonts.zip -d ~/.fonts/ >> $LOGFILE

echo '* Emacs configuration'
mkdir -p ~/.emacs.d/
cp "$BASEDIR/init.el" ~/.emacs.d/init.el

echo '* package install'
emacs --batch --load ~/.emacs.d/init.el \
      --eval "(package-refresh-contents)" \
      --eval "(package-install 'company)" \
      --eval "(package-install 'company-math)" \
      >> $LOGFILE 2>&1

echo '* PATH adjustments'
echo 'export PATH="$PATH:$HOME/MSR/z3/bin/:$HOME/synquid/"' >> ~/.profile

echo ""
echo '*********************************'
echo '***       Setup complete      ***'
echo '*********************************'

echo ""
echo 'Log into the VM using ‘vagrant ssh’. To start using Synquid, just open a ‘.sq’ file in Emacs.'
