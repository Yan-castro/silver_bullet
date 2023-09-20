require "controllers/api/v1/test"

class Api::V1::PropertiesControllerTest < Api::Test
  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @property = build(:property, team: @team)
    @other_properties = create_list(:property, 3)

    @another_property = create(:property, team: @team)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @property.save
    @another_property.save
  end

  # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
  # data we were previously providing to users _will_ break the test suite.
  def assert_proper_object_serialization(property_data)
    # Fetch the property in question and prepare to compare it's attributes.
    property = Property.find(property_data["id"])

    assert_equal_or_nil property_data['name'], property.name
    assert_equal_or_nil property_data['description'], property.description
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal property_data["team_id"], property.team_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/teams/#{@team.id}/properties", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    property_ids_returned = response.parsed_body.map { |property| property["id"] }
    assert_includes(property_ids_returned, @property.id)

    # But not returning other people's resources.
    assert_not_includes(property_ids_returned, @other_properties[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/properties/#{@property.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/properties/#{@property.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    property_data = JSON.parse(build(:property, team: nil).api_attributes.to_json)
    property_data.except!("id", "team_id", "created_at", "updated_at")
    params[:property] = property_data

    post "/api/v1/teams/#{@team.id}/properties", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/teams/#{@team.id}/properties",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/properties/#{@property.id}", params: {
      access_token: access_token,
      property: {
        name: 'Alternative String Value',
        description: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @property.reload
    assert_equal @property.name, 'Alternative String Value'
    assert_equal @property.description, 'Alternative String Value'
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/properties/#{@property.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Property.count", -1) do
      delete "/api/v1/properties/#{@property.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/properties/#{@another_property.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
