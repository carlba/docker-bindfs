# docker-bindfs

A Docker container that wraps [bindfs](https://bindfs.org) - a FUSE filesystem for mirroring directories with altered permissions.

## What is bindfs?

Bindfs is a FUSE filesystem that allows you to mirror a directory to another location with modified permissions. It's useful for:
- Making a directory read-only
- Making all executables non-executable
- Sharing a directory with specific users or groups
- Modifying permission bits using chmod-like syntax
- Changing the permissions with which files are created

## Building the Image

```bash
docker build -t carlba/docker-bindfs .
```

## Usage

### Basic Usage

The container requires privileged mode and access to the `/dev/fuse` device to function properly.

```bash
docker run --rm -it \
  --privileged \
  --cap-add SYS_ADMIN \
  --device /dev/fuse \
  -v /source/path:/mnt/source:rshared \
  -v /target/path:/mnt/target:rshared \
  carlba/docker-bindfs \
  /mnt/source /mnt/target [bindfs-options]
```

### Examples

#### Mirror a directory with different ownership

```bash
docker run --rm -it \
  --privileged \
  --cap-add SYS_ADMIN \
  --device /dev/fuse \
  -v /path/to/source:/mnt/source:rshared \
  -v /path/to/target:/mnt/target:rshared \
  carlba/docker-bindfs \
  --force-user=1000 --force-group=1000 /mnt/source /mnt/target
```

#### Create a read-only mirror

```bash
docker run --rm -it \
  --privileged \
  --cap-add SYS_ADMIN \
  --device /dev/fuse \
  -v /path/to/source:/mnt/source:rshared \
  -v /path/to/target:/mnt/target:rshared \
  carlba/docker-bindfs \
  -o ro /mnt/source /mnt/target
```

#### Make all files non-executable

```bash
docker run --rm -it \
  --privileged \
  --cap-add SYS_ADMIN \
  --device /dev/fuse \
  -v /path/to/source:/mnt/source:rshared \
  -v /path/to/target:/mnt/target:rshared \
  carlba/docker-bindfs \
  --chmod-ignore --chmod=a-x /mnt/source /mnt/target
```

#### View help and available options

```bash
docker run --rm carlba/docker-bindfs --help
```

## Important Notes

- The container must run with `--privileged` flag or at minimum `--cap-add SYS_ADMIN` and `--device /dev/fuse`
- Source and target volumes should be mounted with `:rshared` propagation to ensure the FUSE mount is visible
- Bindfs runs in foreground mode by default; use `-f` flag if needed
- To unmount, stop the container with `docker stop <container-id>`

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Links

- [bindfs official website](https://bindfs.org)
- [bindfs GitHub repository](https://github.com/mpartel/bindfs)
