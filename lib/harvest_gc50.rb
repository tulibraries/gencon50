module HarvestCSV
  def self.csv_to_solr(csv_hash, schema_map)
    document = Hash.new
    csv_hash.each { |key, value|
      k = key.parameterize.underscore
      if (schema_map.has_key?(k))
        solr_fields = schema_map[k]
        solr_fields.each {|solr_field|
          document[solr_field] = value
        }
      end
    }
    document["id"] = document['original_order_display'] if document["id"].nil?
    document["id"].prepend("#{document['year_display']}-")
    document
  end
end
