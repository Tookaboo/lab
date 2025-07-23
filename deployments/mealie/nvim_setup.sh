#!/bin/bash

# Complete Neovim Setup Script
echo "🚀 Setting up Neovim with beautiful color schemes..."

# Install neovim
echo "📦 Installing Neovim..."
sudo apt update
sudo apt install -y neovim

# Create neovim config directories
echo "📁 Creating config directories..."
mkdir -p ~/.config/nvim/colors
mkdir -p ~/.config/nvim/backup
mkdir -p ~/.config/nvim/swap
mkdir -p ~/.config/nvim/undo

# Download color schemes
echo "🎨 Downloading color schemes..."
cd ~/.config/nvim/colors

# Gruvbox (warm, retro)
echo "  - Downloading Gruvbox..."
curl -sL -o gruvbox.vim https://raw.githubusercontent.com/morhetz/gruvbox/master/colors/gruvbox.vim

# Molokai (dark, vibrant)
echo "  - Downloading Molokai..."
curl -sL -o molokai.vim https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim

# Nord (cool, minimal)
echo "  - Downloading Nord..."
curl -sL -o nord.vim https://raw.githubusercontent.com/nordtheme/vim/develop/colors/nord.vim

# Dracula (purple/pink theme)
echo "  - Downloading Dracula..."
curl -sL -o dracula.vim https://raw.githubusercontent.com/dracula/vim/master/colors/dracula.vim

# One Dark (Atom-inspired)
echo "  - Downloading One Dark..."
curl -sL -o onedark.vim https://raw.githubusercontent.com/joshdick/onedark.vim/main/colors/onedark.vim

echo "✅ Color schemes downloaded!"

# Create the main init.vim configuration
echo "⚙️  Creating Neovim configuration..."
cat > ~/.config/nvim/init.vim << 'NVIMEOF'
" ===== NEOVIM CONFIGURATION FOR YAML DEVELOPMENT =====

" ===== BASIC SETTINGS =====
set number relativenumber       " Line numbers with relative
set expandtab                   " Use spaces instead of tabs
set shiftwidth=2               " 2 spaces for indentation
set tabstop=2                  " 2 spaces for tabs
set softtabstop=2              " 2 spaces for soft tabs
set autoindent                 " Auto indent
set smartindent                " Smart indent
set wrap                       " Wrap lines
set linebreak                  " Break at word boundaries
set scrolloff=8                " Keep 8 lines visible around cursor
set sidescrolloff=8            " Keep 8 columns visible
set signcolumn=yes             " Always show sign column
set updatetime=50              " Fast update time
set mouse=a                    " Mouse support
set clipboard=unnamedplus      " Use system clipboard
set hidden                     " Allow hidden buffers
set encoding=utf-8             " UTF-8 encoding

" ===== SEARCH SETTINGS =====
set hlsearch                   " Highlight search results
set incsearch                  " Incremental search
set ignorecase                 " Case insensitive search
set smartcase                  " Smart case (case sensitive if uppercase used)

" ===== FILE HANDLING =====
set backup                     " Enable backups
set backupdir=~/.config/nvim/backup//
set directory=~/.config/nvim/swap//
set undofile                   " Persistent undo
set undodir=~/.config/nvim/undo//
set autoread                   " Auto-reload files changed outside

" ===== VISUAL SETTINGS =====
set termguicolors              " True color support
set background=dark
set cursorline                 " Highlight current line
set showmatch                  " Show matching brackets
set colorcolumn=80             " Show column at 80 characters
syntax enable

" ===== COLOR SCHEME =====
" Choose one by uncommenting (try them all!):

colorscheme molokai             " Dark, vibrant (default)
" colorscheme gruvbox           " Warm, retro, easy on eyes
" colorscheme nord              " Cool, minimal, professional
" colorscheme dracula           " Purple/pink, very popular
" colorscheme onedark           " Atom-inspired, modern

" ===== STATUS LINE =====
set laststatus=2               " Always show status line
set statusline=%F%m%r%h%w\ [%Y]\ [%{&ff}]\ [%l,%v][%p%%]\ %{strftime('%H:%M')}

" ===== YAML SPECIFIC SETTINGS =====
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType yaml setlocal autoindent smartindent
autocmd FileType yaml setlocal cursorcolumn
autocmd FileType yaml setlocal foldmethod=indent
autocmd FileType yaml setlocal foldlevel=20

" YAML file detection
autocmd BufRead,BufNewFile *.yml,*.yaml,*.docker-compose.yml set filetype=yaml

" Show indentation for YAML
autocmd FileType yaml set list
autocmd FileType yaml set listchars=tab:│\ ,trail:•,extends:❯,precedes:❮,space:·

" ===== KEY MAPPINGS =====
let mapleader = ","

" Quick save/quit/exit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :wq<CR>
nnoremap <leader>Q :q!<CR>

" Clear search highlighting
nnoremap <leader>c :nohl<CR>

" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Better window management
nnoremap <leader>v :vsplit<CR>
nnoremap <leader>s :split<CR>

" Toggle folding with space
nnoremap <space> za

" ===== YAML VALIDATION =====
function! ValidateYAML()
    if &filetype == 'yaml'
        echo "Validating YAML..."
        let result = system('python3 -c "import yaml; yaml.safe_load(open(\"' . expand('%') . '\"))"')
        if v:shell_error == 0
            echo "✅ YAML is valid!"
        else
            echo "❌ YAML validation failed: " . result
        endif
    else
        echo "Not a YAML file"
    endif
endfunction

autocmd FileType yaml nnoremap <leader>v :call ValidateYAML()<CR>

" ===== YAML SNIPPETS =====
autocmd FileType yaml inoremap <leader>k key: value
autocmd FileType yaml inoremap <leader>l - item
autocmd FileType yaml inoremap <leader>d ---<CR>

" ===== FOLDING =====
set foldmethod=syntax
set foldlevelstart=10
set foldnestmax=10

" ===== QUALITY OF LIFE =====
" Remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Remember cursor position
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
NVIMEOF

# Create vim alias for neovim
echo "🔗 Creating vim alias for neovim..."
echo 'alias vim="nvim"' >> ~/.bashrc
echo 'alias vi="nvim"' >> ~/.bashrc
echo 'export EDITOR=nvim' >> ~/.bashrc

# Create a sample YAML file for testing
echo "📝 Creating test YAML file..."
cat > ~/sample.yaml << 'YAMLEOF'
# Sample Kubernetes YAML for testing neovim
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
  namespace: default
  labels:
    app: my-app
    version: v1.0.0
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: app
        image: nginx:1.21
        ports:
        - containerPort: 80
          name: http
        env:
        - name: ENV
          value: "production"
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 500m
            memory: 512Mi
---
apiVersion: v1
kind: Service
metadata:
  name: my-app-service
spec:
  selector:
    app: my-app
  ports:
  - port: 80
    targetPort: 8080
    protocol: TCP
  type: ClusterIP
YAMLEOF

echo ""
echo "🎉 Neovim setup complete!"
echo ""
echo "📋 Quick Reference:"
echo "   nvim ~/sample.yaml    - Open test file"
echo "   vim ~/sample.yaml     - Also opens with neovim"
echo ""
echo "⌨️  Key Bindings:"
echo "   ,w                    - Save file"
echo "   ,q                    - Quit"
echo "   ,x                    - Save and quit"
echo "   ,c                    - Clear search highlight"
echo "   ,v                    - Validate YAML"
echo "   Space                 - Toggle fold"
echo "   Ctrl+h/j/k/l         - Navigate windows"
echo ""
echo "🎨 Try different color schemes in nvim:"
echo "   :colorscheme gruvbox"
echo "   :colorscheme nord"
echo "   :colorscheme dracula"
echo "   :colorscheme onedark"
echo ""
echo "💡 To make a color scheme permanent:"
echo "   Edit ~/.config/nvim/init.vim and uncomment your favorite!"
