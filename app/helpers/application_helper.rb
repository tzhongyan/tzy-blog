module ApplicationHelper
  def markdown(text)
    # TODO: Maybe parse it onto js for code print

    options = {
      fenced_code_blocks: true,
      strikethrough: true,
      prettify: true,
      hard_wrap: true,
      escape_html: true,
      filter_html: true,
      link_attributes: { rel: 'nofollow', target: "_blank" },
      space_after_headers: true
    }
    extensions = {
      superscript: true,
      tables: true,
      autolink: true
    }

    renderer = RCpet.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)
    markdown.render(text).html_safe
  end

  class RCpet < Redcarpet::Render::HTML
    # bootstrap style table
    def table(header, body)
      %(<div class="table table-responsive">
        <table class="table table-hover table-bordered">
        <thead>#{header}</thead>
        <tbody>#{body}</tbody>
        </table></div>)
    end

    # block code
    def block_code(code, lang)
      %(<pre><code class="#{lang} block-code">#{code}</code></pre>)
    end
  end
end
