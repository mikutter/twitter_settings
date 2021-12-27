# frozen_string_literal: true

UserConfig[:retrieve_interval_friendtl] ||= 1         # TLを更新する間隔(int)
UserConfig[:retrieve_interval_mention] ||= 20         # Replyを更新する間隔(int)
UserConfig[:retrieve_interval_search] ||= 60          # 検索を更新する間隔(int)
UserConfig[:retrieve_interval_followings] ||= 60      # followを更新する間隔(int)
UserConfig[:retrieve_interval_followers] ||= 60       # followerを更新する間隔(int)
UserConfig[:retrieve_interval_direct_messages] ||= 20 # DirectMessageを更新する間隔(int)
UserConfig[:retrieve_interval_list_timeline] ||= 60   # リストの更新間隔(int)
UserConfig[:retrieve_count_friendtl] ||= 20           # TLを取得する数(int)
UserConfig[:retrieve_count_mention] ||= 20            # Replyを取得する数(int)
UserConfig[:retrieve_count_followings] ||= 20         # followを取得する数(int)
UserConfig[:retrieve_count_followers] ||= 20          # followerを取得する数(int)
UserConfig[:retrieve_count_direct_messages] ||= 200   # followerを取得する数(int)
UserConfig[:update_queue_delay] ||= 100
UserConfig[:favorite_queue_delay] ||= 100
UserConfig[:follow_queue_delay] ||= 100
UserConfig[:direct_message_queue_delay] ||= 100
UserConfig[:filter_realtime_rewind] ||= true
UserConfig[:filter_dont_exclude_retweet] ||= false
UserConfig[:anti_retrieve_fail] ||= false

Plugin.create(:twitter_settings) do
  settings(_('Twitter')) do
    settings(_ '各情報を取りに行く間隔。単位は分') do
      adjustment(_('タイムラインとリプライ'), :retrieve_interval_friendtl, 1, 60*24).
        tooltip(_ 'あなたがフォローしている人からのリプライとつぶやきの取得間隔')

      adjustment(_('フォローしていない人からのリプライ'),:retrieve_interval_mention, 1, 60*24).
        tooltip(_("あなたに送られてきたリプライを取得する間隔。\n上との違いは、あなたがフォローしていない人からのリプライも取得出来ることです"))

      adjustment(_('保存した検索'), :retrieve_interval_search, 1, 60*24).
        tooltip(_ '保存した検索を確認しに行く間隔')

      adjustment(_('リストのタイムライン'), :retrieve_interval_list_timeline, 1, 60*24).
        tooltip(_ '表示中のリストのタイムラインを確認しに行く間隔')

      adjustment(_('フォロー'), :retrieve_interval_followings, 1, 60*24).
        tooltip(_ 'フォロー一覧を確認しに行く間隔。mikutterを使わずにフォローした場合、この時に同期される')

      adjustment(_('フォロワー'), :retrieve_interval_followers, 1, 60*24).
        tooltip(_ 'フォロワー一覧を確認しに行く間隔')

      adjustment(_('ダイレクトメッセージ'), :retrieve_interval_direct_messages, 1, 60*24).
        tooltip(_ 'ダイレクトメッセージを確認しに行く間隔')
    end

    settings(_ '一度に取得するつぶやきの件数(1-200)') do
      adjustment(_('タイムラインとリプライ'), :retrieve_count_friendtl, 1, 200)
      adjustment(_('フォローしていない人からのリプライ'), :retrieve_count_mention, 1, 200)
      adjustment(_('フォロー'), :retrieve_count_followings, 1, 100000)
      adjustment(_('フォロワー'), :retrieve_count_followers, 1, 100000)
      adjustment(_('ダイレクトメッセージ'), :retrieve_count_direct_messages, 1, 200)
    end

    settings(_ 'イベントの発生頻度(ミリ秒単位)') do
      adjustment(_('タイムラインとリプライとリツイート'), :update_queue_delay, 100, 10000)
      adjustment(_('ふぁぼられ'), :favorite_queue_delay, 100, 10000)
      adjustment(_('フォロワー'), :follow_queue_delay, 100, 10000)
      adjustment(_('ダイレクトメッセージ'), :direct_message_queue_delay, 100, 10000)
    end

    settings _('リアルタイム更新') do
      boolean(_('リスト(Streaming API)'), :filter_realtime_rewind).
        tooltip _('Twitter の Streaming APIを用いて、リアルタイムにリストの更新等を受け取ります')
      boolean(_('StreamingにRTを含める'), :filter_dont_exclude_retweet).
        tooltip _('サードパーティープラグインでRTをStreaming受信したい場合に有効にします。副作用として既存プラグインに意図しないRTが表示される場合があります ')
    end

    settings(_('その他')) do
      boolean(_('つぶやきの取得漏れを防止する（遅延対策）'), :anti_retrieve_fail).
        tooltip _('遅延に強くなりますが、ちょっと遅くなります。')
    end
  end
end
