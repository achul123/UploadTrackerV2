export const randomInt = (low: number, high: number) => Math.floor(Math.random() * (high - low) + low);

export const cleanDirectoryPath = (path: string) => path.replace(/(\/(\/*))|(^$)/g, '/');

export function fileBitsToString(mode: string, directory: boolean): string {
    const m = parseInt(mode, 8);

    let buf = '';
    'dalTLDpSugct?'.split('').forEach((c, i) => {
        if ((m & (1 << (32 - 1 - i))) !== 0) {
            buf = buf + c;
        }
    });

    if (buf.length === 0) {
        // If the file is directory, make sure it has the directory flag.
        if (directory) {
            buf = 'd';
        } else {
            buf = '-';
        }
    }

    'rwxrwxrwx'.split('').forEach((c, i) => {
        if ((m & (1 << (9 - 1 - i))) !== 0) {
            buf = buf + c;
        } else {
            buf = buf + '-';
        }
    });

    return buf;
}

/**
 * URL-encodes the segments of a path.
 * This allows to use the path as part of a URL while preserving the slashes.
 * @param path the path to encode
 */
export function encodePathSegments(path: string): string {
    return path
        .split('/')
        .map((s) => encodeURIComponent(s))
        .join('/');
}

export function hashToPath(hash: string): string {
    return hash.length > 0 ? decodeURIComponent(hash.substr(1)) : '/';
}

export function bytesToHuman(bytes: number, si=true, dp=1) {
  const thresh = si ? 1000 : 1024;

  if (Math.abs(bytes) < thresh) {
    return bytes + ' B';
  }

  const units = si 
    ? ['kB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'] 
    : ['KiB', 'MiB', 'GiB', 'TiB', 'PiB', 'EiB', 'ZiB', 'YiB'];
  let u = -1;
  const r = 10**dp;

  do {
    bytes /= thresh;
    ++u;
  } while (Math.round(Math.abs(bytes) * r) / r >= thresh && u < units.length - 1);


  return bytes.toFixed(dp) + ' ' + units[u];
}