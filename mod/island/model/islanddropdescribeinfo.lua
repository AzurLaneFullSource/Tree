local var0_0 = class("IslandDropDescribeInfo", import("model.vo.BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.drop = arg1_1
end

function var0_0.GetName(arg0_2)
	return arg0_2.drop:getName() or ""
end

function var0_0.GetDes(arg0_3)
	return arg0_3.drop.desc or ""
end

function var0_0.GetOwnCount(arg0_4)
	return arg0_4.drop:getOwnedCount()
end

function var0_0.GetDrop(arg0_5)
	return arg0_5.drop
end

function var0_0.GetAcquiringWay(arg0_6)
	local var0_6 = {}
	local var1_6 = arg0_6:GetDropConfig().jump_page or {}

	var1_6 = var1_6 == "" and {} or var1_6

	for iter0_6, iter1_6 in ipairs(var1_6) do
		table.insert(var0_6, iter1_6)
	end

	return var0_6
end

function var0_0.IsTecUnlocked(arg0_7)
	local var0_7 = arg0_7:GetDropConfig()

	if var0_7.tech_id == 0 or var0_7.tech_id == nil then
		return true
	end

	return getProxy(IslandProxy):GetIsland():GetTechnologyAgency():IsUnlockTech(var0_7.tech_id)
end

function var0_0.GetTecDes(arg0_8)
	local var0_8 = arg0_8:GetDropConfig().tech_id

	if var0_8 == 0 then
		return ""
	end

	local var1_8 = pg.island_technology_template[var0_8]
	local var2_8 = IslandTechBelong.Names[var1_8.tech_belong]
	local var3_8 = var1_8.tech_name

	return i18n("island_information_tech", var2_8, var3_8)
end

function var0_0.GetDropConfig(arg0_9)
	return arg0_9.drop:getConfigTable()
end

return var0_0
