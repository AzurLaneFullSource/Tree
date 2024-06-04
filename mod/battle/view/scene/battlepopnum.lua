ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = require("Mgr/Pool/PoolUtil")

var0.Battle.BattlePopNum = class("BattlePopNum")
var0.Battle.BattlePopNum.__name = "BattlePopNum"

local var3 = var0.Battle.BattlePopNum

var3.NUM_INIT_OFFSET = Vector3(0, 1.6, 0)

local var4 = Vector3(10000, 10000)
local var5 = Vector2(1, 1)

function var3.Ctor(arg0, arg1, arg2)
	arg0.bundle = arg2.bundle
	arg0.pool = arg1

	local var0 = Object.Instantiate(arg2.template)

	arg0._go = var0
	arg0._tf = var0.transform

	arg0:SetParent(arg2.parentTF)

	arg0._animator = var0:GetComponent(typeof(Animator))

	local var1 = arg0._tf:Find("text")

	if var1 then
		arg0.textCom = var1:GetComponent(typeof(Text))
	end

	var0:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0)
		arg1:Recycle(arg0)
	end)

	arg0._offsetVector = Vector3.zero
end

function var3.SetParent(arg0, arg1)
	arg0._tf:SetParent(arg1, false)
end

function var3.SetText(arg0, arg1)
	arg0.textCom.text = tostring(arg1)
end

function var3.SetReferenceCharacter(arg0, arg1, arg2)
	arg0._offsetVector.x = arg2.x

	local var0 = arg1:GetReferenceVector(arg0._offsetVector)

	var0:Add(var3.NUM_INIT_OFFSET)

	arg0._tf.position = var0
end

function var3.Play(arg0)
	arg0._animator.enabled = true
end

function var3.SetScale(arg0, arg1)
	arg0._tf.localScale = Vector2(arg1, arg1)
end

function var3.Init(arg0)
	arg0._go:SetActive(true)
end

function var3.Recycle(arg0)
	arg0._animator.enabled = false
	arg0._tf.position = var4
	arg0._tf.localScale = var5
end

function var3.Dispose(arg0)
	arg0._go:SetActive(false)

	arg0._go = nil
	arg0._tf = nil
end
