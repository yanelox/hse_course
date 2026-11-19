const { mkdirSync } = require('node:fs');
const { resolve } = require('node:path');

// Snap Firefox cannot access browser profiles in the host's /tmp.
const temp = resolve(__dirname, '../.cache/marp');
mkdirSync(temp, { recursive: true });
process.env.TMPDIR = temp;

const { marpCli } = require('@marp-team/marp-cli');

marpCli(process.argv.slice(2)).then(
    (status) => { process.exitCode = status; },
    (error) => { console.error(error); process.exitCode = 1; },
);
