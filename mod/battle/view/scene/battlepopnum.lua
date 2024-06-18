ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = require("Mgr/Pool/PoolUtil")

var0_0.Battle.BattlePopNum = class("BattlePopNum")
var0_0.Battle.BattlePopNum.__name = "BattlePopNum"

local var3_0 = var0_0.Battle.BattlePopNum

var3_0.NUM_INIT_OFFSET = Vector3(0, 1.6, 0)

local var4_0 = Vector3(10000, 10000)
local var5_0 = Vector2(1, 1)

function var3_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.bundle = arg2_1.bundle
	arg0_1.pool = arg1_1

	local var0_1 = Object.Instantiate(arg2_1.template)

	arg0_1._go = var0_1
	arg0_1._tf = var0_1.transform

	arg0_1:SetParent(arg2_1.parentTF)

	arg0_1._animator = var0_1:GetComponent(typeof(Animator))

	local var1_1 = arg0_1._tf:Find("text")

	if var1_1 then
		arg0_1.textCom = var1_1:GetComponent(typeof(Text))
	end

	var0_1:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_2)
		arg1_1:Recycle(arg0_1)
	end)

	arg0_1._offsetVector = Vector3.zero
end

function var3_0.SetParent(arg0_3, arg1_3)
	arg0_3._tf:SetParent(arg1_3, false)
end

function var3_0.SetText(arg0_4, arg1_4)
	arg0_4.textCom.text = tostring(arg1_4)
end

function var3_0.SetReferenceCharacter(arg0_5, arg1_5, arg2_5)
	arg0_5._offsetVector.x = arg2_5.x

	local var0_5 = arg1_5:GetReferenceVector(arg0_5._offsetVector)

	var0_5:Add(var3_0.NUM_INIT_OFFSET)

	arg0_5._tf.position = var0_5
end

function var3_0.Play(arg0_6)
	arg0_6._animator.enabled = true
end

function var3_0.SetScale(arg0_7, arg1_7)
	arg0_7._tf.localScale = Vector2(arg1_7, arg1_7)
end

function var3_0.Init(arg0_8)
	arg0_8._go:SetActive(true)
end

function var3_0.Recycle(arg0_9)
	arg0_9._animator.enabled = false
	arg0_9._tf.position = var4_0
	arg0_9._tf.localScale = var5_0
end

function var3_0.Dispose(arg0_10)
	arg0_10._go:SetActive(false)

	arg0_10._go = nil
	arg0_10._tf = nil
end
