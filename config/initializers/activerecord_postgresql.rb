# Add support for postgres' text search configuration
require "active_record/connection_adapters/postgresql_adapter"

module ActiveRecord
  module ConnectionAdapters
    class PostgreSQLAdapter < AbstractAdapter
      NATIVE_DATABASE_TYPES[:regconfig] = { name: "regconfig" }

      private

      def initialize_type_map(m = type_map)
        self.class.initialize_type_map(m)

        m.register_type "regconfig", OID::SpecializedString.new(:regconfig)

        self.class.register_class_with_precision m, "time", Type::Time, timezone: @default_timezone
        self.class.register_class_with_precision m, "timestamp", OID::Timestamp, timezone: @default_timezone
        self.class.register_class_with_precision m, "timestamptz", OID::TimestampWithTimeZone

        load_additional_types
      end
    end

    module PostgreSQL
      module RegconfigExtension
        extend ActiveSupport::Concern

        included do
          define_column_methods :regconfig
        end
      end

      TableDefinition.include RegconfigExtension
      Table.include RegconfigExtension
    end
  end
end
