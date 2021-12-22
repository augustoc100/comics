require 'rails_helper'

describe Infra::Repositories::ComicsRepository do
  it 'teste' do
    result = described_class.new.test

    expect(result).to eq 'foo'
  end
end
