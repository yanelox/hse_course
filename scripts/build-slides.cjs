const { existsSync, readdirSync, readFileSync, writeFileSync } = require('node:fs');
const { join, resolve } = require('node:path');
const { spawnSync } = require('node:child_process');

const root = resolve(__dirname, '..');
const course = join(root, 'c-course');

function readNotes(source, notesPath) {
    const slides = readFileSync(source, 'utf8').replace(/\r\n/g, '\n')
        .split(/^---[ \t]*$/m).slice(2).filter((slide) => slide.trim());
    const titles = slides.map((slide) => slide.match(/^#\s+(.+)$/m)?.[1].trim());
    const notes = readFileSync(notesPath, 'utf8').replace(/\r\n/g, '\n');
    const sections = [...notes.matchAll(/^### (\d+)\. (.+)\n([\s\S]*?)(?=^#{1,3} |(?![\s\S]))/gm)];
    if (titles.length !== sections.length) {
        throw new Error(`${notesPath}: ${sections.length} sections for ${titles.length} slides`);
    }

    return sections.map(([, number, title, body], idx) => {
        if (Number(number) !== idx + 1 || title.trim() !== titles[idx] || !body.trim()) {
            throw new Error(`${notesPath}: check heading and text for slide ${idx + 1} (${titles[idx]})`);
        }
        return { idx, note: body.trim() };
    });
}

function main() {
    const requested = process.argv.slice(2);
    const topics = readdirSync(course, { withFileTypes: true })
        .filter((entry) => entry.isDirectory() && existsSync(join(course, entry.name, 'slides')))
        .map((entry) => entry.name).sort();
    for (const topic of requested) {
        if (!topics.includes(topic)) throw new Error(`Unknown slide topic: ${topic}`);
    }

    for (const topic of requested.length ? requested : topics) {
        const folder = join(course, topic);
        const slides = join(folder, 'slides');
        const sources = readdirSync(slides).filter((name) => name.endsWith('.md')).sort();

        for (const name of sources) {
            const base = name.slice(0, -3);
            const source = join(slides, name);
            const notesPath = join(folder, 'notes', name);
            const pages = existsSync(notesPath) ? readNotes(source, notesPath) : null;

            const pdf = join(folder, `${base}.pdf`);
            const result = spawnSync(process.execPath, [join(__dirname, 'marp.cjs'), source,
                '--pdf', '--output', pdf], { cwd: root, stdio: 'inherit' });
            if (result.error) throw result.error;
            if (result.status !== 0) throw new Error(`Marp failed for ${name}`);

            if (pages) {
                const sidecar = join(folder, 'notes', `${base}.pdfpc`);
                writeFileSync(sidecar, JSON.stringify({ pdfpcFormat: 2, pages }, null, 2) + '\n');
            }
        }
    }
}

try {
    main();
} catch (error) {
    console.error(error.message);
    process.exitCode = 1;
}
