#### 概要

Ubuntu 20.04 にrbenv を載せて、rbenv経由でruby 3.1.0 を突っ込んだもの。rbenv は${HOME}.rbeenv/ にまとめて入れてある

#### データを消さない使い方

1. Dockerfile とお文字ディレクトリで `mkdir -p dockers/fjordbootcamp/{data,conf}` を実行して
2. `ln -s ${HOME}/.ssh .ssh` を実行
3. ビルド `docker build -t <イメージ姪>:<タグ>`
4. コンテナの実行
```
docker run -it --rm --mount type=bind,source=${PWD}/data,destination=${PWD}/data \
               --mount type=bind,source=${PWD}/conf/.ssh,destination=${PWD}/.ssh \
               <イメージ名>:<タグ>



