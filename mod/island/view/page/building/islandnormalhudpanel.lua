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

	arg0_3.tfDic = {
		hudImage = arg0_3.hudImageBg,
		title = arg0_3.hudTitle,
		name = arg0_3.hudName
	}
	arg0_3.activeTFDic = {}
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

		local var1_8 = {
			"title",
			"name"
		}

		for iter0_8, iter1_8 in ipairs(var1_8) do
			arg0_8:SetTFActive(iter1_8, arg0_8.isNear)
		end
	end
end

function var0_0.SetTFActive(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg0_9.tfDic[arg1_9]

	if IsNil(var0_9) then
		return
	end

	if arg0_9.activeTFDic[arg1_9] == arg2_9 then
		return
	end

	arg0_9.activeTFDic[arg1_9] = arg2_9

	local var1_9 = var0_9:GetComponent(typeof(Animation))

	if arg2_9 then
		var1_9:Play("anim_IslandNormalNpcHud_in")

		if arg1_9 == "hudImage" then
			arg0_9:UpdateTaskDisplay()
		else
			setActive(var0_9, true)
		end
	else
		var1_9:Play("anim_IslandNormalNpcHud_out")
		var0_9:GetComponent("DftAniEvent"):SetEndEvent(function(arg0_10)
			if arg1_9 == "hudImage" then
				arg0_9:UpdateTaskDisplay()
			else
				setActive(var0_9, false)
			end
		end)
	end
end

function var0_0.RefreshHud(arg0_11)
	arg0_11:UpdateTaskDisplay()
end

function var0_0.UpdateTaskDisplay(arg0_12)
	if IsNil(arg0_12.hudImageBg) then
		return
	end

	local var0_12, var1_12 = IslandObjectTaskHudHelper.GetObjectTaskHud(arg0_12.unitId)

	if arg0_12.currentTaskId ~= var1_12 then
		arg0_12.currentTaskId = var1_12

		if var1_12 then
			local var2_12, var3_12 = IslandObjectTaskHudHelper.GetHudDislayInfoByTaskId(var1_12)

			setActive(arg0_12.hudImageBg, true)
			GetImageSpriteFromAtlasAsync("island/IslandHudIcon", var2_12, arg0_12.hudImageBg)
			setImageColor(arg0_12.hudImageTF, Color.NewHex(var3_12))
		else
			setActive(arg0_12.hudImageBg, arg0_12.hudImageIcon ~= "")
			GetImageSpriteFromAtlasAsync("island/IslandHudIcon", "hud_main", arg0_12.hudImageBg)
			setImageColor(arg0_12.hudImageTF, Color.NewHex("78787a"))
		end
	end

	if var0_12 ~= arg0_12.currentTaskType then
		arg0_12.currentTaskType = var0_12

		local var4_12 = IslandObjectTaskHudHelper.TaskProcessToHudIcon[var0_12] or arg0_12.hudImageIcon

		setActive(arg0_12.hudImageBg, var4_12 ~= "")

		if var4_12 ~= "" then
			GetImageSpriteFromAtlasAsync("island/IslandHudIcon", var4_12, arg0_12.hudImageTF)
		end
	end
end

function var0_0.Show(arg0_13)
	if not arg0_13._tf or arg0_13.active == true then
		return
	end

	arg0_13.active = true

	setActive(arg0_13._tf, true)

	local var0_13 = {
		"hudImage",
		"title",
		"name"
	}

	for iter0_13, iter1_13 in ipairs(var0_13) do
		arg0_13:SetTFActive(iter1_13, true)
	end
end

function var0_0.Hide(arg0_14)
	if not arg0_14._tf then
		return
	end

	arg0_14.active = false

	local var0_14 = {
		"hudImage",
		"title",
		"name"
	}

	for iter0_14, iter1_14 in ipairs(var0_14) do
		arg0_14:SetTFActive(iter1_14, false)
	end
end

return var0_0
