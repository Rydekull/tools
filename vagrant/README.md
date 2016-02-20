etup vagrant on Fedora 23


```
$ sudo yum install libvirt-devel libvirt zlib-devel vagrant -y
$ sudo usermod -aG vagrant,libvirt,kvm $USER
$ vagrant plugin install vagrant-libvirt vagrant-registration vagrant-triggers

```


## Preparing an image
Basically, you can do whatever you want in your image. As long as you make sure that you add a vagrant user that can use sudo when logging in. Vagrant will then use this to setup your new host.

```
$ adduser vagrant
$ echo -e 'vagrant ALL=(ALL) NOPASSWD:ALL\nDefaults:vagrant \!requiretty' > /etc/sudoers.d/vagrant
$ yum install openssh-server -y
$ mkdir -m 0700 -p /home/vagrant/.ssh
$ curl -k https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -o /home/vagrant/.ssh/authorized_keys
$ chmod 0600 /home/vagrant/.ssh/authorized_keys
$ chown -R vagrant /home/vagrant/.ssh
$ chkconfig sshd on
```

## Create a box out of an image
Needs to be a qcow2 image. it needs a metadata-file and a Vagrantfile, and the actual image.

```
$ cat <<EOF> metadata.json 
{
  "provider"     : "libvirt",
  "format"       : "qcow2",
  "virtual_size" : 8
}
EOF
$ cat <<EOF> Vagrantfile
Vagrant.configure("2") do |config|
  config.vm.provider :libvirt do |libvirt|
    libvirt.driver = "kvm"
    libvirt.host = 'localhost'
    libvirt.uri = 'qemu:///system'
  end
  config.vm.define "new" do |custombox|
    custombox.vm.box = "custombox"       
    custombox.vm.provider :libvirt do |test|
      test.memory = 1024
      test.cpus = 1
    end
  end
end
EOF
$ sudo cp /var/lib/libvirt/images/vagrant-rhel7.qcow2 /home/rydekull/rhel7/box.img
$ tar cvzf rhel7.box ./metadata.json ./Vagrantfile ./box.img
```

## Manage boxes

```
$ vagrant box list
$ vagrant box remove rhel7
$ vagrant box add --name rhel7 rhel7.box
```

## Start a system 

```
$ mkdir $mydir
$ cd mydir
$ vagrant init -mf $BOXNAME
$ vagrant up
```

## Destroy a system
```
$ cd mydir
$ vagrant destroy 
```

## Setup a Vagrant file for talking to Satellite
```
$ cat <<EOF> Vagrantfile
Vagrant.configure(2) do |config|
  config.vm.box = "rhel7"
  if Vagrant.has_plugin?('vagrant-registration')
    config.registration.ca_cert = '/home/myuser/rhel7/katello-server-ca.crt'
    config.registration.serverurl = 'https://rhs.example.com/rhsm'
    config.registration.baseurl = 'https://rhs.example.com/pulp/repos'
    config.registration.org = 'Default_Organization'
    config.registration.activationkey = 'AK-RHEL7'
  end
end
EOF
```

## Refresh pools in libvirt when vagrant complains about disks/isos not existing
This can happen if you remove a VM, an ISO or whatever libvirt is monitoring and expects to exist. Just refresh the pool and continue with your life.

```
$ sudo virsh pool-list
# Pick a pool name
$ sudo virsh pool-refresh default
```
