"'-------------------------
" Базовые настройки
"-------------------------
" Включаем несовместимость настроек с Vi (ибо Vi нам и не понадобится).
set nocompatible

" Показывать положение курсора всё время.
set ruler  

" Показывать незавершённые команды в статусбаре
set showcmd  

" Включаем нумерацию строк
set nu

" Текст вставляется с сохранением отступа
" set nppaste
set paste

" Настраиваем к-во символов пробелов, для таб.
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smarttab
set noet

" Переносим длинные строки
set wrap

"Включаем автоотступы для новых строк, а так же делаем перенос в стиле Си
set ai
set cin

"Настраиваем подсветку результатов поиска и совпадения скобок
set showmatch
set hlsearch
set incsearch
set ignorecase

" Выключаем надоедливый "звонок"
set noerrorbells
set novisualbell
set t_vb=   
set tm=500

" Отключение функционала мыши вне графического режима.
if !has('gui_running')
	set mouse= 
endif

" Не выгружать буфер, когда переключаемся на другой
" Это позволяет редактировать несколько файлов в один и тот же момент без необходимости сохранения каждый раз
" когда переключаешься между ними
set hidden

"Устанавливаем историю на 700 линий.
set history=700

"Включаем автообновление документа, если он был изменен извне
set autoread

"Переназначаем кнопку пользовательских функций на запятую
let mapleader = ","
let g:mapleader = ","

"Быстрое сохранение
nmap <leader>w :w!<cr>

"Включаем классную менюшку
set wildmenu
set wildmode=list:longest,full

"устанавливаем высоту сомандного бара 
set cmdheight=2

"заставляем backspace работать так, как нужно
set backspace=eol,start,indent
set whichwrap+=<,>,[,]

"Устанавливаем ленивую перерисовку при отработке макросов
set lazyredraw

"Более привычные регулярки, для них нужна магия ^_^
set magic

"подсвечиваем скобки, когда на них курсор
set showmatch

"""""""""""""""""""""""""""""
" Всякая подсветкая 
" и шрифты
"""""""""""""""""""""""""""""

" Разные шрифты в разных системах.
if has('gui')
"	colorscheme darkblue 
	if has('win32')
		set guifont=Lucida_Console:h12:cRUSSIAN::
	else
		set guifont=Terminus\ 14
	endif
endif

"Включаем подсветку синтакса
syntax enable
set background=dark
colorscheme desert

"Вырубаем нафиг в гуях всякое
if has('gui')
	set guioptions-=T
	set guioptions+=e
	set t_Co=256
	set guitablabel=%M\ %t
endif

" Порядок применения кодировок и формата файлов
set ffs=unix,dos,mac
set fencs=utf-8,cp12.51,koi8-r,ucs-2,cp866

" умолчальная кодировка utf8
set encoding=utf8
set fileencodings=utf8,cp1251

"включаем фолдинг (сворачивание блоков) и делаем его ручным, 
"а так же устанавливаем размер колноки для плюсиков(блок свернут)
set foldmethod=manual
set foldcolumn=2

"Отключаем временные файлы кроме бэкапов
set backup
set nowb
set noswapfile

" сохранять умные резервные копии ежедневно
function! BackupDir()
    " определим каталог для сохранения резервной копии
    let l:backupdir=$HOME.'/.vim/backup/'.
            \substitute(expand('%:p:h'), '^'.$HOME, '~', '')

    " если каталог не существует, создадим его рекурсивно
    if !isdirectory(l:backupdir)
        call mkdir(l:backupdir, 'p', 0700)
    endif

    " переопределим каталог для резервных копий
    let &backupdir=l:backupdir

    " переопределим расширение файла резервной копии
    let &backupext=strftime('~%Y-%m-%d~')
endfunction

" выполним перед записью буффера на диск
autocmd! bufwritepre * call BackupDir()

""""""""""""""""""""""
" Упрощаем жизнь 
" мапы для перемещний и прочего
""""""""""""""""""""""

"Шняга для поиска в визуальном режиме, удобная. * и # для поиска выделенного далее по тексту
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

"Назначим <SPACE> для поиска и Ctrl-<SPACE> для обратного поиска
map <space> /
map <c-space> ?

"Упрощение перемещения между сплитами
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

"Оперируем табами с помощью <leader>:
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove

"Открываем проводник для этой директории в новом табе
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Задаем собственные функции для назначения имен заголовкам табов -->
     function MyTabLine()
         let tabline = ''

        " Формируем tabline для каждой вкладки -->
             for i in range(tabpagenr('$'))
                " Подсвечиваем заголовок выбранной в данный момент вкладки.
                 if i + 1 == tabpagenr()
                     let tabline .= '%#TabLineSel#'
                 else
                     let tabline .= '%#TabLine#'
                 endif

                " Устанавливаем номер вкладки
                 let tabline .= '%' . (i + 1) . 'T'

                " Получаем имя вкладки
                 let tabline .= ' %{MyTabLabel(' . (i + 1) . ')} |'
             endfor
        " Формируем tabline для каждой вкладки <--

        " Заполняем лишнее пространство
         let tabline .= '%#TabLineFill#%T'

        " Выровненная по правому краю кнопка закрытия вкладки
         if tabpagenr('$') > 1
             let tabline .= '%=%#TabLine#%999XX'
         endif

         return tabline
     endfunction

     function MyTabLabel(n)
         let label = ''
         let buflist = tabpagebuflist(a:n)

        " Имя файла и номер вкладки -->
             let label = substitute(bufname(buflist[tabpagewinnr(a:n) - 1]), '.*/', '', '')

             if label == ''
                 let label = '[No Name]'
             endif

             let label .= ' (' . a:n . ')'
        " Имя файла и номер вкладки <--

        " Определяем, есть ли во вкладке хотя бы один
        " модифицированный буфер.
        " -->
             for i in range(len(buflist))
                 if getbufvar(buflist[i], "&modified")
                     let label = '[+] ' . label
                     break
                 endif
             endfor
        " <--

         return label
     endfunction

     function MyGuiTabLabel()
         return '%{MyTabLabel(' . tabpagenr() . ')}'
     endfunction

     set tabline=%!MyTabLine()
     set guitablabel=%!MyGuiTabLabel()
" Задаем собственные функции для назначения имен заголовкам табов <--

" Возвращает к последней позиции при открытии буфера
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
	      \   exe "normal! g`\"" |
		       \ endif

"всегда показывать status line
set laststatus=2

"форматирование status line
"set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l
set statusline=%<%f%h%m%r%=format=%{&fileformat}\ file=%{&fileencoding}\ enc=%{&encoding}\ %1*%{CurTime()}%*\ %b\ 0x%B\ %l,%c%V\ %P
"функция для вывода времени в строке состояния.
fun! CurTime()
	let ftime=""
	let ftime=ftime." ".strftime("%H:%M:%S")
	return ftime
endf

"задаем правила поиска для всяких поисковых команд: gf, [f, ]f, ^Wf, :find, :sfind, :tabfind и других
set path=.,,**

" Делаем файлы сценариев исполняемыми
au BufWritePost * if getline(1) =~ "^#!.*/bin/"|silent !chmod u+x %|endif

