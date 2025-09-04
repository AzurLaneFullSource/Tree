local var0_0 = class("IslandMapDescPage", import(".IslandBaseMapDescPage"))

function var0_0.OnLoaded(arg0_1)
	var0_0.super.OnLoaded(arg0_1)

	arg0_1.timers = {}
end

function var0_0.OnShow(arg0_2, arg1_2)
	var0_0.super.OnShow(arg0_2, arg1_2)
	arg0_2:UpdateProductionList(arg1_2)
end

function var0_0.UpdateProductionList(arg0_3, arg1_3)
	local var0_3 = pg.island_map_details.get_id_list_by_belong_map[arg1_3]
	local var1_3 = arg0_3:GetIsland():GetAblityAgency()
	local var2_3 = _.select(var0_3, function(arg0_4)
		return var1_3:HasAbility(pg.island_map_details[arg0_4].ability_id)
	end)

	arg0_3.uiProductionList:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventUpdate then
			local var0_5 = var2_3[arg1_5 + 1]
			local var1_5 = pg.island_map_details[var0_5]

			GetImageSpriteFromAtlasAsync("island/IslandMapRes", var1_5.detail_icon, arg2_5)
			setText(arg2_5:Find("Text"), var1_5.name)
			arg0_3:AddTimer(arg2_5, var1_5.production_place_id)
		end
	end)
	arg0_3.uiProductionList:align(#var2_3)
end

function var0_0.AddTimer(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg1_6:Find("full")

	setActive(var0_6, false)
	arg0_6:RemoveTimer(arg2_6)

	if arg2_6 <= 0 then
		return
	end

	local var1_6 = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuilding(arg2_6)
	local var2_6 = var1_6 and var1_6:GetMinRoleDeleGationTime() or -1

	if var2_6 < 0 then
		return
	end

	local var3_6 = pg.TimeMgr.GetInstance():GetServerTime()

	if var2_6 <= var3_6 then
		setActive(var0_6, true)
		arg0_6:UpdateAnyFullMark()

		return
	end

	local var4_6 = var2_6 - var3_6

	arg0_6.timers[arg2_6] = Timer.New(function()
		setActive(var0_6, true)
		arg0_6:UpdateAnyFullMark()
		arg0_6:RemoveTimer(arg2_6)
	end, var4_6, 1)

	arg0_6.timers[arg2_6]:Start()
end

function var0_0.UpdateAnyFullMark(arg0_8)
	setActive(arg0_8.fullMark, true)
end

function var0_0.RemoveTimer(arg0_9, arg1_9)
	if arg0_9.timers[arg1_9] then
		arg0_9.timers[arg1_9]:Stop()

		arg0_9.timers[arg1_9] = nil
	end
end

function var0_0.OnHide(arg0_10)
	for iter0_10, iter1_10 in pairs(arg0_10.timers) do
		iter1_10:Stop()
	end

	arg0_10.timers = {}
end

return var0_0
