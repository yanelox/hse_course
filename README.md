# Презентации курса на Marp

Ветка **`dev`** — для работы: [Markdown](slides/marp-demo.md),
[общая CSS-тема](slides/theme.css) и учебные исходники.
Ветка **`main`** — для публикации PDF.

## Правки и сборка

Нужны Node.js 18+ и один из браузеров: Firefox, Chrome, Chromium или Edge.
Из корня репозитория выполните:

```sh
git switch dev
npm ci
npm run preview
```

Откройте [предпросмотр](http://localhost:8080/marp-demo.md). После сохранения
`slides/marp-demo.md` страница обновится. Для редактирования в VS Code
можно установить **Marp for VS Code** (`marp-team.marp-vscode`), добавить
`./slides/theme.css` в настройку `markdown.marp.themes` и открыть предпросмотр
Markdown (`Ctrl+K`, затем `V`).

Слайды разделяются строкой `---`. Новый файл `slides/<имя>.md` можно начать
с настроек в начале `marp-demo.md`. Команда сборки:

```sh
npm run build
```

Результат — `pdf/marp-demo.pdf`. Каждый файл из `slides/` собирается в
одноимённый PDF. В `dev` папка `pdf/` игнорируется Git.

## Публикация

Закоммитьте правки исходника в `dev` и соберите PDF. В `main` переносите
только PDF, не сливая ветку `dev` целиком. Например, из `dev`, когда
`main` не открыта в другой рабочей копии:

```sh
git worktree add ../hse-course-publish main
mkdir -p ../hse-course-publish/pdf
cp pdf/marp-demo.pdf ../hse-course-publish/pdf/marp-demo.pdf
git -C ../hse-course-publish add -- pdf/marp-demo.pdf
git -C ../hse-course-publish commit -m "Update Marp demo PDF"
git worktree remove ../hse-course-publish
```
