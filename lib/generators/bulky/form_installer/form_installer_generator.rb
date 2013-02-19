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
      write_div_1
      write_div_2
      close_form
    end

    private

    def namespace(model_name)
      @namespace ||= Rails.root.join("app/" "views/" "bulky/updates/edit_#{model_name}.html.erb")
    end

    def create_div(klass, style=nil)
      File.open(@namespace, "ab") do |f|
        f.write "<div class='#{klass}', style='#{style}'>"
      end 
    end

    def close_div
      File.open(@namespace, "ab") do |f|
        f.write "</div>\n"
      end
    end

    def start_form
      File.open(@namespace, "ab") do |f|
        f.write "<%= form_tag('/bulky/#{model_name}', method: :put) do %>\n"
      end
    end

    def write_div_1
      create_div("bulky-container")
      File.open(@namespace, "ab") do |f|
        f.write "<h4>Ids To Update</h4>"
      end
      create_div("bulky-id-input")
      File.open(@namespace, "ab") do |f|
        f.write "<%= text_area_tag(:ids) %>\n"
      end
      close_div
      close_div
    end

    def write_div_2
      create_div("bulky-container")
      File.open(@namespace, "ab") do |f|
        f.write "<h4>Attributes To Update</h4>"
      end
      create_div("bulky-form-inputs")
      write_form_fields(@columns)
      File.open(@namespace, "ab") do |f|
        f.write "<br/>"
        f.write "<%= submit_tag('Submit') %>\n"
      end
      close_div
    end

    def write_form_fields(columns_from_table)
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
    end

    def build_string_field(column_name)
      File.open(@namespace, "ab") do |f|
        f.write "<%= label_tag(:#{column_name}, '#{column_name.capitalize.humanize}') %>\n"
        f.write "<%= text_field_tag(:#{column_name}, '', name: 'bulk[#{column_name}]') %>\n"
      end
    end

    def build_integer_field(column_name)
      File.open(@namespace, "ab") do |f|
        f.write "<%= label_tag(:#{column_name}, '#{column_name.capitalize.humanize}') %>\n"
        f.write "<%= text_field_tag(:#{column_name}, '', name: 'bulk[#{column_name}]') %>\n"
      end
    end

    def build_select_field(column)
      File.open(@namespace, "ab") do |f|
        f.write "<%= select_tag(:#{column.name}, options_for_select(#{gather_select_field_values(column)}), name: 'bulk[#{column.name}]') %>\n"
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
        f.write "<%= check_box_tag(:#{column_name}, '', name: 'bulk[#{column_name}]') %>\n"
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
