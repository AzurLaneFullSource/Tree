local var0 = class("BackYardSettlementCard")

function var0.Ctor(arg0, arg1)
	arg0._go = arg1
	arg0.additionTF = findTF(arg0._go, "addition_bg/Text")
	arg0.levelText = findTF(arg0._go, "exp/level"):GetComponent(typeof(Text))
	arg0.additionText = arg0.additionTF:GetComponent(typeof(Text))
	arg0.nameTxt = findTF(arg0._go, "name_bg/Mask/Text"):GetComponent(typeof(ScrollText))
	arg0.icon = findTF(arg0._go, "icon"):GetComponent(typeof(Image))
	arg0.slider = findTF(arg0._go, "exp/value"):GetComponent(typeof(Slider))
end

function var0.Update(arg0, arg1, arg2, arg3)
	arg0:UpdateInfo(arg2)
	arg0:DoAnimation(arg1, arg2, arg3)
end

function var0.UpdateInfo(arg0, arg1)
	arg0.additionText.text = "EXP+" .. 0
	arg0.levelText.text = "LEVEL" .. arg1.level

	arg0.nameTxt:SetText(arg1:getName())
	LoadSpriteAtlasAsync("HeroHrzIcon/" .. arg1:getPainting(), "", function(arg0)
		if arg0.exited then
			return
		end

		arg0.icon.sprite = arg0
	end)
end

function var0.DoAnimation(arg0, arg1, arg2, arg3)
	if arg2.level == arg2:getMaxLevel() then
		return
	end

	local var0 = 0.3
	local var1 = arg3.level - arg2.level

	TweenValue(arg0.additionTF, 0, arg1, var0 * (var1 + 1), 0, function(arg0)
		arg0.additionText.text = "EXP+" .. math.floor(arg0)
	end)

	local var2 = var1 > 0
	local var3 = math.max(arg3:getLevelExpConfig().exp, 0.001)

	if var2 then
		local var4 = math.max(arg2:getLevelExpConfig().exp, 0.001)

		arg0:DoLevelUpAnimation(arg2.exp, var4, arg3.exp, var3, arg3.level, var1, var0)
	else
		TweenValue(arg0.slider, 0, arg3.exp / var3, var0, 0, function(arg0)
			arg0:SetSliderValue(arg0.slider, arg0)
		end)
	end
end

function var0.DoLevelUpAnimation(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
	local var0
	local var1
	local var2

	local function var3()
		TweenValue(arg0.slider, 0, arg3 / arg4, arg7, 0, function(arg0)
			arg0:SetSliderValue(arg0.slider, arg0)
		end)
	end

	local function var4()
		TweenValue(arg0.slider, 0, 1, arg7, 0, function(arg0)
			arg0:SetSliderValue(arg0.slider, arg0)
		end, var0)
	end

	function var0()
		arg6 = arg6 - 1

		if arg6 == 0 then
			var3()
		else
			var4()
		end

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_BOAT_LEVEL_UP)

		arg0.levelText.text = "LEVEL" .. arg5 - arg6
	end

	TweenValue(arg0.slider, arg1, arg2, arg7, 0, function(arg0)
		arg0:SetSliderValue(arg0.slider, arg0 / arg2)
	end, var0)
end

function var0.SetSliderValue(arg0, arg1, arg2)
	if arg2 ~= 0 and arg2 < 0.03 then
		arg2 = 0.03
	end

	arg1.value = arg2
end

function var0.Dispose(arg0)
	if LeanTween.isTweening(arg0.slider.gameObject) then
		LeanTween.cancel(arg0.slider.gameObject)
	end

	if LeanTween.isTweening(arg0.additionTF.gameObject) then
		LeanTween.cancel(arg0.additionTF.gameObject)
	end

	arg0.exited = true
end

return var0
