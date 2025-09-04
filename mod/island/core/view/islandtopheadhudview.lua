local var0_0 = class("IslandTopHeadHudView", import(".IslandBaseOpView"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)
end

function var0_0.GetSubView(arg0_2, arg1_2)
	for iter0_2, iter1_2 in ipairs(arg0_2.views) do
		if isa(iter1_2, arg1_2) then
			return iter1_2
		end
	end

	return nil
end

function var0_0.SubViewInit(arg0_3)
	arg0_3.views = {
		arg0_3:CreateInfoHudView()
	}
	arg0_3.chatBubblePlayers = {}
end

function var0_0.CreateInfoHudView(arg0_4)
	return IslandHudView.New(arg0_4.view)
end

function var0_0.GetUIName(arg0_5)
	return "IslandTopHeadHudUI"
end

function var0_0.OnInit(arg0_6, arg1_6)
	arg0_6._go = arg1_6
	arg0_6._tf = arg1_6.transform
	arg0_6.chatTpl = arg0_6._tf:GetComponent(typeof(ItemList)).prefabItem[0]
	arg0_6.parent = arg0_6._tf:Find("parent")
	arg0_6.unitHudRoot = arg0_6._tf:Find("parent/unitHud")
	arg0_6.unitHudDic = {}

	arg0_6:SubViewInit()
end

function var0_0.Update(arg0_7)
	for iter0_7, iter1_7 in ipairs(arg0_7.views) do
		iter1_7:Update()
	end
end

function var0_0.LateUpdate(arg0_8)
	arg0_8:UpdateChatPosition()
end

function var0_0.UpdateChatPosition(arg0_9)
	for iter0_9, iter1_9 in pairs(arg0_9.unitHudDic) do
		local var0_9 = arg0_9:UnitKey2unitData(iter0_9)
		local var1_9 = arg0_9.view:GetUnitModuleWithType(var0_9.type, var0_9.id)
		local var2_9 = var1_9 and var1_9._go or nil

		if var1_9 and not IsNil(var2_9) then
			local var3_9 = var2_9.transform.position + Vector3(0, 1.8, 0)

			if IslandCalcUtil.IsInViewport(var3_9) then
				setActive(iter1_9, true)

				local var4_9 = IslandCalcUtil.WorldPosition2LocalPosition(arg0_9.parent, var3_9)

				iter1_9.transform.localPosition = var4_9
			else
				setActive(iter1_9, false)
			end
		end
	end
end

function var0_0.UnitKey2unitData(arg0_10, arg1_10)
	local var0_10 = string.split(arg1_10, "_")

	return {
		id = tonumber(var0_10[2]),
		type = tonumber(var0_10[1])
	}
end

function var0_0.GetUnitHudRoot(arg0_11, arg1_11)
	local var0_11 = arg0_11.unitHudDic[arg1_11.key]

	if IsNil(var0_11) then
		var0_11 = Object.Instantiate(arg0_11.unitHudRoot, arg0_11.parent)
		var0_11.name = arg1_11.key

		setActive(var0_11, true)

		arg0_11.unitHudDic[arg1_11.key] = var0_11
	end

	return var0_11.transform
end

function var0_0.GenUnitData(arg0_12, arg1_12, arg2_12)
	return {
		id = arg1_12,
		type = arg2_12,
		key = arg2_12 .. "_" .. arg1_12
	}
end

function var0_0.PlayBubble(arg0_13, arg1_13, arg2_13, arg3_13)
	local var0_13 = pg.NewStoryMgr.GetInstance():GetScript(arg1_13)
	local var1_13 = IslandStory.New(var0_13, arg2_13, IslandStory.MODE_BUBBLE)
	local var2_13 = {}

	for iter0_13, iter1_13 in ipairs(var1_13.steps) do
		local var3_13 = iter1_13:GetUnitData()
		local var4_13 = arg0_13:GetUnitHudRoot(var3_13):Find("bubleContainer")
		local var5_13 = arg0_13:GetView():GetUnitModuleWithType(var3_13.type, var3_13.id)

		assert(var5_13)
		table.insert(var2_13, function(arg0_14)
			local var0_14 = arg0_13.chatBubblePlayers[var3_13.key] or IslandChatBubblePlayer.New(Object.Instantiate(arg0_13.chatTpl, var4_13), var5_13._go)

			var0_14:Play(iter1_13, arg3_13)

			arg0_13.chatBubblePlayers[var3_13.key] = var0_14
		end)
	end

	seriesAsync(var2_13, function()
		if arg3_13 then
			arg3_13()
		end
	end)
end

function var0_0.ShowHud(arg0_16, arg1_16)
	local var0_16 = arg0_16:GetUnitHudRoot(arg0_16:GenUnitData(arg1_16.id, arg1_16.type)):Find("npcInfoContainer")

	arg0_16:GetSubView(IslandHudView):ShowHud(arg1_16, var0_16)
end

function var0_0.RefreshHud(arg0_17, arg1_17)
	local var0_17 = arg0_17:GetUnitHudRoot(arg0_17:GenUnitData(arg1_17.id, arg1_17.type)):Find("npcInfoContainer")

	arg0_17:GetSubView(IslandHudView):RefreshHud(arg1_17, var0_17)
end

function var0_0.HideHud(arg0_18, arg1_18)
	arg0_18:GetSubView(IslandHudView):HideHud(arg1_18)
end

function var0_0.UpdateAllHud(arg0_19)
	arg0_19:GetSubView(IslandHudView):UpdateAllHud()
end

function var0_0.OnDispose(arg0_20)
	var0_0.super.OnDispose(arg0_20)

	for iter0_20, iter1_20 in pairs(arg0_20.chatBubblePlayers) do
		iter1_20:Dispose()
	end

	arg0_20.chatBubblePlayers = nil
end

return var0_0
