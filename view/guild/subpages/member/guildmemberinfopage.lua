local var0_0 = class("GuildMemberInfoPage", import(".GuildMemberBasePage"))

function var0_0.getUIName(arg0_1)
	return "GuildMemberInfoPage"
end

local var1_0 = {
	{
		value = "shipCount",
		type = 1,
		tag = i18n("friend_resume_ship_count")
	},
	{
		type = 3,
		tag = i18n("friend_resume_collection_rate"),
		value = {
			"collectionCount"
		}
	},
	{
		value = "attackCount",
		type = 1,
		tag = i18n("friend_resume_attack_count")
	},
	{
		type = 2,
		tag = i18n("friend_resume_attack_win_rate"),
		value = {
			"attackCount",
			"winCount"
		}
	},
	{
		value = "pvp_attack_count",
		type = 1,
		tag = i18n("friend_resume_manoeuvre_count")
	},
	{
		type = 2,
		tag = i18n("friend_resume_manoeuvre_win_rate"),
		value = {
			"pvp_attack_count",
			"pvp_win_count"
		}
	},
	{
		value = "collect_attack_count",
		type = 1,
		tag = i18n("friend_event_count")
	}
}

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)

	arg0_2.infonameTF = arg0_2:findTF("frame/info/name/Text"):GetComponent(typeof(Text))
	arg0_2.infoiconTF = arg0_2:findTF("frame/info/shipicon/icon"):GetComponent(typeof(Image))
	arg0_2.infoduty = arg0_2:findTF("frame/duty"):GetComponent(typeof(Image))
	arg0_2.infostarsTF = arg0_2:findTF("frame/info/shipicon/stars")
	arg0_2.infostarTF = arg0_2:findTF("frame/info/shipicon/stars/star")
	arg0_2.infolevelTF = arg0_2:findTF("frame/info/level/Text"):GetComponent(typeof(Text))
	arg0_2.circle = arg0_2:findTF("frame/info/shipicon/frame")
	arg0_2.resumeInfo = arg0_2:findTF("frame/content")
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_CONFIRM)
end

function var0_0.Show(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)
	arg0_5.guildVO = arg1_5
	arg0_5.playerVO = arg2_5
	arg0_5.memberVO = arg3_5

	arg0_5:emit(GuildMemberMediator.OPEN_DESC_INFO, arg3_5)

	if arg4_5 then
		arg4_5()
	end
end

function var0_0.Flush(arg0_6, arg1_6)
	pg.UIMgr.GetInstance():BlurPanel(arg0_6._tf)
	setActive(arg0_6._tf, true)
	arg0_6._tf:SetAsLastSibling()
	arg0_6.onShowCallBack(arg0_6.buttonPos)

	local var0_6 = arg0_6.guildVO
	local var1_6 = arg0_6.memberVO

	arg0_6.infonameTF.text = var1_6.name

	local var2_6 = AttireFrame.attireFrameRes(var1_6, var1_6.id == getProxy(PlayerProxy):getRawData().id, AttireConst.TYPE_ICON_FRAME, var1_6.propose)

	PoolMgr.GetInstance():GetPrefab("IconFrame/" .. var2_6, var2_6, true, function(arg0_7)
		if IsNil(arg0_6._tf) then
			return
		end

		if arg0_6.circle then
			arg0_7.name = var2_6
			findTF(arg0_7.transform, "icon"):GetComponent(typeof(Image)).raycastTarget = false

			setParent(arg0_7, arg0_6.circle, false)
		else
			PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var2_6, var2_6, arg0_7)
		end
	end)

	local var3_6 = pg.ship_data_statistics[var1_6.icon]
	local var4_6 = Ship.New({
		configId = var1_6.icon,
		skin_id = var1_6.skinId
	})

	LoadSpriteAsync("qicon/" .. var4_6:getPainting(), function(arg0_8)
		if not IsNil(arg0_6.infoiconTF) then
			arg0_6.infoiconTF.sprite = arg0_8
		end
	end)

	local var5_6 = GetSpriteFromAtlas("dutyicon", "icon_" .. var1_6.duty)

	arg0_6.infoduty.sprite = var5_6

	local var6_6 = arg0_6.infostarsTF.childCount

	for iter0_6 = var6_6, var3_6.star - 1 do
		cloneTplTo(arg0_6.infostarTF, arg0_6.infostarsTF)
	end

	for iter1_6 = 1, var6_6 do
		local var7_6 = arg0_6.infostarsTF:GetChild(iter1_6 - 1)

		setActive(var7_6, iter1_6 <= var3_6.star)
	end

	arg0_6.infolevelTF.text = "Lv." .. var1_6.level

	for iter2_6, iter3_6 in ipairs(var1_0) do
		local var8_6 = arg0_6.resumeInfo:GetChild(iter2_6 - 1)

		setText(var8_6:Find("tag"), iter3_6.tag)

		local var9_6 = var8_6:Find("tag (1)")

		if iter3_6.type == 1 then
			setText(var9_6, arg1_6[iter3_6.value])
		elseif iter3_6.type == 2 then
			local var10_6 = math.max(arg1_6[iter3_6.value[1]], 1)
			local var11_6 = math.max(arg1_6[iter3_6.value[2]], 0)

			setText(var9_6, string.format("%0.2f", var11_6 / var10_6 * 100) .. "%")
		elseif iter3_6.type == 3 then
			local var12_6 = arg1_6[iter3_6.value[1]] or 1

			setText(var9_6, string.format("%0.2f", var12_6 / getProxy(CollectionProxy):getCollectionTotal() * 100) .. "%")
		end
	end
end

return var0_0
