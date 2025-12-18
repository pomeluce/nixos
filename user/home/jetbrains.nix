{
  config,
  pkgs,
  opts,
  ...
}:
{
  home.packages = with pkgs; [
    (jetbrains.idea-ultimate.override {
      forceWayland = true; # fixed cursor theme
    })
  ];

  home.file.".jebrains/idea.vmoptions".text = ''
    ${builtins.readFile "${pkgs.jetbrains.idea-ultimate}/idea-ultimate/bin/idea64.vmoptions"}
    --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED
    --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED
    -javaagent:${opts.devroot}/env/agent/netfilter/ja-netfilter.jar=jetbrains
  '';

  home.sessionVariables = {
    IDEA_VM_OPTIONS = "${config.home.homeDirectory}/.jebrains/idea.vmoptions";
  };

  home.file.".ideavimrc".text = ''
    " 插件配置
    Plug 'tpope/vim-surround'
    Plug 'preservim/nerdtree'
    Plug 'easymotion/vim-easymotion'
    Plug 'terryma/vim-multiple-cursors'

    " 基础配置
    " 设置回到 normal 模式时自动切换英文输入法, 进入 insert 模式自动恢复(需要下载插件 ideavim_extension )
    let rime_ascii = 1
    set keep-english-in-normal-and-restore-in-insert
    set showcmd
    set clipboard=unnamed
    set clipboard+=unnamedplus
    set clipboard+=ideaput
    set hlsearch
    set incsearch
    set ignorecase
    set smartcase
    set timeoutlen=500
    set wildmenu
    set viminfo=!,'10000,<50,s10,h
    set scrolloff=50
    set sidescrolloff=50
    set number
    set relativenumber
    set history=100
    set notimeout
    set NERDTree
    set multiple-cursors
    let mapleader=" "

    " 基本键位
    nnoremap s <nop>
    nnoremap ; \:
    vnoremap ; \:
    nnoremap S :action SaveAll<cr>
    nnoremap Q :q!<cr>
    vnoremap p "_dhp
    nnoremap <M-a> ggVG
    nnoremap <M-s> vi{

    " 插入模式下光标移动
    inoremap <M-h> <left>
    inoremap <M-j> <down>
    inoremap <M-k> <up>
    inoremap <M-l> <right>

    " 窗口配置
    nnoremap sv :vs<cr>
    nnoremap sp :sp<cr>
    nnoremap sc <C-w>c
    nnoremap so <C-w>o
    nnoremap <C-h> <C-w>h
    nnoremap <C-l> <C-w>l
    nnoremap <C-j> <C-w>j
    nnoremap <C-k> <C-w>k
    nnoremap <C-Space> <C-w>w
    nnoremap s. :vertical resize+20<cr>
    nnoremap s, :vertical resize-20<cr>
    nnoremap sj :res +10<cr>
    nnoremap sk :res -10<cr>
    nnoremap ss :bn<cr>
    nnoremap <tab> :action NextTab<cr>
    nnoremap <S-tab> :action PreviousTab<cr>
    nnoremap <leader>c :q!<cr>

    " 代码跳转设置
    nnoremap gd :action GotoDeclaration<cr>
    nnoremap ge :action GotoNextError<cr>
    nnoremap gt :action GotoTest<cr>
    nnoremap gs :action GotoSuperMethod<cr>
    nnoremap gi :action GotoImplementation<cr>
    nnoremap ga '.
    nnoremap g; $a;<esc>

    " 光标移动
    nnoremap <C-M-k> :action MoveLineUp<cr>
    inoremap <C-M-k> :action MoveLineUp<cr>
    vnoremap <C-M-k> :action MoveLineUp<cr>
    nnoremap <C-M-j> :action MoveLineDown<cr>
    inoremap <C-M-j> :action MoveLineDown<cr>
    vnoremap <C-M-j> :action MoveLineDown<cr>

    " 代码连续缩进
    vnoremap < <gv
    vnoremap > >gv
    vnoremap <S-Tab> <gv
    vnoremap <Tab> >gv

    " 代码注释
    nnoremap <leader>/ :action CommentByLineComment<cr>
    vnoremap <leader>/ :action CommentByLineComment<cr>
    nnoremap <leader><leader>/ :action CommentByBlockComment<cr><esc>
    vnoremap <leader><leader>/ :action CommentByBlockComment<cr><esc>
    nnoremap <leader>d/ :action FixDocComment<cr>

    " find 配置
    nnoremap <leader>ff :action GotoFile<cr>
    nnoremap <leader>ft :action FindInPath<cr>
    nnoremap <leader>fw :action Find<cr>
    nnoremap <leader>fc :action GotoAction<cr>
    nnoremap <leader>fp :action RecentProjectListGroup<cr>

    " 重命名 格式化
    nnoremap <leader>rt :action Replace<cr>
    nnoremap <leader>rn :action RenameElement<cr>
    nnoremap <leader>fm :action ReformatCode<cr>\:action OptimizeImports<cr>
    nnoremap <leader><leader>fm :action ReformatWithPrettierAction<cr>

    " 折叠设置
    nnoremap zz : action CollapseRegion<cr>
    nnoremap <leader>zc :action ExpandAllRegions<cr>
    nnoremap <leader>zz :action CollapseAllRegions<cr>

    " 切换设置
    vnoremap th :action de.netnexus.CamelCasePlugin.ToggleCamelCase<cr>
    nnoremap td :action ToggleRenderedDocPresentation<cr>

    " 代码抽取
    vnoremap <leader>em :action ExtractMethod<cr>
    vnoremap <leader>ec :action IntroduceConstant<cr>
    vnoremap <leader>ef :action IntroduceField<cr>
    vnoremap <leader>ev :action IntroduceVariable<cr>

    " 项目显示
    nnoremap <leader>sh :action RecentProjectListGroup<cr>

    " 其他配置
    inoremap <C-Space> :action CodeCompletion<cr>
    nnoremap <C-T> :action Terminal.OpenInReworkedTerminal<cr>
    nnoremap T :action SelectInProjectView<cr>
    nnoremap <leader>nh :nohlsearch<cr>
    nnoremap <leader>ss :action FileStructurePopup<cr>
    nnoremap <leader>i f(a
    nnoremap <leader>; A;<esc>
    nnoremap <leader>np :action NewProjectOrModuleGroup<cr>
    nnoremap <leader>sw :action SurroundWith<cr>
    vnoremap <leader>sw :action SurroundWith<cr>
    nnoremap <leader>gc :action Generate<cr>
    vnoremap <leader>gc :action Generate<cr>
    nnoremap <F5> :action RunClass<cr>
    nnoremap <leader>tr :action Translation.EditorTranslateAction<cr>
    vnoremap <leader>tr :action Translation.EditorTranslateAction<cr>
  '';
}
