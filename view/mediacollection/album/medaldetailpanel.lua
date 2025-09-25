local var0_0 = class("MedalDetailPanel")

function var0_0.SetIconScale(arg0_1, arg1_1)
	arg0_1._iconScale = Vector2.New(arg1_1, arg1_1)
end

function var0_0.Ctor(arg0_2, arg1_2, arg2_2)
	arg0_2._go = arg1_2
	arg0_2._tf = arg1_2.transform
	arg0_2._parent = arg2_2

	pg.DelegateInfo.New(arg0_2)

	arg0_2._mask = findTF(arg0_2._tf, "mask")
	arg0_2._medalIcon = findTF(arg0_2._tf, "icon")
	arg0_2._medalLock = findTF(arg0_2._tf, "lock")
	arg0_2._nameText = findTF(arg0_2._tf, "name")
	arg0_2._descText = findTF(arg0_2._tf, "desc")
	arg0_2._progressBG = findTF(arg0_2._tf, "progress")
	arg0_2._progressText = findTF(arg0_2._tf, "progress/label")
	arg0_2._conditionText = findTF(arg0_2._tf, "condition")
	arg0_2._stateText = findTF(arg0_2._tf, "state")
	arg0_2._prevBtn = findTF(arg0_2._tf, "prevBtn")
	arg0_2._nextBtn = findTF(arg0_2._tf, "nextBtn")
	arg0_2._closeBtn = findTF(arg0_2._tf, "backbtn")

	onButton(arg0_2, arg0_2._mask, function()
		if arg0_2._parent.DETAIL_CLOSE_ANIM and arg0_2._parent.DETAIL_CLOSE_ANIM_Time then
			quickPlayAnimation(arg0_2._go, arg0_2._parent.DETAIL_CLOSE_ANIM)
			onDelayTick(function()
				arg0_2:SetActive(false)
			end, arg0_2._parent.DETAIL_CLOSE_ANIM_Time)
		else
			arg0_2:SetActive(false)
		end
	end, SFX_CANCEL)

	if arg0_2._closeBtn then
		onButton(arg0_2, arg0_2._closeBtn, function()
			if arg0_2._parent.DETAIL_CLOSE_ANIM and arg0_2._parent.DETAIL_CLOSE_ANIM_Time then
				quickPlayAnimation(arg0_2._go, arg0_2._parent.DETAIL_CLOSE_ANIM)
				onDelayTick(function()
					arg0_2:SetActive(false)
				end, arg0_2._parent.DETAIL_CLOSE_ANIM_Time)
			else
				arg0_2:SetActive(false)
			end
		end, SFX_CANCEL)
	end

	onButton(arg0_2, arg0_2._prevBtn, function()
		arg0_2._currentIndex = math.max(arg0_2._currentIndex - 1, 1)

		arg0_2:UpdateMedal()
	end)
	onButton(arg0_2, arg0_2._nextBtn, function()
		arg0_2._currentIndex = math.min(arg0_2._currentIndex + 1, #arg0_2._medalGroup:GetMedalIds())

		arg0_2:UpdateMedal()
	end)
end

function var0_0.SetMedalGroup(arg0_9, arg1_9)
	arg0_9._medalGroup = arg1_9
end

function var0_0.SetCurrentIndex(arg0_10, arg1_10)
	arg0_10._currentIndex = arg1_10
end

function var0_0.UpdateMedal(arg0_11)
	local var0_11 = arg0_11._medalGroup:GetMedalIds()[arg0_11._currentIndex]

	arg0_11._medal = arg0_11._medalGroup:GetMedalList()[var0_11]

	local var1_11 = pg.activity_medal_template[var0_11]

	setText(arg0_11._nameText, var1_11.activity_medal_name)
	setText(arg0_11._descText, var1_11.activity_medal_desc)

	if arg0_11._medal.timeStamp then
		LoadImageSpriteAsync("activitymedal/" .. var0_11, arg0_11._medalIcon, true)
	else
		LoadImageSpriteAsync("activitymedal/" .. var0_11 .. "_l", arg0_11._medalIcon, true)
	end

	arg0_11._medalIcon.transform.localScale = arg0_11._iconScale

	SetActive(arg0_11._medalLock, not arg0_11._medal.timeStamp)

	if arg0_11._medal.timeStamp then
		setText(arg0_11._conditionText, i18n("word_gain_date") .. pg.TimeMgr.GetInstance():CTimeDescC(arg0_11._medal.timeStamp, "%Y/%m/%d"))
		setText(arg0_11._progressText, i18n("word_unlock"))
	else
		setText(arg0_11._conditionText, pg.task_data_template[var1_11.task_id].desc)
		setText(arg0_11._progressText, i18n("word_lock"))
	end

	local var2_11 = findTF(arg0_11._tf, "progress/lock")

	if var2_11 then
		SetActive(var2_11, not arg0_11._medal.timeStamp)
	end

	local var3_11 = arg0_11._medalGroup:GetMedalGroupState()

	if var3_11 == ActivityMedalGroup.STATE_EXPIRE then
		setText(arg0_11._stateText, setColorStr(i18n("word_cant_gain_anymore"), "#73757f"))
	elseif var3_11 == ActivityMedalGroup.STATE_CLOSE then
		setText(arg0_11._stateText, setColorStr(i18n("word_activity_not_open"), "#ed4646"))
	end

	SetActive(arg0_11._stateText, var3_11 ~= ActivityMedalGroup.STATE_ACTIVE)
	SetActive(arg0_11._prevBtn, arg0_11._currentIndex ~= 1)
	SetActive(arg0_11._nextBtn, arg0_11._currentIndex ~= #arg0_11._medalGroup:GetMedalIds())
end

function var0_0.SetActive(arg0_12, arg1_12)
	SetActive(arg0_12._go, arg1_12)

	arg0_12._active = arg1_12

	if arg1_12 then
		pg.UIMgr.GetInstance():BlurPanel(arg0_12._go)
	else
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_12._go, arg0_12._parent._tf)
	end
end

function var0_0.IsActive(arg0_13)
	return arg0_13._active
end

function var0_0.Dispose(arg0_14)
	pg.DelegateInfo.Dispose(arg0_14)
end

return var0_0
