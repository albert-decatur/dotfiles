# great dpkgs available in apt  
#### tested on Ubuntu 14.04  

* packages typically installed with npm, pip, cpan forthcoming in separate lists  
* these packages are not shown because I like to compile their more recent versions from source
  * r-base-core
  * gdal-bin

### version control    
git-core     
tig # ncurses git interface    

### install things on a thing!    
aptitude # 'aptitude install' can save you!    
npm    
python-pip  

### get files    
axel # try 'axel -n 20 some_url.com/bigFile'. for real    
wget    
curl     
lftp    
rtorrent    

### disk use    
gt5 # seriously.  give it a try    

### network    
rsync     
ufw    
fail2ban # or maybe the simpler denyhosts   
openssh-client    
openssh-server    
nmap # see which ports are open    

### fun! and multimedia    
imagemagick # image editing tool    
gifsicle  
libav-tools # video editing tool    
feh # view images - might want [sxiv](https://github.com/muennich/sxiv) instead    
canto # CLI for feeds    
mpv # mplayer fork: watch videos, listen to music  
moc # music library in the command line    
scrot # take screenshots    
mtpaint # simple image editor with GUI    
cmatrix # dumb and fun    
ninvaders # fun but not dumb    

### web browsers    
w3m    
links    
surf # graphical!    
surfraw # better than a browser    

### data science / text munging    
mawk # fast awk    
jq # sed for JSON    
moreutils # sponge is super convenient    
pdftk # edit PDFs    
poppler-utils # edit PDFs    
redis-server # key-value db    
redis-tools # key-value db    
postgresql-9.3-postgis-2.1 # relational db, with GIS functions    
sqlite3 # relational db    
spatialite-bin # GIS for SQLite    
gnuplot # nice for quick plotting in terminal    
xmlstarlet # parse XML    
xsltproc # parse XML    
gnumeric # spreadsheet program great for converter "ssconvert"    
raptor-utils # turtle parsing.  you heard me    
antiword # msoffice -> text    
odt2txt # openoffice -> text    
html2text    
# python-numpy # code depending on numpy install often has trouble installing numpy itself  

### compression    
dtrx # automatically "Do The Right eXtraction"    
p7zip-full     
unzip     
unrar     

### user interface    
vim # text editor  
zsh # shell  
tmux # terminal multiplexer - more terminals!!   
terminator # heavier terminal but featureful  
i3 # tiled window manager  
# stterm # [simple terminal](http://st.suckless.org/)  
nodejs-dev   
detox # automatically fix bad file/directory names    
xclip # pipe to clipboard! or maybe you like [xsel](https://github.com/kfish/xsel)  
htop # better than top    
kpcli # keepass CLI    
slock # simple screen locker    
evince # pdf viewer - might want [mupdf](http://www.mupdf.com/)    
mutt # email client. [alpine](https://en.wikipedia.org/wiki/Alpine_(email_client)) is a lot simpler    
getmail4 # backup email in maildir    
hunspell # spellcheck CLI    
gnupg2 # encrypt / decrypt with keys and password    
anacron # cron for boxes not up 24/7    
nwipe # wipe devices  
pv # see progress of a pipe. I know you're impatient    

### essentials - minimal systems sometimes do not come with these    
build-essential    
python-dev python-pip  
python-setuptools  
pkg-config  
man    
# libwebkit-dev # compiling browsers from source often need this
ascii # ASCII lookup table    
