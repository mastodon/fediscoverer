require "test_helper"

module Admin
  class FollowRecommendationPresetsTest < ActionDispatch::IntegrationTest
    include FaspBase::IntegrationTestHelper

    test "signed out users cannot access follow recommendation presets" do
      get admin_follow_recommendation_presets_path

      assert_redirected_to fasp_base.new_admin_session_path
    end

    test "it shows the list of follow recommendation presets" do
      sign_in_admin(fasp_base_admin_users(:provider_admin))

      get admin_follow_recommendation_presets_path

      assert_response :success
    end

    test "it enqueues the job to create a new follow recommendation preset" do
      sign_in_admin(fasp_base_admin_users(:provider_admin))

      assert_enqueued_with job: CreateFollowRecommendationPresetJob do
        post admin_follow_recommendation_presets_path,
          params: { uri: "https://fedi.example.com/users/a82661" }
      end
    end

    test "it removes the `recommended` flag from actors" do
      recommended_actor = actors(:recommended)

      sign_in_admin(fasp_base_admin_users(:provider_admin))

      delete admin_follow_recommendation_preset_path(recommended_actor)

      refute recommended_actor.reload.recommended?
    end
  end
end
