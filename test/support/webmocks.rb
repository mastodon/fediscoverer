module Webmocks
  def mock_valid_actor_request(...)
    actor = mock_actor(...)
    stub_json_request(actor[:id], actor)
  end

  def mock_valid_content_request(...)
    object = mock_content_object(...)
    stub_json_request(object[:id], object)
  end

  def mock_valid_followers_collection_request(...)
    collection = mock_followers_collection(...)
    stub_json_request(collection[:id], collection)
  end

  private

  def stub_json_request(uri, json_object)
    stub_request(:get, uri)
      .to_return_json(
        body: json_object,
        headers: { "content-type" => "application/activity+json" }
      )
  end
end
