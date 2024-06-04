local var0 = class("WorldBossFormationPreViewPage", import("....base.BaseSubView"))

function var0.getUIName(arg0)
	return "WorldBossFormationPreViewPage"
end

function var0.OnLoaded(arg0)
	arg0.shipList = {
		arg0:findTF("frame/ships/1"),
		arg0:findTF("frame/ships/2"),
		arg0:findTF("frame/ships/3")
	}
	arg0.returnBtn = arg0:findTF("frame/return")
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.returnBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onToggle(arg0, arg0:findTF("frame/toggles/main"), function(arg0)
		if arg0 then
			arg0:Switch(1)
		end
	end, SFX_PANEL)
	onToggle(arg0, arg0:findTF("frame/toggles/vanguard"), function(arg0)
		if arg0 then
			arg0:Switch(2)
		end
	end, SFX_PANEL)
end

function var0.Switch(arg0, arg1)
	local var0 = arg0.ships[arg1]

	for iter0, iter1 in ipairs(arg0.shipList) do
		local var1 = var0[iter0]

		arg0:UpdateShip(iter1, var1)
	end
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0)
	setParent(arg0._tf, pg.UIMgr.GetInstance().UIMain)

	local var0 = {}
	local var1 = {}

	for iter0, iter1 in ipairs(arg1) do
		local var2 = iter1:getTeamType()

		if var2 == TeamType.Vanguard then
			table.insert(var1, iter1)
		elseif var2 == TeamType.Main then
			table.insert(var0, iter1)
		end
	end

	arg0.ships = {
		var0,
		var1
	}

	triggerToggle(arg0:findTF("frame/toggles/main"), true)
end

function var0.OnHide(arg0)
	var0.super.OnHide(arg0)
end

function var0.UpdateShip(arg0, arg1, arg2)
	local var0 = arg1:Find("bg/info")

	setActive(var0, arg2)

	if arg2 then
		local var1 = var0:Find("name"):GetComponent(typeof(Text))
		local var2 = var0:Find("ship_type"):GetComponent(typeof(Image))
		local var3 = UIItemList.New(var0:Find("stars"), var0:Find("stars/star_tpl"))
		local var4 = var0:Find("lv"):GetComponent(typeof(Text))

		var1.text = shortenString(arg2:getName(), 6)

		local var5 = pg.ship_data_statistics[arg2.configId]

		var2.sprite = GetSpriteFromAtlas("shiptype", shipType2print(var5.type))

		local var6 = arg2:getMaxStar()
		local var7 = arg2:getStar()

		var3:make(function(arg0, arg1, arg2)
			if arg0 == UIItemList.EventUpdate then
				setActive(arg2:Find("star_tpl"), arg1 <= var7)
			end
		end)
		var3:align(var6)

		var4.text = "Lv." .. arg2.level
		var0:Find("mask/icon"):GetComponent(typeof(Image)).sprite = LoadSprite("HeroHrzIcon/" .. arg2:getPainting())
	end

	arg1:Find("bg/line").sizeDelta = arg2 and Vector2(235, 2) or Vector2(461, 2)

	arg0:UpdateEquipments(var0, arg2)
end

function var0.UpdateEquipments(arg0, arg1, arg2)
	local var0 = UIItemList.New(arg1.parent:Find("equipemtns"), arg1.parent:Find("equipemtns/equipment_tpl"))
	local var1 = arg2 and arg2:getActiveEquipments() or {}

	var0:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var1[arg1 + 1]

			setActive(arg2:Find("info"), var0)
			setActive(arg2:Find("empty"), not var0)

			if var0 then
				updateEquipment(arg2:Find("info"), var0)
				onButton(arg0, arg2, function()
					arg0:emit(BaseUI.ON_EQUIPMENT, {
						type = EquipmentInfoMediator.TYPE_DISPLAY,
						equipment = var0
					})
				end, SFX_PANEL)
			else
				removeOnButton(arg2)
			end
		end
	end)
	var0:align(5)
end

function var0.OnDestroy(arg0)
	return
end

return var0
