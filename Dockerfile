FROM centos:centos6
MAINTAINER rcsavage

# Install yum packages
RUN yum update -y && \
    yum install -y mysql-server 

# Remove pre-installed database
RUN rm -rf /var/lib/mysql/*

# Add MySQL configuration
ADD my.cnf /etc/mysql/conf.d/my.cnf
ADD mysqld_charset.cnf /etc/mysql/conf.d/mysqld_charset.cnf

# Add MySQL scripts
ADD admin_user.sh /usr/bin/admin_user.sh
ADD sql_import.sh /usr/bin/sql_import.sh
ADD run.sh /usr/local/bin/run.sh
RUN chmod 777 /usr/bin/*.sh && chmod 777 /usr/local/bin/run.sh

# Exposed ENV
ENV MYSQL_USER admin
ENV MYSQL_PASS admin 

# Replication ENV
ENV REPLICATION_MASTER **False**
ENV REPLICATION_SLAVE **False**
ENV REPLICATION_USER replica
ENV REPLICATION_PASS replica

# Add VOLUMEs to allow backup of config and databases
VOLUME  ["/etc/mysql", "/var/lib/mysql"]

EXPOSE 3306
CMD ["/usr/local/bin/run.sh"]
