# Installation

## Panel

You need to redo all steps, after every panel update.
You can use the file given in this archive as an example, where to paste the code snippets.

**Easy installtion:** 
Overwrite the file given in this archive, to 
`resources/scripts/components/server/files/UploadButton.tsx`
`resources/scripts/helpers.ts`

**Manual Installation:**
1. Open file `resources/scripts/components/server/files/UploadButton.tsx`
below `import { WithClassname } from '@/components/types';`, add
`import { bytesToHuman } from "@/helpers";`

2. On the same file, below `const [loading, setLoading] = useState(false);`
add `const [upload, setUpload] = useState({ size: 0, totalSize: 0, progress: 0 });`

3. On the same file, `headers` comma
```react
headers: {
    'Content-Type': 'multipart/form-data',
}, //<!-- this comma, paste here the below onUploadProgress
onUploadProgress: (progressEvent: ProgressEvent) => {
    const size = progressEvent.loaded;
    const totalSize = progressEvent.total;
    const progress = Math.round((progressEvent.loaded / progressEvent.total) * 100);
    setUpload({ size, totalSize, progress });
},
```

4. On the same file, at `<SpinnerOverlay visible={loading} size={'large'} fixed></SpinnerOverlay>` replace it with
```react
<SpinnerOverlay visible={loading} size={'large'} fixed>
    <span css={tw`mt-4`}>Uploaded {bytesToHuman(upload.size)} of {bytesToHuman(upload.totalSize)} ({upload.progress}%)</span>
</SpinnerOverlay>
```

5. Open file ressources/scripts/helper.ts at the very bottom of the code, enter the code below


```export function bytesToHuman(bytes: number, si=true, dp=1): string {
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
```
---

You can check with the node -v command if you have installed NodeJS v16.  
Any higher version won't work, so you can use nvm or normal nodejs.

1. cd /var/www/pterodactyl
2. npm install -g yarn
3. yarn
4. yarn build:production

**Contact**

`Discord: Achul123`
`Github:https://github.com/achul123`
`Github:https://github.com/Lefraudeur/`