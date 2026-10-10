local var0_0 = class("MedalDetailPanel")

var0_0.setColorstateText = "#73757f"
var0_0.setColorstate = "#ed4646"

function var0_0.SetIconScale(arg0_1, arg1_1)
	arg0_1._iconScale = Vector2.New(arg1_1, arg1_1)
end

function var0_0.Ctor(arg0_2, arg1_2, arg2_2)
	arg0_2._go = arg1_2
	arg0_2._tf = arg1_2.transform
	arg0_2._parent = arg2_2

	pg.DelegateInfo.New(arg0_2)
	arg0_2:InitUI()
end

function var0_0.InitUI(arg0_3)
	arg0_3._mask = findTF(arg0_3._tf, "mask")
	arg0_3._medalIcon = findTF(arg0_3._tf, "icon")
	arg0_3._medalLock = findTF(arg0_3._tf, "lock")
	arg0_3._nameText = findTF(arg0_3._tf, "name")
	arg0_3._descText = findTF(arg0_3._tf, "desc")
	arg0_3._progressBG = findTF(arg0_3._tf, "progress")
	arg0_3._progressText = findTF(arg0_3._tf, "progress/label")
	arg0_3._conditionText = findTF(arg0_3._tf, "condition")
	arg0_3._stateText = findTF(arg0_3._tf, "state")
	arg0_3._prevBtn = findTF(arg0_3._tf, "prevBtn")
	arg0_3._nextBtn = findTF(arg0_3._tf, "nextBtn")
	arg0_3._closeBtn = findTF(arg0_3._tf, "backbtn")

	onButton(arg0_3, arg0_3._mask, function()
		if arg0_3._parent.DETAIL_CLOSE_ANIM and arg0_3._parent.DETAIL_CLOSE_ANIM_Time then
			quickPlayAnimation(arg0_3._go, arg0_3._parent.DETAIL_CLOSE_ANIM)
			onDelayTick(function()
				arg0_3:SetActive(false)
			end, arg0_3._parent.DETAIL_CLOSE_ANIM_Time)
		else
			arg0_3:SetActive(false)
		end
	end, SFX_CANCEL)

	if arg0_3._closeBtn then
		onButton(arg0_3, arg0_3._closeBtn, function()
			if arg0_3._parent.DETAIL_CLOSE_ANIM and arg0_3._parent.DETAIL_CLOSE_ANIM_Time then
				quickPlayAnimation(arg0_3._go, arg0_3._parent.DETAIL_CLOSE_ANIM)
				onDelayTick(function()
					arg0_3:SetActive(false)
				end, arg0_3._parent.DETAIL_CLOSE_ANIM_Time)
			else
				arg0_3:SetActive(false)
			end
		end, SFX_CANCEL)
	end

	onButton(arg0_3, arg0_3._prevBtn, function()
		arg0_3._currentIndex = math.max(arg0_3._currentIndex - 1, 1)

		arg0_3:UpdateMedal()
	end)
	onButton(arg0_3, arg0_3._nextBtn, function()
		arg0_3._currentIndex = math.min(arg0_3._currentIndex + 1, #arg0_3._medalGroup:GetMedalIds())

		arg0_3:UpdateMedal()
	end)
end

function var0_0.SetMedalGroup(arg0_10, arg1_10)
	arg0_10._medalGroup = arg1_10
end

function var0_0.SetCurrentIndex(arg0_11, arg1_11)
	arg0_11._currentIndex = arg1_11
end

function var0_0.UpdateMedal(arg0_12)
	local var0_12 = arg0_12._medalGroup:GetMedalIds()[arg0_12._currentIndex]

	arg0_12._medal = arg0_12._medalGroup:GetMedalList()[var0_12]

	local var1_12 = pg.activity_medal_template[var0_12]

	setText(arg0_12._nameText, var1_12.activity_medal_name)
	setText(arg0_12._descText, var1_12.activity_medal_desc)

	if arg0_12._medal.timeStamp then
		LoadImageSpriteAsync("activitymedal/" .. var0_12, arg0_12._medalIcon, true)
	else
		LoadImageSpriteAsync("activitymedal/" .. var0_12 .. "_l", arg0_12._medalIcon, true)
	end

	arg0_12._medalIcon.transform.localScale = arg0_12._iconScale

	SetActive(arg0_12._medalLock, not arg0_12._medal.timeStamp)

	if arg0_12._medal.timeStamp then
		setText(arg0_12._conditionText, i18n("word_gain_date") .. pg.TimeMgr.GetInstance():CTimeDescC(arg0_12._medal.timeStamp, "%Y/%m/%d"))
		setText(arg0_12._progressText, i18n("word_unlock"))
	else
		setText(arg0_12._conditionText, pg.task_data_template[var1_12.task_id].desc)
		setText(arg0_12._progressText, i18n("word_lock"))
	end

	local var2_12 = findTF(arg0_12._tf, "progress/lock")

	if var2_12 then
		SetActive(var2_12, not arg0_12._medal.timeStamp)
	end

	local var3_12 = arg0_12._medalGroup:GetMedalGroupState()

	if var3_12 == ActivityMedalGroup.STATE_EXPIRE then
		setText(arg0_12._stateText, setColorStr(i18n("word_cant_gain_anymore"), arg0_12._parent.setColorstateText or arg0_12.setColorstateText))
	elseif var3_12 == ActivityMedalGroup.STATE_CLOSE then
		setText(arg0_12._stateText, setColorStr(i18n("word_activity_not_open"), arg0_12._parent.setColorstate or arg0_12.setColorstate))
	end

	SetActive(arg0_12._stateText, var3_12 ~= ActivityMedalGroup.STATE_ACTIVE)
	SetActive(arg0_12._prevBtn, arg0_12._currentIndex ~= 1)
	SetActive(arg0_12._nextBtn, arg0_12._currentIndex ~= #arg0_12._medalGroup:GetMedalIds())
end

function var0_0.SetActive(arg0_13, arg1_13)
	SetActive(arg0_13._go, arg1_13)

	arg0_13._active = arg1_13

	if arg1_13 then
		pg.UIMgr.GetInstance():BlurPanel(arg0_13._go)
	else
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_13._go, arg0_13._parent._tf)
	end
end

function var0_0.IsActive(arg0_14)
	return arg0_14._active
end

function var0_0.Dispose(arg0_15)
	pg.DelegateInfo.Dispose(arg0_15)
end

return var0_0
