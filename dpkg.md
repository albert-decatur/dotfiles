# great packages available in apt repos 
#### tested on Ubuntu 16.04  
  
* these tools focus on simplicity and low overhead  
 * command line for the win  
* packages typically installed with npm, pip, cpan not listed here  
  
### version control  
git-core  
tig # ncurses git interface  
  
### install things on a thing!  
aptitude # 'aptitude install' can save you!  
npm  
python-pip  
  
### get files  
axel # download faster. try 'axel -n 20 example.com/bigFile'. for real  
rsync # remote delta copy. try it with inotify!  
curl # do anything over any protocol (not quite but nearly)  
wget  
lftp # great for conditional batch downloads from FTP  
rtorrent  
  
### check disk use  
gt5 # browse HTML of your disk use. great for finding big old files to delete. or maybe you prefer ncdu  
  
### network  
ufw # easy firewall  
fail2ban # or maybe the simpler denyhosts  
openssh-client  
openssh-server  
nmap # check if your ports are open  
iftop # monitor network traffic live  
nethogs # which processes are using the network most?  
iperf3 # network throughput test between two boxes you control  
mtr # trace / ping combo  
#tor-arm # monitor traffic on a tor node  
#atsar # silently collects system stats. or if you are super cool use collectd with statsd plugin  
vnstat # silently collects network traffic stats  
  
### fun! and multimedia  
#imagemagick # image editing tool. or if you like forks use graphicsmagick  
#gifsicle  
#libav-tools # video editing  
feh # view images.  
#canto # CLI for feeds  
# avconv # for avplay, extremely lightweight video player, and also editing that replaces ffmpeg
#moc # music library in the command line  
#scrot # take screenshots. I know - gross name  
mtpaint # crazy simple GUI image editor  
#cmatrix # dumb and fun  
#ninvaders # fun but not dumb  
#flpsed # a WYSIWYG PDF and postscript editor 
  
### command line web browsers  
w3m # maybe you prefer the browser "links"  
w3m-img # images for w3m  
surfraw # better than a browser  
  
### data science / text munging  
mawk # fast awk  
jq # parse JSON fast  
python3-csvkit # use CVSs the Unix way with pipes 
pdftk # edit PDFs  
poppler-utils # edit PDFs  
#redis-server # key-value db  
#redis-tools # key-value db  
postgresql-9.5-postgis-2.2 # relational db, with GIS functions  
sqlite3 # relational db  
spatialite-bin # GIS for SQLite  
gnuplot # nice for quick plotting in terminal  
xmlstarlet # parse XML  
xsltproc # use XSLT. so convenient  
gnumeric # spreadsheet program great for converter "ssconvert"  
raptor-utils # turtle parsing.  you heard me. it is an RDF thing  
antiword # msoffice -> text  
odt2txt # openoffice -> text  
html2text # just simple  
  
### compression  
dtrx # automatically "Do The Right eXtraction"  
p7zip-full  
zip  
unzip  
unrar  
  
### user interface  
vim # text editor  
zsh # shell  
tmux # terminal multiplexer - more terminals!!  
detox # automatically fix bad file/directory names  
xclip # pipe to clipboard! or maybe you like [xsel](https://github.com/kfish/xsel)  
htop # monitor system processes  
suckless-tools # includes slock, simple screen locker  
mupdf # pdf viewer - might want evince instead  
mutt # email client. [alpine](https://en.wikipedia.org/wiki/Alpine_(email_client)) is a lot simpler  
getmail4 # backup email in maildir  
hunspell # spellcheck CLI  
gnupg2 # encrypt / decrypt with keys and password  
pinentry-curses # for gnupg2  
paperkey # helps preserve GPG secret key on paper!  
dcfldd # like dd but extra features  
bmap-tools # like dd but faster  
anacron # cron for boxes not up 24/7  
nwipe # wipe devices  
pv # see progress of a pipe. I know you're impatient  
  
### essentials - minimal systems sometimes do not come with these  
build-essential  
at  
man  
lsof  
strace  
parted  
gparted  
python-dev  
python-setuptools  
pkg-config  
ascii # ASCII lookup table  
  
  
### these will not install using the README command but they are cool  
 python-numpy # code depending on numpy install often has trouble installing numpy itself  
 i3 # tiled window manager  
 kpcli # keepass CLI  # and libreadline-dev for cpan Term::ReadLine::Gnu  
 libwebkit-dev # compiling browsers from source often needs this  
 moreutils # sponge is super convenient. however, it will mess with your GNU parallel install because it also has a command named "parallel"  
 keychain # enter SSH passphrase once, use many times eg in terminal multiplexer 
