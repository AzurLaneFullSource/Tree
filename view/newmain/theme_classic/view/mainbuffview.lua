local var0_0 = class("MainBuffView", import("...base.MainBaseView"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.buffs = {
		arg1_1:Find("buff").gameObject
	}
	arg0_1.skinFreeUsageTag = nil
	arg0_1.timers = {}
	arg0_1.buffOffsetX = 20
	arg0_1.noTagStartPos = 285
	arg0_1.hasTagStartPos = 390
	arg0_1.tagPos = Vector3(-169, -18, 0)

	arg0_1:bind(MiniGameProxy.ON_HUB_DATA_UPDATE, function(arg0_2)
		arg0_1:Refresh()
	end)
	arg0_1:bind(GAME.SEND_MINI_GAME_OP_DONE, function(arg0_3)
		arg0_1:Refresh()
	end)
end

function var0_0.CollectBuffs(arg0_4)
	local var0_4 = BuffHelper.GetBuffsForMainUI()
	local var1_4 = import("GameCfg.activity.MainUIVirtualIconData")

	for iter0_4, iter1_4 in ipairs(var1_4.CurrentIconList) do
		if var1_4[iter1_4]:CheckExist() then
			table.insert(var0_4, var1_4[iter1_4])
		end
	end

	return var0_4
end

function var0_0.Init(arg0_5)
	local var0_5 = arg0_5:CollectBuffs()
	local var1_5 = arg0_5:ShouldFreeUsageSkinTag()

	arg0_5._tf.anchoredPosition = Vector3(var1_5 and arg0_5.hasTagStartPos or arg0_5.noTagStartPos, arg0_5._tf.anchoredPosition.y, 0)

	if var1_5 then
		arg0_5:UpdateFreeUsageSkinTag()
	elseif arg0_5.skinFreeUsageTag then
		setActive(arg0_5.skinFreeUsageTag, false)
	end

	arg0_5:ClearTimers()
	arg0_5:UpdateBuffs(var0_5)

	arg0_5.buffList = var0_5
	arg0_5.showTag = var1_5
end

function var0_0.Refresh(arg0_6)
	local var0_6 = arg0_6:CollectBuffs()
	local var1_6 = arg0_6:ShouldFreeUsageSkinTag()

	arg0_6:Init()
end

function var0_0.ShouldFreeUsageSkinTag(arg0_7)
	local var0_7 = getProxy(ShipSkinProxy):getRawData()

	for iter0_7, iter1_7 in pairs(var0_7) do
		if iter1_7:isExpireType() and not iter1_7:isExpired() then
			return true
		end
	end

	return false
end

function var0_0.UpdateFreeUsageSkinTag(arg0_8)
	local var0_8 = arg0_8.skinFreeUsageTag or Object.Instantiate(arg0_8.buffs[1], arg0_8.buffs[1].transform.parent).transform

	arg0_8.skinFreeUsageTag = var0_8

	local var1_8

	var1_8.sprite, var1_8 = GetSpriteFromAtlas("ui/mainui_atlas", "huanzhuangtiyan"), var0_8:GetComponent(typeof(Image))

	var1_8:SetNativeSize()
	onButton(arg0_8, var0_8, function()
		local var0_9 = arg0_8:GetFreeUsageSkins()

		arg0_8:emit(NewMainScene.ON_SKIN_FREEUSAGE_DESC, var0_9)
	end, SFX_PANEL)

	var0_8.anchoredPosition = arg0_8.tagPos

	setActive(arg0_8.skinFreeUsageTag, true)
end

function var0_0.GetFreeUsageSkins(arg0_10)
	local var0_10 = {}
	local var1_10 = getProxy(ShipSkinProxy):getRawData()

	for iter0_10, iter1_10 in pairs(var1_10) do
		if iter1_10:isExpireType() and not iter1_10:isExpired() then
			table.insert(var0_10, iter1_10)
		end
	end

	return var0_10
end

function var0_0.GetTpl(arg0_11, arg1_11)
	if not arg0_11.buffs[arg1_11] then
		local var0_11 = arg0_11.buffs[1]
		local var1_11 = Object.Instantiate(var0_11, var0_11.transform.parent)
		local var2_11 = var0_11.transform.anchoredPosition.x + (arg1_11 - 1) * (var0_11.transform.sizeDelta.x + arg0_11.buffOffsetX)

		var1_11.transform.anchoredPosition = Vector3(var2_11, var0_11.transform.anchoredPosition.y, 0)
		arg0_11.buffs[arg1_11] = var1_11
	end

	return arg0_11.buffs[arg1_11]
end

function var0_0.UpdateBuffs(arg0_12, arg1_12)
	for iter0_12 = #arg0_12.buffs, #arg1_12 + 1, -1 do
		if arg0_12.buffs[iter0_12] then
			setActive(arg0_12.buffs[iter0_12], false)
		end
	end

	for iter1_12, iter2_12 in ipairs(arg1_12) do
		local var0_12 = arg0_12:GetTpl(iter1_12)

		if iter2_12.IsVirtualIcon then
			arg0_12:UpdateVirtualBuff(var0_12, iter2_12)
		else
			arg0_12:UpdateBuff(var0_12, iter2_12)
			arg0_12:AddEndTimer(var0_12, iter2_12)
		end
	end
end

function var0_0.UpdateVirtualBuff(arg0_13, arg1_13, arg2_13)
	LoadImageSpriteAtlasAsync("ui/mainui_atlas", arg2_13.Image, arg1_13)
	onButton(arg0_13, arg1_13, function()
		arg0_13:emit(NewMainMediator.GO_SINGLE_ACTIVITY, ActivityConst.DOA_PT_ID)
	end, SFX_PANEL)
	setActive(arg1_13, true)
end

function var0_0.UpdateBuff(arg0_15, arg1_15, arg2_15)
	LoadImageSpriteAsync(arg2_15:getConfig("icon"), arg1_15)
	onButton(arg0_15, arg1_15, function()
		local var0_16 = pg.UIMgr.GetInstance().UIMain:InverseTransformPoint(arg1_15.transform.position)

		arg0_15:emit(NewMainScene.ON_BUFF_DESC, arg2_15, Vector3(var0_16.x, var0_16.y - 55, 0))
	end, SFX_PANEL)
	setActive(arg1_15, true)
end

function var0_0.AddEndTimer(arg0_17, arg1_17, arg2_17)
	local var0_17 = arg2_17:getLeftTime()

	arg0_17.timers[arg1_17] = Timer.New(function()
		setActive(arg1_17, false)
	end, var0_17, 1)

	arg0_17.timers[arg1_17]:Start()
end

function var0_0.ClearTimers(arg0_19)
	for iter0_19, iter1_19 in pairs(arg0_19.timers) do
		iter1_19:Stop()
	end

	arg0_19.timers = {}
end

function var0_0.GetDirection(arg0_20)
	return Vector2(0, 1)
end

function var0_0.Dispose(arg0_21)
	var0_0.super.Dispose(arg0_21)

	if arg0_21.skinFreeUsageTag then
		Destroy(arg0_21.skinFreeUsageTag.gameObject)

		arg0_21.skinFreeUsageTag = nil
	end

	arg0_21:ClearTimers()
end

return var0_0
