DATE=$(date +%Y-%m-%d)

git status

echo -ne "确认？ [y/n] "

read confirm
if [ "$confirm" != "y" ]; then
    echo "中止 ."
    exit 0
fi

git add -A

git commit -m "bkup@$DATE"

git push