local var0_0 = class("GuildShipEquipmentsPage", import("....base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "GuildShipEquipmentsPage"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"shiptype",
		"weaponframes",
		"ui/iconcolorful"
	}

	return table.insertto(var0_2, var0_0.super.getResource(arg0_2, arg1_2))
end

function var0_0.getEquipmentResList(arg0_3, arg1_3)
	local var0_3 = {}
	local var1_3 = arg1_3 and arg1_3:getActiveEquipments() or {}

	_.each(var1_3, function(arg0_4)
		if arg0_4 then
			local var0_4 = ResPathSupport.CombinePath(ResPathSupport.ConstPath.Equipment.Equip, arg0_4:getConfig("icon"))

			table.insert(var0_3, var0_4)
		end
	end)

	return var0_3
end

function var0_0.OnLoaded(arg0_5)
	arg0_5.shipNameTxt = arg0_5._tf:Find("frame/ship_info/shipname"):GetComponent(typeof(Text))
	arg0_5.userNameTxt = arg0_5._tf:Find("frame/ship_info/username"):GetComponent(typeof(Text))
	arg0_5.shipTypeIcon = arg0_5._tf:Find("frame/ship_info/ship_type"):GetComponent(typeof(Image))
	arg0_5.shipStarList = UIItemList.New(arg0_5._tf:Find("frame/ship_info/stars"), arg0_5._tf:Find("frame/ship_info/stars/star_tpl"))
	arg0_5.shipLvTxt = arg0_5._tf:Find("frame/ship_info/lv/Text"):GetComponent(typeof(Text))
	arg0_5.equipmentList = UIItemList.New(arg0_5._tf:Find("frame/equipemtns"), arg0_5._tf:Find("frame/equipemtns/equipment_tpl"))
	arg0_5.playerId = getProxy(PlayerProxy):getRawData().id
	arg0_5.nextBtn = arg0_5._tf:Find("frame/next")
	arg0_5.prevBtn = arg0_5._tf:Find("frame/prev")
end

function var0_0.OnInit(arg0_6)
	onButton(arg0_6, arg0_6._tf, function()
		arg0_6:Hide()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.nextBtn, function()
		if arg0_6.onNext then
			arg0_6.onNext()
		end
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.prevBtn, function()
		if arg0_6.onPrev then
			arg0_6.onPrev()
		end
	end, SFX_PANEL)
end

function var0_0.SetCallBack(arg0_10, arg1_10, arg2_10)
	arg0_10.onPrev = arg1_10
	arg0_10.onNext = arg2_10
end

function var0_0.downloadEquipmentResList(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg0_11:getEquipmentResList(arg1_11)

	SplitPackConst.DownloadByLuaArr(var0_11, function()
		if arg0_11._state == var0_0.STATES.DESTROY then
			return
		end

		arg2_11()
	end)
end

function var0_0.Show(arg0_13, arg1_13, arg2_13, arg3_13, arg4_13)
	arg0_13:downloadEquipmentResList(arg1_13, function()
		var0_0.super.Show(arg0_13)

		arg0_13.OnHide = arg3_13

		if arg4_13 then
			arg4_13()
		end

		arg0_13:Flush(arg1_13, arg2_13)
		pg.UIMgr.GetInstance():BlurPanel(arg0_13._tf)
		setActive(arg0_13.nextBtn, arg0_13.onNext ~= nil)
		SetActive(arg0_13.prevBtn, arg0_13.onPrev ~= nil)
	end)
end

function var0_0.Flush(arg0_15, arg1_15, arg2_15)
	arg0_15.ship = arg1_15
	arg0_15.member = arg2_15

	arg0_15:UpdateShipInfo()
	arg0_15:UpdateEquipments()
end

function var0_0.Refresh(arg0_16, arg1_16, arg2_16)
	arg0_16:downloadEquipmentResList(arg1_16, function()
		arg0_16:Flush(arg1_16, arg2_16)
	end)
end

function var0_0.UpdateShipInfo(arg0_18)
	local var0_18 = arg0_18.ship
	local var1_18 = arg0_18.member

	arg0_18.shipNameTxt.text = var0_18:getName()

	local var2_18 = arg0_18.playerId == var1_18.id and "" or i18n("guild_ship_from") .. var1_18.name

	arg0_18.userNameTxt.text = var2_18

	local var3_18 = pg.ship_data_statistics[var0_18.configId]

	arg0_18.shipTypeIcon.sprite = GetSpriteFromAtlas("shiptype", shipType2print(var3_18.type))

	local var4_18 = var0_18:getMaxStar()
	local var5_18 = var0_18:getStar()

	arg0_18.shipStarList:make(function(arg0_19, arg1_19, arg2_19)
		if arg0_19 == UIItemList.EventUpdate then
			setActive(arg2_19:Find("star_tpl"), arg1_19 <= var5_18)
		end
	end)
	arg0_18.shipStarList:align(var4_18)

	arg0_18.shipLvTxt.text = var0_18.level
end

function var0_0.UpdateEquipments(arg0_20)
	local var0_20 = arg0_20.ship:getActiveEquipments()

	arg0_20.equipmentList:make(function(arg0_21, arg1_21, arg2_21)
		if arg0_21 == UIItemList.EventUpdate then
			local var0_21 = var0_20[arg1_21 + 1]

			setActive(arg2_21:Find("info"), var0_21)
			setActive(arg2_21:Find("empty"), not var0_21)

			if var0_21 then
				updateEquipment(arg2_21:Find("info"), var0_21)
				setText(arg2_21:Find("info/name_bg/Text"), shortenString(var0_21:getConfig("name"), 5))
			end
		end
	end)
	arg0_20.equipmentList:align(5)
end

function var0_0.Hide(arg0_22)
	var0_0.super.Hide(arg0_22)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_22._tf, arg0_22._parentTf)

	if arg0_22.OnHide then
		arg0_22.OnHide()

		arg0_22.OnHide = nil
	end
end

function var0_0.OnDestroy(arg0_23)
	arg0_23:Hide()
end

return var0_0
