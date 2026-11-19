# Презентации курса на Marp

Ветка **`dev`** — все материалы семинаров. Ветка **`main`** — только PDF со слайдами.

```text
c-course/<тема>/
├── slides/      # исходники Marp
├── notes/       # сценарии докладчика и файлы pdfpc
├── livecoding/  # задания, код и тесты
└── *.pdf        # готовые слайды
```

## Правки и сборка

Нужны Node.js 18+ и один из браузеров: Firefox, Chrome, Chromium или Edge.
Из корня репозитория выполните:

```sh
git switch dev
npm ci
npm run preview
```

Откройте [предпросмотр](http://localhost:8080/pointer-arrays.md). После сохранения
`c-course/pointer-arrays/slides/pointer-arrays.md` страница обновится.

Для предпросмотра в VS Code откройте **корень репозитория** и установите
**Marp for VS Code** (`marp-team.marp-vscode`). В локальном
`.vscode/settings.json` добавьте настройку рабочего пространства:

```json
{
  "markdown.marp.themes": ["./slides/theme.css"]
}
```

Откройте слайд командой **Markdown: Open Preview to the Side**. Если
предпросмотр уже был открыт, откройте его заново. Настройка темы в
`.marprc.yml` применяется при запуске Marp CLI.

Слайды разделяются строкой `---`. Настройки нового файла можно взять из
[примера](c-course/marp-demo/slides/marp-demo.md). Общая [тема `hse-course`](slides/theme.css)
выделяет `*важный термин*` синим цветом. На титуле — без даты и номера семинара.

```sh
npm run build
npm run build -- pointer-arrays # только одна тема
```

Сборка берёт Marp-файлы из `c-course/<тема>/slides/` и сохраняет одноимённые PDF непосредственно в папку темы. Если есть `notes/<имя>.md`, она также проверяет соответствие заголовков и номеров слайдам и обновляет `notes/<имя>.pdfpc`.

### Указатели и массивы

- [Теория](c-course/pointer-arrays/pointer-arrays.pdf) · [Исходник](c-course/pointer-arrays/slides/pointer-arrays.md) · [Сценарий](c-course/pointer-arrays/notes/pointer-arrays.md).
- [Практика](c-course/pointer-arrays/pointer-arrays-practice.pdf) · [Исходник](c-course/pointer-arrays/slides/pointer-arrays-practice.md) · [Заметки](c-course/pointer-arrays/notes/pointer-arrays-practice.md) · [Тесты и сборка](c-course/pointer-arrays/livecoding/README.md).

## Показ в pdfpc

На Ubuntu / Debian: `sudo apt install pdf-presenter-console`. Для показа настройте второй экран как расширение рабочего стола.

```sh
pdfpc -R c-course/pointer-arrays/notes/pointer-arrays.pdfpc c-course/pointer-arrays/pointer-arrays.pdf
```

Для практики замените в обоих путях имя файла на `pointer-arrays-practice`. Ключи:

| Команда / клавиша | Действие |
| --- | --- |
| `-s` | Поменять местами экран докладчика и проектор |
| `-S` | Репетиция на одном экране |
| `-d 80` | Обратный отсчёт на 80 минут |
| `←` / `→` | Предыдущий / следующий слайд |
| `Tab`, `g` | Обзор слайдов, переход к номеру |
| `b`, `h` | Затемнить экран аудитории или скрыть окно показа для лайвкодинга; повторное нажатие возвращает показ |
| `Ctrl+N` | Правка заметки в pdfpc, `Esc` завершает редактирование |

pdfpc читает заметки из файла `.pdfpc`, переданного через `-R`. Для постоянных правок редактируйте `notes/<имя>.md`: при сборке файл `.pdfpc` генерируется заново. Каждому слайду с заголовком `# Название` соответствует раздел заметок `### N. Название`, нумерация начинается с титула. В PDF для аудитории заметки не встраиваются. [Руководство pdfpc](https://manpages.ubuntu.com/manpages/noble/man1/pdfpc.1.html).

## Публикация

В `main` копируем только проверенные PDF в соответствующую папку темы; ветку `dev` целиком не сливаем. Для переноса можно использовать отдельное рабочее дерево:

```sh
git worktree add ../hse-course-publish main
mkdir -p ../hse-course-publish/c-course/pointer-arrays
cp c-course/pointer-arrays/*.pdf ../hse-course-publish/c-course/pointer-arrays/
```

Коммиты — только после явного разрешения пользователя.
