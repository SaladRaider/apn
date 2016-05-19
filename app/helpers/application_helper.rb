module ApplicationHelper
	def markdown(text)
		options = {
			filter_html:         true,
			hard_wrap:           true, 
			prettify:            true,
			link_attributes:     { rel: 'nofollow', target: "_blank" },
			space_after_headers: true, 
			fenced_code_blocks:  true
		}

		extensions = {
			autolink:                     true,
			underline:                    true,
			superscript:                  true,
			no_intra_emphasis:            true,
			strikethrough:                true,
			highlight:                    true,
			quote:                        true,
			disable_indented_code_blocks: true
		}

		renderer = Redcarpet::Render::HTML.new(options)
		markdown = Redcarpet::Markdown.new(renderer, extensions)

		markdown.render(text).html_safe
	end
end
