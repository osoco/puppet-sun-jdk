class sun-jdk::gentoo
{
    include wget
    include portage

    wget::fetch { "sun-jdk-download":
        source => "http://download.oracle.com/otn-pub/java/jdk/6u29-b11/jdk-6u29-linux-x64.bin",
        destination => "/usr/portage/distfiles/jdk-6u29-linux-x64.bin"
    }
    
    file { "/etc/portage/package.license/sun-jdk":
        owner => 'root',
        group => 'root',
        mode => 0644,
        source => "puppet:///modules/sun-jdk/portage/sun-jdk",
        require => File["/etc/portage/package.license"]
    }

    package { "dev-java/sun-jdk":
        ensure => "1.6.0.29",
        require => [Wget::Fetch["sun-jdk-download"], File["/etc/portage/package.license/sun-jdk"]]
    }

    exec { "eselect-java-vm":
        command => "eselect java-vm set system sun-jdk-1.6",
        cwd => "/root",
        path => ["/bin", "/usr/bin"],
        require => Package["dev-java/sun-jdk"]
    }

}
