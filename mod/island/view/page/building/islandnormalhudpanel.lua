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

	arg0_3.playerTF = arg0_3:GetPlayer().transform
	arg0_3.isNear = arg0_3:CheckIsNear()

	setActive(arg0_3.hudTitle, arg0_3.isNear)
	setActive(arg0_3.hudName, arg0_3.isNear)
	arg0_3:UpdateTaskDisplay()
end

function var0_0.OnDispose(arg0_4)
	var0_0.super.OnDispose(arg0_4)
end

function var0_0.GetPlayer(arg0_5)
	local var0_5 = GameObject.Find("Root"):GetComponentsInChildren(typeof("WorldObjectItem")):ToTable()

	for iter0_5, iter1_5 in ipairs(var0_5) do
		if iter1_5.isPlayer then
			return iter1_5.gameObject
		end
	end

	return nil
end

function var0_0.CheckIsNear(arg0_6)
	local var0_6 = arg0_6.view:GetUnitModuleWithType(arg0_6.unitType, arg0_6.unitId)
	local var1_6 = var0_6 and var0_6._go or nil

	if not var0_6 or IsNil(var1_6) then
		return false
	end

	if (arg0_6.playerTF.position - var1_6.transform.position).magnitude < arg0_6.hud_name_range then
		return true
	end

	return false
end

function var0_0.OnUpdate(arg0_7)
	local var0_7 = arg0_7:CheckIsNear()

	if var0_7 == arg0_7.isNear then
		return
	end

	arg0_7.isNear = var0_7

	setActive(arg0_7.hudTitle, arg0_7.isNear)
	setActive(arg0_7.hudName, arg0_7.isNear)
end

function var0_0.RefreshHud(arg0_8)
	arg0_8:UpdateTaskDisplay()
end

function var0_0.UpdateTaskDisplay(arg0_9)
	local var0_9, var1_9 = IslandObjectTaskHudHelper.GetObjectTaskHud(arg0_9.unitId)

	if arg0_9.currentTaskId ~= var1_9 then
		arg0_9.currentTaskId = var1_9

		if var1_9 then
			local var2_9, var3_9 = IslandObjectTaskHudHelper.GetHudDislayInfoByTaskId(var1_9)

			setActive(arg0_9.hudImageBg, true)
			GetImageSpriteFromAtlasAsync("island/IslandHudIcon", var2_9, arg0_9.hudImageBg)
			setImageColor(arg0_9.hudImageTF, Color.NewHex(var3_9))
		else
			setActive(arg0_9.hudImageBg, arg0_9.hudImageIcon ~= "")
			GetImageSpriteFromAtlasAsync("island/IslandHudIcon", "hud_main", arg0_9.hudImageBg)
			setImageColor(arg0_9.hudImageTF, Color.NewHex("78787a"))
		end
	end

	if var0_9 ~= arg0_9.currentTaskType then
		arg0_9.currentTaskType = var0_9

		local var4_9 = IslandObjectTaskHudHelper.TaskProcessToHudIcon[var0_9] or arg0_9.hudImageIcon

		setActive(arg0_9.hudImageBg, var4_9 ~= "")

		if var4_9 ~= "" then
			GetImageSpriteFromAtlasAsync("island/IslandHudIcon", var4_9, arg0_9.hudImageTF)
		end
	end
end

return var0_0
