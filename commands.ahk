#Requires AutoHotkey v2.0

;####################################################################
;変数と初期値
;####################################################################
;{{{

;EditMode
; 0 通常モード(Insertモード)
; 1 コマンドモード(VIモード)
global EditMode := 0

;}}}

;;####################################################################
;;コマンド
;;####################################################################
;{{{

; コマンドモードへ移行
cmd_command()
{
  mode_visual_end()
  mode_command()
}

; Ctrl-Left 単語単位の左移動
cmd_word_left()
{
  caret_moved()
  if ((EditMode & 2) = 0)
    Send("^{Left}")
  else
    Send("+^{Left}")
}

; Ctrl-Right 単語単位の右移動
cmd_word_right()
{
  caret_moved()
  if ((EditMode & 2) = 0)
    Send("^{Right}")
  else
    Send("+^{Right}")
}

; Win-t タスクバーにフォーカスを移す
cmd_task_bar()
{
  if ((EditMode & 2) = 0)
    Send("#t")
}

; Ctrl-y やり直し
cmd_redo()
{
  mode_visual_end()
  Send("^y")
}

; 行末に移動してInsertモード
cmd_insert_end()
{
  caret_moved()
  if ((EditMode & 2) = 0)
    Send("{End}")
  else
    Send("+{End}")
  mode_visual_end()
  mode_normal()
}

; Insertモードへ移行
cmd_insert()
{
  mode_visual_end()
  mode_normal()
}

; 次行に改行を入れてInsertモード
cmd_insert_next()
{
  caret_moved()
  if ((EditMode & 2) = 0)
    Send("{End}")
  else
    Send("+{End}")
  mode_visual_end()
  Send("{Enter}")
  mode_normal()
}

; 前行に改行を入れてInsertモード
cmd_insert_prev()
{
  caret_moved()
  if ((EditMode & 2) = 0)
    Send("{Home}")
  else
    Send("+{Home}")
  mode_visual_end()
  Send("{Enter}{Up}")
  mode_normal()
}

; 行末まで削除
cmd_delete_end()
{
  caret_moved()
  mode_visual_end()
  Send("+{End}{Delete}")
}

; Ctrl-a すべて選択
cmd_all_select()
{
  caret_moved()
  Send("^a")
}

; Ctrl-s 保存
cmd_save()
{
  Send("^s")
}

; Ctrl-f 検索
cmd_find()
{
  caret_moved()
  mode_visual_end()
  Send("^f")
}

; Ctrl-z 元に戻す
cmd_undo()
{
  caret_moved()
  mode_visual_end()
  Send("^z")
}

; Ctrl-x 切り取り
cmd_cut()
{
  mode_visual_end()
  cut_and_save_clipboard()
}

; Ctrl-c コピー
cmd_copy()
{
  mode_visual_end()
  copy_and_save_clipboard()
}

; Ctrl-v 貼り付け
cmd_paste()
{
  mode_visual_end()
  paste_from_first_clipboard()
}

; 以前のクリップボードの内容を貼り付け
cmd_back_clipboard()
{
  mode_visual_end()
  back_clipboard()
}

; Delete
cmd_delete()
{
  caret_moved()
  mode_visual_end()
  Send("{Delete}")
}

; Backspace
cmd_bs()
{
  caret_moved()
  mode_visual_end()
  Send("{BS}")
}

; Ctrl-BS 単語単位でBackspace
cmd_word_bs()
{
  caret_moved()
  mode_visual_end()
  Send("^{BS}")
}

; Ctrl-Delete 単語単位でDelete
cmd_word_del()
{
  caret_moved()
  mode_visual_end()
  Send("^{Delete}")
}

; 行頭まで削除
cmd_delete_home()
{
  caret_moved()
  mode_visual_end()
  Send("+{Home}{Delete}")
}

; Shift-Left
cmd_left_select()
{
  caret_moved()
  Send("+{Left}")
}

; IME 英数字変換
cmd_ime_alnum()
{
  if ((EditMode & 2) = 0)
    Send("^{t}")
}

; Shift-Right
cmd_right_select()
{
  caret_moved()
  Send("+{Right}")
}

; 半角/全角
cmd_toggle_ime()
{
  Send("{sc029}")
}

; 左の仮想デスクトップへ移動
cmd_left_desktop()
{
  if ((EditMode & 2) = 0)
    Send("^#{Left}")		;デスクトップ左
}

; 右の仮想デスクトップへ移動
cmd_right_desktop()
{
  if ((EditMode & 2) = 0)
    Send("^#{Right}")		;デスクトップ右
}

; 左のタブへ移動
cmd_left_tab()
{
  if ((EditMode & 2) = 0)
    Send("^{PgUp}")
}

; 右のタブへ移動
cmd_right_tab()
{
  if ((EditMode & 2) = 0)
    Send("^{PgDn}")
}

; F3 次を検索
cmd_find_next()
{
  caret_moved()
  Send("{F3}")
}

; Shift-F3 前を検索
cmd_find_prev()
{
  caret_moved()
  Send("+{F3}")
}

; F2
cmd_f2()
{
  caret_moved()
  Send("{F2}")
}

; F5
cmd_f5()
{
  caret_moved()
  Send("{F5}")
}

; F6
cmd_f6()
{
  caret_moved()
  Send("{F6}")
}

; F7
cmd_f7()
{
  caret_moved()
  Send("{F7}")
}

; F8
cmd_f8()
{
  caret_moved()
  Send("{F8}")
}

; ファイルの先頭へ移動
cmd_file_head()
{
  caret_moved()
  if ((EditMode & 2) = 0)
    Send("^{Home}")
  else
    Send("+^{Home}")
}

; 行頭へ移動
cmd_line_head()
{
  caret_moved()
  if ((EditMode & 2) = 0)
    Send("{End}{Home}{Home}")
  else
    Send("+{End}+{Home}+{Home}")
}

; ファイルの末尾へ移動
cmd_file_tail()
{
  caret_moved()
  if ((EditMode & 2) = 0)
    Send("^{End}")
  else
    Send("+^{End}")
}

; Win-Tab タスクビュー表示
cmd_task_view()
{
  if ((EditMode & 2) = 0)
    Send("#{Tab}")
}

; Visualモードへ移行
cmd_visual()
{
  if ((EditMode & 2) = 0)
    mode_visual()
  else
    mode_visual_end()
}

; 行頭からVisualモード
cmd_visual_line()
{
  caret_moved()
  if ((EditMode & 2) = 0)
  {
    Send("{End}{Home}{Home}")
    mode_visual()
  }
  else
    mode_visual_end()
}

; 左移動
cmd_left()
{
  caret_moved()
  if ((EditMode & 2) = 0)
    Send("{Left}")
  else
    Send("+{Left}")
}

; 右移動
cmd_right()
{
  caret_moved()
  if ((EditMode & 2) = 0)
    Send("{Right}")
  else
    Send("+{Right}")
}

; 上移動
cmd_up()
{
  caret_moved()
  if ((EditMode & 2) = 0)
    Send("{Up}")
  else
    Send("+{Up}")
}

; 下移動
cmd_down()
{
  caret_moved()
  if ((EditMode & 2) = 0)
    Send("{Down}")
  else
    Send("+{Down}")
}

; 上ページ
cmd_page_up()
{
  caret_moved()
  if ((EditMode & 2) = 0)
    Send("{PgUp}")
  else
    Send("+{PgUp}")
}

; 下ページ
cmd_page_down()
{
  caret_moved()
  if ((EditMode & 2) = 0)
    Send("{PgDn}")
  else
    Send("+{PgDn}")
}

; 行頭
cmd_home()
{
  caret_moved()
  if ((EditMode & 2) = 0)
    Send("{Home}")
  else
    Send("+{Home}")
}

; 行末
cmd_end()
{
  caret_moved()
  if ((EditMode & 2) = 0)
    Send("{End}")
  else
    Send("+{End}")
}

; 次行の行頭
cmd_next_line_head()
{
  caret_moved()
  if ((EditMode & 2) = 0)
    Send("{Down}{End}{Home}{Home}")
  else
    Send("+{Down}+{End}+{Home}+{Home}")
}

; 次行の行末
cmd_next_line_end()
{
  caret_moved()
  if ((EditMode & 2) = 0)
    Send("{Down}{End}")
  else
    Send("+{Down}+{End}")
}

; 対応する括弧に移動
cmd_goto_bracket()
{
  caret_moved()
  Send("^+{sc07D}")
}

; 行が中央になるまでスクロール
cmd_center_scroll()
{
  Send("^!l")
}

; インクリメンタルサーチ
cmd_incremental_search()
{
  caret_moved()
  mode_visual_end()
  Send("^i")
}

; 置換
cmd_replace()
{
  caret_moved()
  mode_visual_end()
  Send("^h")
}

; インデント
cmd_indent()
{
  caret_moved()
  mode_visual_end()
  Send("{Tab}")
}

; 逆インデント
cmd_inv_indent()
{
  caret_moved()
  mode_visual_end()
  Send("+{Tab}")
}

;}}}


;####################################################################
; モード変更関数
;####################################################################

mode_normal()
{
  global
  EditMode &= 2
  if ((EditMode & 2) = 0)
    TraySetIcon("insert.ico")
  else
    TraySetIcon("insert-v.ico")
}

mode_command()
{
  global
  EditMode |= 1
  if ((EditMode & 2) = 0)
    TraySetIcon("command.ico")
  else
    TraySetIcon("command-v.ico")
}

mode_visual()
{
  global
  EditMode |= 2
  if ((EditMode & 1) = 0)
    TraySetIcon("insert-v.ico")
  else
    TraySetIcon("command-v.ico")
}

mode_visual_end()
{
  global
  EditMode &= 1
  if ((EditMode & 1) = 0)
    TraySetIcon("insert.ico")
  else
    TraySetIcon("command.ico")
}