FROM ansible/awx:12.0.0

USER root
RUN rpmdb --initdb
# Rebuild fails while doing the copy because a storage driver issue
RUN rpmdb --rebuilddb || true
# We copy the files manually instead
RUN cp -r /var/lib/rpmrebuilddb*/* /var/lib/rpm/

RUN dnf update -y
RUN dnf -y install krb5-devel gcc krb5-libs krb5-workstation python3-pip
COPY requirements.txt .
RUN python3 -m pip install -r requirements.txt
RUN ansible-galaxy collection install openstack.cloud
RUN chmod 0755 /usr/bin/launch_awx*.sh && /var/lib/awx/venv/awx/bin/pip3 install python-memcached
