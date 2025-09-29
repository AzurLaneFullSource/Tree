local var0_0 = class("IslandNormalHudPanel", import("Mod.Island.Core.View.IslandBaseHudPanel"))

function var0_0.GetUIName(arg0_1)
	return "IslandNormalNpcHud"
end

function var0_0.Ctor(arg0_2, arg1_2, arg2_2, arg3_2)
	var0_0.super.Ctor(arg0_2, arg1_2, arg2_2, arg3_2)

	arg0_2.hud_name_range = pg.island_set.hud_name_range.key_value_int
	arg0_2.currentTaskType = -1
	arg0_2.currentTaskId = -1
end

function var0_0.OnInit(arg0_3)
	arg0_3.npcId = tonumber(arg0_3.param1)
	arg0_3.hudImageTF = arg0_3._tf:Find("hud_bg/hudImage")
	arg0_3.hudImageBg = arg0_3._tf:Find("hud_bg")

	local var0_3 = pg.island_npc_hud[arg0_3.npcId]

	arg0_3.hudImageIcon = var0_3.icon
	arg0_3.hudTitle = arg0_3._tf:Find("title")
	arg0_3.hudName = arg0_3._tf:Find("name")

	setText(arg0_3.hudTitle, var0_3.title)
	setText(arg0_3.hudName, var0_3.name)

	arg0_3.playerTF = arg0_3:GetPlayer()

	arg0_3:CheckPlayer()
end

function var0_0.CheckPlayer(arg0_4)
	arg0_4.isNear = arg0_4:CheckIsNear()

	setActive(arg0_4.hudTitle, arg0_4.isNear)
	setActive(arg0_4.hudName, arg0_4.isNear)
	arg0_4:UpdateTaskDisplay()
end

function var0_0.OnDispose(arg0_5)
	var0_0.super.OnDispose(arg0_5)
end

function var0_0.GetPlayer(arg0_6)
	local var0_6 = GameObject.Find("Root"):GetComponentsInChildren(typeof(WorldObjectItem)):ToTable()

	for iter0_6, iter1_6 in ipairs(var0_6) do
		if iter1_6.isPlayer then
			arg0_6.hasPlayer = true

			return iter1_6.gameObject.transform
		end
	end

	return nil
end

function var0_0.CheckIsNear(arg0_7)
	local var0_7 = arg0_7.view:GetUnitModuleWithType(arg0_7.unitType, arg0_7.unitId)
	local var1_7 = var0_7 and var0_7._go or nil

	if not var0_7 or IsNil(var1_7) or IsNil(var1_7.transform) then
		return false
	end

	if IsNil(arg0_7.playerTF) then
		return false
	end

	if (arg0_7.playerTF.position - var1_7.transform.position).magnitude < arg0_7.hud_name_range then
		return true
	end

	return false
end

function var0_0.OnUpdate(arg0_8)
	if not arg0_8.hasPlayer then
		arg0_8.playerTF = arg0_8:GetPlayer()

		arg0_8:CheckPlayer()
	else
		local var0_8 = arg0_8:CheckIsNear()

		if var0_8 == arg0_8.isNear then
			return
		end

		arg0_8.isNear = var0_8

		setActive(arg0_8.hudTitle, arg0_8.isNear)
		setActive(arg0_8.hudName, arg0_8.isNear)
	end
end

function var0_0.RefreshHud(arg0_9)
	arg0_9:UpdateTaskDisplay()
end

function var0_0.UpdateTaskDisplay(arg0_10)
	if IsNil(arg0_10.hudImageBg) then
		return
	end

	local var0_10, var1_10 = IslandObjectTaskHudHelper.GetObjectTaskHud(arg0_10.unitId)

	if arg0_10.currentTaskId ~= var1_10 then
		arg0_10.currentTaskId = var1_10

		if var1_10 then
			local var2_10, var3_10 = IslandObjectTaskHudHelper.GetHudDislayInfoByTaskId(var1_10)

			setActive(arg0_10.hudImageBg, true)
			GetImageSpriteFromAtlasAsync("island/IslandHudIcon", var2_10, arg0_10.hudImageBg)
			setImageColor(arg0_10.hudImageTF, Color.NewHex(var3_10))
		else
			setActive(arg0_10.hudImageBg, arg0_10.hudImageIcon ~= "")
			GetImageSpriteFromAtlasAsync("island/IslandHudIcon", "hud_main", arg0_10.hudImageBg)
			setImageColor(arg0_10.hudImageTF, Color.NewHex("78787a"))
		end
	end

	if var0_10 ~= arg0_10.currentTaskType then
		arg0_10.currentTaskType = var0_10

		local var4_10 = IslandObjectTaskHudHelper.TaskProcessToHudIcon[var0_10] or arg0_10.hudImageIcon

		setActive(arg0_10.hudImageBg, var4_10 ~= "")

		if var4_10 ~= "" then
			GetImageSpriteFromAtlasAsync("island/IslandHudIcon", var4_10, arg0_10.hudImageTF)
		end
	end
end

return var0_0
