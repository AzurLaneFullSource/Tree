local var0_0 = class("ReFluxCGPlayer", import("..animation.StoryAnimtion"))
local var1_0 = "anim_CG_1_show"
local var2_0 = "anim_CG_1"
local var3_0 = "anim_CG_2"
local var4_0 = "anim_CG_1_hide"
local var5_0 = "anim_CG_textfx"

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1)

	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.topBox = arg0_1._tf:Find("CGbox_top")
	arg0_1.bottomBox = arg0_1._tf:Find("CGbox_bottom")
	arg0_1.topDft = arg0_1.topBox:GetComponent(typeof(DftAniEvent))
	arg0_1.topAnim = arg0_1.topBox:GetComponent(typeof(Animation))
	arg0_1.bottomDft = arg0_1.bottomBox:GetComponent(typeof(DftAniEvent))
	arg0_1.bottomAnim = arg0_1.bottomBox:GetComponent(typeof(Animation))
	arg0_1.topBg = arg0_1.topBox:Find("1/mask/CG1"):GetComponent(typeof(Image))
	arg0_1.bottomBg = arg0_1.bottomBox:Find("2/CG2"):GetComponent(typeof(Image))
	arg0_1.blurSize = pg.UIMgr.GetInstance().cameraBlurs[pg.UIMgr.CameraUI][1].blurSize
	arg0_1.title = arg0_1.topBox:Find("text")
	arg0_1.titleAnim = arg0_1.title:GetComponent(typeof(Animation))
	arg0_1.titleDft = arg0_1.title:GetComponent(typeof(DftAniEvent))
	arg0_1.titleTxt = arg0_1.title:Find("animroot/text"):GetComponent(typeof(Text))
end

function var0_0.Play(arg0_2, arg1_2, arg2_2)
	assert(#arg1_2 >= 3, "bgs can not be empty")
	arg0_2:UpdateLayout(arg1_2[1], arg1_2[2])

	local var0_2 = {}

	table.insert(var0_2, function(arg0_3)
		arg0_2:PlayEnterAnimation(arg0_3)
	end)

	local var1_2 = #arg1_2 - 2

	arg0_2.speed = 1

	for iter0_2 = 3, #arg1_2 do
		local var2_2 = arg1_2[iter0_2]

		if iter0_2 == var1_2 then
			table.insert(var0_2, function(arg0_4)
				arg0_2:PlayTitleAniamtion(arg0_4)
			end)
		end

		table.insert(var0_2, function(arg0_5)
			arg0_2:PlayTurnAnimation(arg0_2.speed, arg0_5)
		end)
		table.insert(var0_2, function(arg0_6)
			arg0_2:ReplaceGC(var2_2, arg0_6)
		end)
	end

	parallelAsync({
		function(arg0_7)
			seriesAsync(var0_2, arg0_7)
		end,
		function(arg0_8)
			arg0_2.titleAnimCallback = arg0_8
		end
	}, function()
		seriesAsync({
			function(arg0_10)
				arg0_2:PlayExitAnimation(arg0_10)
			end,
			function(arg0_11)
				arg0_2:ResetCG(arg0_11)
			end
		}, arg2_2)
	end)
end

function var0_0.ResetCG(arg0_12, arg1_12)
	arg0_12:ResetLayout()
	arg0_12:ResetBlurSize()
	arg1_12()
end

function var0_0.UpdateSpeed(arg0_13)
	arg0_13.speed = arg0_13.speed + 0.2
	arg0_13.speed = math.clamp(arg0_13.speed, 1, 2)
end

function var0_0.UpdateLayout(arg0_14, arg1_14, arg2_14)
	setActive(arg0_14.title, false)
	pg.UIMgr.GetInstance():BlurPanel(arg0_14.topBox)
	setParent(arg0_14.bottomBox, pg.UIMgr.GetInstance().UIOrigin)

	arg0_14.topBg.sprite = LoadSprite("bg/" .. arg1_14)
	arg0_14.bottomBg.sprite = LoadSprite("bg/" .. arg2_14)
end

function var0_0.ResetLayout(arg0_15)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_15.topBox, arg0_15._tf)
	setParent(arg0_15.bottomBox, arg0_15._tf)
end

function var0_0.PlayTitleAniamtion(arg0_16, arg1_16)
	arg0_16.titleAnim:Stop()

	arg0_16.titleTxt.text = ""

	arg0_16:SetTriggerEvent(arg0_16.titleDft, function()
		arg0_16.titleTxt.text = i18n("refux_cg_title")
	end)
	arg0_16:SetEndEvent(arg0_16.titleDft, function()
		if arg0_16.titleAnimCallback then
			arg0_16.titleAnimCallback()

			arg0_16.titleAnimCallback = nil
		end
	end)
	arg0_16.titleAnim:Play(var5_0)
	setActive(arg0_16.title, true)
	arg1_16()
end

function var0_0.PlayEnterAnimation(arg0_19, arg1_19)
	arg0_19:SetEndEvent(arg0_19.topDft, arg1_19)
	arg0_19.topAnim:Play(var1_0)
end

function var0_0.PlayExitAnimation(arg0_20, arg1_20)
	setActive(arg0_20.bottomBox, false)
	arg0_20:SetEndEvent(arg0_20.topDft, arg1_20)
	arg0_20.topAnim:Play(var4_0)
end

function var0_0.PlayTurnAnimation(arg0_21, arg1_21, arg2_21)
	arg0_21:StopAniamtion(arg0_21.topAnim, var2_0)
	arg0_21:StopAniamtion(arg0_21.bottomAnim, var3_0)
	parallelAsync({
		function(arg0_22)
			arg0_21:SetEndEvent(arg0_21.topDft, arg0_22)
			arg0_21:PlayAniamtion(arg0_21.topAnim, arg1_21, var2_0)
		end,
		function(arg0_23)
			arg0_21:SetEndEvent(arg0_21.bottomDft, arg0_23)
			arg0_21:PlayAniamtion(arg0_21.bottomAnim, arg1_21, var3_0)
		end,
		function(arg0_24)
			arg0_21:UpdateBlurSize(3, 0, 0.35 / arg1_21, arg0_24)
		end
	}, arg2_21)
end

function var0_0.UpdateBlurSize(arg0_25, arg1_25, arg2_25, arg3_25, arg4_25)
	local var0_25 = pg.UIMgr.GetInstance().cameraBlurs[pg.UIMgr.CameraUI][1]

	arg0_25:TweenValue(arg0_25._tf, arg1_25, arg2_25, arg3_25, 0, function(arg0_26)
		var0_25.blurSize = arg0_26
	end, arg4_25)
end

function var0_0.ResetBlurSize(arg0_27)
	pg.UIMgr.GetInstance().cameraBlurs[pg.UIMgr.CameraUI][1].blurSize = arg0_27.blurSize
end

function var0_0.ReplaceGC(arg0_28, arg1_28, arg2_28)
	arg0_28:UpdateSpeed()
	arg0_28:StopAniamtion(arg0_28.topAnim, var2_0)
	arg0_28:StopAniamtion(arg0_28.bottomAnim, var3_0)

	local var0_28 = arg0_28.bottomBg.sprite

	arg0_28.topBg.sprite = var0_28
	arg0_28.bottomBg.sprite = LoadSprite("bg/" .. arg1_28)

	arg2_28()
end

function var0_0.SetEndEvent(arg0_29, arg1_29, arg2_29)
	arg1_29:SetEndEvent(nil)
	arg1_29:SetEndEvent(function()
		arg1_29:SetEndEvent(nil)
		arg2_29()
	end)
end

function var0_0.SetTriggerEvent(arg0_31, arg1_31, arg2_31)
	arg1_31:SetTriggerEvent(nil)
	arg1_31:SetTriggerEvent(function()
		arg1_31:SetTriggerEvent(nil)
		arg2_31()
	end)
end

function var0_0.PlayAniamtion(arg0_33, arg1_33, arg2_33, arg3_33)
	arg1_33:get_Item(arg3_33).speed = arg2_33

	arg1_33:Play(arg3_33)
end

function var0_0.StopAniamtion(arg0_34, arg1_34, arg2_34)
	arg1_34:get_Item(arg2_34).speed = 1
	arg1_34:get_Item(arg2_34).time = 0

	arg1_34:Rewind(arg2_34)
	arg1_34:Sample()
end

function var0_0.Dispose(arg0_35)
	arg0_35.topDft:SetEndEvent(nil)
	arg0_35.bottomDft:SetEndEvent(nil)
	arg0_35.titleDft:SetEndEvent(nil)
	arg0_35.titleDft:SetTriggerEvent(nil)
	arg0_35:ResetLayout()

	arg0_35._go = nil
	arg0_35._tf = nil
	arg0_35.topBox = nil
	arg0_35.bottomBox = nil
	arg0_35.topDft = nil

	arg0_35:ClearAnimation()
end

return var0_0
