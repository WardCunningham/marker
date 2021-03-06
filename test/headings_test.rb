require File.expand_path( File.dirname( __FILE__ ) + '/test_helper' )
require 'marker'

class HeadingTest < Test::Unit::TestCase

  def test_level_one
    text = "= Level 1 ="
    markup = Marker.parse text

    assert_match("<h1>Level 1</h1>", markup.to_html)
  end

  def test_level_two
    text = "== Level 2 =="
    markup = Marker.parse text

    assert_match("<h2>Level 2</h2>", markup.to_html)
  end

  def test_level_three
    text = "=== Level 3 ==="
    markup = Marker.parse text

    assert_match("<h3>Level 3</h3>", markup.to_html)
  end

  def test_level_four
    text = "==== Level 4 ===="
    markup = Marker.parse text

    assert_match("<h4>Level 4</h4>", markup.to_html)
  end

  def test_level_five
    text = "===== Level 5 ====="
    markup = Marker.parse text

    assert_match("<h5>Level 5</h5>", markup.to_html)
  end

  def test_level_six
    text = "====== Level 6 ======"
    markup = Marker.parse text

    assert_match("<h6>Level 6</h6>", markup.to_html)
  end

  def test_unbalanced_delimiters
    # this behavior should match MediaWiki
    text = "=== Level 2 =="
    markup = Marker.parse text
    assert_match("<h2>= Level 2</h2>", markup.to_html)

    text = "== Level 2 ==="
    markup = Marker.parse text
    assert_match("<h2>Level 2 =</h2>", markup.to_html)
  end

  def test_containing_equals
    text = "== Level = 2 =="
    markup = Marker.parse text

    assert_match("<h2>Level = 2</h2>", markup.to_html)
  end

  def test_trailing_text
    # headings must be alone on a line or else are treated as text; this
    # behavior matches MediaWiki
    #
    # should this be changed to work like horizontal rules?
    text = "== Level 2 == trailing text"
    markup = Marker.parse text

    assert_match("<p>== Level 2 == trailing text</p>", markup.to_html)
  end

end
