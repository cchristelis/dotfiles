

key()
{
  pwgen -cnB ${1:-8}
}

password()
{
  pwgen -cnyB ${1:-15}
}

pc()
{
  pandoc -s --standalone --toc -f markdown --highlight-style zenburn --template ~/dotfiles/pandoc/template.html -t html "$1" | sed 's/<table/<table class=\"table\"/' > "${1%.*}.html"
}

pc_print()
{
  pandoc -s --standalone --toc -f markdown --highlight-style haddock --template ~/dotfiles/pandoc/template.html -t html "$1" | sed 's/<table/<table class=\"table\"/' > "${1%.*}.html"
}

fetch_markdown()
{
  curl --data "read=1" --data "u=$1" "http://fuckyeahmarkdown.com/go/"
}

convertTime()
{
  date -d @$(echo $1) +"%Y-%m-%d %T"
}

convertMilli()
{
  convertTime $(echo $1 | rev | cut -c 4- | rev)
}

print_all_them_colors()
{
  for x in 0 1 4 5 7 8; do
    for i in `seq 30 37`; do
      for a in `seq 40 47`; do
        echo -ne "\e[$x;$i;$a""m\\\e[$x;$i;$a""m\e[0;37;40m "
      done
      echo
    done
  done
  echo ""
}

tmp()
{
  if [ -d "$HOME/tmp" ]; then
    cd "$HOME/tmp"
  else
    if [ -d "$TMPDIR" ]; then
      cd "$TMPDIR"
    else
      cd /tmp
    fi
  fi
  pwd
}

tm()
{
  convertMilli $1 | pbcopy
}

t()
{
  convertTime $1 | pbcopy
}

line()
{
  printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
}

pip3_install()
{
  pip3 install --user --upgrade -r ~/dotfiles/requirements-main.txt
}

pip3_install_extra()
{
  pip3 install --user --upgrade -r ~/dotfiles/requirements-extra.txt
}

last_monday()
{
  date -d'last week last monday' +%Y-%m-%d
}

last_sunday()
{
  date -d'last sunday' +%Y-%m-%d
}

get_ip_for_host()
{
  for f in "$@"; do
    echo "$f"
    answer="$(curl -s "https://1.1.1.1/dns-query?ct=application/dns-json&name=$f")"
    if [[ "$(echo "$answer" | jq -r '.Status')" == "0" ]]; then
      echo "$answer" | jq -r '.Answer[] | .data' | sort -u
    else
      echo "Error finding IP:"
      echo "$answer"
    fi
  done
}

compress_dir()
{
  tar -cv $1/ | gzip -9 > archive.tar.gz
}

load_avg()
{
  uptime | rev | cut -d' ' -f1,2,3 | rev
}

filesize()
{
  for f in "$@"; do
    echo "$f => $(stat --printf="%B\n" "$f" | nft)"
  done
}

get_tweets()
{
  curl -s "https://twitrss.me/twitter_user_to_rss/?user=$1" | xq '.rss.channel.item[]' | jq -c .
}

get_random_tweet()
{
  get_tweets $1 | sort -R | head -n1 | jq -r '.title'
}

timestamp()
{
  if [[ $# -eq 0 ]]; then
    date "+%s"
  else
    for d in "$@"; do
      s="$d"
      if [[ ${#s} -gt 10 ]]; then
        s="$(echo $d | rev | cut -c 4- | rev)"
      fi
      date -d @$s +"%Y-%m-%d %T"
    done
  fi
}

do_merge()
{
  filename=$(basename -- "$1")
  extension="${filename##*.}"
  filename="${filename%.*}"
  base="$1"
  convert $@ -background black -flatten "output.$extension"
}