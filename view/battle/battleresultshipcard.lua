local var0 = class("BattleResultShipCard")

function var0.Ctor(arg0, arg1)
	arg0._expTF = arg1

	arg0:init()
end

function var0.init(arg0)
	arg0._expContent = findTF(arg0._expTF, "content")
	arg0._expInfo = findTF(arg0._expContent, "exp")
	arg0._nameTxt = findTF(arg0._expContent, "info/name_mask/name")
	arg0._intimacyUpFX = findTF(arg0._expContent, "heartsfly")
	arg0._intimacyDownFX = findTF(arg0._expContent, "heartsbroken")
	arg0._lvText = findTF(arg0._expContent, "dockyard/lv/Text")
	arg0._lvUp = findTF(arg0._expContent, "dockyard/lv_bg/levelUpLabel")
	arg0._lvFX = findTF(arg0._expContent, "dockyard/lv_bg/levelup")
	arg0._expText = findTF(arg0._expInfo, "exp_text")
	arg0._expProgress = findTF(arg0._expInfo, "exp_progress")
	arg0._expImage = arg0._expProgress:GetComponent(typeof(Image))
	arg0._expBuff = findTF(arg0._expInfo, "exp_buff_mask/exp_buff")

	arg0._expTF:GetComponent(typeof(DftAniEvent)):SetTriggerEvent(function(arg0)
		arg0:expAnimation()
	end)
	SetActive(arg0._expTF, false)
end

function var0.SetShipVO(arg0, arg1, arg2, arg3, arg4)
	flushShipCard(arg0._expTF, arg1)

	arg0._oldShipVO = arg1
	arg0._newShipVO = arg2
	arg0._isMVP = arg3
	arg0._buffName = arg4

	arg0:setShipInfo()
end

function var0.RegisterPreEXPTF(arg0, arg1)
	arg1:GetTF():GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0)
		setActive(arg0._expTF, true)
	end)
end

function var0.ConfigCallback(arg0, arg1)
	arg0._expTF:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0)
		arg1()
	end)
end

function var0.setShipInfo(arg0)
	setScrollText(arg0._nameTxt, arg0._oldShipVO:GetColorName())
	setActive(findTF(arg0._expContent, "mvp"), arg0._isMVP)
	SetActive(arg0._expBuff, arg0._buffName ~= nil)
	setScrollText(arg0._expBuff, arg0._buffName or "")
end

function var0.expAnimation(arg0)
	SetActive(arg0._expInfo, true)
	SetActive(arg0._intimacyUpFX, arg0._oldShipVO:getIntimacy() < arg0._newShipVO:getIntimacy())
	SetActive(arg0._intimacyDownFX, arg0._oldShipVO:getIntimacy() > arg0._newShipVO:getIntimacy())

	local var0 = arg0._oldShipVO:getConfig("rarity")
	local var1 = getExpByRarityFromLv1(var0, arg0._oldShipVO.level)

	arg0._expImage.fillAmount = arg0._oldShipVO:getExp() / var1

	if arg0._oldShipVO.level < arg0._newShipVO.level then
		local var2 = 0

		for iter0 = arg0._oldShipVO.level, arg0._newShipVO.level - 1 do
			var2 = var2 + getExpByRarityFromLv1(var0, iter0)
		end

		arg0.playAnimation(arg0._expTF, 0, var2 + arg0._newShipVO:getExp() - arg0._oldShipVO:getExp(), 1, 0, function(arg0)
			setText(arg0._expText, "+" .. math.ceil(arg0))
		end)

		arg0._animationLV = arg0._oldShipVO.level

		arg0:loopAnimation(arg0._oldShipVO:getExp() / var1, 1, 0.7, true)
	else
		local var3 = math.ceil(arg0._newShipVO:getExp() - arg0._oldShipVO:getExp())

		setText(arg0._expText, "+" .. var3)

		if arg0._oldShipVO.level == arg0._oldShipVO:getMaxLevel() then
			arg0._expImage.fillAmount = 1

			return
		end

		arg0.playAnimation(arg0._expTF, arg0._oldShipVO:getExp() / var1, arg0._newShipVO:getExp() / var1, 1, 0, function(arg0)
			arg0._expImage.fillAmount = arg0
		end)
	end
end

function var0.loopAnimation(arg0, arg1, arg2, arg3, arg4)
	local var0 = getExpByRarityFromLv1(arg0._oldShipVO:getConfig("rarity"), arg0._newShipVO.level)

	LeanTween.value(go(arg0._expTF), arg1, arg2, arg3):setOnUpdate(System.Action_float(function(arg0)
		arg0._expImage.fillAmount = arg0
	end)):setOnComplete(System.Action(function()
		arg0._animationLV = arg0._animationLV + 1

		if arg4 then
			arg0:levelUpEffect()
		end

		if arg0._newShipVO.level == arg0._animationLV then
			if arg0._animationLV == arg0._newShipVO:getMaxLevel() then
				arg0._expImage.fillAmount = 1
			else
				arg0:loopAnimation(0, arg0._newShipVO:getExp() / var0, 1, false)
			end
		elseif arg0._newShipVO.level > arg0._animationLV then
			arg0:loopAnimation(0, 1, 0.7, true)
		end
	end))
end

function var0.levelUpEffect(arg0)
	SetActive(arg0._lvUp, true)
	SetActive(arg0._lvFX, true)

	local var0 = arg0._lvUp.localPosition

	LeanTween.moveY(rtf(arg0._lvUp), var0.y + 30, 0.5):setOnComplete(System.Action(function()
		SetActive(arg0._lvUp, false)

		arg0._lvUp.localPosition = var0

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_BOAT_LEVEL_UP)
	end))

	if arg0._animationLV <= arg0._newShipVO.level then
		setText(arg0._lvText, arg0._animationLV)
	end
end

function var0.Play(arg0)
	setActive(arg0._expTF, true)
end

function var0.SkipAnimation(arg0)
	arg0._expTF:GetComponent(typeof(Animator)).enabled = false

	SetActive(arg0._expTF, true)
	SetActive(arg0._expContent, true)
	SetActive(arg0._expInfo, true)

	arg0._expTF:GetComponent(typeof(CanvasGroup)).alpha = 1

	LeanTween.cancel(go(arg0._lvUp))
	LeanTween.cancel(go(arg0._expTF))
	SetActive(arg0._intimacyUpFX, arg0._oldShipVO:getIntimacy() < arg0._newShipVO:getIntimacy())
	SetActive(arg0._intimacyDownFX, arg0._oldShipVO:getIntimacy() > arg0._newShipVO:getIntimacy())

	arg0._expContent.localPosition = Vector3(0, 0, 0)

	setText(arg0._lvText, arg0._newShipVO.level)

	if arg0._oldShipVO.level == arg0._oldShipVO:getMaxLevel() then
		setText(arg0._expText, "+" .. math.ceil(arg0._newShipVO:getExp() - arg0._oldShipVO:getExp()))

		arg0._expImage.fillAmount = 1
	else
		local var0 = arg0._oldShipVO:getConfig("rarity")

		if arg0._oldShipVO.level < arg0._newShipVO.level then
			local var1 = 0

			for iter0 = arg0._oldShipVO.level, arg0._newShipVO.level - 1 do
				var1 = var1 + getExpByRarityFromLv1(var0, iter0)
			end

			setText(arg0._expText, "+" .. var1 + arg0._newShipVO:getExp() - arg0._oldShipVO:getExp())
		else
			setText(arg0._expText, "+" .. math.ceil(arg0._newShipVO:getExp() - arg0._oldShipVO:getExp()))
		end

		arg0._expImage.fillAmount = arg0._newShipVO:getExp() / getExpByRarityFromLv1(var0, arg0._newShipVO.level)
	end

	SetActive(arg0._lvUp, false)
end

function var0.GetTF(arg0)
	return arg0._expTF
end

function var0.playAnimation(arg0, arg1, arg2, arg3, arg4, arg5)
	LeanTween.value(arg0.gameObject, arg1, arg2, arg3):setDelay(arg4):setOnUpdate(System.Action_float(function(arg0)
		arg5(arg0)
	end))
end

function var0.Dispose(arg0)
	arg0._oldShipVO = nil
	arg0._newShipVO = nil
end

return var0
