# Canuby

[![GitHub version](https://badge.fury.io/gh/SuperSandro2000%2Fcanuby.svg)](https://badge.fury.io/gh/SuperSandro2000%2Fcanuby)
[![Rubygems Version](https://badge.fury.io/rb/canuby.svg)](https://badge.fury.io/rb/canuby)
[![Travis Build Status](https://travis-ci.org/SuperSandro2000/canuby.svg?branch=master)](https://travis-ci.org/SuperSandro2000/canuby)
[![Appveyor Build status](https://ci.appveyor.com/api/projects/status/6y2963auej1de2ec?svg=true)](https://ci.appveyor.com/project/SuperSandro2000/canuby)

[![CodeFactor](https://www.codefactor.io/repository/github/SuperSandro2000/canuby/badge)](https://www.codefactor.io/repository/github/SuperSandro2000/canuby)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/352928d800dc41eaad0a5f8b030132e8)](https://www.codacy.com/app/SuperSandro2000/canuby?utm_source=github.com&utm_medium=referral&utm_content=SuperSandro2000/canuby&utm_campaign=Badge_Grade)
[![AwesomeCode Status](https://awesomecode.io/projects/b8fed95d-1b9c-47a3-96b1-437a2a6ef5ea/status)](https://awesomecode.io/projects/91)

WIP

## How to run

* ``gem install canuby``
* ``canuby``


## Version scheme

Canuby uses this ``MAJOR.MINOR.PATCH`` version scheme.
It is based of https://semver.org/ version scheme.


## Contributing

#### How to run from source

Run these command inside your clone. On Windows it may be necessary to use an elevated command prompt to install all gems correctly.

* ``gem install bundler``
* ``bundle install``
* ``rake -f bin\canuby`` or ``rake thirdparty``


#### Code Style

* This projects uses rubocop. Get it with ``gem install rubocop`` and then run ``rubocop`` inside the git repo. PR's without rubocop applied are not being merged.

  Rubocop Style Reference: https://rubocop.readthedocs.io/en/latest/cops_style/

* Fasterer is a tool that will suggest speed improvements for your ruby code. It is highly recommended to use on bigger changes to keep the Canuby code fast. Get it with ``gem install fasterer`` and then run ``fasterer`` inside the git repo to get the code flash fast.


#### Testing

To run the Canuby tests use ``rake test`` in the root directory. You may pass arguments ``rake test TESTOPTS='--profile'``.


#### Documenting

Canuby uses rdoc to generate the docs. They are available here [https://canuby.readthedocs.io/](https://supersandro2000.github.io/canuby/). To update the documentation run ``rake rerdoc``.


#### Usefull Links

* Ruby regular expression editor: http://rubular.com/
