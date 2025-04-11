module Cabins
  class ManageService
    def initialize(cabin = nil, params = {})
      @cabin = cabin || Cabin.new
      @params = params
    end

    def create
      if @cabin.update(@params)
        OpenStruct.new(success?: true, cabin: @cabin)
      else
        OpenStruct.new(success?: false, errors: @cabin.errors.full_messages)
      end
    end

    def update
      if @cabin.update(@params)
        OpenStruct.new(success?: true, cabin: @cabin)
      else
        OpenStruct.new(success?: false, errors: @cabin.errors.full_messages)
      end
    end
  end
end