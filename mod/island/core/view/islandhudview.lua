local var0_0 = class("IslandHudView")

var0_0.LuaName2ContainerName = {
	IslandVisitorHudPanel = "visitorContainer",
	IslandNormalHudPanel = "npcInfoContainer",
	IslandCustomerHudPanel = "npcInfoContainer"
}

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.view = arg1_1
	arg0_1.hudPanelDic = {}
end

function var0_0.ShowHud(arg0_2, arg1_2, arg2_2)
	if arg1_2.id == nil or arg1_2.type == nil then
		return
	end

	local var0_2 = arg0_2.hudPanelDic[arg1_2.type] and arg0_2.hudPanelDic[arg1_2.type][arg1_2.id] or nil

	if var0_2 then
		var0_2:Show()
	else
		arg0_2:CreateNewHud(arg1_2, arg2_2)
	end
end

function var0_0.RefreshHud(arg0_3, arg1_3, arg2_3)
	if arg1_3.id == nil or arg1_3.type == nil then
		return
	end

	local var0_3 = arg0_3.hudPanelDic[arg1_3.type] and arg0_3.hudPanelDic[arg1_3.type][arg1_3.id] or nil

	if var0_3 then
		var0_3:Refresh(arg1_3)
	else
		arg0_3:CreateNewHud(arg1_3, arg2_3)
	end
end

function var0_0.HideHud(arg0_4, arg1_4)
	if arg1_4.id == nil or arg1_4.type == nil then
		return
	end

	local var0_4 = arg0_4.hudPanelDic[arg1_4.type] and arg0_4.hudPanelDic[arg1_4.type][arg1_4.id] or nil

	if var0_4 then
		var0_4:Hide()
	end
end

function var0_0.CreateNewHud(arg0_5, arg1_5, arg2_5)
	local var0_5 = arg0_5:GenUnitData(arg1_5.id, arg1_5.type)
	local var1_5 = _G[arg1_5.uiLuaName].New(arg0_5.view, arg1_5, arg2_5)

	var1_5:Init()

	if not arg0_5.hudPanelDic[arg1_5.type] then
		arg0_5.hudPanelDic[arg1_5.type] = {}
	end

	arg0_5.hudPanelDic[arg1_5.type][arg1_5.id] = var1_5
end

function var0_0.Update(arg0_6)
	for iter0_6, iter1_6 in pairs(arg0_6.hudPanelDic) do
		for iter2_6, iter3_6 in pairs(iter1_6) do
			iter3_6:Update()
		end
	end
end

function var0_0.LateUpdate(arg0_7)
	for iter0_7, iter1_7 in pairs(arg0_7.hudPanelDic) do
		for iter2_7, iter3_7 in pairs(iter1_7) do
			iter3_7:LateUpdate()
		end
	end
end

function var0_0.OnDispose(arg0_8)
	for iter0_8, iter1_8 in pairs(arg0_8.hudPanelDic) do
		for iter2_8, iter3_8 in pairs(iter1_8) do
			iter3_8:Dispose()
		end
	end

	if not IsNil(arg0_8._go) then
		Object.Destroy(arg0_8._go)
	end

	arg0_8._go = nil
	arg0_8._tf = nil
end

function var0_0.GenUnitData(arg0_9, arg1_9, arg2_9)
	return {
		id = arg1_9,
		type = arg2_9,
		key = arg2_9 .. "_" .. arg1_9
	}
end

function var0_0.UpdateAllHud(arg0_10)
	for iter0_10, iter1_10 in pairs(arg0_10.hudPanelDic) do
		for iter2_10, iter3_10 in pairs(iter1_10) do
			iter3_10:RefreshHud()
		end
	end
end

return var0_0
