local var0_0 = class("MedalDetailPanel")

function var0_0.SetIconScale(arg0_1, arg1_1)
	arg0_1._iconScale = Vector2.New(arg1_1, arg1_1)
end

function var0_0.Ctor(arg0_2, arg1_2, arg2_2)
	arg0_2._go = arg1_2
	arg0_2._tf = arg1_2.transform
	arg0_2._parent = arg2_2
	arg0_2.UIMgr = pg.UIMgr.GetInstance()

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
		arg0_2:SetActive(false)
	end, SFX_CANCEL)

	if arg0_2._closeBtn then
		onButton(arg0_2, arg0_2._closeBtn, function()
			arg0_2:SetActive(false)
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

function var0_0.SetMedalGroup(arg0_7, arg1_7)
	arg0_7._medalGroup = arg1_7
end

function var0_0.SetCurrentIndex(arg0_8, arg1_8)
	arg0_8._currentIndex = arg1_8
end

function var0_0.UpdateMedal(arg0_9)
	local var0_9 = arg0_9._medalGroup:GetMedalIds()[arg0_9._currentIndex]

	arg0_9._medal = arg0_9._medalGroup:GetMedalList()[var0_9]

	local var1_9 = pg.activity_medal_template[var0_9]

	setText(arg0_9._nameText, var1_9.activity_medal_name)
	setText(arg0_9._descText, var1_9.activity_medal_desc)

	if arg0_9._medal.timeStamp then
		LoadImageSpriteAsync("activitymedal/" .. var0_9, arg0_9._medalIcon, true)
	else
		LoadImageSpriteAsync("activitymedal/" .. var0_9 .. "_l", arg0_9._medalIcon, true)
	end

	arg0_9._medalIcon.transform.localScale = arg0_9._iconScale

	SetActive(arg0_9._medalLock, not arg0_9._medal.timeStamp)

	if arg0_9._medal.timeStamp then
		setText(arg0_9._conditionText, i18n("word_gain_date") .. pg.TimeMgr.GetInstance():CTimeDescC(arg0_9._medal.timeStamp, "%Y/%m/%d"))
		setText(arg0_9._progressText, i18n("word_unlock"))
	else
		setText(arg0_9._conditionText, pg.task_data_template[var1_9.task_id].desc)
		setText(arg0_9._progressText, i18n("word_lock"))
	end

	local var2_9 = findTF(arg0_9._tf, "progress/lock")

	if var2_9 then
		SetActive(var2_9, not arg0_9._medal.timeStamp)
	end

	local var3_9 = arg0_9._medalGroup:GetMedalGroupState()

	if var3_9 == ActivityMedalGroup.STATE_EXPIRE then
		setText(arg0_9._stateText, setColorStr(i18n("word_cant_gain_anymore"), "#73757f"))
	elseif var3_9 == ActivityMedalGroup.STATE_CLOSE then
		setText(arg0_9._stateText, setColorStr(i18n("word_activity_not_open"), "#ed4646"))
	end

	SetActive(arg0_9._stateText, var3_9 ~= ActivityMedalGroup.STATE_ACTIVE)
	SetActive(arg0_9._prevBtn, arg0_9._currentIndex ~= 1)
	SetActive(arg0_9._nextBtn, arg0_9._currentIndex ~= #arg0_9._medalGroup:GetMedalIds())
end

function var0_0.SetActive(arg0_10, arg1_10)
	SetActive(arg0_10._go, arg1_10)

	arg0_10._active = arg1_10

	if arg1_10 then
		pg.UIMgr.GetInstance():BlurPanel(arg0_10._go, false, {
			weight = LayerWeightConst.SECOND_LAYER
		})
	else
		pg.UIMgr.GetInstance():UnblurPanel(arg0_10._go, arg0_10._parent._tf)
	end
end

function var0_0.IsActive(arg0_11)
	return arg0_11._active
end

function var0_0.Dispose(arg0_12)
	pg.DelegateInfo.Dispose(arg0_12)
end

return var0_0
