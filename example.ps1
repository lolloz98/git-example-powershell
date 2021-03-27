echo "repo_remota simulates a remote repository (e.g. the one that you might have on github)"

mkdir repo_remota
cd .\repo_remota\
git init --bare

echo "I clone the repo in repo_locale"
cd ..
git clone .\repo_remota\ repo_locale

echo "I clone the repo in repo_locale_2"
git clone .\repo_remota\ repo_locale_2

echo "I create file 1 in repo 1, add, commit and push it on repo_remota"
cd repo_locale_2
echo "new file" | Set-Content -Encoding utf8 1.txt
git add .
git commit -m "commit 1. from repo_locale_2"
git push

echo "I pull from repo_locale. Since file 1 is new in repo_remota (and it is not in repo_locale), it is added to repo_locale."
cd ..\repo_locale\
git pull

echo "I modify file 1, add, commit and push the changes"
echo "blabla in locale" | Set-Content -Encoding utf8 1.txt
git add .
git commit -m "modified 1.txt in repo_locale"
git push

cd ..\repo_locale_2\ 
echo "sono bello e in locale 2" | Set-Content -Encoding utf8 1.txt

git add .
git commit -m "modified 1.txt in repo_locale_2"

echo "I modified file 1, I am not up-to-date with the repo_remota. If I push or pull pm locale_2 -> CONFLICT TO BE SOLVED"
git pull

echo "Since we have a merge conflict with a file encoded with utf8, file 1 in locale_2 has markers to help us choose which version of the file we want to keep. We must solve the conflicts by hand. After that we have to add, commit and push the changes."
echo "Use `type 1.txt` to look at the content of file 1."
echo "ho deciso che risolvo il conflitto cambiando il contenuto del file arbitrariamente" | Set-Content -Encoding utf8 1.txt
git add .
git commit -m "merge conflict on file 1 solved"

git push

echo "Update locale 1 by pull. No conflicts, because file 1 has not been modified after pushing"
cd ..\repo_locale\ 
git pull

echo "create file 2"
echo "ehi, new file" | Set-Content -Encoding utf8 2.txt

git add . 
git commit -m "file 2 added from repo_locale"
git push

echo "I create file 3, add, commit and pull. Since file 2 does not exist in locale_2, it is added to locale 2 BUT no conflict because file 2 was not locale_2"
cd ..\repo_locale_2\ 
echo "create file 3"
echo "just created the third" | Set-Content -Encoding utf8 3.txt

git add . 
git commit -m "file 2 added from repo_locale"
git pull

git push

echo "Pull from locale 1 to keep up-to-date. I get file 3 in locale 1"
cd ..\repo_locale\ 
git pull

echo "I create file 4 and file 5 and add, commit and push."
echo "file 4 from repo_locale" | Set-Content -Encoding utf8 4.txt
echo "file 5 from repo_locale" | Set-Content -Encoding utf8 5.txt
git add .
git commit -m "file 4 and 5 from locale 1"
git push

echo "I create file 4 in locale_2, I don't add it to the stage area and I pull. Pull command fails (It should override an untracked file. It does not even pull file 5)"
cd ..\repo_locale_2\ 
echo "in locale 2, file 4 lalala" | Set-Content -Encoding utf8 4.txt
git pull

echo "I delete file 4.txt. Now I can pull. To do so, I add it and delete it using git commands (I could simply do `del 4.txt` instead)"
git add 4.txt
git rm -f 4.txt

git pull

echo "If I want to delete a committed file I can use git rm. In this case I do not need to add the changes to stage (they are already added), I just need to commit"
git rm .\5.txt
git commit -m "file 5 deleted"
git push

echo "Pull from locale 1 to keep up-to-date. I get file 3 in locale 1"
cd ..\repo_locale\ 
git pull
