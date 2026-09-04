# RosBE in OCI container

This repository contains configuration files for OCI containers to run RosBE to compile ReactOS.

## How to run

First, build the container image (this will take a while):

```bash
podman build -t rosbe .
```

Then run the container in the directory with ReactOS code:

```bash
podman run -it --rm --userns=keep-id -v $(pwd):/reactos:Z rosbe
```

or

```bash
docker run --rm -it -v $(pwd):/reactos rosbe
```

Proceed as described on the [ReactOS Wiki](https://reactos.org/wiki/Building_ReactOS). You are already inside the code base with `RosBE.sh` running.

## License

ReactOS is licensed under the GNU GPL license with several parts under some other licenses.

This repository contains the OCI container files only. It is under the BSD 2-Clause "Simplified" License.
