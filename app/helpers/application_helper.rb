module ApplicationHelper
  # ページごとの完全なタイトルを返します。
  def full_title(page_title)
    base_title = "BIGBAG Store"
    if page_title.blank?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end
end
