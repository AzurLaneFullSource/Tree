local var0 = class("CourtyardPlayTheLutePage", import(".CourtYardBaseSubPage"))

function var0.getUIName(arg0)
	return "CourtyardPlayTheLuteui"
end

function var0.OnLoaded(arg0)
	arg0.backBtn = arg0:findTF("back")
	arg0.tpl = arg0:findTF("keys/key")
	arg0.noteTr = arg0:findTF("prints/tansou_yinfu")
	arg0.keyTplPool = {
		arg0.tpl
	}
	arg0.tpls = {}
end

function var0.Show(arg0, arg1)
	arg0.furniture = arg1
	Input.multiTouchEnabled = true

	if arg0.isInit then
		arg0:BlurPanel()
	else
		seriesAsync({
			function(arg0)
				arg0:InitKeys(arg0)
			end,
			function(arg0)
				arg0.isInit = true

				arg0:RegisetEvent()
				onNextTick(arg0)
			end,
			function(arg0)
				arg0:BlurPanel()
				arg0()
			end
		})
	end
end

function var0.BlurPanel(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	var0.super.Show(arg0)
end

function var0.GetKeys(arg0)
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

function var0.GetTpl(arg0)
	if #arg0.keyTplPool > 0 then
		return table.remove(arg0.keyTplPool, 1)
	else
		local var0 = arg0.tpl

		return Object.Instantiate(var0, var0.parent)
	end
end

function var0.InitKeys(arg0, arg1)
	local var0 = arg0:GetKeys()
	local var1 = {}

	for iter0, iter1 in ipairs(var0) do
		table.insert(var1, function(arg0)
			local var0 = arg0:GetTpl()

			arg0:InitKey(var0, iter1[1], iter1[2])
			table.insert(arg0.tpls, var0)

			if iter0 % 3 == 0 then
				onNextTick(arg0)
			else
				arg0()
			end
		end)
	end

	seriesAsync(var1, arg1)
end

function var0.InitKey(arg0, arg1, arg2, arg3)
	local var0 = arg1:Find("Text"):GetComponent(typeof(Image))

	var0.sprite = GetSpriteFromAtlas("ui/CourtyardLute_atlas", arg2)

	var0:SetNativeSize()

	local var1 = arg1:Find("sel")

	onButton(arg0, arg1, function()
		setActive(var1, true)
		arg0:AnimationForKey(arg1)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/" .. arg3)
		arg0:OnStartPlay(arg2)
	end)
	arg1:Find("animation"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		setActive(var1, false)
		arg0:OnEndPlay(arg2)
	end)
end

function var0.OnStartPlay(arg0, arg1)
	return
end

function var0.OnEndPlay(arg0, arg1)
	return
end

function var0.AnimationForKey(arg0, arg1)
	local var0 = arg1:Find("animation"):GetComponent(typeof(Animation))

	var0:Stop()
	var0:Play()
end

function var0.ClearAnimationForKey(arg0, arg1)
	arg1:Find("animation"):GetComponent(typeof(Animation)):Stop()
	arg1:Find("animation"):GetComponent(typeof(DftAniEvent)):SetEndEvent(nil)
end

function var0.RegisetEvent(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:Hide()
	end, SFX)
end

function var0.Hide(arg0)
	Input.multiTouchEnabled = false

	var0.super.Hide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
	arg0:Emit("StopPlayMusicalInstruments", arg0.furniture.id)
end

function var0.ClearAllAnimation(arg0)
	for iter0, iter1 in ipairs(arg0.tpls) do
		arg0:ClearAnimationForKey(iter1)
	end
end

function var0.OnDestroy(arg0)
	arg0:ClearAllAnimation()

	if arg0:isShowing() then
		arg0:Hide()
	end
end

return var0
