# Backup-ItemWithAbsolutePath

Inspired by 7-Zip's `-spf` switch, copies files and directories,
including the full specified absolute source paths into the
destination path, creating all the necessary parent directories
if they don't exist.

For example:

```powershell
> Backup-ItemWithAbsolutePath `
    -Path "/etc/sourcedirectory/source.file" `
    -Destinaion "/home/user/backup/"
```

will copy `source.file` into `/home/user/backup/etc/sourcedirectory/`.

**Note:** The path created in the destination directory will be exactly
          as specified in the source path, i.e. if the specified source
          path is not fully qualified, it will NOT be converted to a
          fully qualified path, e.g.:

```powershell
> Backup-ItemWithAbsolutePath `
    -Path "./sourcedirectory/source.file" `
    -Destinaion "/home/user/backup/"
```

will copy `source.file` into `/home/user/backup/sourcedirectory/`.

