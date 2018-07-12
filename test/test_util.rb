# frozen_string_literal: true

# Copyright (C) 2018 Sandro Jäckel.  All rights reserved.
#
# This file is part of Canuby.
#
# Canuby is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Canuby is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Canuby.  If not, see <http://www.gnu.org/licenses/>.
require 'test_helper'

# require "canuby/argparser"
# require "canuby/util"

class CanubyTest < Minitest::Test
  def test_version
    refute_nil ::Canuby::VERSION
  end

  def test_logger
    # $options = ArgParser.parse(ARGV)

    assert_output('') { logger.debug('This is an debug log.') }
    assert_output('') { logger.info('This is an info log.') }
    assert_output(/#{timestamp_regex('magenta')} \e\[0;31;49mWARN\e\[0m  \(\): warn log./) { logger.warn('warn log.') }
    assert_output(/#{timestamp_regex('red')}\e\[0;31;49m ERROR \(\): error log.\e\[0m/) { logger.error('error log.') }

    logger.level = Logger::DEBUG
    assert_output(/#{timestamp_regex('magenta')} \e\[0;36;49mDEBUG\e\[0m \(\): debug log./) { logger.debug('debug log.') }
    logger.level = Logger::INFO
    assert_output(/#{timestamp_regex('magenta')} \e\[0;33;49mINFO\e\[0m  \(\): \e\[0;32;49minfo log.\e\[0m/) { logger.info('info log.') }
    logger.level = Logger::WARN
  end
end
