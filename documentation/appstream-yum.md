* Rebuilding repositories that have AppStream components:

~~~
yum install createrepo_c
cd /path/to/repos/AppStream
cd repodata
gunzip 87ada5e5d9c759dccdff8955fc93c33760454907021411ef552d3a6a8ca5ecc5-modules.yaml.gz
mv 87ada5e5d9c759dccdff8955fc93c33760454907021411ef552d3a6a8ca5ecc5-modules.yaml ../modules.yaml
cp 9d3cd6fcf9bdd9799b1c285b9d2d2627a8e4e5cd4e126bbfa8d8efea1722bde3-comps-AppStream.x86_64.xml ../
cd ..
rm -rf ./repodata
createrepo_c . -g 9d3cd6fcf9bdd9799b1c285b9d2d2627a8e4e5cd4e126bbfa8d8efea1722bde3-comps-AppStream.x86_64.xml
modifyrepo_c --mdtype=modules ./modules.yaml ./repodata/
~~~

At this point, you have properly regenerated the AppStream repository.

* Choosing an appstream module on RHEL 8. Let's do this on node1.example.com:

yum module list

We see that we have:

~~~
postgresql           10 [d]      client, server [d]          PostgreSQL server and client module
postgresql           9.6         client, server [d]          PostgreSQL server and client module
~~~

This means that I can pick either the postgresql 10 stream (the default) or the 9.6 stream. This enable me to use an older postgresql than what RHEL 8 ships. In the future as new postgresql versions come out, they can be added as different streams that I can change to as well. Switching streams is not supported. App Stream allows us to be more in control with userspace than any previous version of RHEL.

On a new RHEL 8 system, if you do:

~~~
yum install postgresql-server
~~~

you will get:

~~~
10.6-1.module+el8+2469+5ecd5aae
~~~

But let's say that our application teams have a dependency on 9.6 but we want to move to RHEL 8. With the app stream, we can do this. On node3.example.com, let's run:

~~~
yum module install postgresql:9.6/server -y
~~~

The above command tells yum to install the server profile for postgresql in the 9.6 version.

Once we've installed that, if we look at the corresponding section of yum module list again, we will see:

~~~
postgresql               10 [d]          client, server [d]                           PostgreSQL server and client module
postgresql               9.6 [e]         client, server [d] [i]                       PostgreSQL server and client module
~~~

The [e] by 9.6 means enabled. The [i] by server means installed. Anywhere that we see a [d] it represents the default on the operating system.

The server profile installs both the server and the client. If we just wanted the client, we could remove the server profile:

~~~
yum module remove postgresql:9.6/server -y
~~~

and install only the client:

~~~
yum module install postgresql:9.6/client -y
~~~

We would then see (in yum module list):

~~~
postgresql               10 [d]          client, server [d]                           PostgreSQL server and client module
postgresql               9.6 [e]         client [i], server [d]                       PostgreSQL server and client module
~~~

* Disabling application streams

Another interesting feature of application streams is the ability to easily prevent packages from being installed. On node3.example.com, we just installed postgresql. We don't want to have another database on the same machine and we see app stream profiles for mysql and mariadb. Let's disable these:

~~~
yum module disable mariadb mysql -y
~~~

Now when we do yum module list, we will see:

~~~
mariadb                  10.3 [d][x]     client, server [d], galera                   MariaDB Module
mysql                    8.0 [d][x]      client, server [d]                           MySQL Module
~~~

The [x] stands for disabled. When we run:

~~~
yum install mariadb -y
~~~

we get:

~~~
No match for argument: mariadb
Error: Unable to find a match
~~~

To re-enable these app streams and allow the packages to be installed, the command is:

~~~
yum module enable mariadb mysql -y
~~~

* Ansible automation with App Stream

Showing us that just the client profile is now installed.

---

Modularity brings parallel availability, not parallel installability. 

yum module list -- d indicates default.

 yum module install python27:2.7/common

Installs python 2.7

so does:

yum install python2

so what is the point of modularity....

ships additional versions of software on independent life cycles. This enables users to keep their operating system up-to-date while having the right version of an application for their use case, even when the default version in the distribution changes.

This is where the postgresql example is key.

Ansible:

- name: install a modularity appstream with defined stream and profile
  dnf:
    name: '@postgresql:9.6/client'
    state: present

gonna need newer ansible to do this: https://access.redhat.com/downloads/content/ansible/2.7.6-1.el7ae/noarch/fd431d51/package

installed 2.4 does not support modularity.

Run (as root):

ansible-playbook appstream-pgsql.yml

then:

ansible rhel8 -a "rpm -q postgresql-server"

and:

ansible rhel8 -a "rpm -q postgresql"

appstream-pgsql.yml:

~~~
---
  - name: Deploy Postgresql 9.6 server and client to old db servers.
    hosts: old-db
    tasks:
      - name: install postgresql 9.6 server
        dnf:
           name: '@postgresql:9.6/server'
           state: present
      - name: install postgresql 9.6 client
        dnf:
           name: '@postgresql:9.6/client'
           state: present


  - name: Deploy Postgresql 10 server and client to new db servers.
    hosts: new-db
    tasks:
      - name: install postgresql 10 server
        dnf:
           name: '@postgresql:10/server'
           state: present
      - name: install postgresql 10 client
        dnf:
           name: '@postgresql:10/client'
           state: present
~~~

ansible.cfg:

~~~
[defaults]
inventory=/root/.ansible/hosts
remote_user=root

[privilege_escalation]
become=True
become_user=root
become_ask_pass=False
~~~


/root/.ansible/hosts:

~~~
[rhel8]
node1.example.com
node2.example.com
node3.example.com

[old-db]
node3.example.com

[new-db]
node1.example.com
node2.example.com
~~~


yum module info --profile postgresql
