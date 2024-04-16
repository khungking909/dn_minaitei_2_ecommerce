# frozen_string_literal: true

Ransack.configure do |config|
  # Change default search parameter key name.
  # Default key name is :q
  config.search_key = :query # Raise errors if a query contains an unknown predicate or attribute.
  # Default is true (do not raise error on unknown conditions).
  config.ignore_unknown_conditions = false # Globally display sort links without the order indicator arrow.
  # Default is false (sort order indicators are displayed).
  # This can also be configured individually in each sort link (see the README).
  config.hide_sort_order_indicators = true # Change whitespace stripping behavior.
  # Default is true
  config.strip_whitespace = false

  config.add_predicate("between",
                       arel_predicate: "between",
                       formatter: proc { |v|
                                    arr = v.split("..")
                                    Integer(arr[0], 10)..Integer(arr[1], 10)
                                  },
                       type: :string
                      )
end
