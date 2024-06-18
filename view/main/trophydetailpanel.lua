local var0_0 = class("TrophyDetailPanel")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1._parent = arg2_1
	arg0_1.UIMgr = pg.UIMgr.GetInstance()

	pg.DelegateInfo.New(arg0_1)

	arg0_1._medalIcon = findTF(arg0_1._tf, "center/medalBG/icon")
	arg0_1._nameLabel = findTF(arg0_1._tf, "center/name")
	arg0_1._timeStamp = findTF(arg0_1._tf, "center/timeStamp/Text"):GetComponent(typeof(Text))
	arg0_1._desc = findTF(arg0_1._tf, "center/desc/Text"):GetComponent(typeof(Text))
	arg0_1._progressBar = findTF(arg0_1._tf, "center/progress_bar/progress")
	arg0_1._rank = findTF(arg0_1._tf, "center/rank/Text"):GetComponent(typeof(Text))
	arg0_1._lock = findTF(arg0_1._tf, "center/medalBG/lock")
	arg0_1._conditionList = findTF(arg0_1._tf, "center/conditions/container")
	arg0_1._conditionTpl = findTF(arg0_1._tf, "center/conditions/condition_tpl")

	onButton(arg0_1, arg0_1._go, function()
		arg0_1:SetActive(false)
	end, SFX_CANCEL)

	arg0_1._stepper = findTF(arg0_1._tf, "center/stepper")
	arg0_1._preTrophyBtn = findTF(arg0_1._stepper, "pre")
	arg0_1._postTrophyBtn = findTF(arg0_1._stepper, "post")
	arg0_1._pageText = findTF(arg0_1._stepper, "page")
	arg0_1._backTipsText = findTF(arg0_1._tf, "center/backTips/GameObject (1)")

	setText(arg0_1._backTipsText, i18n("world_collection_back"))
	onButton(arg0_1, arg0_1._postTrophyBtn, function()
		local var0_3 = arg0_1._trophyGroup:getPostTrophy(arg0_1._trophy)

		arg0_1:UpdateTrophy(var0_3)
	end)
	onButton(arg0_1, arg0_1._preTrophyBtn, function()
		local var0_4 = arg0_1._trophyGroup:getPreTrophy(arg0_1._trophy)

		arg0_1:UpdateTrophy(var0_4)
	end)

	arg0_1._active = false
end

function var0_0.SetTrophyGroup(arg0_5, arg1_5)
	arg0_5._trophyGroup = arg1_5
end

function var0_0.UpdateTrophy(arg0_6, arg1_6)
	if arg1_6 == nil then
		return
	end

	arg0_6._trophy = arg1_6
	arg0_6._rank.text = arg1_6:getConfig("rank")
	arg0_6._desc.text = arg1_6:getConfig("desc")

	if arg1_6:isClaimed() then
		local var0_6 = pg.TimeMgr.GetInstance():STimeDescS(arg1_6.timestamp, "*t")

		arg0_6._timeStamp.text = var0_6.year .. "/" .. var0_6.month .. "/" .. var0_6.day
	else
		arg0_6._timeStamp.text = "-"
	end

	removeAllChildren(arg0_6._conditionList)
	LoadImageSpriteAsync("medal/" .. arg1_6:getConfig("icon"), arg0_6._medalIcon, true)
	SetActive(arg0_6._lock, not arg1_6:isClaimed())
	LoadImageSpriteAsync("medal/" .. arg1_6:getConfig("label"), arg0_6._nameLabel, true)

	local function var1_6(arg0_7, arg1_7)
		setText(findTF(arg0_7, "desc"), arg1_7:getConfig("condition"))

		local var0_7, var1_7 = arg1_7:getProgress()

		if arg1_7:getTargetType() == Trophy.INTAMACT_TYPE then
			setText(findTF(arg0_7, "progress"), arg1_7:isDummy() and "" or "[" .. math.modf(var0_7 / 100) .. "/" .. math.modf(var1_7 / 100) .. "]")
		else
			setText(findTF(arg0_7, "progress"), arg1_7:isDummy() and "" or "[" .. var0_7 .. "/" .. var1_7 .. "]")
		end
	end

	if not arg1_6:isComplexTrophy() then
		local var2_6 = cloneTplTo(arg0_6._conditionTpl, arg0_6._conditionList)

		var1_6(var2_6, arg1_6)
	else
		for iter0_6, iter1_6 in pairs(arg1_6:getSubTrophy()) do
			local var3_6 = cloneTplTo(arg0_6._conditionTpl, arg0_6._conditionList)

			var1_6(var3_6, iter1_6)
		end
	end

	arg0_6._progressBar:GetComponent(typeof(Image)).fillAmount = arg1_6:getProgressRate()

	arg0_6:updateStepper(arg1_6)
end

function var0_0.updateStepper(arg0_8, arg1_8)
	local var0_8 = arg0_8._trophyGroup:getTrophyIndex(arg0_8._trophy)
	local var1_8 = arg0_8._trophyGroup:getTrophyCount()

	setText(arg0_8._pageText, var0_8 .. "/" .. var1_8)
end

function var0_0.SetActive(arg0_9, arg1_9)
	SetActive(arg0_9._go, arg1_9)

	arg0_9._active = arg1_9

	if arg1_9 then
		pg.UIMgr.GetInstance():BlurPanel(arg0_9._go, false, {
			weight = LayerWeightConst.SECOND_LAYER
		})
	else
		pg.UIMgr.GetInstance():UnblurPanel(arg0_9._go, arg0_9._parent)
	end
end

function var0_0.IsActive(arg0_10)
	return arg0_10._active
end

function var0_0.Dispose(arg0_11)
	pg.DelegateInfo.Dispose(arg0_11)
end

return var0_0
