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

* Picking a version of postgresql and sticking with it. Let's do this on node1.example.com:

yum module list

We see that we have:

~~~
postgresql           10 [d]      client, server [d]          PostgreSQL server and client module
postgresql           9.6         client, server [d]          PostgreSQL server and client module
~~~

This means that I can pick either the postgresql 10 stream (the default) or the 9.6 stream. This enable me to use an older postgresql than what RHEL 8 ships. In the future as new postgresql versions come out, they can be added as different streams that I can change to as well. This allows me to be more on the forefront of the latest and greatest with userspace or to stay on a version for longer depending on my needs.

By default if you do:

~~~
yum install postgresql-server
~~~

you will get:

~~~
10.6-1.module+el8+2469+5ecd5aae
~~~

Now let's do this using the app stream tooling in yum:

~~~
yum module install postgresql:10/server
~~~

The above command tells yum to install the server profile for postgresql in the 10 version.

Once we've installed that, if we look at the corresponding section of yum module list again, we will see:

~~~
postgresql           10 [d][e]   client, server [d][i]       PostgreSQL server and client module
postgresql           9.6         client, server [d]          PostgreSQL server and client module
~~~

The e by 10 means enabled. The i by server means installed.

The server profile installs both the server and the client. If we just wanted the client, we could remove the server profile:

~~~
yum module remove postgresql:10/server
~~~

and install only the client:

~~~
yum module install postgresql:10/client
~~~

We would then see (in yum module list):

~~~
postgresql           10 [d][e]   client [i], server [d]  PostgreSQL server and client module
postgresql           9.6         client, server [d]      PostgreSQL server and client module
~~~

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
