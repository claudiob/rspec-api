require 'spec_helper'

def existing(key)
  metadata[:description_attribute] = 'an existing'
  -> { instances.any key }
end

def unknown(key)
  metadata[:description_attribute] = 'an unknown'
  -> { instances.none key }
end

def apply(method_name, options = {})
  proc = options[:to]
  -> { proc.call.send method_name }
end

def with(request_params = {})
  request_params[:attribute] ||= metadata.delete :description_attribute
  request description_for(request_params), request_params, &Proc.new
end

def no_params
  {}
end

def valid(request_params)
  request_params.merge attribute: 'an valid'
end

def invalid(request_params)
  request_params.merge attribute: 'an invalid'
end

def description_for(request_params = {})
  [description_verb, description_object(request_params)].join ' '
end

def description_verb
  case metadata[:method]
  when :get then 'Getting'
  when :post then 'Creating'
  when :put then 'Updating'
  when :delete then 'Deleting'
  end
end

def description_object(request_params = {})
  attribute = request_params.delete :attribute
  if metadata[:array]
    "a list of #{metadata[:resource_name]}".tap do |objects|
      objects << " by #{request_params.keys.join(', ')}" if request_params.any?
    end
  else
    [attribute, metadata[:resource_name].singularize].join ' '
  end.downcase
end