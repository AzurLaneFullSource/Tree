local var0 = class("GuildMemberInfoPage", import(".GuildMemberBasePage"))

function var0.getUIName(arg0)
	return "GuildMemberInfoPage"
end

local var1 = {
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

function var0.OnLoaded(arg0)
	var0.super.OnLoaded(arg0)

	arg0.infonameTF = arg0:findTF("frame/info/name/Text"):GetComponent(typeof(Text))
	arg0.infoiconTF = arg0:findTF("frame/info/shipicon/icon"):GetComponent(typeof(Image))
	arg0.infoduty = arg0:findTF("frame/duty"):GetComponent(typeof(Image))
	arg0.infostarsTF = arg0:findTF("frame/info/shipicon/stars")
	arg0.infostarTF = arg0:findTF("frame/info/shipicon/stars/star")
	arg0.infolevelTF = arg0:findTF("frame/info/level/Text"):GetComponent(typeof(Text))
	arg0.circle = arg0:findTF("frame/info/shipicon/frame")
	arg0.resumeInfo = arg0:findTF("frame/content")
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_CONFIRM)
end

function var0.Show(arg0, arg1, arg2, arg3, arg4)
	arg0.guildVO = arg1
	arg0.playerVO = arg2
	arg0.memberVO = arg3

	arg0:emit(GuildMemberMediator.OPEN_DESC_INFO, arg3)

	if arg4 then
		arg4()
	end
end

function var0.Flush(arg0, arg1)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	setActive(arg0._tf, true)
	arg0._tf:SetAsLastSibling()
	arg0.onShowCallBack(arg0.buttonPos)

	local var0 = arg0.guildVO
	local var1 = arg0.memberVO

	arg0.infonameTF.text = var1.name

	local var2 = AttireFrame.attireFrameRes(var1, var1.id == getProxy(PlayerProxy):getRawData().id, AttireConst.TYPE_ICON_FRAME, var1.propose)

	PoolMgr.GetInstance():GetPrefab("IconFrame/" .. var2, var2, true, function(arg0)
		if IsNil(arg0._tf) then
			return
		end

		if arg0.circle then
			arg0.name = var2
			findTF(arg0.transform, "icon"):GetComponent(typeof(Image)).raycastTarget = false

			setParent(arg0, arg0.circle, false)
		else
			PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var2, var2, arg0)
		end
	end)

	local var3 = pg.ship_data_statistics[var1.icon]
	local var4 = Ship.New({
		configId = var1.icon,
		skin_id = var1.skinId
	})

	LoadSpriteAsync("qicon/" .. var4:getPainting(), function(arg0)
		if not IsNil(arg0.infoiconTF) then
			arg0.infoiconTF.sprite = arg0
		end
	end)

	local var5 = GetSpriteFromAtlas("dutyicon", "icon_" .. var1.duty)

	arg0.infoduty.sprite = var5

	local var6 = arg0.infostarsTF.childCount

	for iter0 = var6, var3.star - 1 do
		cloneTplTo(arg0.infostarTF, arg0.infostarsTF)
	end

	for iter1 = 1, var6 do
		local var7 = arg0.infostarsTF:GetChild(iter1 - 1)

		setActive(var7, iter1 <= var3.star)
	end

	arg0.infolevelTF.text = "Lv." .. var1.level

	for iter2, iter3 in ipairs(var1) do
		local var8 = arg0.resumeInfo:GetChild(iter2 - 1)

		setText(var8:Find("tag"), iter3.tag)

		local var9 = var8:Find("tag (1)")

		if iter3.type == 1 then
			setText(var9, arg1[iter3.value])
		elseif iter3.type == 2 then
			local var10 = math.max(arg1[iter3.value[1]], 1)
			local var11 = math.max(arg1[iter3.value[2]], 0)

			setText(var9, string.format("%0.2f", var11 / var10 * 100) .. "%")
		elseif iter3.type == 3 then
			local var12 = arg1[iter3.value[1]] or 1

			setText(var9, string.format("%0.2f", var12 / getProxy(CollectionProxy):getCollectionTotal() * 100) .. "%")
		end
	end
end

return var0
