require "controllers/api/v1/test"

class Api::V1::BookingsControllerTest < Api::Test
  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @property = create(:property, team: @team)
    @booking = build(:booking, property: @property)
    @other_bookings = create_list(:booking, 3)

    @another_booking = create(:booking, property: @property)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @booking.save
    @another_booking.save
  end

  # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
  # data we were previously providing to users _will_ break the test suite.
  def assert_proper_object_serialization(booking_data)
    # Fetch the booking in question and prepare to compare it's attributes.
    booking = Booking.find(booking_data["id"])

    assert_equal_or_nil booking_data['start_date_time'], booking.start_date_time
    assert_equal_or_nil booking_data['end_date_time'], booking.end_date_time
    assert_equal_or_nil booking_data['extra_info'], booking.extra_info
    assert_equal_or_nil booking_data['access_info'], booking.access_info
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal booking_data["property_id"], booking.property_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/properties/#{@property.id}/bookings", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    booking_ids_returned = response.parsed_body.map { |booking| booking["id"] }
    assert_includes(booking_ids_returned, @booking.id)

    # But not returning other people's resources.
    assert_not_includes(booking_ids_returned, @other_bookings[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/bookings/#{@booking.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/bookings/#{@booking.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    booking_data = JSON.parse(build(:booking, property: nil).api_attributes.to_json)
    booking_data.except!("id", "property_id", "created_at", "updated_at")
    params[:booking] = booking_data

    post "/api/v1/properties/#{@property.id}/bookings", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/properties/#{@property.id}/bookings",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/bookings/#{@booking.id}", params: {
      access_token: access_token,
      booking: {
        start_date_time: 'Alternative String Value',
        end_date_time: 'Alternative String Value',
        extra_info: 'Alternative String Value',
        access_info: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @booking.reload
    assert_equal @booking.start_date_time, 'Alternative String Value'
    assert_equal @booking.end_date_time, 'Alternative String Value'
    assert_equal @booking.extra_info, 'Alternative String Value'
    assert_equal @booking.access_info, 'Alternative String Value'
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/bookings/#{@booking.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Booking.count", -1) do
      delete "/api/v1/bookings/#{@booking.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/bookings/#{@another_booking.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
