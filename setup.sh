git init project-a
git init project-b
git init project-merge
pushd project-a
> filea echo "initial content"
git add .
git commit -m "initial revision"
> filea echo "new content"
git commit -am "new version"
popd
pushd project-b
> fileb echo "initial content"
git add .
git commit -m "start"
> fileb echo "update"
git commit -am "continue"
popd

cd project-merge

touch root
git add root
git commit -m "need a commit"


