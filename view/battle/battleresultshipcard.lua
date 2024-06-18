local var0_0 = class("BattleResultShipCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._expTF = arg1_1

	arg0_1:init()
end

function var0_0.init(arg0_2)
	arg0_2._expContent = findTF(arg0_2._expTF, "content")
	arg0_2._expInfo = findTF(arg0_2._expContent, "exp")
	arg0_2._nameTxt = findTF(arg0_2._expContent, "info/name_mask/name")
	arg0_2._intimacyUpFX = findTF(arg0_2._expContent, "heartsfly")
	arg0_2._intimacyDownFX = findTF(arg0_2._expContent, "heartsbroken")
	arg0_2._lvText = findTF(arg0_2._expContent, "dockyard/lv/Text")
	arg0_2._lvUp = findTF(arg0_2._expContent, "dockyard/lv_bg/levelUpLabel")
	arg0_2._lvFX = findTF(arg0_2._expContent, "dockyard/lv_bg/levelup")
	arg0_2._expText = findTF(arg0_2._expInfo, "exp_text")
	arg0_2._expProgress = findTF(arg0_2._expInfo, "exp_progress")
	arg0_2._expImage = arg0_2._expProgress:GetComponent(typeof(Image))
	arg0_2._expBuff = findTF(arg0_2._expInfo, "exp_buff_mask/exp_buff")

	arg0_2._expTF:GetComponent(typeof(DftAniEvent)):SetTriggerEvent(function(arg0_3)
		arg0_2:expAnimation()
	end)
	SetActive(arg0_2._expTF, false)
end

function var0_0.SetShipVO(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4)
	flushShipCard(arg0_4._expTF, arg1_4)

	arg0_4._oldShipVO = arg1_4
	arg0_4._newShipVO = arg2_4
	arg0_4._isMVP = arg3_4
	arg0_4._buffName = arg4_4

	arg0_4:setShipInfo()
end

function var0_0.RegisterPreEXPTF(arg0_5, arg1_5)
	arg1_5:GetTF():GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_6)
		setActive(arg0_5._expTF, true)
	end)
end

function var0_0.ConfigCallback(arg0_7, arg1_7)
	arg0_7._expTF:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_8)
		arg1_7()
	end)
end

function var0_0.setShipInfo(arg0_9)
	setScrollText(arg0_9._nameTxt, arg0_9._oldShipVO:GetColorName())
	setActive(findTF(arg0_9._expContent, "mvp"), arg0_9._isMVP)
	SetActive(arg0_9._expBuff, arg0_9._buffName ~= nil)
	setScrollText(arg0_9._expBuff, arg0_9._buffName or "")
end

function var0_0.expAnimation(arg0_10)
	SetActive(arg0_10._expInfo, true)
	SetActive(arg0_10._intimacyUpFX, arg0_10._oldShipVO:getIntimacy() < arg0_10._newShipVO:getIntimacy())
	SetActive(arg0_10._intimacyDownFX, arg0_10._oldShipVO:getIntimacy() > arg0_10._newShipVO:getIntimacy())

	local var0_10 = arg0_10._oldShipVO:getConfig("rarity")
	local var1_10 = getExpByRarityFromLv1(var0_10, arg0_10._oldShipVO.level)

	arg0_10._expImage.fillAmount = arg0_10._oldShipVO:getExp() / var1_10

	if arg0_10._oldShipVO.level < arg0_10._newShipVO.level then
		local var2_10 = 0

		for iter0_10 = arg0_10._oldShipVO.level, arg0_10._newShipVO.level - 1 do
			var2_10 = var2_10 + getExpByRarityFromLv1(var0_10, iter0_10)
		end

		arg0_10.playAnimation(arg0_10._expTF, 0, var2_10 + arg0_10._newShipVO:getExp() - arg0_10._oldShipVO:getExp(), 1, 0, function(arg0_11)
			setText(arg0_10._expText, "+" .. math.ceil(arg0_11))
		end)

		arg0_10._animationLV = arg0_10._oldShipVO.level

		arg0_10:loopAnimation(arg0_10._oldShipVO:getExp() / var1_10, 1, 0.7, true)
	else
		local var3_10 = math.ceil(arg0_10._newShipVO:getExp() - arg0_10._oldShipVO:getExp())

		setText(arg0_10._expText, "+" .. var3_10)

		if arg0_10._oldShipVO.level == arg0_10._oldShipVO:getMaxLevel() then
			arg0_10._expImage.fillAmount = 1

			return
		end

		arg0_10.playAnimation(arg0_10._expTF, arg0_10._oldShipVO:getExp() / var1_10, arg0_10._newShipVO:getExp() / var1_10, 1, 0, function(arg0_12)
			arg0_10._expImage.fillAmount = arg0_12
		end)
	end
end

function var0_0.loopAnimation(arg0_13, arg1_13, arg2_13, arg3_13, arg4_13)
	local var0_13 = getExpByRarityFromLv1(arg0_13._oldShipVO:getConfig("rarity"), arg0_13._newShipVO.level)

	LeanTween.value(go(arg0_13._expTF), arg1_13, arg2_13, arg3_13):setOnUpdate(System.Action_float(function(arg0_14)
		arg0_13._expImage.fillAmount = arg0_14
	end)):setOnComplete(System.Action(function()
		arg0_13._animationLV = arg0_13._animationLV + 1

		if arg4_13 then
			arg0_13:levelUpEffect()
		end

		if arg0_13._newShipVO.level == arg0_13._animationLV then
			if arg0_13._animationLV == arg0_13._newShipVO:getMaxLevel() then
				arg0_13._expImage.fillAmount = 1
			else
				arg0_13:loopAnimation(0, arg0_13._newShipVO:getExp() / var0_13, 1, false)
			end
		elseif arg0_13._newShipVO.level > arg0_13._animationLV then
			arg0_13:loopAnimation(0, 1, 0.7, true)
		end
	end))
end

function var0_0.levelUpEffect(arg0_16)
	SetActive(arg0_16._lvUp, true)
	SetActive(arg0_16._lvFX, true)

	local var0_16 = arg0_16._lvUp.localPosition

	LeanTween.moveY(rtf(arg0_16._lvUp), var0_16.y + 30, 0.5):setOnComplete(System.Action(function()
		SetActive(arg0_16._lvUp, false)

		arg0_16._lvUp.localPosition = var0_16

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_BOAT_LEVEL_UP)
	end))

	if arg0_16._animationLV <= arg0_16._newShipVO.level then
		setText(arg0_16._lvText, arg0_16._animationLV)
	end
end

function var0_0.Play(arg0_18)
	setActive(arg0_18._expTF, true)
end

function var0_0.SkipAnimation(arg0_19)
	arg0_19._expTF:GetComponent(typeof(Animator)).enabled = false

	SetActive(arg0_19._expTF, true)
	SetActive(arg0_19._expContent, true)
	SetActive(arg0_19._expInfo, true)

	arg0_19._expTF:GetComponent(typeof(CanvasGroup)).alpha = 1

	LeanTween.cancel(go(arg0_19._lvUp))
	LeanTween.cancel(go(arg0_19._expTF))
	SetActive(arg0_19._intimacyUpFX, arg0_19._oldShipVO:getIntimacy() < arg0_19._newShipVO:getIntimacy())
	SetActive(arg0_19._intimacyDownFX, arg0_19._oldShipVO:getIntimacy() > arg0_19._newShipVO:getIntimacy())

	arg0_19._expContent.localPosition = Vector3(0, 0, 0)

	setText(arg0_19._lvText, arg0_19._newShipVO.level)

	if arg0_19._oldShipVO.level == arg0_19._oldShipVO:getMaxLevel() then
		setText(arg0_19._expText, "+" .. math.ceil(arg0_19._newShipVO:getExp() - arg0_19._oldShipVO:getExp()))

		arg0_19._expImage.fillAmount = 1
	else
		local var0_19 = arg0_19._oldShipVO:getConfig("rarity")

		if arg0_19._oldShipVO.level < arg0_19._newShipVO.level then
			local var1_19 = 0

			for iter0_19 = arg0_19._oldShipVO.level, arg0_19._newShipVO.level - 1 do
				var1_19 = var1_19 + getExpByRarityFromLv1(var0_19, iter0_19)
			end

			setText(arg0_19._expText, "+" .. var1_19 + arg0_19._newShipVO:getExp() - arg0_19._oldShipVO:getExp())
		else
			setText(arg0_19._expText, "+" .. math.ceil(arg0_19._newShipVO:getExp() - arg0_19._oldShipVO:getExp()))
		end

		arg0_19._expImage.fillAmount = arg0_19._newShipVO:getExp() / getExpByRarityFromLv1(var0_19, arg0_19._newShipVO.level)
	end

	SetActive(arg0_19._lvUp, false)
end

function var0_0.GetTF(arg0_20)
	return arg0_20._expTF
end

function var0_0.playAnimation(arg0_21, arg1_21, arg2_21, arg3_21, arg4_21, arg5_21)
	LeanTween.value(arg0_21.gameObject, arg1_21, arg2_21, arg3_21):setDelay(arg4_21):setOnUpdate(System.Action_float(function(arg0_22)
		arg5_21(arg0_22)
	end))
end

function var0_0.Dispose(arg0_23)
	arg0_23._oldShipVO = nil
	arg0_23._newShipVO = nil
end

return var0_0
