local var0_0 = class("CourtyardPlayTheLutePage", import(".CourtYardBaseSubPage"))

function var0_0.getUIName(arg0_1)
	return "CourtyardPlayTheLuteui"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.backBtn = arg0_2:findTF("back")
	arg0_2.tpl = arg0_2:findTF("keys/key")
	arg0_2.noteTr = arg0_2:findTF("prints/tansou_yinfu")
	arg0_2.keyTplPool = {
		arg0_2.tpl
	}
	arg0_2.tpls = {}
end

function var0_0.Show(arg0_3, arg1_3)
	arg0_3.furniture = arg1_3
	Input.multiTouchEnabled = true

	if arg0_3.isInit then
		arg0_3:BlurPanel()
	else
		seriesAsync({
			function(arg0_4)
				arg0_3:InitKeys(arg0_4)
			end,
			function(arg0_5)
				arg0_3.isInit = true

				arg0_3:RegisetEvent()
				onNextTick(arg0_5)
			end,
			function(arg0_6)
				arg0_3:BlurPanel()
				arg0_6()
			end
		})
	end
end

function var0_0.BlurPanel(arg0_7)
	pg.UIMgr.GetInstance():BlurPanel(arg0_7._tf)
	var0_0.super.Show(arg0_7)
end

function var0_0.GetKeys(arg0_8)
	return {
		{
			"7D",
			"pipa_1"
		},
		{
			"1",
			"pipa_2"
		},
		{
			"2",
			"pipa_5"
		},
		{
			"3",
			"pipa_7"
		},
		{
			"4",
			"pipa_9"
		},
		{
			"5",
			"pipa_11"
		},
		{
			"6",
			"pipa_13"
		},
		{
			"7",
			"pipa_15"
		},
		{
			"D1",
			"pipa_3"
		},
		{
			"D2",
			"pipa_6"
		},
		{
			"D3",
			"pipa_8"
		},
		{
			"D4",
			"pipa_10"
		},
		{
			"D5",
			"pipa_12"
		},
		{
			"D6",
			"pipa_14"
		},
		{
			"D7",
			"pipa_16"
		},
		{
			"DD1",
			"pipa_4"
		}
	}
end

function var0_0.GetTpl(arg0_9)
	if #arg0_9.keyTplPool > 0 then
		return table.remove(arg0_9.keyTplPool, 1)
	else
		local var0_9 = arg0_9.tpl

		return Object.Instantiate(var0_9, var0_9.parent)
	end
end

function var0_0.InitKeys(arg0_10, arg1_10)
	local var0_10 = arg0_10:GetKeys()
	local var1_10 = {}

	for iter0_10, iter1_10 in ipairs(var0_10) do
		table.insert(var1_10, function(arg0_11)
			local var0_11 = arg0_10:GetTpl()

			arg0_10:InitKey(var0_11, iter1_10[1], iter1_10[2])
			table.insert(arg0_10.tpls, var0_11)

			if iter0_10 % 3 == 0 then
				onNextTick(arg0_11)
			else
				arg0_11()
			end
		end)
	end

	seriesAsync(var1_10, arg1_10)
end

function var0_0.InitKey(arg0_12, arg1_12, arg2_12, arg3_12)
	local var0_12 = arg1_12:Find("Text"):GetComponent(typeof(Image))

	var0_12.sprite = GetSpriteFromAtlas("ui/CourtyardLute_atlas", arg2_12)

	var0_12:SetNativeSize()

	local var1_12 = arg1_12:Find("sel")

	onButton(arg0_12, arg1_12, function()
		setActive(var1_12, true)
		arg0_12:AnimationForKey(arg1_12)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/" .. arg3_12)
		arg0_12:OnStartPlay(arg2_12)
	end)
	arg1_12:Find("animation"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		setActive(var1_12, false)
		arg0_12:OnEndPlay(arg2_12)
	end)
end

function var0_0.OnStartPlay(arg0_15, arg1_15)
	return
end

function var0_0.OnEndPlay(arg0_16, arg1_16)
	return
end

function var0_0.AnimationForKey(arg0_17, arg1_17)
	local var0_17 = arg1_17:Find("animation"):GetComponent(typeof(Animation))

	var0_17:Stop()
	var0_17:Play()
end

function var0_0.ClearAnimationForKey(arg0_18, arg1_18)
	arg1_18:Find("animation"):GetComponent(typeof(Animation)):Stop()
	arg1_18:Find("animation"):GetComponent(typeof(DftAniEvent)):SetEndEvent(nil)
end

function var0_0.RegisetEvent(arg0_19)
	onButton(arg0_19, arg0_19.backBtn, function()
		arg0_19:Hide()
	end, SFX)
end

function var0_0.Hide(arg0_21)
	Input.multiTouchEnabled = false

	var0_0.super.Hide(arg0_21)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_21._tf, arg0_21._parentTf)
	arg0_21:Emit("StopPlayMusicalInstruments", arg0_21.furniture.id)
end

function var0_0.ClearAllAnimation(arg0_22)
	for iter0_22, iter1_22 in ipairs(arg0_22.tpls) do
		arg0_22:ClearAnimationForKey(iter1_22)
	end
end

function var0_0.OnDestroy(arg0_23)
	arg0_23:ClearAllAnimation()

	if arg0_23:isShowing() then
		arg0_23:Hide()
	end
end

return var0_0
