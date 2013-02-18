FactoryGirl.define do

  factory :bulky_updated_record, class: Bulky::UpdatedRecord do
    bulk_update_id 1
    sequence :updatable_id do |n|
      n
    end
    updatable_type "Account"
  end

  factory :bulky_bulk_update, class: Bulky::BulkUpdate do
    ids [1,2,3]
    updates HashWithIndifferentAccess.new(
      updated_by_id: "17",
      note_status_id: "4",
      content: "This account's status was changed as part of a bulk update of those accounts where the county has notified us that they will not pursue. The list of accounts was generated from our Denial Tracking worksheet, "
    )          
    factory :bulky_bulk_update_with_bulky_updated_records do
      ignore do
        bulky_updated_records_count 5
      end

      after(:create) do |bulk_update, evaluator|
        FactoryGirl.create_list(:bulky_updated_record, 5, bulk_update_id: bulk_update, updatable: bulk_update)
      end
    end
  end
end

