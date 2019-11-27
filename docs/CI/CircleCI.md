# CircleCI設定手順
ここではCircleCI上でRSpec、およびRubocopを実行させるまでの手順を説明します。

# ゴール
- ローカルcommitをremoteブランチにpushする度にCIが起動すること
- CIはすべての種類のRSpec、およびRubocopを実行すること
- 実行結果はそのブランチのPull Request上で閲覧できること
- 全てのテストをパスすると、アプリがHerokuにデプロイされること

# Bitbucketとの連携
BitbucketとCircleCIを連携させるための設定を行います。

まずは以下のURLにアクセスし、Bitbucket連携でSign Upしましょう。
https://circleci.com/signup/

画面左上のドロップダウンメニューにBitbucketのアイコンが付いたアカウント名が表示されていればOKです。
![configure ci with bitbucket](../images/CI/configure_ci_with_bitbucket.png)

次にpotepanecレポジトリをCIのビルド対象に追加する設定を行います。
画面左の`Add Projects`から、potepanecレポジトリ横にある`Set Up Project`を選択します。
![set up repo](../images/CI/setup_repo.png)

`config.yml`を追加するためのステップが表示されていますが、fork元の本家potepanecレポジトリでは既に`.circleci/config.yml`に追加されています。ファイルがあることを確認できれば、次のステップに進むために`Start building`を選択します。
![start building](../images/CI/start_building.png)

CircleCIが`.circleci/config.yml`に記載された手順に従ってビルドを開始する様子が確認できたでしょうか?

![jobs on circleci](../images/CI/jobs_on_circleci.png)

Pull Request を作成すると、CIの実行結果が画面上で確認できます。
![ci result on pr](../images/CI/ci_result_on_pr.png)

### 補足: `.circleci/config.yml`が見つからない方へ
forkした時期によってはこのファイルがまだ追加されていない可能性があります。

もしファイルが見つからない方は[最新の本家potepanecレポジトリ](https://bitbucket.org/potepancamp/potepanec/src/master/)から対象のファイルをコピーして、ご自身のレポジトリに追加してください。
追加する際は必ずルートディレクトリ配下に`.circleci/config.yml`という名前で保存するように注意してください。

# Herokuデプロイの準備
## 前提
[ローカルからHerokuにデプロイする設定](../deploy/heroku.md)を先に完了させておいてください。
CicleCIからHerokuにデプロイする前に、まずはローカルからHerokuにデプロイ出来るようにする必要があります。

# 手順
ここではCirckeCIでテストが通った後、自動的にHerokuにデプロイするための設定を行います。

まずCircleCIにHerokuの認証情報を追加しましょう。

HerokuのWebページにログインし、右上の自分のアイコンから`Account settings`を選択します。
![heroku personal](../images/CI/heroku_personal.png)

`API Key`セクションにある`Reveal`ボタンをクリックすると表示されるトークンをコピーしておきます。
![heroku apu key](../images/CI/heroku_api_key.png)

続いて、CircleCI上でpotepanecレポジトリ横にある歯車アイコンをクリックします。
![config gear](../images/CI/config_gear.png)

左メニューから`Environment Variable`を選択し、`Add Variables`ボタンをクリックするとポップアップが表示されます。

`Name`に`HEROKU_API_KEY`、`Value`に先ほどコピーしたHerokuのAPI Keyを入力し、`Add Variable`をクリックします。
![circleci_env_var](../images/CI/circleci_env_var.png)

次に[ローカルからHerokuにデプロイする設定](../deploy/heroku.md)で取得したAWSの認証情報を追加します。

同じようにCircleCIの歯車アイコンから`Add Variables`を選択し、`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`、という名前でそれぞれ環境変数を追加します。

以上で設定は完了です!

これでCircleCIからHerokuにデプロイする準備が整いました。
