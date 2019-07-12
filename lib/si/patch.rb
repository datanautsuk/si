# frozen_string_literal: true

# patch float
class Float
  include SI
end

# patch Integer
class Integer
  include SI
end

# patch Rational
class Rational
  include SI
end

# Patch BD
class BigDecimal
  include SI
end
