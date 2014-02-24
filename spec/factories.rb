FactoryGirl.define do
  factory :audio_encoding, class: "Preroller::AudioEncoding" do
    campaign
    extension 'mp3'
    stream_key 'mp3-44100-48-m'
  end

  factory :output, class: "Preroller::Output" do
    sequence(:description) { |n|  "Some description #{n}" }
    sequence(:key) {|n| "key #{n}" }
  end

  factory :campaign, class: "Preroller::Campaign" do
    output
    sequence(:title) { |n| "Campaign Title #{n}" }
    start_at { 1.day.ago }
    end_at   { 1.day.from_now }
    metatitle 'testing'
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
