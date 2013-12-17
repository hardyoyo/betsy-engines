package :tomcat5_5_36 do
  requires :jre
  requires :jsvc
  requires :unzip
  requires :tomcat5_user
  requires :tomcat5_init
  requires :tomcat5_download

  runner "rm -R -f apache-tomcat-5.5.36"
  runner "rm -R -f /usr/share/tomcat5.5"
  runner "unzip apache-tomcat-5.5.36.zip"
  runner "mv -f apache-tomcat-5.5.36 /usr/share/tomcat5.5"
  # Create folders
  runner "mkdir --parents /etc/tomcat5.5/policy.d"
  runner "mkdir --parents /var/log/tomcat5.5"
  runner "mkdir --parents /var/cache/tomcat5.5"
  # Make tomcat55 to owner, allows creation of folders, etc.
  runner "touch /etc/tomcat5.5/policy.d/default.policy"
  runner "touch /usr/share/tomcat5.5/logs/catalina.out"
  runner "chown --recursive tomcat55:tomcat55 /etc/tomcat5.5"
  runner "chown --recursive tomcat55:tomcat55 /usr/share/tomcat5.5"
  runner "chmod -R 755 /usr/share/tomcat5.5"
  runner "chown --recursive tomcat55:tomcat55 /var/log/tomcat5.5"
  runner "chmod -R 777 /var/log/tomcat5.5"
  runner "chown --recursive tomcat55:tomcat55 /var/cache/tomcat5.5"
  runner "chmod -R 777 /usr/share/tomcat5.5/logs"

  #workaround: tomcat won't start if called from sprinkle :/
  transfer "files/tomcat5.5/start.sh", "/tmp/start_tc.sh"
  runner "mv /tmp/start_tc.sh /usr/share/tomcat5.5/bin/restart.sh"
  runner "chmod +x /usr/share/tomcat5.5/bin/restart.sh"
  runner "chown root:root /usr/share/tomcat5.5/bin/restart.sh"
  runner "at now -f /usr/share/tomcat5.5/bin/restart.sh"
  runner "sleep 5"

  verify do
    has_directory '/usr/share/tomcat5.5'
    has_process 'java'
    has_file '/usr/share/tomcat5.5/temp/tomcat5.5.pid'
  end

end

package :tomcat5_download do

  runner "wget https://svn.lspi.wiai.uni-bamberg.de/svn/betsy/apache-tomcat-5.5.36.zip"

  verify do
    has_file "apache-tomcat-5.5.36.zip"
  end
end

package :tomcat5_init do
  transfer "files/tomcat5.5/tomcat5.5", "/tmp/tomcat5.5"
  runner "mv -f /tmp/tomcat5.5 /etc/init.d/tomcat5.5"
  runner "chmod 755 /etc/init.d/tomcat5.5"
  runner "chmod +x /etc/init.d/tomcat5.5"
  runner "chown root:root /etc/init.d/tomcat5.5"
  runner "update-rc.d tomcat5.5 defaults"

  verify do
    has_file "/etc/init.d/tomcat5.5"
  end
end

package :tomcat5_user do
  runner "useradd -m -d /home/tomcat55 tomcat55"

  verify do
    has_user "tomcat55"
  end
end
