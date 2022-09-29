FROM ubuntu:latest
COPY wild.py ../
RUN apt update -y
RUN apt install python3-pip git curl wget -y
RUN pip3 install gitpython

# Twistlock Container Defender - app embedded
ADD twistlock_defender_app_embedded.tar.gz /
ENV DEFENDER_TYPE="appEmbedded"
ENV DEFENDER_APP_ID="pc-github-cloudrun"
ENV FILESYSTEM_MONITORING="true"
ENV WS_ADDRESS="wss://us-east1.cloud.twistlock.com:443"
ENV DATA_FOLDER="/"
ENV INSTALL_BUNDLE="eyJzZWNyZXRzIjp7InNlcnZpY2UtcGFyYW1ldGVyIjoiYjFVd2RpeUJKeUhqaGdiQjNrNGMvRTF4ejhIR3VMcExnNG9WTTNSc3pKcldMYzVMM1pTb0FlN2N0bEJjeEQzL2RhclJaclFjOHQ0Mlh5SkQ1WlVrS1E9PSJ9LCJnbG9iYWxQcm94eU9wdCI6eyJodHRwUHJveHkiOiIiLCJub1Byb3h5IjoiIiwiY2EiOiIiLCJ1c2VyIjoiIiwicGFzc3dvcmQiOnsiZW5jcnlwdGVkIjoiIn19LCJjdXN0b21lcklEIjoidXMtMi0xNTgyNTY4ODUiLCJhcGlLZXkiOiI5YlloWFMvTzIyKzhqNDQxTHFHcENCR1dvRlVtK3dzdHlZWjFvNnpEV29kV2dYa01JQXRiUUV3eDl6TmZYWEJNb1pRd1htYWszNXpyY1hCWkdMQ290dz09IiwibWljcm9zZWdDb21wYXRpYmxlIjpmYWxzZSwiaW1hZ2VTY2FuSUQiOiI0ZTRmMTNhZS01YzUyLTFjM2QtNjRiNy04MjVlZGI2OTRiNTgifQ=="
EXPOSE 8080
ENTRYPOINT ["/defender", "app-embedded", "python3", "wild.py"]
