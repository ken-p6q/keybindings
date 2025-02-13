#Include "%A_ScriptDir%\IMEv2.ahk"

;=============================
; タイマー入り 同時打鍵スクリプト
;　　+ IME 状態チェック IMEv2.ahk 利用バージョン
;    AutoHotKey 2.0.18対応
; 「http://kohada.2ch.net/test/read.cgi/pc/1201883108/199,282
; の199氏の作ったahk版下駄配列スクリプトの配列を入れ替えただけの新下駄配列版。
;=============================

; 新下駄配列 0:無効 1:有効
global ShinGeta:=0

; 英語キーボード 0:日本語 1:英語
global USLayout:=0

; 印字可能文字が入力されたか？
; (外部スクリプト用)
global PressedPrintableLetter:=0

; Maximal Gap Time は同時打鍵判定用の時定数です
; この時間(ms)内に次の入力があった場合は「同時」と見なします
global MaximalGT:=70

; Single Key Wait はキーを押してからタイマーで確定するまでの時間です
global SingleKeyWait:=MaximalGT

; キー関連グローバル変数定義↓-------------------------------------

; キーバッファ
; bufKey には "q" のようなキー文字列が格納されます
; bufTime はキーが押された時刻です

global bufKey:=""
global bufTime:=0

; 各キーに同時打鍵判定のための識別フラグをわりあてます
global gKB:=Map(
	"q", 1,
	"w", 1<<1,
	"e", 1<<2,
	"r", 1<<3,
	"t", 1<<4,
	"y", 1<<5,
	"u", 1<<6,
	"i", 1<<7,
	"o", 1<<8,
	"p", 1<<9,
	"a", 1<<10,
	"s", 1<<11,
	"d", 1<<12,
	"f", 1<<13,
	"g", 1<<14,
	"h", 1<<15,
	"j", 1<<16,
	"k", 1<<17,
	"l", 1<<18,
	";", 1<<19,
	"z", 1<<20,
	"x", 1<<21,
	"c", 1<<22,
	"v", 1<<23,
	"b", 1<<24,
	"n", 1<<25,
	"m", 1<<26,
	",", 1<<27,
	".", 1<<28,
	"/", 1<<29,
	"@", 1<<30,
	"1", 1<<31,
	"2", 1<<32,
	"3", 1<<33,
	"4", 1<<34,
	"5", 1<<35,
	"6", 1<<36,
	"7", 1<<37,
	"8", 1<<38,
	"9", 1<<39,
	"0", 1<<40,
	"-", 1<<41,
	"[", 1<<42,
	"]", 1<<43,
	":", 1<<44,
	"^", 1<<45,
	"\", 1<<46,
)

; シングルストロークでsendする文字列
global singleStroke:=Map(
	"q", "-",	;ー
	"w", "ni",	;に
	"e", "ha",	;は
	"r", ",",	;,
	"t", "ti",	;ち
	"y", "gu",	;ぐ
	"u", "ba",	;ば
	"i", "ko",	;こ
	"o", "ga",	;が
	"p", "hi",	;ひ
	"@", "ge",	;げ
	"a", "no",	;の
	"s", "to",	;と
	"d", "ka",	;か
	"f", "nn",	;ん
	"g", "ltu",	;っ
	"h", "ku",	;く
	"j", "u",	;う
	"k", "i",	;い
	"l", "si",	;し
	";", "na",	;な
	"z", "su",	;す
	"x", "ma",	;ま
	"c", "ki",	;き
	"v", "ru",	;る
	"b", "tu",	;つ
	"n", "te",	;て
	"m", "ta",	;た
	",", "de",	;で
	".", ".",	;。
	"/", "bu",	;ぶ
	"1", "1",	;１
	"2", "2",	;２
	"3", "3",	;３
	"4", "4",	;４
	"5", "5",	;５
	"6", "6",	;６
	"7", "7",	;７
	"8", "8",	;８
	"9", "9",	;９
	"0", "0",	;０
	"-", "-",	;ー
	"[", "[",
	"]", "]",
	":", "{BackSpace}",
	"^", "^",
	"\", "\",
)

if (USLayout)
{
	gKB["["]:=1<<30
	gKB["'"]:=1<<44
	gKB["="]:=1<<45
	singleStroke["["]:="ge"	;げ
	singleStroke["'"]:="{BackSpace}"
	singleStroke["="]:="="
}

; 同時打鍵でsendする文字列
global kCmb:=Map(
	gKB["k"]|gKB["q"],	; ふぁ
	"fa",
	gKB["k"]|gKB["w"],	; ご
	"go",
	gKB["k"]|gKB["e"],	; ふ
	"fu",
	gKB["k"]|gKB["r"],	; ふぃ
	"fi",
	gKB["k"]|gKB["t"],	; ふぇ
	"fe",
	gKB["k"]|gKB["a"],	; ほ
	"ho",
	gKB["k"]|gKB["s"],	; じ
	"ji",
	gKB["k"]|gKB["d"],	; れ
	"re",
	gKB["k"]|gKB["f"],	; も
	"mo",
	gKB["k"]|gKB["g"],	; ゆ
	"yu",
	gKB["k"]|gKB["z"],	; づ
	"du",
	gKB["k"]|gKB["c"],	; ぼ
	"bo",
	gKB["k"]|gKB["v"],	; む
	"mu",
	gKB["k"]|gKB["b"],	; ふぉ
	"fo",
	gKB["d"]|gKB["y"],	; うぃ
	"wi",
	gKB["d"]|gKB["u"],	; ぱ
	"pa",
	gKB["d"]|gKB["i"],	; よ
	"yo",
	gKB["d"]|gKB["o"],	; み
	"mi",
	gKB["d"]|gKB["p"],	; うぇ
	"we",
	gKB["d"]|gKB["h"],	; へ
	"he",
	gKB["d"]|gKB["j"],	; あ
	"a",
	gKB["d"]|gKB[";"],	; え
	"e",
	gKB["d"]|gKB["n"],	; せ
	"se",
	gKB["d"]|gKB["m"],	; ね
	"ne",
	gKB["d"]|gKB[","],	; べ
	"be",
	gKB["d"]|gKB["."],	; ぷ
	"pu",
	gKB["d"]|gKB["/"],	; ヴ
	"vu",
	gKB["l"]|gKB["w"],	; め
	"me",
	gKB["l"]|gKB["e"],	; け
	"ke",
	gKB["l"]|gKB["r"],	; てぃ
	"thi",
	gKB["l"]|gKB["t"],	; でぃ
	"dhi",
	gKB["l"]|gKB["a"],	; を
	"wo",
	gKB["l"]|gKB["s"],	; さ
	"sa",
	gKB["l"]|gKB["d"],	; お
	"o",
	gKB["l"]|gKB["f"],	; り
	"ri",
	gKB["l"]|gKB["g"],	; ず
	"zu",
	gKB["l"]|gKB["z"],	; ぜ
	"ze",
	gKB["l"]|gKB["x"],	; ざ
	"za",
	gKB["l"]|gKB["c"],	; ぎ
	"gi",
	gKB["l"]|gKB["v"],	; ろ
	"ro",
	gKB["l"]|gKB["b"],	; ぬ
	"nu",
	gKB["s"]|gKB["u"],	; ぺ
	"pe",
	gKB["s"]|gKB["i"],	; ど
	"do",
	gKB["s"]|gKB["o"],	; や
	"ya",
	gKB["s"]|gKB["h"],	; び
	"bi",
	gKB["s"]|gKB["j"],	; ら
	"ra",
	gKB["s"]|gKB[";"],	; そ
	"so",
	gKB["s"]|gKB["n"],	; わ
	"wa",
	gKB["s"]|gKB["m"],	; だ
	"da",
	gKB["s"]|gKB[","],	; ぴ
	"pi",
	gKB["s"]|gKB["/"],	; ちぇ
	"che",
	gKB["i"]|gKB["r"],	; きゅ
	"kyu",
	gKB["i"]|gKB["f"],	; きょ
	"kyo",
	gKB["i"]|gKB["v"],	; きゃ
	"kya",
	gKB["i"]|gKB["t"],	; ちゅ
	"cyu",
	gKB["i"]|gKB["g"],	; ちょ
	"cyo",
	gKB["i"]|gKB["b"],	; ちゃ
	"cya",
	gKB["i"]|gKB["a"],	; ひょ
	"hyo",
	gKB["i"]|gKB["z"],	; ひゃ
	"hya",
	gKB["i"]|gKB["x"],	; くぇ
	"qe",
	gKB["i"]|gKB["c"],	; しゃ
	"sha",
	gKB["i"]|gKB["q"],	; ひゅ
	"hyu",
	gKB["i"]|gKB["w"],	; しゅ
	"shu",
	gKB["i"]|gKB["e"],	; しょ
	"syo",
	gKB["o"]|gKB["r"],	; ぎゅ
	"gyu",
	gKB["o"]|gKB["f"],	; ぎょ
	"gyo",
	gKB["o"]|gKB["v"],	; ぎゃ
	"gya",
	gKB["o"]|gKB["t"],	; にゅ
	"nyu",
	gKB["o"]|gKB["g"],	; にょ
	"nyo",
	gKB["o"]|gKB["b"],	; にゃ
	"nya",
	gKB["o"]|gKB["a"],	; りょ
	"ryo",
	gKB["o"]|gKB["z"],	; りゃ
	"rya",
	gKB["o"]|gKB["x"],	; ぐぇ
	"gwe",
	gKB["o"]|gKB["c"],	; じゃ
	"ja",
	gKB["o"]|gKB["q"],	; りゅ
	"ryu",
	gKB["o"]|gKB["w"],	; じゅ
	"ju",
	gKB["o"]|gKB["e"],	; じょ
	"jo",
	gKB["r"]|gKB["g"],	; ・
	"/",
	gKB["r"]|gKB["f"],	; ・
	"/",
	gKB["f"]|gKB["g"],	; 「」
	"[]{Enter}{Left}",
	gKB["u"]|gKB["h"],	; ／
	"／",
	gKB["h"]|gKB["j"],	; （）
	"+8+9{Enter}{Left}",
	gKB["k"]|gKB["x"],	; ぞ
	"zo",
	gKB["l"]|gKB["q"],	; ぢ
	"di",
	gKB["s"]|gKB["y"],	; しぇ
	"she",
	gKB["s"]|gKB["."],	; ぽ
	"po",
	gKB["s"]|gKB["p"],	; じぇ
	"je",
	gKB["k"]|gKB["1"],	; ぁ
	"xa",
	gKB["k"]|gKB["2"],	; ぃ
	"xi",
	gKB["k"]|gKB["3"],	; ぅ
	"xu",
	gKB["k"]|gKB["4"],	; ぇ
	"xe",
	gKB["k"]|gKB["5"],	; ぉ
	"xo",
	gKB["l"]|gKB["1"],	; ゃ
	"xya",
	gKB["l"]|gKB["2"],	; みゃ
	"mya",
	gKB["l"]|gKB["3"],	; みゅ
	"myu",
	gKB["l"]|gKB["4"],	; みょ
	"myo",
	gKB["l"]|gKB["5"],	; ゎ
	"xwa",
	gKB["i"]|gKB["1"],	; ゅ
	"xyu",
	gKB["i"]|gKB["2"],	; びゃ
	"bya",
	gKB["i"]|gKB["3"],	; びゅ
	"byu",
	gKB["i"]|gKB["4"],	; びょ
	"byo",
	gKB["o"]|gKB["1"],	; ょ
	"xyo",
	gKB["o"]|gKB["2"],	; ぴゃ
	"pya",
	gKB["o"]|gKB["3"],	; ぴゅ
	"pyu",
	gKB["o"]|gKB["4"],	; ぴょ
	"pyo",
	gKB["d"]|gKB["7"],	; 全角カンマ
	"，",
	gKB["d"]|gKB["8"],	; 「
	"[",
	gKB["d"]|gKB["9"],	; 」
	"]",
	gKB["d"]|gKB["0"],	; ；
	";",
	gKB["d"]|gKB["-"],	; @
	"@",
	gKB["s"]|gKB["7"],	; 全角ピリオド
	"．",
	gKB["s"]|gKB["8"],	; （
	"+8",
	gKB["s"]|gKB["9"],	; ）
	"+9",
	gKB["s"]|gKB["0"],	; ：
	"`:",
	gKB["s"]|gKB["-"],	; ＊
	"+`:",
	gKB["f"]|gKB["v"],	; ！
	"+1",
	gKB["f"]|gKB["b"],	; ！
	"+1",
	gKB["n"]|gKB["j"],	; ？
	"?",
)

; キー関連グローバル変数定義↑-------------------------------------

;================
; 同時打鍵の判定
;================

;=================================
; キーを押し込んでも即座には入力されません
; 入力を確定するタイミングは次の２つです
; 
; 1. 次のキーが押されたとき (onKeyDown)
; 2. ある程度の時間が経過したとき (確定タイマー)
; 
; 確定タイマーはキーが押されたときにセット/リセットされ、
; 入力が確定したときに解除されます
; 確定タイマーはonKeyUp ルーチンを呼びます
;=================================

outputChar(string)
{
	Send(string)
}

onKeyUp()
{
    global
	if (StrLen(bufKey) > 0)
	{
		outputChar(singleStroke[bufKey])
		bufKey:=""
	}
	SetTimer(onKeyUp,0)
}

onKeyDown(keyName)
{
    global
	PressedPrintableLetter:=1
	if (IME_GET())
	{
		if (ShinGeta == 1 && (IME_GetConvMode() & 7))
		{
			onOnKeyDown(keyName)
			return
		}
	}
	Send(keyName)
}

onOnKeyDown(keyName)
{
	global
	inputTime:=A_TickCount

	if (StrLen(bufKey) > 0)
	{
		; GapTime が許容値内であるか
		if( inputTime-bufTime <= MaximalGT )
		{
			currentKeyPattern:=gKB.Get(keyName,0)|gKB.Get(bufKey,0)

			; 押下中の組み合わせが定義されているか
			resultOfKCmb:=KCmb.Get(currentKeyPattern,0)
			if(resultOfKCmb)
			{
				; 同時打鍵を出力、バッファとタイマーをクリア
				outputChar(resultOfKCmb)
				bufKey:=""
				SetTimer(onKeyUp,0)
				Return
			}
		}
		; 同時打鍵でなかったらバッファを確定
		outputChar(singleStroke[bufKey])
	}
	; バッファ更新、タイマー設定
	bufTime:=inputTime
	bufKey:=keyName
	SetTimer(onKeyUp,SingleKeyWait)
}

