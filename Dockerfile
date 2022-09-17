FROM ubuntu:latest
COPY wild.py /
RUN apt update -y
RUN apt install python3-pip git  -y
RUN pip3 install gitpython
EXPOSE 8080


# Make marshalsec's LDAP server to redirect the client to host (172.17.0.1)'s attacker web server
# CHANGEME to change attacker web server's 8888 port. 
ENTRYPOINT [ "python3", "wild.py"]
