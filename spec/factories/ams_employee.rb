FactoryGirl.define do
  sequence :name do |n|
    "Employee #{n}"
  end

  factory :ams_employee, class: AmsEmployee do
    name
    age 25
    position 'engineer'
  end
end
