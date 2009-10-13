ConvertEncodingValidation
===============

This plugin provides a validation for convert encoding.

任意の文字エンコーディングに変換できるかどうかを検証するための機能をモデルに提供します。

Example
=======

    class Book < ActiveRecord::Base
      validates_for_convert_encoding :from => 'utf-8', :to => 'cp932'
    end

or

    class Blog < ActiveRecord::Base
      validates_for_convert_encoding_of :title, :from => 'utf-8', :to => 'cp932'
    end

Copyright (c) 2009 jugyo, released under the MIT license
