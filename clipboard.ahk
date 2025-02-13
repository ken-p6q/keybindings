#Requires AutoHotkey v2.0

;####################################################################
;変数と初期値
;####################################################################
;{{{

; クリップボードのデータを保存する配列
global CutData := Array()

; クリップボードデータを貼り付ける際のインデックス
global CutDataIndex := 0

; キャレットの位置が動いていないか？ 0:動いている 1:動いていない
global CaretPosUnchanged := 0

;}}}

;;####################################################################
;;クリップボード履歴の保存
;;####################################################################
;{{{

; キャレットが動いたときに呼び出す関数
caret_moved()
{
  global
  CaretPosUnchanged := 0
  if (CutDataIndex > 1)
  {
    ; クリップボードが退避されていたら元に戻す
    A_Clipboard := CutData.RemoveAt(1)
  }
  CutDataIndex := 0
}

; 1行カットかどうか判定
is_one_line_cut()
{
  LastIndex := 0
  LastField := ""
  Loop Parse A_Clipboard, "`n", "`r"
  {
    LastIndex := A_Index
    LastField := A_LoopField
    if (A_Index > 2)
      break
  }
  if (LastIndex = 2 && LastField = "")
    return 1
  return 0
}

; クリップボードの内容を保存
save_clipboard()
{
  if (A_Clipboard)
  {
    CutData.InsertAt(1, A_Clipboard)
    if (CutData.Length > 32)
    {
      CutData.Pop()
    }
  }
}

merge_clipboard()
{
  if (CaretPosUnchanged && PressedPrintableLetter = 0 && CutData.Length > 0 && is_one_line_cut())
  {
    ; 1行カットでキャレットが動いていないなら、
    ; Ctrl-xの連続カットと見なし、最後のCutDataと連結する。
    CutData[1] .= A_Clipboard
    A_Clipboard := CutData.RemoveAt(1)
  }
}

; 切り取り・クリップボードの保存
cut_and_save_clipboard()
{
  global
  save_clipboard()
  A_Clipboard := ""
  Send("^x")
  ClipWait(0.25)
  merge_clipboard()
  CaretPosUnchanged := 1
  PressedPrintableLetter := 0
}

; コピー・クリップボードの保存
copy_and_save_clipboard()
{
  save_clipboard()
  A_Clipboard := ""
  Send("^c")
  ClipWait(0.25)
}

;}}}

;;####################################################################
;;クリップボード履歴の貼り付け
;;####################################################################
;{{{

; クリップボードの最初の要素を貼り付け
paste_from_first_clipboard()
{
  global
  Send("^v")
  CutDataIndex := 1
  PressedPrintableLetter := 0
}

; 一つ前のクリップボードデータを貼り付け直す
back_clipboard()
{
  global
  if (CutDataIndex = 0 || PressedPrintableLetter != 0)
  {
    paste_from_first_clipboard()
  }
  if (CutDataIndex <= CutData.Length)
  {
    if (CutDataIndex = 1)
    {
      ; 現在のクリップボードをCutData[1]に退避
      CutData.InsertAt(1, A_Clipboard)
      CutDataIndex := 2
    }
    Send("^z")
    A_Clipboard := CutData[CutDataIndex]
    Send("^v")
    CutDataIndex += 1
  }
}

;}}}
