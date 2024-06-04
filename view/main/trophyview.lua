local var0 = class("TrophyView")

var0.GRAY_COLOR = Color(0.764, 0.764, 0.764, 0.784)

function var0.Ctor(arg0, arg1)
	arg0._go = arg1
	arg0._tf = arg1.transform
	arg0._trophyNamePic = findTF(arg0._tf, "frame/trophyName/Text")
	arg0._trophyNameBG = findTF(arg0._tf, "frame/trophyName")
	arg0._trophyIcon = findTF(arg0._tf, "frame/trophyIcon")
	arg0._trophyDescUpper = findTF(arg0._tf, "frame/trophyDesc/Text_upper"):GetComponent(typeof(Text))
	arg0._trophyDescLower = findTF(arg0._tf, "frame/trophyDesc/Text_lower"):GetComponent(typeof(Text))
	arg0._trophyCountBG = findTF(arg0._tf, "frame/trophyCount")
	arg0._trophyCount = findTF(arg0._tf, "frame/trophyCount/Text"):GetComponent(typeof(Text))
	arg0._progressBar = findTF(arg0._tf, "frame/trophy_progress/Fill"):GetComponent(typeof(Slider))
end

function var0.UpdateTrophyGroup(arg0, arg1)
	local var0 = arg1:getDisplayTrophy()
	local var1 = arg1:getProgressTrophy()

	arg0:updateInfoView(var0)
	arg0:updateProgressView(var1)
end

function var0.ProgressingForm(arg0, arg1)
	local var0 = arg1:getProgressTrophy()

	arg0:updateInfoView(var0)
	arg0:updateProgressView(var0)
end

function var0.ClaimForm(arg0, arg1)
	local var0 = arg1:getMaxClaimedTrophy()

	if var0 then
		arg0:updateInfoView(var0)
		arg0:updateProgressView(var0)
	end
end

function var0.updateInfoView(arg0, arg1)
	arg0._trophy = arg1
	arg0._trophyCount.text = arg1:getConfig("rank")

	if not arg1:isClaimed() and not arg1:canClaimed() then
		setActive(arg0._trophyCount, false)
	end

	LoadImageSpriteAsync("medal/" .. arg1:getConfig("icon"), arg0._trophyIcon, true)
	LoadImageSpriteAsync("medal/" .. arg1:getConfig("label"), arg0._trophyNamePic, true)
	arg0:setGray(arg0._trophyIcon, not arg1:isClaimed())
	arg0:setGray(arg0._trophyNamePic, not arg1:isClaimed())
	arg0:setGray(arg0._trophyNameBG, not arg1:isClaimed())
	arg0:setGray(arg0._trophyCountBG, not arg1:isClaimed())

	arg0._trophyDescUpper.text = arg1:getConfig("explain1")
	arg0._trophyDescLower.text = arg1:getConfig("explain2")
end

function var0.setGray(arg0, arg1, arg2)
	setGray(arg1, arg2, true)

	if arg2 then
		arg1:GetComponent(typeof(Image)).color = var0.GRAY_COLOR
	else
		arg1:GetComponent(typeof(Image)).color = Color.white
	end
end

function var0.updateProgressView(arg0, arg1)
	arg0._progressTrophy = arg1
	arg0._progressBar.value = arg1:getProgressRate()
end

function var0.GetTrophyClaimTipsID(arg0)
	return "reminder_" .. math.floor(arg0._trophy:getConfig("icon") / 10)
end

function var0.SetTrophyReminder(arg0, arg1)
	arg0._reminder = tf(arg1)

	arg0._reminder:SetParent(findTF(arg0._tf, "frame"), false)

	arg0._reminder.localPosition = arg0._trophyIcon.localPosition

	setActive(arg0._reminder, arg0._progressTrophy:canClaimed() and not arg0._progressTrophy:isClaimed())
end

function var0.PlayClaimAnima(arg0, arg1, arg2, arg3)
	arg0._isPlaying = true

	setActive(arg0._reminder, false)

	local var0 = arg0._tf:GetComponent(typeof(Animator))

	var0.enabled = true

	arg0._tf:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0)
		arg3()
		setActive(arg0._reminder, arg0._progressTrophy:canClaimed() and not arg0._progressTrophy:isClaimed())
	end)
	var0:Play("trophy_upper", -1, 0)
	setActive(arg2, true)

	local var1 = tf(arg2)

	var1:SetParent(findTF(arg0._tf, "frame"), false)

	var1.localScale = Vector3(1, 1, 0)

	LuaHelper.SetParticleEndEvent(arg2, function()
		arg0._isPlaying = false

		Object.Destroy(arg2)
	end)
end

function var0.IsPlaying(arg0)
	return arg0._isPlaying
end

return var0
