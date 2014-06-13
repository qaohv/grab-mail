#coding: utf-8
class Dashboard::ApplicationController < ApplicationController
  before_filter :authenticate_user!
end
