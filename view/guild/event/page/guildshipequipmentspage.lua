local var0_0 = class("GuildShipEquipmentsPage", import("....base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "GuildShipEquipmentsPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.shipNameTxt = arg0_2:findTF("frame/ship_info/shipname"):GetComponent(typeof(Text))
	arg0_2.userNameTxt = arg0_2:findTF("frame/ship_info/username"):GetComponent(typeof(Text))
	arg0_2.shipTypeIcon = arg0_2:findTF("frame/ship_info/ship_type"):GetComponent(typeof(Image))
	arg0_2.shipStarList = UIItemList.New(arg0_2:findTF("frame/ship_info/stars"), arg0_2:findTF("frame/ship_info/stars/star_tpl"))
	arg0_2.shipLvTxt = arg0_2:findTF("frame/ship_info/lv/Text"):GetComponent(typeof(Text))
	arg0_2.equipmentList = UIItemList.New(arg0_2:findTF("frame/equipemtns"), arg0_2:findTF("frame/equipemtns/equipment_tpl"))
	arg0_2.playerId = getProxy(PlayerProxy):getRawData().id
	arg0_2.nextBtn = arg0_2:findTF("frame/next")
	arg0_2.prevBtn = arg0_2:findTF("frame/prev")
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.nextBtn, function()
		if arg0_3.onNext then
			arg0_3.onNext()
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.prevBtn, function()
		if arg0_3.onPrev then
			arg0_3.onPrev()
		end
	end, SFX_PANEL)
end

function var0_0.SetCallBack(arg0_7, arg1_7, arg2_7)
	arg0_7.onPrev = arg1_7
	arg0_7.onNext = arg2_7
end

function var0_0.Show(arg0_8, arg1_8, arg2_8, arg3_8, arg4_8)
	var0_0.super.Show(arg0_8)

	arg0_8.OnHide = arg3_8

	if arg4_8 then
		arg4_8()
	end

	arg0_8:Flush(arg1_8, arg2_8)
	pg.UIMgr:GetInstance():BlurPanel(arg0_8._tf)
	setActive(arg0_8.nextBtn, arg0_8.onNext ~= nil)
	SetActive(arg0_8.prevBtn, arg0_8.onPrev ~= nil)
end

function var0_0.Flush(arg0_9, arg1_9, arg2_9)
	arg0_9.ship = arg1_9
	arg0_9.member = arg2_9

	arg0_9:UpdateShipInfo()
	arg0_9:UpdateEquipments()
end

function var0_0.Refresh(arg0_10, arg1_10, arg2_10)
	arg0_10:Flush(arg1_10, arg2_10)
end

function var0_0.UpdateShipInfo(arg0_11)
	local var0_11 = arg0_11.ship
	local var1_11 = arg0_11.member

	arg0_11.shipNameTxt.text = var0_11:getName()

	local var2_11 = arg0_11.playerId == var1_11.id and "" or i18n("guild_ship_from") .. var1_11.name

	arg0_11.userNameTxt.text = var2_11

	local var3_11 = pg.ship_data_statistics[var0_11.configId]

	arg0_11.shipTypeIcon.sprite = GetSpriteFromAtlas("shiptype", shipType2print(var3_11.type))

	local var4_11 = var0_11:getMaxStar()
	local var5_11 = var0_11:getStar()

	arg0_11.shipStarList:make(function(arg0_12, arg1_12, arg2_12)
		if arg0_12 == UIItemList.EventUpdate then
			setActive(arg2_12:Find("star_tpl"), arg1_12 <= var5_11)
		end
	end)
	arg0_11.shipStarList:align(var4_11)

	arg0_11.shipLvTxt.text = var0_11.level
end

function var0_0.UpdateEquipments(arg0_13)
	local var0_13 = arg0_13.ship:getActiveEquipments()

	arg0_13.equipmentList:make(function(arg0_14, arg1_14, arg2_14)
		if arg0_14 == UIItemList.EventUpdate then
			local var0_14 = var0_13[arg1_14 + 1]

			setActive(arg2_14:Find("info"), var0_14)
			setActive(arg2_14:Find("empty"), not var0_14)

			if var0_14 then
				updateEquipment(arg2_14:Find("info"), var0_14)
				setText(arg2_14:Find("info/name_bg/Text"), shortenString(var0_14:getConfig("name"), 5))
			end
		end
	end)
	arg0_13.equipmentList:align(5)
end

function var0_0.Hide(arg0_15)
	var0_0.super.Hide(arg0_15)
	pg.UIMgr:GetInstance():UnblurPanel(arg0_15._tf, arg0_15._parentTf)

	if arg0_15.OnHide then
		arg0_15.OnHide()

		arg0_15.OnHide = nil
	end
end

function var0_0.OnDestroy(arg0_16)
	arg0_16:Hide()
end

return var0_0
