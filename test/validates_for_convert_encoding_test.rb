require 'test_helper'

class Book < ActiveRecord::Base
  validates_for_convert_encoding :from => 'utf-8', :to => 'cp932'
end

class Blog < ActiveRecord::Base
  validates_for_convert_encoding_of :title, :from => 'utf-8', :to => 'cp932'
end

class Cp932ValidationTest < ActiveSupport::TestCase
  test "columns_for_convert_encode に検証対象のカラムの情報が入っている" do
    assert Book.columns_for_convert_encode.keys - ["title", "content"] == []
    assert Blog.columns_for_convert_encode.keys - ["title"] == []
  end

  test "SJIS に存在する文字の保存に成功する" do
    assert Book.create(:title => 'テスト', :price => 100, :rate => 0.1), 'テスト'
    assert Book.create(:content => 'テスト', :price => 100, :rate => 0.1), 'テスト'
  end

  test "SJIS に存在しない文字の保存に失敗する" do
    book =  Book.new(:title => 'テスト♨テスト', :content => 'テスト', :price => 100, :rate => 0.1)
    assert book.valid? == false
    assert book.errors.size == 1
    assert book.errors["title"] == "invalid sequence for cp932 from utf-8"

    book =  Book.new(:title => 'テスト', :content => 'テスト♨テスト', :price => 100, :rate => 0.1)
    assert book.valid? == false
    assert book.errors.size == 1
    assert book.errors["content"] == "invalid sequence for cp932 from utf-8"

    book =  Book.new(:title => 'テスト♨テスト', :content => 'テスト♨テスト', :price => 100, :rate => 0.1)
    assert book.valid? == false
    assert book.errors.size == 2
    assert book.errors["title"] == "invalid sequence for cp932 from utf-8"
    assert book.errors["content"] == "invalid sequence for cp932 from utf-8"
  end

  test "特定のカラムだけバリデーション対象にする（正常ケース）" do
    blog = Blog.new(:title => 'テスト', :content => 'テスト')
    assert blog.valid? == true
    blog = Blog.new(:title => 'テスト', :content => 'テスト♨テスト')
    assert blog.valid? == true
  end

  test "特定のカラムだけバリデーション対象にする（エラーケース）" do
    blog = Blog.new(:title => 'テスト♨テスト', :content => 'テスト')
    assert blog.valid? == false
    assert blog.errors.size == 1
    assert blog.errors["title"] == "invalid sequence for cp932 from utf-8"
  end
end
