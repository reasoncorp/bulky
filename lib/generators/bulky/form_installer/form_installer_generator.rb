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
      write_id_div
      write_options_div
      close_form
    end

    private

    def namespace(model_name)
      @namespace ||= Rails.root.join("app/" "views/" "bulky/updates/edit_#{model_name.downcase}.html.erb")
    end

    def append(content)
      File.open(@namespace, "ab") do |f|
        f.write content
      end
    end

    def create_div(klass, style=nil)
      append("<div class='#{klass}', style='#{style}'>\n")
    end

    def close_div
      append("</div>\n")
    end

    def start_form
      append("<%= form_tag('/bulky/#{model_name.downcase}', method: :put) do %>\n")
    end

    def write_id_div
      create_div("bulky-container")
      append("<h4>Ids To Update</h4>\n")
      create_div("bulky-id-input")
      append("<%= text_area_tag(:ids) %>\n")
      close_div
      close_div
    end

    def write_options_div
      create_div("bulky-container")
      append("<h4>Attributes To Update</h4>")
      create_div("bulky-form-inputs")
      write_form_fields(@columns)
      append("<br/> <%= submit_tag('Submit') %>\n")
      close_div
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
      append("<%= label_tag(:#{column_name}, '#{column_name.capitalize.humanize}') %>\n<%= text_field_tag(:#{column_name}, '', name: 'bulk[#{column_name}]') %>\n")
    end

    def build_integer_field(column_name)
      append("<%= label_tag(:#{column_name}, '#{column_name.capitalize.humanize}') %>\n<%= text_field_tag(:#{column_name}, '', name: 'bulk[#{column_name}]') %>\n")
    end

    def build_select_field(column)
      append("<%= select_tag(:#{column.name}, options_for_select(#{gather_select_field_values(column)}), name: 'bulk[#{column.name}]') %>\n")
    end

    def gather_select_field_values(column)
      values = []
      column.limit.each do |limit|
        values << [limit.to_s.humanize, limit.to_s.humanize]
      end
      values
    end

    def build_boolean_field(column_name)
      append("<%= check_box_tag(:#{column_name}, '', name: 'bulk[#{column_name}]') %>\n<%= label_tag(:#{column_name}) %>\n")
    end

    def close_form
      append("<% end %>")
    end
  end
end
