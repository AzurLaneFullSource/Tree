local var0_0 = class("GuildImpeachPage", import(".GuildMemberBasePage"))

function var0_0.getUIName(arg0_1)
	return "GuildImpeachPage"
end

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)

	arg0_2.impeachconfirmBtn = arg0_2:findTF("frame/confirm_btn")
	arg0_2.impeachcancelBtn = arg0_2:findTF("frame/cancel_btn")
	arg0_2.impeachnameTF = arg0_2:findTF("frame/info/name/Text", arg0_2._tf):GetComponent(typeof(Text))
	arg0_2.impeachiconTF = arg0_2:findTF("frame/info/shipicon/icon", arg0_2._tf):GetComponent(typeof(Image))
	arg0_2.impeachduty = arg0_2:findTF("frame/duty"):GetComponent(typeof(Image))
	arg0_2.impeachstarsTF = arg0_2:findTF("frame/info/shipicon/stars", arg0_2._tf)
	arg0_2.impeachstarTF = arg0_2:findTF("frame/info/shipicon/stars/star", arg0_2._tf)
	arg0_2.impeachlevelTF = arg0_2:findTF("frame/info/level/Text", arg0_2._tf):GetComponent(typeof(Text))
	arg0_2.circle = arg0_2:findTF("frame/info/shipicon/frame", arg0_2._tf)
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.impeachcancelBtn, function()
		arg0_3:Hide()
	end, SFX_CONFIRM)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_CONFIRM)
end

function var0_0.OnShow(arg0_6)
	local var0_6 = arg0_6.guildVO
	local var1_6 = arg0_6.playerVO
	local var2_6 = arg0_6.memberVO

	arg0_6.impeachnameTF.text = var2_6.name

	local var3_6 = AttireFrame.attireFrameRes(var2_6, var2_6.id == getProxy(PlayerProxy):getRawData().id, AttireConst.TYPE_ICON_FRAME, var2_6.propose)

	PoolMgr.GetInstance():GetPrefab("IconFrame/" .. var3_6, var3_6, true, function(arg0_7)
		if IsNil(arg0_6._tf) then
			return
		end

		if arg0_6.cirCle then
			arg0_7.name = var3_6
			findTF(arg0_7.transform, "icon"):GetComponent(typeof(Image)).raycastTarget = false

			setParent(arg0_7, arg0_6.cirCle, false)
		else
			PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var3_6, var3_6, arg0_7)
		end
	end)

	local var4_6 = pg.ship_data_statistics[var2_6.icon]
	local var5_6 = Ship.New({
		configId = var2_6.icon,
		skin_id = var2_6.skinId
	})

	LoadSpriteAsync("qicon/" .. var5_6:getPainting(), function(arg0_8)
		if not IsNil(arg0_6.impeachiconTF) then
			arg0_6.impeachiconTF.sprite = arg0_8
		end
	end)

	local var6_6 = GetSpriteFromAtlas("dutyicon", "icon_" .. var2_6.duty)

	arg0_6.impeachduty.sprite = var6_6

	local var7_6 = arg0_6.impeachstarsTF.childCount

	for iter0_6 = var7_6, var4_6.star - 1 do
		cloneTplTo(arg0_6.impeachstarTF, arg0_6.impeachstarsTF)
	end

	for iter1_6 = 1, var7_6 do
		local var8_6 = arg0_6.impeachstarsTF:GetChild(iter1_6 - 1)

		setActive(var8_6, iter1_6 <= var4_6.star)
	end

	arg0_6.impeachlevelTF.text = "Lv." .. var2_6.level

	onButton(arg0_6, arg0_6.impeachconfirmBtn, function()
		if var2_6.id == var1_6.id then
			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("guild_impeach_tip"),
			onYes = function()
				arg0_6:emit(GuildMemberMediator.IMPEACH, var2_6.id)
				arg0_6:Hide()
			end
		})
	end, SFX_CONFIRM)
end

return var0_0
