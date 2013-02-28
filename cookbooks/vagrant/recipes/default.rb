template "#{node[:release_dir]}/Vagrantfile" do
  source "Vagrantfile.erb"
  mode 00644
end
