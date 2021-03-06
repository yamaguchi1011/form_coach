# form_coach
■ サービス概要
野球の投球フォームで悩んでいる人に
客観的に見た意見やアドバイスを全国の野球好きから集め提供する
投球フォーム専門の動画投稿サービスです。

■メインのターゲットユーザー
野球を始めた小学生から、プロ野球の選手、ポジションは投手限定

■ユーザーが抱える課題
野球で投手をしていると必ずと言っていいほど、全員がフォームについて一度は考える。
しかし、投手を指導できる指導者がいない場合も多く、またいたとしても偏った指導で個人に合った指導ができない指導者も多い。
個人の身体的特徴などから全員が同じフォームで投げられるわけではないため書籍や、動画等で情報を取り入れて実践しても自分に当てはまらないことも多く、効率よくパフォーマンスアップできない。
また高いパフォーマンスを発揮していても身体の一部に負担のかかるフォームだと怪我に繋がる場合もある。
またサイドスローなどの数の少ない投げ方だと基本は独学のため高いパフォーマンスを発揮することが難しい。
野球について話したいが話す相手がおらずyoutubeのコメント欄で激しく議論されている場面が多々ある。

■解決方法
撮った動画を投稿し、その動画を見た人から感じたことやアドバイスをもらって自分の投球フォームの改善点を教えてもらう。
基本的なチェックポイントは動画から自動で分析して伝える。

■実装予定の機能
・プレイヤー（動画を投稿する人）
　・動画の投稿ができる。
　・顔や背景をぼかして個人が特定できないようにする。
　・アドバイザーに依頼ができる。
　・動画内の肘の角度や膝の角度を分析しアプリが自動でアドバイスする。
・アドバイザー（投稿された動画を見てアドバイスする人）
　・動画を一覧できる
　・動画検索ができる
　・動画を見てコメントすることができる。
　・的確なコメントには他のアドバイザーから賛同機能や、パフォーマンスアップにつながったコメントに対してはプレイヤーからありがとう機能がもらえる。
　　・賛同やありがとうが一定値になると段階的に称号がもらえる。
・管理ユーザー　
　・誹謗中傷コメントの自動削除機能
　・プレイヤーの検索、一覧、詳細、編集
　・アドバイザーの検索、一覧、詳細、編集
　・投稿された動画の検索、一覧、詳細、編集
　・動画に対するコメントの一覧、詳細、作成、編集、削除
　・管理ユーザーの一覧、詳細、作成、編集、削除

■なぜこのサービスを作りたいのか？
　家の駐車場で練習していた時にたまたま車で通りかかった女性から中学生の息子に投球フォームについて教えてもらえないかと頼まれたことがありました。
　トップレベルの社会人チームの練習に参加させていただく機会があり、その際に甲子園で優勝経験のある投手からフォームについて聞かれることがありました。そんな選手でさえフォームについてずっと考え続け何かきっかけがないかを探っています。
　投球フォームについて教えてほしい人はたくさんいます。
　自分自身が野球をやっていてフォームのことはずっと考えてきて、自分に合ったフォームでないとパフォーマンスは上がらないことがわかりました。
　しかしパフォーマンスが上がってきたところで負担のかかるフォームで投げていたために肘を剥離骨折、内側側副靱帯の損傷をしました。骨はもう完治することはなく靭帯は１年以上の安静とリハビリが必要と病院で言われています。
　原因はテイクバックの際に肘が背中側に入りすぎてしまうことにより肘に過剰な負荷がかかり骨と靭帯が耐えられなくなった事によるものでした。あくまで怪我は自分の責任ですが、誰かがほんのひと言、腕が背中側に入りすぎてないかと教えてくれれば防げる怪我だ　ったかもしれません。
　子どもの頃によくないフォームで投げすぎて骨が変形し肘が伸び切らない選手や、肩肘を壊しもう二度とボールを投げられなくなり野球から離れる選手をたくさん見てきました。
　そんな中youtubeではフォームのことについて激しく議論されている場面を多々見かけることがありました。技術的で詳しいコメントも多くあります。
　野球は素人の家族から、このプロ選手のフォームとはこの部分が違うと指摘されたことがあり自分では気が付かなかった部分でパフォーマンスアップに大きくつながったこともあります。
　そこで、野球を見る専門の人やフォームについてアドバイスしたいに人にその場所を提供し、教えてほしい選手、怪我をする可能性のある選手が気づくきっかけを作るサービスを作りたいと考えました。
　もっともっと投球フォームについて議論され、怪我をする選手が減っていけばいいなと考えております。
　

■スケジュール
　企画〜技術調査：7/12〆切
　README〜ER図作成：7/18 〆切
　メイン機能実装：7/18 - 8/1
　β版をRUNTEQ内リリース（MVP）：8/1〆切
　本番リリース：8/9　〆切