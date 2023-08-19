#!/bin/bash

sudo apt update
sudo apt install -y npm git

npm install -g yarn

cd /var/www/pterodactyltest
yarn

UPLOAD_BUTTON_FILE="resources/scripts/components/server/files/UploadButton.tsx"
cd "$UPLOAD_BUTTON_FILE"

# Step 2: Insert the modifications using sed
sed -i '/import { WithClassname } from/a import { bytesToHuman } from "@/helpers";' "$UPLOAD_BUTTON_FILE"
sed -i '/const \[loading, setLoading\] = useState(false);/a const \[upload, setUpload\] = useState({ size: 0, totalSize: 0, progress: 0 });' "$UPLOAD_BUTTON_FILE"
sed -i '/headers: {/a\    onUploadProgress: (progressEvent: ProgressEvent) => {\n        const size = progressEvent.loaded;\n        const totalSize = progressEvent.total;\n        const progress = Math.round((progressEvent.loaded / progressEvent.total) * 100);\n        setUpload({ size, totalSize, progress });\n    },' "$UPLOAD_BUTTON_FILE"
sed -i 's/<SpinnerOverlay visible={loading} size={'\''large'\''} fixed><\/SpinnerOverlay>/<SpinnerOverlay visible={loading} size={'\''large'\''} fixed>\n        <span css={tw`mt-4`}>Uploaded {bytesToHuman(upload.size)} of {bytesToHuman(upload.totalSize)} ({upload.progress}%)<\/span>\n    <\/SpinnerOverlay>/' "$UPLOAD_BUTTON_FILE"

echo "Modifications applied to $UPLOAD_BUTTON_FILE"

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
