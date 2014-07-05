# coding: utf-8
class ErrorsController < ApplicationController
  def render_404
    render layout: false
  end
end
