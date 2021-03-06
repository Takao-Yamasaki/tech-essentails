# 下記サービスについて説明してください。
## IAM
- IAM(Identity and Access Management)には、次の４つの機能がある。
  - IAMポリシー
    - どのサービスのどういう機能や範囲を許可/拒否するかというルールに基づいて、AWSサービスを利用する上での様々な権限を設定する。
    - 作成されたポリシーをIAMユーザー、IAMグループ、IAMロールに付与することで、権限の制御を行う。
  - IAMユーザー
    - AWSを利用するために各利用者に１つずつ与えられる認証情報（ID）。
  - IAMグループ
    - 同じ権限を持ったユーザーの集まり。
    - 認証されたユーザーがどういった権限を持つか管理する。
  - IAMロール
    - 一時的にAWSリソースにアクセス権限を付与する。
      - AWSリソースへの権限付与
      - クロスアカウントアクセス
      - IDフェデレーション
      - Web IDフェデレーション

## VPC
- Amazon Virtual Private Cloudの略で、利用者ごとにプライベートなネットワークをAWS内に作成する。
- VPCにインターネットゲートウェイ（IGW）というインターネット側の出口を付けることにより、直接インターネットに出ていくことが可能。
## AZ
- リージョンとは、AWSが提供している拠点（国や地域）のこと。リージョンは、それぞれ地理的に離れた場所に配置されている。
- リージョン内には、複数のアベイラリティーゾーン（AZ）が含まれている。
- それぞれのAZは、地理的・電源的に独立しているため、AZへの局所的な災害に対して別のAZが影響されないように配置されている。
## EC2
- 仮装サーバーを提供するサービス。
- 「インスタンス」という単位でサーバーを管理する。
- インスタンスを起動する時には、元となるイメージ（AMI）を選択する。
- ELB（Elastic Load Balancing）やAuto Scalingといったサービスを組み合わせることで、負荷に応じて動的にサーバーの台数を変更することもできる。
## ALB
- ELB（Elastic Load Balancing）は、ロードバランサーのマネージドサービス。
- ELBには、次の3つのタイプがある。
  - CLB(Classic Load Balancer) L4/L7レイヤーでの負荷分散を行う。
  - ALB(Application Load Balancer) L7レイヤーでの負荷分散を行う。CLBの後継であり、機能を豊富に提供している。
    - CLBとALBは同じアプリケーションレイヤーで負荷分散を行うが、後継のALBの方が安価で、機能が豊富。
    - 具体的には、WebSocketやHTTP/2に対応していること、URLパターンによって振り分け先を変える「パスベースルーティング機能」が提供されている。
  - NLB(Network Load Balancer) L4レイヤーでの負荷分散を行う。HTTP（S）以外のプロトコル通信の負荷分散をしたい時に利用する。

## Route53
- Route53は、「ドメイン管理機能」と「権威DNS機能」を持つサービス。
  - ドメイン管理機能
    - 新規ドメインの取得や更新の手続きが可能。ドメインの取得からゾーン情報の設定まで一貫して行うことができる。
  - 権威DNS機能
    - 権威DNSとは、ドメイン名とIPアドレスの変換情報を保持しているDNS。
    - 保持しているドメイン名以外の名前解決をリクエストしても応答しない。

## RDS
- マネージドRDS（Relational Database Service）サービス。
- MySQL、MariaDB、PosgreSQL、Oracle、Microsoft SQLサーバーなどのデータベースエンジンから選択することができる。

## S3
- Simple Storage Serviceの略で、優れた耐久性を持つ、容量無制限のオブジェクトストレージサービス。
- 主なユースケースは次のとおり。
  - データバックアップ
  - ビッグデータ解析用のデータレイク
  - ELT(Extract/Transform/Load)の中間ファイルの保存
  - Auto Scaling構成されたEC2インスタンスやコンテナのログの転送先
  - 静的コンテンツのホスティング
  - 簡易なKey-Value型のデータベース
## セキュリティグループ
- セキュリティグループは、EC2、ELB、RDSなどインスタンス単位の通信制御に利用される。
- インスタンスには、少なくとも１つのセキュリティグループをアタッチする必要がある。
- 通信制御としては、インバウンド（外部からVPCへ）とアウトバウンド（内部から外部へ）がある
- セキュリティグループは、デフォルトで、アクセスを拒否し、設定された項目にのみアクセスを許可する。