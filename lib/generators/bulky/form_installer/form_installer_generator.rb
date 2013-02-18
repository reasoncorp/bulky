module Bulky
  class FormInstallerGenerator < Rails::Generators::Base
    desc "This generator will build a bulk update form for a specified model"

    argument :model_name, type: :string, required: true

    def gather_fields
      @columns ||= model_name.capitalize.constantize.columns
    end

    def create_the_file
      create_file namespace(model_name)
    end

    def write_form
      start_form

      @columns.each do |column|
        if column.name.to_s == "id"
          next
        elsif column.type.to_s == "string"
          build_string_field(column.name)
        elsif column.type.to_s == "integer"
          build_integer_field(column.name)
        elsif column.type.to_s == "boolean"
          build_boolean_field(column.name)
        elsif column.type.to_s == "enum"
          build_select_field(column)
        else
          next
        end
      end 

      close_form
    end

    private

    def namespace(model_name)
      @namespace ||= Rails.root.join("app/" "views/" "bulky/updates/edit.html.erb")
    end

    def start_form
      File.open(@namespace, "ab") do |f|
        f.write "<%= form_tag do %>\n"
      end
    end

    def build_string_field(column_name)
      File.open(@namespace, "ab") do |f|
        f.write "<%= label_tag(:#{column_name}, '#{column_name.capitalize.humanize}') %>\n"
        f.write "<%= text_field_tag(:#{column_name}) %>\n"
      end
    end

    def build_integer_field(column_name)
      File.open(@namespace, "ab") do |f|
        f.write "<%= label_tag(:#{column_name}, '#{column_name.capitalize.humanize}') %>\n"
        f.write "<%= text_field_tag(:#{column_name}) %>\n"
      end
    end

    def build_select_field(column)
      File.open(@namespace, "ab") do |f|
        f.write "<%= select_tag(:#{column.name}, options_for_select(#{gather_select_field_values(column)})) %>\n"
      end
    end

    def gather_select_field_values(column)
      values = []
      column.limit.each do |limit|
        values << [limit.to_s.humanize, limit.to_s.humanize]
      end
      values
    end

    def build_boolean_field(column_name)
      File.open(@namespace, "ab") do |f|
        f.write "<%= check_box_tag(:#{column_name}) %>\n"
        f.write "<%= label_tag(:#{column_name}) %>\n"
      end
    end

    def close_form
      File.open(@namespace, "ab") do |f|
        f.write "<% end %>"
      end
    end
  end
end
