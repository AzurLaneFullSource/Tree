local var0_0 = class("TrophyView")

var0_0.GRAY_COLOR = Color(0.764, 0.764, 0.764, 0.784)

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1._trophyNamePic = findTF(arg0_1._tf, "frame/trophyName/Text")
	arg0_1._trophyNameBG = findTF(arg0_1._tf, "frame/trophyName")
	arg0_1._trophyIcon = findTF(arg0_1._tf, "frame/trophyIcon")
	arg0_1._trophyDescUpper = findTF(arg0_1._tf, "frame/trophyDesc/Text_upper"):GetComponent(typeof(Text))
	arg0_1._trophyDescLower = findTF(arg0_1._tf, "frame/trophyDesc/Text_lower"):GetComponent(typeof(Text))
	arg0_1._trophyCountBG = findTF(arg0_1._tf, "frame/trophyCount")
	arg0_1._trophyCount = findTF(arg0_1._tf, "frame/trophyCount/Text"):GetComponent(typeof(Text))
	arg0_1._progressBar = findTF(arg0_1._tf, "frame/trophy_progress/Fill"):GetComponent(typeof(Slider))
end

function var0_0.UpdateTrophyGroup(arg0_2, arg1_2)
	local var0_2 = arg1_2:getDisplayTrophy()
	local var1_2 = arg1_2:getProgressTrophy()

	arg0_2:updateInfoView(var0_2)
	arg0_2:updateProgressView(var1_2)
end

function var0_0.ProgressingForm(arg0_3, arg1_3)
	local var0_3 = arg1_3:getProgressTrophy()

	arg0_3:updateInfoView(var0_3)
	arg0_3:updateProgressView(var0_3)
end

function var0_0.ClaimForm(arg0_4, arg1_4)
	local var0_4 = arg1_4:getMaxClaimedTrophy()

	if var0_4 then
		arg0_4:updateInfoView(var0_4)
		arg0_4:updateProgressView(var0_4)
	end
end

function var0_0.updateInfoView(arg0_5, arg1_5)
	arg0_5._trophy = arg1_5
	arg0_5._trophyCount.text = arg1_5:getConfig("rank")

	if not arg1_5:isClaimed() and not arg1_5:canClaimed() then
		setActive(arg0_5._trophyCount, false)
	end

	LoadImageSpriteAsync("medal/" .. arg1_5:getConfig("icon"), arg0_5._trophyIcon, true)
	LoadImageSpriteAsync("medal/" .. arg1_5:getConfig("label"), arg0_5._trophyNamePic, true)
	arg0_5:setGray(arg0_5._trophyIcon, not arg1_5:isClaimed())
	arg0_5:setGray(arg0_5._trophyNamePic, not arg1_5:isClaimed())
	arg0_5:setGray(arg0_5._trophyNameBG, not arg1_5:isClaimed())
	arg0_5:setGray(arg0_5._trophyCountBG, not arg1_5:isClaimed())

	arg0_5._trophyDescUpper.text = arg1_5:getConfig("explain1")
	arg0_5._trophyDescLower.text = arg1_5:getConfig("explain2")
end

function var0_0.setGray(arg0_6, arg1_6, arg2_6)
	setGray(arg1_6, arg2_6, true)

	if arg2_6 then
		arg1_6:GetComponent(typeof(Image)).color = var0_0.GRAY_COLOR
	else
		arg1_6:GetComponent(typeof(Image)).color = Color.white
	end
end

function var0_0.updateProgressView(arg0_7, arg1_7)
	arg0_7._progressTrophy = arg1_7
	arg0_7._progressBar.value = arg1_7:getProgressRate()
end

function var0_0.GetTrophyClaimTipsID(arg0_8)
	return "reminder_" .. math.floor(arg0_8._trophy:getConfig("icon") / 10)
end

function var0_0.SetTrophyReminder(arg0_9, arg1_9)
	arg0_9._reminder = tf(arg1_9)

	arg0_9._reminder:SetParent(findTF(arg0_9._tf, "frame"), false)

	arg0_9._reminder.localPosition = arg0_9._trophyIcon.localPosition

	setActive(arg0_9._reminder, arg0_9._progressTrophy:canClaimed() and not arg0_9._progressTrophy:isClaimed())
end

function var0_0.PlayClaimAnima(arg0_10, arg1_10, arg2_10, arg3_10)
	arg0_10._isPlaying = true

	setActive(arg0_10._reminder, false)

	local var0_10 = arg0_10._tf:GetComponent(typeof(Animator))

	var0_10.enabled = true

	arg0_10._tf:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_11)
		arg3_10()
		setActive(arg0_10._reminder, arg0_10._progressTrophy:canClaimed() and not arg0_10._progressTrophy:isClaimed())
	end)
	var0_10:Play("trophy_upper", -1, 0)
	setActive(arg2_10, true)

	local var1_10 = tf(arg2_10)

	var1_10:SetParent(findTF(arg0_10._tf, "frame"), false)

	var1_10.localScale = Vector3(1, 1, 0)

	LuaHelper.SetParticleEndEvent(arg2_10, function()
		arg0_10._isPlaying = false

		Object.Destroy(arg2_10)
	end)
end

function var0_0.IsPlaying(arg0_13)
	return arg0_13._isPlaying
end

return var0_0
