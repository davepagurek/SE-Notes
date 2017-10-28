# SE Notes
Notes for UW Software Engineering.

## Overview
Write notes in **Markdown** with embedded **LaTeX.** When you push to `develop`, get CircleCI to render HTML pages using a small Ruby script and Pandoc, and then push the results to a Github Pages branch.

## Setup

### File structure
Each folder that contains Markdown files will get its own index in the rendered site. I tend to use one folder per course. Inside a course folder, I also make an `img` directory that just has images I use in my notes that I then reference with a relative path (e.g. `<img src="img/some_image.png" />`).

### Local editing
I use Vim to edit my files. I use <a href="https://github.com/davepagurek/markdown-preview.vim">my fork of markdown-preview</a> to create a Markdown preview with MathJax support, only refreshed on save. Here's a snippet from my `.vimrc`:

```vim
" In Vundle setup
Plugin 'iamcco/mathjax-support-for-mkdp'
Plugin 'davepagurek/markdown-preview.vim'
Plugin 'drmingdrmer/vim-syntax-markdown'

" Markdown preview config

" Only refresh preview on save (default is every edit, jumps around too much for my liking
let g:mkdp_refresh_on_save = 1

" Use Safari for preview (feel free to change to Chrome)
let g:mkdp_path_to_chrome = "open -a Safari"

" Use <Leader>mm to launch preview, <Leader>mn to close
nmap <silent> <Leader>mm <Plug>MarkdownPreview
nmap <silent> <Leader>mn <Plug>StopMarkdownPreview

" Enable MathJax
let g:vim_markdown_math = 1
```

For illustrations, I use <a href="https://paintbrush.sourceforge.io">Paintbrush</a>, an mspaint clone for Mac. I have also had to disble BetterTouchTool for Paintbrush in Sierra to prevent it from thinking there are extra clicks happening.

### Hosting

1. Make a `develop` branch
2. Set up Github Pages for `master`
3. Set up CircleCI for the project
4. Authorize CircleCI to push to Github on your behalf: https://circleci.com/docs/2.0/gh-bb-integration/
5. Add a user key from here: https://circleci.com/gh/youraccount/yourrepo/edit#checkout
6. Change your Github email in `deploy.sh`
