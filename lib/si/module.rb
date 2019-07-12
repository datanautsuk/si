module SI
  class << self
    def convert(num, options = {})
      options = { length: options } if options.is_a?(Integer)
      options = DEFAULT.merge(options)
      units = PREFIXES.merge(options[:units] || {})

      length, min_exp, max_exp = options.values_at(:length, :min_exp, :max_exp)
      raise ArgumentError, 'Invalid length' if length < 2
      return num.is_a?(Integer) ? '0' : "0.#{'0' * (length - 1)}" if num.zero?

      base    = options[:base].to_f
      minus   = num < 0 ? '-' : ''
      nump    = num.abs

      PREFIXES.keys.sort.reverse.select { |exp| (min_exp..max_exp).cover? exp }.each do |exp|
        denom = base**exp
        next unless nump >= denom || exp == min_exp
        val = nump / denom
        dp = options[:decimal_places] || [length - val.to_i.to_s.length, 0].max
        val = val.round dp
        val = val.to_i if exp.zero? && num.is_a?(Integer)
        val = val.to_s.ljust(dp, '0') if val.is_a?(Float)

        return "#{minus}#{val}#{units[exp]}"
      end

      nil
    end

    def revert(str, options = {})
      options = { base: DEFAULT[:base] }.merge(options)
      pair    = PREFIXES.to_a.find { |_k, v| !v.empty? && str =~ /[0-9]#{v}$/ }

      if pair
        str[0...-1].to_f * (options[:base]**pair.first)
      else
        str.to_f
      end
    end
  end

  def si(options = {})
    SI.convert(self, options)
  end

  def si_byte(length = 3)
    SI.convert(self, length: length, base: 1024, min_exp: 0) + 'B'
  end
end
