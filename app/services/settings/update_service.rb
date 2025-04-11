module Settings
  class UpdateService
    def initialize(setting, params)
      @setting = setting
      @params = params
    end

    def call
      if @setting.update(@params)
        OpenStruct.new(success?: true, setting: @setting)
      else
        OpenStruct.new(success?: false, errors: @setting.errors.full_messages)
      end
    end
  end
end