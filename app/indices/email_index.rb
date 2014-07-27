# coding: utf-8

ThinkingSphinx::Index.define :email, :with => :active_record do
  indexes :to
  indexes :from
  indexes :subject
  indexes :body
end
