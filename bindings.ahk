#Requires AutoHotkey v2.0

#Include shingeta.ahk

; Alt-Ctrl-\ 新下駄配列 ON/OFF
!^sc073::
{
  global
  ShinGeta := ! ShinGeta
}

#UseHook true

q::onKeyDown(ThisHotKey)
w::onKeyDown(ThisHotKey)
e::onKeyDown(ThisHotKey)
r::onKeyDown(ThisHotKey)
t::onKeyDown(ThisHotKey)
y::onKeyDown(ThisHotKey)
u::onKeyDown(ThisHotKey)
i::onKeyDown(ThisHotKey)
o::onKeyDown(ThisHotKey)
p::onKeyDown(ThisHotKey)
@::onKeyDown(ThisHotKey)
a::onKeyDown(ThisHotKey)
s::onKeyDown(ThisHotKey)
d::onKeyDown(ThisHotKey)
f::onKeyDown(ThisHotKey)
g::onKeyDown(ThisHotKey)
h::onKeyDown(ThisHotKey)
j::onKeyDown(ThisHotKey)
k::onKeyDown(ThisHotKey)
l::onKeyDown(ThisHotKey)
`;::onKeyDown(ThisHotKey)
z::onKeyDown(ThisHotKey)
x::onKeyDown(ThisHotKey)
c::onKeyDown(ThisHotKey)
v::onKeyDown(ThisHotKey)
b::onKeyDown(ThisHotKey)
n::onKeyDown(ThisHotKey)
m::onKeyDown(ThisHotKey)
sc033::onKeyDown(",")
.::onKeyDown(ThisHotKey)
/::onKeyDown(ThisHotKey)
sc073::onKeyDown("\")
1::onKeyDown(ThisHotKey)
2::onKeyDown(ThisHotKey)
3::onKeyDown(ThisHotKey)
4::onKeyDown(ThisHotKey)
5::onKeyDown(ThisHotKey)
6::onKeyDown(ThisHotKey)
7::onKeyDown(ThisHotKey)
8::onKeyDown(ThisHotKey)
9::onKeyDown(ThisHotKey)
0::onKeyDown(ThisHotKey)
-::onKeyDown(ThisHotKey)
[::onKeyDown(ThisHotKey)
]::onKeyDown(ThisHotKey)
sc028::onKeyDown(":")
~::onKeyDown(ThisHotKey)
sc07D::onKeyDown("\")

#UseHook false
