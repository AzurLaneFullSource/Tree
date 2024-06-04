local var0 = class("GuildFirePage", import(".GuildMemberBasePage"))

function var0.getUIName(arg0)
	return "GuildFirePage"
end

function var0.OnLoaded(arg0)
	var0.super.OnLoaded(arg0)

	arg0.fireconfirmBtn = arg0:findTF("frame/confirm_btn")
	arg0.firecancelBtn = arg0:findTF("frame/cancel_btn")
	arg0.firenameTF = arg0:findTF("frame/info/name/Text", arg0._tf):GetComponent(typeof(Text))
	arg0.fireiconTF = arg0:findTF("frame/info/shipicon/icon", arg0._tf):GetComponent(typeof(Image))
	arg0.fireduty = arg0:findTF("frame/duty"):GetComponent(typeof(Image))
	arg0.firestarsTF = arg0:findTF("frame/info/shipicon/stars", arg0._tf)
	arg0.firestarTF = arg0:findTF("frame/info/shipicon/stars/star", arg0._tf)
	arg0.firelevelTF = arg0:findTF("frame/info/level/Text", arg0._tf):GetComponent(typeof(Text))
	arg0.circle = arg0:findTF("frame/info/shipicon/frame", arg0._tf)
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.firecancelBtn, function()
		arg0:Hide()
	end, SFX_CONFIRM)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_CONFIRM)
end

function var0.OnShow(arg0)
	local var0 = arg0.guildVO
	local var1 = arg0.playerVO
	local var2 = arg0.memberVO

	arg0.firenameTF.text = var2.name

	local var3 = AttireFrame.attireFrameRes(var2, var2.id == getProxy(PlayerProxy):getRawData().id, AttireConst.TYPE_ICON_FRAME, var2.propose)

	PoolMgr.GetInstance():GetPrefab("IconFrame/" .. var3, var3, true, function(arg0)
		if IsNil(arg0._tf) then
			return
		end

		if arg0.circle then
			arg0.name = var3
			findTF(arg0.transform, "icon"):GetComponent(typeof(Image)).raycastTarget = false

			setParent(arg0, arg0.circle, false)
		else
			PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var3, var3, arg0)
		end
	end)

	local var4 = pg.ship_data_statistics[var2.icon]
	local var5 = Ship.New({
		configId = var2.icon,
		skin_id = var2.skinId
	})

	LoadSpriteAsync("qicon/" .. var5:getPainting(), function(arg0)
		if not IsNil(arg0.fireiconTF) then
			arg0.fireiconTF.sprite = arg0
		end
	end)

	local var6 = GetSpriteFromAtlas("dutyicon", "icon_" .. var2.duty)

	arg0.fireduty.sprite = var6

	local var7 = arg0.firestarsTF.childCount

	for iter0 = var7, var4.star - 1 do
		cloneTplTo(arg0.firestarTF, arg0.firestarsTF)
	end

	for iter1 = 1, var7 do
		local var8 = arg0.firestarsTF:GetChild(iter1 - 1)

		setActive(var8, iter1 <= var4.star)
	end

	arg0.firelevelTF.text = "Lv." .. var2.level

	onButton(arg0, arg0.fireconfirmBtn, function()
		if var2.id == var1.id then
			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("guild_fire_tip"),
			onYes = function()
				arg0:emit(GuildMemberMediator.FIRE, var2.id)
				arg0:Hide()
			end
		})
	end, SFX_CONFIRM)
end

return var0
