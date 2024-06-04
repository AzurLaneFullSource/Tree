local var0 = class("GuildShipEquipmentsPage", import("....base.BaseSubView"))

function var0.getUIName(arg0)
	return "GuildShipEquipmentsPage"
end

function var0.OnLoaded(arg0)
	arg0.shipNameTxt = arg0:findTF("frame/ship_info/shipname"):GetComponent(typeof(Text))
	arg0.userNameTxt = arg0:findTF("frame/ship_info/username"):GetComponent(typeof(Text))
	arg0.shipTypeIcon = arg0:findTF("frame/ship_info/ship_type"):GetComponent(typeof(Image))
	arg0.shipStarList = UIItemList.New(arg0:findTF("frame/ship_info/stars"), arg0:findTF("frame/ship_info/stars/star_tpl"))
	arg0.shipLvTxt = arg0:findTF("frame/ship_info/lv/Text"):GetComponent(typeof(Text))
	arg0.equipmentList = UIItemList.New(arg0:findTF("frame/equipemtns"), arg0:findTF("frame/equipemtns/equipment_tpl"))
	arg0.playerId = getProxy(PlayerProxy):getRawData().id
	arg0.nextBtn = arg0:findTF("frame/next")
	arg0.prevBtn = arg0:findTF("frame/prev")
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.nextBtn, function()
		if arg0.onNext then
			arg0.onNext()
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.prevBtn, function()
		if arg0.onPrev then
			arg0.onPrev()
		end
	end, SFX_PANEL)
end

function var0.SetCallBack(arg0, arg1, arg2)
	arg0.onPrev = arg1
	arg0.onNext = arg2
end

function var0.Show(arg0, arg1, arg2, arg3, arg4)
	var0.super.Show(arg0)

	arg0.OnHide = arg3

	if arg4 then
		arg4()
	end

	arg0:Flush(arg1, arg2)
	pg.UIMgr:GetInstance():BlurPanel(arg0._tf)
	setActive(arg0.nextBtn, arg0.onNext ~= nil)
	SetActive(arg0.prevBtn, arg0.onPrev ~= nil)
end

function var0.Flush(arg0, arg1, arg2)
	arg0.ship = arg1
	arg0.member = arg2

	arg0:UpdateShipInfo()
	arg0:UpdateEquipments()
end

function var0.Refresh(arg0, arg1, arg2)
	arg0:Flush(arg1, arg2)
end

function var0.UpdateShipInfo(arg0)
	local var0 = arg0.ship
	local var1 = arg0.member

	arg0.shipNameTxt.text = var0:getName()

	local var2 = arg0.playerId == var1.id and "" or i18n("guild_ship_from") .. var1.name

	arg0.userNameTxt.text = var2

	local var3 = pg.ship_data_statistics[var0.configId]

	arg0.shipTypeIcon.sprite = GetSpriteFromAtlas("shiptype", shipType2print(var3.type))

	local var4 = var0:getMaxStar()
	local var5 = var0:getStar()

	arg0.shipStarList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			setActive(arg2:Find("star_tpl"), arg1 <= var5)
		end
	end)
	arg0.shipStarList:align(var4)

	arg0.shipLvTxt.text = var0.level
end

function var0.UpdateEquipments(arg0)
	local var0 = arg0.ship:getActiveEquipments()

	arg0.equipmentList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1 + 1]

			setActive(arg2:Find("info"), var0)
			setActive(arg2:Find("empty"), not var0)

			if var0 then
				updateEquipment(arg2:Find("info"), var0)
				setText(arg2:Find("info/name_bg/Text"), shortenString(var0:getConfig("name"), 5))
			end
		end
	end)
	arg0.equipmentList:align(5)
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	pg.UIMgr:GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)

	if arg0.OnHide then
		arg0.OnHide()

		arg0.OnHide = nil
	end
end

function var0.OnDestroy(arg0)
	arg0:Hide()
end

return var0
