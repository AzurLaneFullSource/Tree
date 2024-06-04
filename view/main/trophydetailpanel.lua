local var0 = class("TrophyDetailPanel")

function var0.Ctor(arg0, arg1, arg2)
	arg0._go = arg1
	arg0._tf = arg1.transform
	arg0._parent = arg2
	arg0.UIMgr = pg.UIMgr.GetInstance()

	pg.DelegateInfo.New(arg0)

	arg0._medalIcon = findTF(arg0._tf, "center/medalBG/icon")
	arg0._nameLabel = findTF(arg0._tf, "center/name")
	arg0._timeStamp = findTF(arg0._tf, "center/timeStamp/Text"):GetComponent(typeof(Text))
	arg0._desc = findTF(arg0._tf, "center/desc/Text"):GetComponent(typeof(Text))
	arg0._progressBar = findTF(arg0._tf, "center/progress_bar/progress")
	arg0._rank = findTF(arg0._tf, "center/rank/Text"):GetComponent(typeof(Text))
	arg0._lock = findTF(arg0._tf, "center/medalBG/lock")
	arg0._conditionList = findTF(arg0._tf, "center/conditions/container")
	arg0._conditionTpl = findTF(arg0._tf, "center/conditions/condition_tpl")

	onButton(arg0, arg0._go, function()
		arg0:SetActive(false)
	end, SFX_CANCEL)

	arg0._stepper = findTF(arg0._tf, "center/stepper")
	arg0._preTrophyBtn = findTF(arg0._stepper, "pre")
	arg0._postTrophyBtn = findTF(arg0._stepper, "post")
	arg0._pageText = findTF(arg0._stepper, "page")
	arg0._backTipsText = findTF(arg0._tf, "center/backTips/GameObject (1)")

	setText(arg0._backTipsText, i18n("world_collection_back"))
	onButton(arg0, arg0._postTrophyBtn, function()
		local var0 = arg0._trophyGroup:getPostTrophy(arg0._trophy)

		arg0:UpdateTrophy(var0)
	end)
	onButton(arg0, arg0._preTrophyBtn, function()
		local var0 = arg0._trophyGroup:getPreTrophy(arg0._trophy)

		arg0:UpdateTrophy(var0)
	end)

	arg0._active = false
end

function var0.SetTrophyGroup(arg0, arg1)
	arg0._trophyGroup = arg1
end

function var0.UpdateTrophy(arg0, arg1)
	if arg1 == nil then
		return
	end

	arg0._trophy = arg1
	arg0._rank.text = arg1:getConfig("rank")
	arg0._desc.text = arg1:getConfig("desc")

	if arg1:isClaimed() then
		local var0 = pg.TimeMgr.GetInstance():STimeDescS(arg1.timestamp, "*t")

		arg0._timeStamp.text = var0.year .. "/" .. var0.month .. "/" .. var0.day
	else
		arg0._timeStamp.text = "-"
	end

	removeAllChildren(arg0._conditionList)
	LoadImageSpriteAsync("medal/" .. arg1:getConfig("icon"), arg0._medalIcon, true)
	SetActive(arg0._lock, not arg1:isClaimed())
	LoadImageSpriteAsync("medal/" .. arg1:getConfig("label"), arg0._nameLabel, true)

	local function var1(arg0, arg1)
		setText(findTF(arg0, "desc"), arg1:getConfig("condition"))

		local var0, var1 = arg1:getProgress()

		if arg1:getTargetType() == Trophy.INTAMACT_TYPE then
			setText(findTF(arg0, "progress"), arg1:isDummy() and "" or "[" .. math.modf(var0 / 100) .. "/" .. math.modf(var1 / 100) .. "]")
		else
			setText(findTF(arg0, "progress"), arg1:isDummy() and "" or "[" .. var0 .. "/" .. var1 .. "]")
		end
	end

	if not arg1:isComplexTrophy() then
		local var2 = cloneTplTo(arg0._conditionTpl, arg0._conditionList)

		var1(var2, arg1)
	else
		for iter0, iter1 in pairs(arg1:getSubTrophy()) do
			local var3 = cloneTplTo(arg0._conditionTpl, arg0._conditionList)

			var1(var3, iter1)
		end
	end

	arg0._progressBar:GetComponent(typeof(Image)).fillAmount = arg1:getProgressRate()

	arg0:updateStepper(arg1)
end

function var0.updateStepper(arg0, arg1)
	local var0 = arg0._trophyGroup:getTrophyIndex(arg0._trophy)
	local var1 = arg0._trophyGroup:getTrophyCount()

	setText(arg0._pageText, var0 .. "/" .. var1)
end

function var0.SetActive(arg0, arg1)
	SetActive(arg0._go, arg1)

	arg0._active = arg1

	if arg1 then
		pg.UIMgr.GetInstance():BlurPanel(arg0._go, false, {
			weight = LayerWeightConst.SECOND_LAYER
		})
	else
		pg.UIMgr.GetInstance():UnblurPanel(arg0._go, arg0._parent)
	end
end

function var0.IsActive(arg0)
	return arg0._active
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)
end

return var0
