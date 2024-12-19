local var0_0 = class("MedalDetailPanel")

var0_0.ICON_SCALE = Vector2.New(1.35, 1.35)

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1._parent = arg2_1
	arg0_1.UIMgr = pg.UIMgr.GetInstance()

	pg.DelegateInfo.New(arg0_1)

	arg0_1._mask = findTF(arg0_1._tf, "mask")
	arg0_1._medalIcon = findTF(arg0_1._tf, "icon")
	arg0_1._medalLock = findTF(arg0_1._tf, "lock")
	arg0_1._nameText = findTF(arg0_1._tf, "name")
	arg0_1._descText = findTF(arg0_1._tf, "desc")
	arg0_1._progressText = findTF(arg0_1._tf, "progress")
	arg0_1._conditionText = findTF(arg0_1._tf, "condition")
	arg0_1._stateText = findTF(arg0_1._tf, "state")
	arg0_1._prevBtn = findTF(arg0_1._tf, "prevBtn")
	arg0_1._nextBtn = findTF(arg0_1._tf, "nextBtn")

	onButton(arg0_1, arg0_1._mask, function()
		arg0_1:SetActive(false)
	end, SFX_CANCEL)
	onButton(arg0_1, arg0_1._prevBtn, function()
		arg0_1._currentIndex = math.max(arg0_1._currentIndex - 1, 1)

		arg0_1:UpdateMedal()
	end)
	onButton(arg0_1, arg0_1._nextBtn, function()
		arg0_1._currentIndex = math.min(arg0_1._currentIndex + 1, #arg0_1._medalGroup:getConfig("activity_medal_ids"))

		arg0_1:UpdateMedal()
	end)
end

function var0_0.SetMedalGroup(arg0_5, arg1_5)
	arg0_5._medalGroup = arg1_5
end

function var0_0.SetCurrentIndex(arg0_6, arg1_6)
	arg0_6._currentIndex = arg1_6
end

function var0_0.UpdateMedal(arg0_7)
	local var0_7 = arg0_7._medalGroup:getConfig("activity_medal_ids")[arg0_7._currentIndex]

	arg0_7._medal = arg0_7._medalGroup:GetMedalList()[var0_7]

	local var1_7 = pg.activity_medal_template[var0_7]

	setText(arg0_7._nameText, var1_7.activity_medal_name)
	setText(arg0_7._descText, var1_7.activity_medal_desc)

	if arg0_7._medal.timeStamp then
		LoadImageSpriteAsync("activitymedal/" .. var0_7, arg0_7._medalIcon, true)
	else
		LoadImageSpriteAsync("activitymedal/" .. var0_7 .. "_l", arg0_7._medalIcon, true)
	end

	arg0_7._medalIcon.transform.localScale = var0_0.ICON_SCALE

	SetActive(arg0_7._medalLock, not arg0_7._medal.timeStamp)

	if arg0_7._medal.timeStamp then
		setText(arg0_7._conditionText, i18n("word_gain_date") .. pg.TimeMgr.GetInstance():CTimeDescC(arg0_7._medal.timeStamp, "%Y/%m/%d"))
		setText(arg0_7._progressText, i18n("word_unlock"))
	else
		setText(arg0_7._conditionText, pg.task_data_template[var1_7.task_id].desc)
		setText(arg0_7._progressText, i18n("word_lock"))
	end

	local var2_7 = arg0_7._medalGroup:GetMedalGroupState()

	if var2_7 == ActivityMedalGroup.STATE_EXPIRE then
		setText(arg0_7._stateText, setColorStr(i18n("word_cant_gain_anymore"), "#73757f"))
	elseif var2_7 == ActivityMedalGroup.STATE_CLOSE then
		setText(arg0_7._stateText, setColorStr(i18n("word_activity_not_open"), "#ed4646"))
	end

	SetActive(arg0_7._stateText, var2_7 ~= ActivityMedalGroup.STATE_ACTIVE)
	SetActive(arg0_7._prevBtn, arg0_7._currentIndex ~= 1)
	SetActive(arg0_7._nextBtn, arg0_7._currentIndex ~= #arg0_7._medalGroup:getConfig("activity_medal_ids"))
end

function var0_0.SetActive(arg0_8, arg1_8)
	SetActive(arg0_8._go, arg1_8)

	arg0_8._active = arg1_8

	if arg1_8 then
		pg.UIMgr.GetInstance():BlurPanel(arg0_8._go, false, {
			weight = LayerWeightConst.SECOND_LAYER
		})
	else
		pg.UIMgr.GetInstance():UnblurPanel(arg0_8._go, arg0_8._parent._tf)
	end
end

function var0_0.IsActive(arg0_9)
	return arg0_9._active
end

function var0_0.Dispose(arg0_10)
	pg.DelegateInfo.Dispose(arg0_10)
end

return var0_0
