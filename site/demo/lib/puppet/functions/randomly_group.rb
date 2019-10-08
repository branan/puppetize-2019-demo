Puppet::Functions.create_function(:randomly_group) do
  dispatch :randomly_group do
    param 'Array[Any]', :values
    param 'Array[String[1]]', :buckets
  end

  def randomly_group(values, buckets)
    out = {}
    buckets.each do |bucket|
      out.merge!({ bucket => [] })
    end
    values.each do |value|
      bucket = buckets.sample()
                            
      val = out[bucket] << value
      out.merge!({ bucket => val })
    end
    out
  end
end
