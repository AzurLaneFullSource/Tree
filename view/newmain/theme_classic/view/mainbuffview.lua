local var0 = class("MainBuffView", import("...base.MainBaseView"))

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg1, arg2)

	arg0.buffs = {
		arg1:Find("buff").gameObject
	}
	arg0.skinFreeUsageTag = nil
	arg0.timers = {}
	arg0.buffOffsetX = 20
	arg0.noTagStartPos = 285
	arg0.hasTagStartPos = 390
	arg0.tagPos = Vector3(-169, -18, 0)

	arg0:bind(MiniGameProxy.ON_HUB_DATA_UPDATE, function(arg0)
		arg0:Refresh()
	end)
	arg0:bind(GAME.SEND_MINI_GAME_OP_DONE, function(arg0)
		arg0:Refresh()
	end)
end

function var0.CollectBuffs(arg0)
	local var0 = BuffHelper.GetBuffsForMainUI()
	local var1 = import("GameCfg.activity.MainUIVirtualIconData")

	for iter0, iter1 in ipairs(var1.CurrentIconList) do
		if var1[iter1]:CheckExist() then
			table.insert(var0, var1[iter1])
		end
	end

	return var0
end

function var0.Init(arg0)
	local var0 = arg0:CollectBuffs()
	local var1 = arg0:ShouldFreeUsageSkinTag()

	arg0._tf.anchoredPosition = Vector3(var1 and arg0.hasTagStartPos or arg0.noTagStartPos, arg0._tf.anchoredPosition.y, 0)

	if var1 then
		arg0:UpdateFreeUsageSkinTag()
	elseif arg0.skinFreeUsageTag then
		setActive(arg0.skinFreeUsageTag, false)
	end

	arg0:ClearTimers()
	arg0:UpdateBuffs(var0)

	arg0.buffList = var0
	arg0.showTag = var1
end

function var0.Refresh(arg0)
	local var0 = arg0:CollectBuffs()
	local var1 = arg0:ShouldFreeUsageSkinTag()

	arg0:Init()
end

function var0.ShouldFreeUsageSkinTag(arg0)
	local var0 = getProxy(ShipSkinProxy):getRawData()

	for iter0, iter1 in pairs(var0) do
		if iter1:isExpireType() and not iter1:isExpired() then
			return true
		end
	end

	return false
end

function var0.UpdateFreeUsageSkinTag(arg0)
	local var0 = arg0.skinFreeUsageTag or Object.Instantiate(arg0.buffs[1], arg0.buffs[1].transform.parent).transform

	arg0.skinFreeUsageTag = var0

	local var1

	var1.sprite, var1 = GetSpriteFromAtlas("ui/mainui_atlas", "huanzhuangtiyan"), var0:GetComponent(typeof(Image))

	var1:SetNativeSize()
	onButton(arg0, var0, function()
		local var0 = arg0:GetFreeUsageSkins()

		arg0:emit(NewMainScene.ON_SKIN_FREEUSAGE_DESC, var0)
	end, SFX_PANEL)

	var0.anchoredPosition = arg0.tagPos

	setActive(arg0.skinFreeUsageTag, true)
end

function var0.GetFreeUsageSkins(arg0)
	local var0 = {}
	local var1 = getProxy(ShipSkinProxy):getRawData()

	for iter0, iter1 in pairs(var1) do
		if iter1:isExpireType() and not iter1:isExpired() then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.GetTpl(arg0, arg1)
	if not arg0.buffs[arg1] then
		local var0 = arg0.buffs[1]
		local var1 = Object.Instantiate(var0, var0.transform.parent)
		local var2 = var0.transform.anchoredPosition.x + (arg1 - 1) * (var0.transform.sizeDelta.x + arg0.buffOffsetX)

		var1.transform.anchoredPosition = Vector3(var2, var0.transform.anchoredPosition.y, 0)
		arg0.buffs[arg1] = var1
	end

	return arg0.buffs[arg1]
end

function var0.UpdateBuffs(arg0, arg1)
	for iter0 = #arg0.buffs, #arg1 + 1, -1 do
		if arg0.buffs[iter0] then
			setActive(arg0.buffs[iter0], false)
		end
	end

	for iter1, iter2 in ipairs(arg1) do
		local var0 = arg0:GetTpl(iter1)

		if iter2.IsVirtualIcon then
			arg0:UpdateVirtualBuff(var0, iter2)
		else
			arg0:UpdateBuff(var0, iter2)
			arg0:AddEndTimer(var0, iter2)
		end
	end
end

function var0.UpdateVirtualBuff(arg0, arg1, arg2)
	LoadImageSpriteAtlasAsync("ui/mainui_atlas", arg2.Image, arg1)
	onButton(arg0, arg1, function()
		arg0:emit(NewMainMediator.GO_SINGLE_ACTIVITY, ActivityConst.DOA_PT_ID)
	end, SFX_PANEL)
	setActive(arg1, true)
end

function var0.UpdateBuff(arg0, arg1, arg2)
	LoadImageSpriteAsync(arg2:getConfig("icon"), arg1)
	onButton(arg0, arg1, function()
		local var0 = pg.UIMgr.GetInstance().UIMain:InverseTransformPoint(arg1.transform.position)

		arg0:emit(NewMainScene.ON_BUFF_DESC, arg2, Vector3(var0.x, var0.y - 55, 0))
	end, SFX_PANEL)
	setActive(arg1, true)
end

function var0.AddEndTimer(arg0, arg1, arg2)
	local var0 = arg2:getLeftTime()

	arg0.timers[arg1] = Timer.New(function()
		setActive(arg1, false)
	end, var0, 1)

	arg0.timers[arg1]:Start()
end

function var0.ClearTimers(arg0)
	for iter0, iter1 in pairs(arg0.timers) do
		iter1:Stop()
	end

	arg0.timers = {}
end

function var0.GetDirection(arg0)
	return Vector2(0, 1)
end

function var0.Dispose(arg0)
	var0.super.Dispose(arg0)

	if arg0.skinFreeUsageTag then
		Destroy(arg0.skinFreeUsageTag.gameObject)

		arg0.skinFreeUsageTag = nil
	end

	arg0:ClearTimers()
end

return var0
