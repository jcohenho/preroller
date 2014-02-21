FactoryGirl.define do
  factory :audio_encoding, class: "Preroller::AudioEncoding" do
  end

  factory :output, class: "Preroller::Output" do
    sequence(:description) { |n|  "Some description #{n}" }
  end

  factory :campaign, class: "Preroller::Campaign" do
    sequence(:title) { |n| "Campaign Title #{n}" }
    start_at { 1.day.ago }
    end_at   { 1.day.from_now }

    trait :is_active do
      active 1
    end

    trait :is_not_active do
      active 0
    end

    factory :active_campaign, traits: [:is_active]
    factory :inactive_campaign, traits: [:is_not_active]
  end

end
