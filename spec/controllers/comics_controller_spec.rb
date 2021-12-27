# frozen_string_literal: true

require 'rails_helper'

describe ComicsController, type: :request do
  context 'when making a request' do
    context 'when no parameters is passed'
    it 'calls the repository without any parameter' do
      expect_any_instance_of(::Infra::Repositories::ComicsRepository).to receive(:find_all).and_return([])

      get root_path
    end
  end

  context 'when the name of a character is passed'
  it 'calls the repository with the character name' do
    character_name = 'deadpool'
    expect_any_instance_of(::Infra::Repositories::ComicsRepository).to receive(:find_all).with(character_name: character_name, page: 1).and_return([])

    get root_path, params: { character_name: character_name }
  end
end
