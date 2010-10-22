module ApplicationHelper

  def block_to_partial(partial_name, options = {}, &block)
    options.merge!(:body => (block_given? ? capture(&block) : ""))
    render(:partial => partial_name, :locals => options).html_safe
  end

  def block(options = {}, &block)
    block_to_partial('common/block', options, &block)
  end

  def block_head(title, options = {}, &block)
    block_to_partial('common/block_head', options.merge!(:title => title), &block)
  end

  def block_content(options = {}, &block)
    block_to_partial('common/block_content', options, &block)
  end

  def message(type, options = {}, &block)
    block_to_partial('common/message', options.merge!(:type => type.to_s), &block)
  end

  def snippet(thought, wordcount = 6)
    thought.split[0..(wordcount-1)].join(" ") +(thought.split.size > wordcount ? "..." : "")
  end

  def sanitize(text)
    Sanitize.clean(text, :elements => [])
  end

  def time_distance(date)
    if date < Date.today
      distance_of_time_in_words(Time.now, date) + " ago"
    else
      "in " + distance_of_time_in_words(Time.now, date)
    end
  end

end
