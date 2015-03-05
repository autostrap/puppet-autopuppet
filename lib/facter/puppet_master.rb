Facter.add('puppet_master') do
  setcode do
    require 'json'

    begin
    data = JSON.parse(IO.read('/config/openstack/latest/meta_data.json'))
    data['meta']['puppet_master']
    rescue
      ''
    end
  end
end
