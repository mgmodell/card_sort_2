# frozen_string_literal: true

require 'test_helper'

class DatasetsControllerTest < ActionDispatch::IntegrationTest
  test 'should get wordcloud' do
    get datasets_wordcloud_url
    assert_response :success
  end

  test 'should get cluster_map' do
    get datasets_cluster_map_url
    assert_response :success
  end

  test 'should get histogram' do
    get datasets_histogram_url
    assert_response :success
  end

  test 'should get show' do
    get datasets_show_url
    assert_response :success
  end

  test 'should get add_source' do
    get datasets_add_source_url
    assert_response :success
  end

  test 'should get process' do
    get datasets_process_url
    assert_response :success
  end

  test 'should get edit' do
    get datasets_edit_url
    assert_response :success
  end

  test 'should get update' do
    get datasets_update_url
    assert_response :success
  end

  test 'should get destroy' do
    get datasets_destroy_url
    assert_response :success
  end
end
