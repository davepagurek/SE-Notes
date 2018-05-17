# Distributed Filesystems

## Accessing remote files
- remote access model
  - Any read/write uses an RPC to push or pull data, which always stays on the server
- upload/download model
  - Files are moved to the client and then back to the server
- Network file system (NFS)
  - Unix-like systems rely on NFS. E.g. your home directory on `ecelinux` is mounted remotely using NFSv4.
  - "Leases" (delegates) the file to the client, but can recall the delegation
  - Uses RPCs internally
  - Server decides which portion to export, to only give a window of visibility to clients

## Distributing large files
- Each file might be on one server, or each could be striped across multiple servers
  - Striping usually allows higher throughput for large requests issued one at a time
  - Many small requests issued in parallel, one file per server is ok
