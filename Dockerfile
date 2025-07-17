FROM debian:11
WORKDIR /home
RUN cd ~
RUN apt-get -y update
RUN apt-get -y dist-upgrade
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata
RUN apt-get install -y git nano python3.9 python3.9-venv python3-pip wget usbutils curl unzip sudo python3.9-dev pkg-config udev

RUN echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" \
| tee /etc/apt/sources.list.d/coral-edgetpu.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN apt-get update

RUN sudo apt-get install libedgetpu1-std

RUN mkdir coral
RUN git clone https://github.com/google-coral/pycoral.git coral/pycoral

RUN bash coral/pycoral/examples/install_requirements.sh classify_image.py

RUN python3.9 -m pip install --extra-index-url https://google-coral.github.io/py-repo/ pycoral~=2.0

RUN python3.9 -m pip install pyftdi pyserial mendel-development-tool numpy==1.26.4

ENTRYPOINT ["python3.9"]
CMD ["/home/coral/pycoral/examples/classify_image.py", "--model", "/home/coral/pycoral/test_data/mobilenet_v2_1.0_224_inat_bird_quant_edgetpu.tflite", "--input", "/home/coral/pycoral/test_data/parrot.jpg", "--labels", "/home/coral/pycoral/test_data/inat_bird_labels.txt"]
