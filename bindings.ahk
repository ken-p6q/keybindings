#Requires AutoHotkey v2.0

#Include shingeta.ahk
#Include clipboard.ahk
#Include commands.ahk

mode_normal()

;;####################################################################
;;タスク制御等　(起動したら通常モードでも有効。除外無し)
;;####################################################################
;{{{

;Alt+Tab タスク切り替え中（Win11対応）
#HotIf WinActive("ahk_class XamlExplorerHostIslandWindow", )
	!h::!Left
	!j::!Down
	!k::!Up
	!l::!Right
	!d::!Delete
#HotIf

;Win+Tabのデスクトップ切り替え
#HotIf WinActive("ahk_class XamlExplorerHostIslandWindow ahk_exe Explorer.EXE", )
  h::Left
  j::Down
  k::Up
  l::Right
  2::										;右のデスクトップへ(ジャンプリスト時は何もしない)
  {
      if WinActive("タスク ビュー")			;ahkファイルは、UTF-8のBOM付きにしておかないと、上手く判定されないので注意。
      {
        BlockInput("on")
        Send("+{Tab}")
        Send("{Right}")
        Send("{Space}")
        Send("{Tab}")
        BlockInput("off")
      }
  }
  1::										;左のデスクトップへ(ジャンプリスト時は何もしない)
  {
      if WinActive("タスク ビュー")
      {
        BlockInput("on")
        Send("+{Tab}")
        Send("{Left}")
        Send("{Space}")
        Send("{Tab}")
        BlockInput("off")
      }
  }
#HotIf

;タスクバーで右クリックしたジャンプリスト（最近使ったもの）
#HotIf WinActive("ahk_class Windows.UI.Core.CoreWindow ahk_exe ShellExperienceHost.exe", )
  j::Down
  k::Up
  ESC::
  q::
    {
        BlockInput("on")
        Send("{Esc}")
        Send("#{t}")
        BlockInput("off")
    }
#HotIf

;Win+T タスクバー
#HotIf WinActive("ahk_class Shell_TrayWnd", )
  h::Left
  j::return				;なにもしない（Ctrl+Shift+Jで入ってくるので反応してしまう）
  k::Up					;プレビュー
  l::Right
  w::
    {
        BlockInput("on")
        Send("{Right}")		;右のアプリのプレビュー
        Send("{Up}")
        BlockInput("off")
    }
  e::
    {
        BlockInput("on")
        Send("{Left}")	;左のアプリのプレビュー
        Send("{Up}")
        BlockInput("off")
    }
  :::
  `;::
    {
        Send("{AppsKey}")	;ジャンプリスト表示
    }
#HotIf

;Win+T タスクバーのプレビュー
#HotIf WinActive("ahk_class TaskListThumbnailWnd", )
  h::Left
  l::Right	
  j::Down					;タスクバーへ戻る
  w::
    {
        BlockInput("on")
        Send("{Down}")			;右のアプリのプレビュー
        Send("{Right}")
        Send("{Up}")
        BlockInput("off")
    }
  e::						;左のアプリのプレビュー
    {
        BlockInput("on")
        Send("{Down}")
        Send("{Left}")
        Send("{Up}")
        BlockInput("off")
    }
  x::
    {
        BlockInput("on")
        Send("{AppsKey}")
        Sleep(200)			;右クリックメニューが出るまで時間がかかるのか、cが空振る事がある。
        Send("c")
        BlockInput("off")
    }
#HotIf

;}}}

;;####################################################################
;;IME状態検知
;;####################################################################
;{{{

global ImeConverting:=0

SendEnter()
{
  global
  ImeConverting:=0
  ImePrintableLetter:=0
  Send("{Enter}")
}

SendSpace()
{
  global
  if (ImePrintableLetter)
    ImeConverting:=1
  Send("{Space}")
}

;}}}

;;####################################################################
;;Ctrlキー
;;####################################################################
;{{{

; 左移動
^h::cmd_left()

; 下移動
^j::cmd_down()

; 上移動
^k::cmd_up()

; 右移動
^l::cmd_right()

; 元に戻す(Ctrl-z)
^/::cmd_undo()

; IME ON/OFFし、Insertモードへ移行
; sc073 -> \_
^sc073::
{
  cmd_toggle_ime()
  cmd_insert()
}

; タスクバーにフォーカスを移す
; ~ -> ^~
^~::cmd_task_bar()

; タスクビューを表示
; sc07D -> \|
^sc07D::cmd_task_view()

; エンター
^`;::
{
  caret_moved()
  SendEnter()
}

; バックスペース
; sc028 -> :*
^sc028::cmd_bs()

; 左のタブへ移動
^[::cmd_left_tab()

; 右のタブへ移動
^]::cmd_right_tab()

; Alt-Ctrl-\ 新下駄配列 ON/OFF
!^sc073::
{
  global
  ShinGeta := ! ShinGeta
}

; F2
^2::
{
  cmd_f2()
  cmd_insert()
}

;}}}

;;####################################################################
;;Fnキー
;;####################################################################
;{{{

; 左の仮想デスクトップへ移動
; Fn - h -> NumLock
NumLock::cmd_left_desktop()

; 右の仮想デスクトップへ移動
; Fn - l -> ScrollLock
ScrollLock::cmd_right_desktop()

;}}}

;;####################################################################
;;コマンドモード / Visualモード(選択モード)
;;####################################################################
;{{{

; コマンドモードへ移行・IME OFF
; sc078 -> 無変換
sc07B::
{
  IME_SET(0)
  cmd_command()
}

#UseHook true

; 行頭からVisualモード
q::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
    cmd_visual_line()
}

; 単語単位の移動(Ctrl-Left)
w::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
  {
    if (ImeConverting)
      Send("^k")
    else
      cmd_word_left()
  }
}

; 単語単位の移動(Ctrl-Right)
e::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
  {
    if (ImeConverting)
      Send("^l")
    else
      cmd_word_right()
  }
}

; Home
r::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
    cmd_home()
}

; 対応する括弧に移動
t::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
    cmd_goto_bracket()
}

; やり直し(Ctrl-y)
y::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
    cmd_redo()
}

; 行末に移動してInsertモード
u::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
    cmd_insert_end()
}

; Insertモードへ移行
i::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
    cmd_insert()
}

; 次行に改行を入れてInsertモード
o::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
    cmd_insert_next()
}

; 前行に改行を入れてInsertモード
p::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
    cmd_insert_prev()
}

; キャレットが画面の中央にくるようにスクロールする
@::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
    cmd_center_scroll()
}

; すべて選択(Ctrl-a)
a::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
    cmd_all_select()
}

; 保存(Ctrl-s)
s::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
    cmd_save()
}

; Delete
d::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
    cmd_delete()
}

; 検索(Ctrl-f)
f::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
    cmd_find()
}

; End
g::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
    cmd_end()
}

; Left
h::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
    cmd_left()
}

; Down
j::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
    cmd_down()
}

; Up
k::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
    cmd_up()
}

; Right
l::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
    cmd_right()
}

; 次行の行末
`;::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
    cmd_next_line_end()
}

; 元に戻す(Ctrl-z)
z::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
    cmd_undo()
}

; 切り取り(Ctrl-x)
x::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
    cmd_cut()
}

; コピー(Ctrl-c)
c::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
    cmd_copy()
}

; 貼り付け(Ctrl-v)
v::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
    cmd_paste()
}

; 次の行の先頭で貼り付け
b::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
  {
    cmd_next_line_head()
    cmd_paste()
  }
}

; 単語単位でBackspace(Ctrl-BS)
n::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
    cmd_word_bs()
}

; 単語単位でDelete(Ctrl-Del)
m::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
    cmd_word_del()
}

; 行頭まで削除
; sc033 -> ,<
sc033::
{
  if (EditMode = 0)
    onKeyDown(",")
  else
    cmd_delete_home()
}

; 行末まで削除
.::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
    cmd_delete_end()
}

; 元に戻す(Ctrl-z)
/::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
    cmd_undo()
}

; IME ON/OFFし、Insertモードへ移行
; sc073 -> \_
sc073::
{
  if (EditMode = 0)
    onKeyDown("\")
  else
  {
    cmd_toggle_ime()
    cmd_insert()
  }
}

; F2キー
1::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
    cmd_f2()
}

; F2キーの後Insertモードへ移行
2::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
  {
    cmd_f2()
    cmd_insert()
  }
}

; F3キー
3::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
    cmd_find_next()
}

; Shift-F3キー
4::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
    cmd_find_prev()
}

; F5キー
5::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
    cmd_f5()
}

; F6キー
6::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
    cmd_f6()
}

; F7キー
7::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
    cmd_f7()
}

; F8キー
8::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
    cmd_f8()
}

; ファイルの先頭へ移動
9::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
    cmd_file_head()
}

; 行頭へ移動
0::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
    cmd_line_head()
}

; ファイルの末尾へ移動
-::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
    cmd_file_tail()
}

; PageUp
[::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
    cmd_page_up()
}

; PageDown
]::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
    cmd_page_down()
}

; Backspace
; sc028 -> :*
sc028::
{
  if (EditMode = 0)
    onKeyDown(":")
  else
    cmd_bs()
}

; 以前のクリップボードの内容を貼り付け
~::
{
  if (EditMode = 0)
    onKeyDown(ThisHotKey)
  else
    cmd_back_clipboard()
}

; 置換(Ctrl-h)
; sc07D -> \|
sc07D::
{
  if (EditMode = 0)
    onKeyDown("\")
  else
    cmd_replace()
}

; Visualモードへ移行
Space::
{
  if (EditMode = 0)
  {
    PressedPrintableLetter := 1
    Send("{Space}")
  }
  else
    cmd_visual()
}

;}}}

;;####################################################################
;;Windowsショートカットと同じコマンド
;;####################################################################
;{{{

Left::cmd_left()
Right::cmd_right()
Up::cmd_up()
Down::cmd_down()
PgUp::cmd_page_up()
PgDn::cmd_page_down()
Home::cmd_home()
End::cmd_end()
BS::cmd_bs()
Delete::cmd_delete()
Tab::cmd_indent()
Enter::SendEnter()
+Tab::cmd_inv_indent()
^Left::cmd_word_left()
^Right::cmd_word_right()
^t::cmd_ime_alnum()
^y::cmd_redo()
^i::cmd_incremental_search()
^a::cmd_all_select()
^s::cmd_save()
; 検索(Ctrl-f)
^f::
{
  cmd_find()
  cmd_insert()
}
^z::cmd_undo()
^x::cmd_cut()
^c::cmd_copy()
^v::cmd_paste()
^BS::cmd_word_bs()
^Delete::cmd_word_del()
^Home::cmd_file_head()
^End::cmd_file_tail()

#UseHook false

;}}}
