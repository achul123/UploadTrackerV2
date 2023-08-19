!/bin/bash

sudo apt update
sudo apt install -y nodejs npm git

npm install -g yarn

cd /var/www/pterodactyl
yarn

UPLOAD_BUTTON_FILE="resources/scripts/components/server/files/UploadButton.tsx"
echo "import { bytesToHuman } from \"@/helpers\";" >> "$UPLOAD_BUTTON_FILE"
echo "const [upload, setUpload] = useState({ size: 0, totalSize: 0, progress: 0 });" >> "$UPLOAD_BUTTON_FILE"
echo "onUploadProgress: (progressEvent: ProgressEvent) => {" >> "$UPLOAD_BUTTON_FILE"
echo "const size = progressEvent.loaded;" >> "$UPLOAD_BUTTON_FILE"
echo "const totalSize = progressEvent.total;" >> "$UPLOAD_BUTTON_FILE"
echo "const progress = Math.round((progressEvent.loaded / progressEvent.total) * 100);" >> "$UPLOAD_BUTTON_FILE"
echo "setUpload({ size, totalSize, progress });" >> "$UPLOAD_BUTTON_FILE"
echo "}," >> "$UPLOAD_BUTTON_FILE"
echo "..." >> "$UPLOAD_BUTTON_FILE"

HELPERS_FILE="resources/scripts/helpers.ts"
cat <<EOT >> "$HELPERS_FILE"
export function bytesToHuman(bytes: number, si=true, dp=1): string {
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
EOT

yarn build:production

echo "Installation and modifications completed!"
