require 'spec_helper'

describe Category do
  it { should validate_presence_of :name }
  it { should validate_presence_of :user_id }
  it { should validate_uniqueness_of(:name).scoped_to(:user_id) }

  it { should have_many(:activities).dependent(:nullify) }
  it { should belong_to :user }

  describe '.activity_names' do
    let!(:category) { FactoryGirl.create(:category) }

    it 'returns a string of activities with given category' do
      activities = FactoryGirl.create_list(:activity, 2, category: category)

      expect(category.activity_names).to eq "#{activities.first.name}, #{activities.last.name}"
    end

    it 'returns empty string if there are no associated activities' do
      expect(category.activity_names).to eq ""
    end
  end
end
