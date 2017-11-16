# Инструкция по установки swift на windows
Перед установкой обязательно установить MinGW-64, так как без него работать не будет. архитектуру при установке следует выбрать: `x86_64` потоки `win32` исключения `seh`. Версию можно скорей всего выбрать любую, но я ставил `7.2.0`.
Скачать mingw можно отсюда: https://sourceforge.net/projects/mingw-w64/
После чего надо прописать переменную окружения `GCC_SWIFT_HOME` = `C:\Program Files\mingw-w64\x86_64-7.2.0-win32-seh-rt_v5-rev0\mingw64`.


Чтобы установить нв windows7 swift3.1 нужно:
1. Зайти на github по ссылке ниже и скачать исполняемый файл: SwiftForWindows-1.6.exe
https://github.com/SwiftForWindows/SwiftForWindows/releases
2. Запустить испоняемый файл, и пройти стандартную процедуру установки
3. Зайти в папку в которую установился swift (по умолчанию `C:\Swift`) и запустить в этой папке скрипт: `setPath.bat`
4. Открыть command tools (cmd) или любой другой.
5. Написать там `swiftc --version`, если надпись будет начинаться так: `Swift version 3.1-dev...`, то установка прошла успешно, если нет идет дальше.
6. Заходим в переменые окружения (мой компьютер/Системные настройки/Другие настройки системы/Переменые окружения)
7. В переменных окружения находим `Path`, открываем его для изменения, переходим в самый конец, и прописываем: `C:\Swift\mingw64\bin;C:\Swift\wxWidgets-3.0.3\lib\gcc510TDM_x64_dll;C:\Swift\usr\lib\swift\mingw;C:\Swift\usr\bin` Обращаю внимание, что если путь до папки Swift был изменен, то его надо поменят
8. Переходим снова в command tools
9. Пишем там `swiftc --version` и он должен написать: `Swift version 3.1-dev...`
10. Если не написал, то или что-то было сделано не так, либо я чегото забыл когда сам ставил.

# Как пользоваться swift-cgdk?
swift-cgdk это аналог всех остальных cgdk, но написанный на swift.
В основе сокетного соединения лежит csimplesocket взятый из cpp-cgdk.

### Для того чтобы собрать проект на OSX нужно
1. Запустить проект `swift-cgdk.xcodeproj`
2. Скомпилировать
3. Запустить
Но так как мы работает с кросплатформенным swift надо запомнить важное правило: никаких `import` - использовать только то что есть из коробки.

### Для того чтобы собрать проект на windows нужно
1. Запустить скрипт `compile-swift-31.bat`
2. Подождать пока он все соберет.
3. На выходе получим файл MyStrategy.exe
4. Если скомпилировать не удалось, то в файле `compilation.log` будет информация почему, правда бывали случаи когда туда ничего не писалось, но не работало.

### Что нужно еще знать?
Так как swift не имеет функции rand(), то она была добавлена как проброска из С кода, и называется: `rand` или `rand32` - она кросплатформенная, то есть работает и на windows и на OSX. Также добавлен `srand`
Помимо этого есть: `sqrt`, `pow`, `sin`, `cos`, `tan`, `asin`, `acos`, `atan`, `atan2`, `log`, `log2`, `log10`, `exp`
P.S. `abs`, `min`, `max` на swift есть и так

### Послесловие
В принципе вы можете использовать предпроцессорные директивы и импортировать на каждой платформе разный функционал. Для windows есть `MinGWCrt` и возможно в следующем году нам повезет и будет даже `Foundation`.

Автор создавший SwiftForWindows активно продвигает его в основном репозитории apple, так что не исключена вероятность, что swift будет поддержан и на windows в дальнейших версиях.

Вообще на windows разрабатывать сложно - нету дебагинга и IDE, так что советую писать на OSX и перед закидывание на сервер проверять на windows работоспособность. Благо local-runner работает на всех системах.
