local var0_0 = class("BackYardSettlementCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1.additionTF = findTF(arg0_1._go, "addition_bg/Text")
	arg0_1.levelText = findTF(arg0_1._go, "exp/level"):GetComponent(typeof(Text))
	arg0_1.additionText = arg0_1.additionTF:GetComponent(typeof(Text))
	arg0_1.nameTxt = findTF(arg0_1._go, "name_bg/Mask/Text"):GetComponent(typeof(ScrollText))
	arg0_1.icon = findTF(arg0_1._go, "icon"):GetComponent(typeof(Image))
	arg0_1.slider = findTF(arg0_1._go, "exp/value"):GetComponent(typeof(Slider))
end

function var0_0.Update(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2:UpdateInfo(arg2_2)
	arg0_2:DoAnimation(arg1_2, arg2_2, arg3_2)
end

function var0_0.UpdateInfo(arg0_3, arg1_3)
	arg0_3.additionText.text = "EXP+" .. 0
	arg0_3.levelText.text = "LEVEL" .. arg1_3.level

	arg0_3.nameTxt:SetText(arg1_3:getName())
	LoadSpriteAtlasAsync("HeroHrzIcon/" .. arg1_3:getPainting(), "", function(arg0_4)
		if arg0_3.exited then
			return
		end

		arg0_3.icon.sprite = arg0_4
	end)
end

function var0_0.DoAnimation(arg0_5, arg1_5, arg2_5, arg3_5)
	if arg2_5.level == arg2_5:getMaxLevel() then
		return
	end

	local var0_5 = 0.3
	local var1_5 = arg3_5.level - arg2_5.level

	TweenValue(arg0_5.additionTF, 0, arg1_5, var0_5 * (var1_5 + 1), 0, function(arg0_6)
		arg0_5.additionText.text = "EXP+" .. math.floor(arg0_6)
	end)

	local var2_5 = var1_5 > 0
	local var3_5 = math.max(arg3_5:getLevelExpConfig().exp, 0.001)

	if var2_5 then
		local var4_5 = math.max(arg2_5:getLevelExpConfig().exp, 0.001)

		arg0_5:DoLevelUpAnimation(arg2_5.exp, var4_5, arg3_5.exp, var3_5, arg3_5.level, var1_5, var0_5)
	else
		TweenValue(arg0_5.slider, 0, arg3_5.exp / var3_5, var0_5, 0, function(arg0_7)
			arg0_5:SetSliderValue(arg0_5.slider, arg0_7)
		end)
	end
end

function var0_0.DoLevelUpAnimation(arg0_8, arg1_8, arg2_8, arg3_8, arg4_8, arg5_8, arg6_8, arg7_8)
	local var0_8
	local var1_8
	local var2_8

	local function var3_8()
		TweenValue(arg0_8.slider, 0, arg3_8 / arg4_8, arg7_8, 0, function(arg0_10)
			arg0_8:SetSliderValue(arg0_8.slider, arg0_10)
		end)
	end

	local function var4_8()
		TweenValue(arg0_8.slider, 0, 1, arg7_8, 0, function(arg0_12)
			arg0_8:SetSliderValue(arg0_8.slider, arg0_12)
		end, var0_8)
	end

	function var0_8()
		arg6_8 = arg6_8 - 1

		if arg6_8 == 0 then
			var3_8()
		else
			var4_8()
		end

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_BOAT_LEVEL_UP)

		arg0_8.levelText.text = "LEVEL" .. arg5_8 - arg6_8
	end

	TweenValue(arg0_8.slider, arg1_8, arg2_8, arg7_8, 0, function(arg0_14)
		arg0_8:SetSliderValue(arg0_8.slider, arg0_14 / arg2_8)
	end, var0_8)
end

function var0_0.SetSliderValue(arg0_15, arg1_15, arg2_15)
	if arg2_15 ~= 0 and arg2_15 < 0.03 then
		arg2_15 = 0.03
	end

	arg1_15.value = arg2_15
end

function var0_0.Dispose(arg0_16)
	if LeanTween.isTweening(arg0_16.slider.gameObject) then
		LeanTween.cancel(arg0_16.slider.gameObject)
	end

	if LeanTween.isTweening(arg0_16.additionTF.gameObject) then
		LeanTween.cancel(arg0_16.additionTF.gameObject)
	end

	arg0_16.exited = true
end

return var0_0
