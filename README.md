# Coral Edge TPU Init Docker Image

This Docker image provides a pre-configured environment for running the Google Coral Edge TPU example using `pycoral`. It includes all necessary dependencies, including Python 3.9, `pycoral`, and the Coral Edge TPU libraries, this allow to initialize coral for use in ESXi.

## Prerequisites

*   Docker installed on your system ([https://www.docker.com/get-docker](https://www.docker.com/get-docker))
*  A Google Coral Edge TPU device connected to your system.

## Building the Image

To build the Docker image, navigate to the directory containing the `Dockerfile` and run the following command:

```bash
docker build -t coral-image .
```

This will download the necessary dependencies and create a Docker image named `coral-image`.  The build process may take some time depending on your internet connection and system resources.

## Running the Image

Once the image is built, you can run it using the following command:

```bash
docker pull ghcr.io/pe46dro/coraltpu-docker-init:main
docker run -it --device=/dev/bus/usb:/dev/bus/usb --rm ghcr.io/pe46dro/coraltpu-docker-init:main
```

It will return: `ValueError: Failed to load delegate from libedgetpu.so.1` now you can run on ESXi host:
```
/etc/init.d/usbarbitrator stop
vmkload_mod -u vmkusb;vmkload_mod vmkusb
kill -SIGHUP $(ps -C | grep vmkdevmgr | awk '{print $1}')
/etc/init.d/usbarbitrator start
```
or if you use USB Network:
```
/etc/init.d/usbarbitrator stop
vmkload_mod -u vmkusb_nic_fling;vmkload_mod vmkusb_nic_fling
kill -SIGHUP $(ps -C | grep vmkdevmgr | awk '{print $1}')
/etc/init.d/usbarbitrator start
```
Original command from [Google Coral USB Edge TPU Accelerator on ESXi](https://williamlam.com/2023/05/google-coral-usb-edge-tpu-accelerator-on-esxi.html)

## Dependencies Included

*   Debian 11
*   Python 3.9
*   `pycoral` (version ~2.0)
*   `numpy` (version 1.26.4)
*   Coral Edge TPU libraries (`libedgetpu1-std`)
*   `git`, `nano`, `wget`, `curl`, `unzip`, `sudo`, `pkg-config`, `udev`
*   Other necessary Python packages (e.g., `pyftdi`, `pyserial`, `mendel-development-tool`)

## Notes

*   This image is designed for initialize a Google Coral Edge TPU device.

## Troubleshooting

If you encounter any issues, please check the following:

*   Ensure that Docker is installed and running correctly.
*   Verify that you have the necessary permissions to run Docker commands.
*   Check the Docker logs for any error messages.
*   Consult the Google Coral documentation for more information: [https://coral.ai/](https://coral.ai/)
