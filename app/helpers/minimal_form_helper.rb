# https://github.com/plataformatec/simple_form/wiki/Creating-a-minimalist-form-%28no-labels-just-placeholders%29
require "minimal_form_builder"
module MinimalFormHelper
  def minimal_form_for(object, *args, &block)
    options = args.extract_options!
    simple_form_for(object, *(args << options.merge(builder: MinimalFormBuilder, wrapper: :minimal)), &block)
  end
end