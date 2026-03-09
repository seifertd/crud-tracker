require 'will_paginate/view_helpers/action_view'

class ::Bootstrap5Renderer < WillPaginate::ActionView::LinkRenderer
  protected

  def page_number(page)
    if page == current_page
      tag(:li, tag(:span, page, class: 'page-link'), class: 'page-item active')
    else
      tag(:li, link(page, page, rel: rel_value(page)), class: 'page-item')
    end
  end

  def gap
    tag(:li, tag(:span, '&hellip;'.html_safe, class: 'page-link'), class: 'page-item disabled')
  end

  def previous_or_next_page(page, text, classname, aria_label = nil)
    if page
      tag(:li, link(text, page, class: classname), class: 'page-item')
    else
      tag(:li, tag(:span, text, class: 'page-link'), class: 'page-item disabled')
    end
  end

  def html_container(html)
    tag(:nav, tag(:ul, html, class: 'pagination'), aria: { label: 'Page navigation' })
  end

  def link(text, target, attributes = {})
    attributes[:class] = [attributes[:class], 'page-link'].compact.join(' ')
    super(text, target, attributes)
  end
end

WillPaginate::ViewHelpers.pagination_options[:inner_window] = 2
WillPaginate::ViewHelpers.pagination_options[:outer_window] = 1
