require 'spec_helper'

describe Barge::Resource::Domain do
  include_context 'resource'
  it_behaves_like 'a resource'

  describe '#create' do
    it 'creates a domain' do
      stubbed_request = stub_request!(:post, '/domains')
        .to_return(body: fixture('domains/create'), status: 201)
      options = { name: 'example.com', ip_address: '1.2.3.4' }
      expect(domain.create(options).name).to eq 'example.com'
      expect(stubbed_request.with(body: options.to_json))
        .to have_been_requested
    end
  end

  describe '#all' do
    it 'lists all domains' do
      stubbed_request = stub_request!(:get, '/domains')
        .to_return(body: fixture('domains/all'), status: 200)
      expect(domain.all.first).to include ttl: 1800
      expect(stubbed_request).to have_been_requested
    end
  end

  describe '#show' do
    it 'shows a domain' do
      stubbed_request = stub_request!(:get, '/domains/example.com')
        .to_return(body: fixture('domains/show'), status: 200)
      expect(domain.show('example.com').zone_file)
        .to eq 'Example zone file text...'
      expect(stubbed_request).to have_been_requested
    end
  end

  describe '#destroy' do
    it 'destroys a domain' do
      stubbed_request = stub_request!(:delete, '/domains/example.com')
        .to_return(status: 204)
      expect(domain.destroy('example.com').success?).to be true
      expect(stubbed_request).to have_been_requested
    end
  end

  describe '#create_record' do
    it 'creates a record' do
      stubbed_request = stub_request!(:post, '/domains/example.com/records')
        .to_return(body: fixture('domains/create_record'), status: 201)
      options = { name: 'test', data: '1.2.3.4', type: 'A' }
      expect(domain.create_record('example.com', options).type).to eq 'A'
      expect(stubbed_request.with(body: options.to_json))
        .to have_been_requested
    end
  end

  describe '#show_record' do
    it 'shows a record' do
      stubbed_request = stub_request!(:get, '/domains/example.com/records/5')
        .to_return(body: fixture('domains/show_record'), status: 200)
      expect(domain.show_record('example.com', 5).type).to eq 'CNAME'
      expect(stubbed_request).to have_been_requested
    end
  end

  describe '#update_record' do
    it 'updates a record' do
      stubbed_request = stub_request!(:put, '/domains/example.com/records/10')
        .to_return(body: fixture('domains/update_record'), status: 200)
      options = { name: 'new_name' }
      expect(domain.update_record('example.com', 10, name: 'new_name').id)
        .to be 10
      expect(stubbed_request.with(body: options.to_json))
        .to have_been_requested
    end
  end

  describe '#destroy_record' do
    it 'destroys a record' do
      stubbed_request =
        stub_request!(:delete, '/domains/example.com/records/20')
        .to_return(status: 204)
      expect(domain.destroy_record('example.com', 20).success?).to be true
      expect(stubbed_request).to have_been_requested
    end
  end
end
