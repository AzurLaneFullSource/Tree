local var0 = class("GuildImpeachPage", import(".GuildMemberBasePage"))

function var0.getUIName(arg0)
	return "GuildImpeachPage"
end

function var0.OnLoaded(arg0)
	var0.super.OnLoaded(arg0)

	arg0.impeachconfirmBtn = arg0:findTF("frame/confirm_btn")
	arg0.impeachcancelBtn = arg0:findTF("frame/cancel_btn")
	arg0.impeachnameTF = arg0:findTF("frame/info/name/Text", arg0._tf):GetComponent(typeof(Text))
	arg0.impeachiconTF = arg0:findTF("frame/info/shipicon/icon", arg0._tf):GetComponent(typeof(Image))
	arg0.impeachduty = arg0:findTF("frame/duty"):GetComponent(typeof(Image))
	arg0.impeachstarsTF = arg0:findTF("frame/info/shipicon/stars", arg0._tf)
	arg0.impeachstarTF = arg0:findTF("frame/info/shipicon/stars/star", arg0._tf)
	arg0.impeachlevelTF = arg0:findTF("frame/info/level/Text", arg0._tf):GetComponent(typeof(Text))
	arg0.circle = arg0:findTF("frame/info/shipicon/frame", arg0._tf)
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.impeachcancelBtn, function()
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

	arg0.impeachnameTF.text = var2.name

	local var3 = AttireFrame.attireFrameRes(var2, var2.id == getProxy(PlayerProxy):getRawData().id, AttireConst.TYPE_ICON_FRAME, var2.propose)

	PoolMgr.GetInstance():GetPrefab("IconFrame/" .. var3, var3, true, function(arg0)
		if IsNil(arg0._tf) then
			return
		end

		if arg0.cirCle then
			arg0.name = var3
			findTF(arg0.transform, "icon"):GetComponent(typeof(Image)).raycastTarget = false

			setParent(arg0, arg0.cirCle, false)
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
		if not IsNil(arg0.impeachiconTF) then
			arg0.impeachiconTF.sprite = arg0
		end
	end)

	local var6 = GetSpriteFromAtlas("dutyicon", "icon_" .. var2.duty)

	arg0.impeachduty.sprite = var6

	local var7 = arg0.impeachstarsTF.childCount

	for iter0 = var7, var4.star - 1 do
		cloneTplTo(arg0.impeachstarTF, arg0.impeachstarsTF)
	end

	for iter1 = 1, var7 do
		local var8 = arg0.impeachstarsTF:GetChild(iter1 - 1)

		setActive(var8, iter1 <= var4.star)
	end

	arg0.impeachlevelTF.text = "Lv." .. var2.level

	onButton(arg0, arg0.impeachconfirmBtn, function()
		if var2.id == var1.id then
			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("guild_impeach_tip"),
			onYes = function()
				arg0:emit(GuildMemberMediator.IMPEACH, var2.id)
				arg0:Hide()
			end
		})
	end, SFX_CONFIRM)
end

return var0
