dnf module list

No matching modules to list

hmm....

https://docs.fedoraproject.org/en-US/modularity/hosting-modules/

* Modifying repositories that have AppStream components:

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

* Postgresql example

dnf module list

We see that we have:

~~~
postgresql           10 [d]      client, server [d]          PostgreSQL server and client module
postgresql           9.6         client, server [d]          PostgreSQL server and client module
~~~

This means that I can pick either the postgresql 10 stream (the default) or the 9.6 stream. This enable me to use an older postgresql than what RHEL 8 ships. In the future as new postgresql versions come out, they can be added as different streams that I can change to as well. This allows me to be more on the forefront of the latest and greatest with userspace or to stay on a version for longer depending on my needs.

By default if you do:

~~~
dnf install postgresql-server
~~~

you will get:

~~~
10.6-1.module+el8+2469+5ecd5aae
~~~

Once we've installed that, if we look at the corresponding section of dnf module list again, we will see:

~~~
postgresql           10 [d][e]   client, server [d]          PostgreSQL server and client module
postgresql           9.6         client, server [d]          PostgreSQL server and client module
~~~

The e by 10 means enabled.

To install the module profile, run:

~~~
dnf module install postgresql:10/server
~~~

Once you've done that, dnf module list will return:

~~~
postgresql           10 [d][e]   client, server [d] [i]      PostgreSQL server and client module
postgresql           9.6         client, server [d]          PostgreSQL server and client module
~~~

Indicating that the profile is installed.

Let's switch to the 9.6 stream:

~~~
dnf module enable postgresql:9.6
~~~

We will now see that the profile has been switched:

~~~
postgresql           10 [d]      client, server [d]          PostgreSQL server and client module
postgresql           9.6 [e]     client, server [d] [i]      PostgreSQL server and client module
~~~

But if we run:

~~~
rpm -q postgresql-server
postgresql-server-10.6-1.module+el8+2469+5ecd5aae.x86_64
~~~

clearly we still have 10.6 installed.

To switch to 9.6, let's run:

~~~
dnf module install postgresql:9.6/server
~~~

This removes 10.6-1 and installs:

9.6.10-1.module+el8+2470+d1bafa0e

Looking at dnf module list again, we see:

~~~
postgresql           10 [d]      client, server [d]          PostgreSQL server and client module
postgresql           9.6 [e]     client, server [d] [i]      PostgreSQL server and client module
~~~

and 

~~~
rpm -q postgresql-server:
postgresql-server-9.6.10-1.module+el8+2470+d1bafa0e.x86_64
~~~

---

Modularity brings parallel availability, not parallel installability. 

dnf module list -- d indicates default.

 dnf module install python27:2.7/common

Installs python 2.7

so does:

dnf install python2

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


dnf module info --profile postgresql
