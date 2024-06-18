local var0_0 = class("WorldBossFormationPreViewPage", import("....base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "WorldBossFormationPreViewPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.shipList = {
		arg0_2:findTF("frame/ships/1"),
		arg0_2:findTF("frame/ships/2"),
		arg0_2:findTF("frame/ships/3")
	}
	arg0_2.returnBtn = arg0_2:findTF("frame/return")
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.returnBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onToggle(arg0_3, arg0_3:findTF("frame/toggles/main"), function(arg0_6)
		if arg0_6 then
			arg0_3:Switch(1)
		end
	end, SFX_PANEL)
	onToggle(arg0_3, arg0_3:findTF("frame/toggles/vanguard"), function(arg0_7)
		if arg0_7 then
			arg0_3:Switch(2)
		end
	end, SFX_PANEL)
end

function var0_0.Switch(arg0_8, arg1_8)
	local var0_8 = arg0_8.ships[arg1_8]

	for iter0_8, iter1_8 in ipairs(arg0_8.shipList) do
		local var1_8 = var0_8[iter0_8]

		arg0_8:UpdateShip(iter1_8, var1_8)
	end
end

function var0_0.Show(arg0_9, arg1_9)
	var0_0.super.Show(arg0_9)
	setParent(arg0_9._tf, pg.UIMgr.GetInstance().UIMain)

	local var0_9 = {}
	local var1_9 = {}

	for iter0_9, iter1_9 in ipairs(arg1_9) do
		local var2_9 = iter1_9:getTeamType()

		if var2_9 == TeamType.Vanguard then
			table.insert(var1_9, iter1_9)
		elseif var2_9 == TeamType.Main then
			table.insert(var0_9, iter1_9)
		end
	end

	arg0_9.ships = {
		var0_9,
		var1_9
	}

	triggerToggle(arg0_9:findTF("frame/toggles/main"), true)
end

function var0_0.OnHide(arg0_10)
	var0_0.super.OnHide(arg0_10)
end

function var0_0.UpdateShip(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg1_11:Find("bg/info")

	setActive(var0_11, arg2_11)

	if arg2_11 then
		local var1_11 = var0_11:Find("name"):GetComponent(typeof(Text))
		local var2_11 = var0_11:Find("ship_type"):GetComponent(typeof(Image))
		local var3_11 = UIItemList.New(var0_11:Find("stars"), var0_11:Find("stars/star_tpl"))
		local var4_11 = var0_11:Find("lv"):GetComponent(typeof(Text))

		var1_11.text = shortenString(arg2_11:getName(), 6)

		local var5_11 = pg.ship_data_statistics[arg2_11.configId]

		var2_11.sprite = GetSpriteFromAtlas("shiptype", shipType2print(var5_11.type))

		local var6_11 = arg2_11:getMaxStar()
		local var7_11 = arg2_11:getStar()

		var3_11:make(function(arg0_12, arg1_12, arg2_12)
			if arg0_12 == UIItemList.EventUpdate then
				setActive(arg2_12:Find("star_tpl"), arg1_12 <= var7_11)
			end
		end)
		var3_11:align(var6_11)

		var4_11.text = "Lv." .. arg2_11.level
		var0_11:Find("mask/icon"):GetComponent(typeof(Image)).sprite = LoadSprite("HeroHrzIcon/" .. arg2_11:getPainting())
	end

	arg1_11:Find("bg/line").sizeDelta = arg2_11 and Vector2(235, 2) or Vector2(461, 2)

	arg0_11:UpdateEquipments(var0_11, arg2_11)
end

function var0_0.UpdateEquipments(arg0_13, arg1_13, arg2_13)
	local var0_13 = UIItemList.New(arg1_13.parent:Find("equipemtns"), arg1_13.parent:Find("equipemtns/equipment_tpl"))
	local var1_13 = arg2_13 and arg2_13:getActiveEquipments() or {}

	var0_13:make(function(arg0_14, arg1_14, arg2_14)
		if arg0_14 == UIItemList.EventUpdate then
			local var0_14 = var1_13[arg1_14 + 1]

			setActive(arg2_14:Find("info"), var0_14)
			setActive(arg2_14:Find("empty"), not var0_14)

			if var0_14 then
				updateEquipment(arg2_14:Find("info"), var0_14)
				onButton(arg0_13, arg2_14, function()
					arg0_13:emit(BaseUI.ON_EQUIPMENT, {
						type = EquipmentInfoMediator.TYPE_DISPLAY,
						equipment = var0_14
					})
				end, SFX_PANEL)
			else
				removeOnButton(arg2_14)
			end
		end
	end)
	var0_13:align(5)
end

function var0_0.OnDestroy(arg0_16)
	return
end

return var0_0
