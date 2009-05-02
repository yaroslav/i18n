# encoding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class I18nSimpleBackendPluralizeTest < Test::Unit::TestCase
  include I18nSimpleBackendTestSetup

  def test_pluralize_given_nil_returns_the_given_entry
    entry = {:one => 'bar', :other => 'bars'}
    assert_equal entry, @backend.send(:pluralize, nil, entry, nil)
  end

  def test_pluralize_given_0_returns_zero_string_if_zero_key_given
    assert_equal 'zero', @backend.send(:pluralize, nil, {:zero => 'zero', :one => 'bar', :other => 'bars'}, 0)
  end

  def test_pluralize_given_0_returns_plural_string_if_no_zero_key_given
    assert_equal 'bars', @backend.send(:pluralize, nil, {:one => 'bar', :other => 'bars'}, 0)
  end

  def test_pluralize_given_1_returns_singular_string
    assert_equal 'bar', @backend.send(:pluralize, nil, {:one => 'bar', :other => 'bars'}, 1)
  end

  def test_pluralize_given_2_returns_plural_string
    assert_equal 'bars', @backend.send(:pluralize, nil, {:one => 'bar', :other => 'bars'}, 2)
  end

  def test_pluralize_given_3_returns_plural_string
    assert_equal 'bars', @backend.send(:pluralize, nil, {:one => 'bar', :other => 'bars'}, 3)
  end
  
  def test_pluralize_uses_lambda_supplied_rule
    @backend.store_translations 'ru', {
      :pluralize => lambda { |n| 
        modulo10 = n.modulo(10)
        modulo100 = n.modulo(100)

        if modulo10 == 1 && modulo100 != 11
          :one
        elsif (modulo10 == 2 || modulo10 == 3 || modulo10 == 4) && !(modulo100 == 12 || modulo100 == 13 || modulo100 == 14)
          :few
        elsif modulo10 == 0 || (modulo10 == 5 || modulo10 == 6 || modulo10 == 7 || modulo10 == 8 || modulo10 == 9) || (modulo100 == 11 || modulo100 == 12 || modulo100 == 13 || modulo100 == 14)
          :many
        else
          :other
        end
      }
    }
    
    entry = {:one => "рубин", :few => "рубина", :many => "рубинов", :other => "рубина"}
    
    assert_equal 'рубин', @backend.send(:pluralize, 'ru', entry, 1)
    assert_equal 'рубина', @backend.send(:pluralize, 'ru', entry, 2)
    assert_equal 'рубинов', @backend.send(:pluralize, 'ru', entry, 9)
    assert_equal 'рубина', @backend.send(:pluralize, 'ru', entry, 3.14)
  end

  def test_interpolate_given_incomplete_pluralization_data_raises_invalid_pluralization_data
    assert_raises(I18n::InvalidPluralizationData){ @backend.send(:pluralize, nil, {:one => 'bar'}, 2) }
  end

  # def test_interpolate_given_a_string_raises_invalid_pluralization_data
  #   assert_raises(I18n::InvalidPluralizationData){ @backend.send(:pluralize, nil, 'bar', 2) }
  # end
  #
  # def test_interpolate_given_an_array_raises_invalid_pluralization_data
  #   assert_raises(I18n::InvalidPluralizationData){ @backend.send(:pluralize, nil, ['bar'], 2) }
  # end
end

