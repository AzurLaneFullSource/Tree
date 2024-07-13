local var0_0 = class("resumeLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "resumeUI"
end

function var0_0.setPlayerVO(arg0_2, arg1_2)
	arg0_2.player = arg1_2
end

function var0_0.init(arg0_3)
	arg0_3.frame = arg0_3:findTF("frame")
	arg0_3.resumeIcon = arg0_3:findTF("frame/window/info/circle/head")
	arg0_3.resumeStars = arg0_3:findTF("frame/window/info/circle/head/stars")
	arg0_3.resumeStarTpl = arg0_3:findTF("frame/window/info/circle/head/star")
	arg0_3.resumeLv = arg0_3:findTF("frame/window/info/player_info/level_bg/level"):GetComponent(typeof(Text))
	arg0_3.resumeName = arg0_3:findTF("frame/window/info/player_info/name_bg/name"):GetComponent(typeof(Text))
	arg0_3.resumeInfo = arg0_3:findTF("frame/window/summary/content")
	arg0_3.resumeEmblem = arg0_3:findTF("frame/window/info/rank_bg/rank/Image")
	arg0_3.resumeEmblemLabel = arg0_3:findTF("frame/window/info/rank_bg/rank/label")
	arg0_3.resumeMedalList = arg0_3:findTF("frame/window/medalList/container")
	arg0_3.resumeMedalTpl = arg0_3:findTF("frame/window/medal_tpl")
	arg0_3.closeBtn = arg0_3:findTF("frame/window/title_bg/close_btn")
	arg0_3.circle = arg0_3:findTF("frame/window/info/circle/head/frame")
	arg0_3.titleText = arg0_3:findTF("frame/title/label_cn/text")

	local var0_3 = i18n("friend_resume_title_detail")

	if var0_3 then
		setText(arg0_3.titleText, var0_3)
	end
end

function var0_0.didEnter(arg0_4)
	arg0_4:display(arg0_4.player)
	onButton(arg0_4, arg0_4._tf, function()
		arg0_4:emit(var0_0.ON_CLOSE)
	end, SOUND_BACK)
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

function var0_0.display(arg0_6, arg1_6)
	if arg0_6.contextData.parent then
		setParent(arg0_6._tf, arg0_6.contextData.parent)
	else
		pg.UIMgr.GetInstance():BlurPanel(arg0_6._tf, false, {
			weight = LayerWeightConst.SECOND_LAYER
		})
	end

	local var0_6 = SeasonInfo.getMilitaryRank(arg1_6.score, arg1_6.rank)
	local var1_6 = SeasonInfo.getEmblem(arg1_6.score, arg1_6.rank)

	LoadImageSpriteAsync("emblem/" .. var1_6, arg0_6.resumeEmblem)
	LoadImageSpriteAsync("emblem/n_" .. var1_6, arg0_6.resumeEmblemLabel)

	arg0_6.resumeName.text = arg1_6.name
	arg0_6.resumeLv.text = "Lv." .. arg1_6.level

	LoadSpriteAsync("qicon/" .. arg1_6:getPainting(), function(arg0_7)
		if not IsNil(arg0_6.resumeIcon) then
			local var0_7 = arg0_6.resumeIcon:GetComponent(typeof(Image))

			var0_7.color = Color.white
			var0_7.sprite = arg0_7 or LoadSprite("heroicon/unknown")
		end
	end)

	local var2_6 = AttireFrame.attireFrameRes(arg1_6, arg1_6.id == getProxy(PlayerProxy):getRawData().id, AttireConst.TYPE_ICON_FRAME, arg1_6.propose)

	PoolMgr.GetInstance():GetPrefab("IconFrame/" .. var2_6, var2_6, true, function(arg0_8)
		if IsNil(arg0_6._tf) then
			return
		end

		if arg0_6.circle then
			arg0_8.name = var2_6
			findTF(arg0_8.transform, "icon"):GetComponent(typeof(Image)).raycastTarget = false

			setParent(arg0_8, arg0_6.circle, false)
		else
			PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var2_6, var2_6, arg0_8)
		end
	end)

	local var3_6 = pg.ship_data_statistics[arg1_6.icon]
	local var4_6 = Ship.New({
		configId = var3_6.id
	})
	local var5_6 = arg0_6.resumeStars.childCount
	local var6_6 = var4_6:getStar()

	for iter0_6 = var5_6, var6_6 - 1 do
		cloneTplTo(arg0_6.resumeStarTpl, arg0_6.resumeStars)
	end

	local var7_6 = arg0_6.resumeStars.childCount

	for iter1_6 = 0, var7_6 - 1 do
		arg0_6.resumeStars:GetChild(iter1_6).gameObject:SetActive(iter1_6 < var3_6.star)
	end

	removeAllChildren(arg0_6.resumeMedalList)

	for iter2_6 = 1, 5 do
		local var8_6 = cloneTplTo(arg0_6.resumeMedalTpl, arg0_6.resumeMedalList)

		setActive(arg0_6:findTF("empty", var8_6), iter2_6 > #arg1_6.displayTrophyList)

		if iter2_6 <= #arg1_6.displayTrophyList then
			setActive(arg0_6:findTF("icon", var8_6), true)

			local var9_6 = pg.medal_template[arg1_6.displayTrophyList[iter2_6]]

			LoadImageSpriteAsync("medal/" .. var9_6.icon, arg0_6:findTF("icon", var8_6), true)
		end
	end

	for iter3_6, iter4_6 in ipairs(var1_0) do
		local var10_6 = arg0_6.resumeInfo:GetChild(iter3_6 - 1)

		setText(var10_6:Find("tag"), iter4_6.tag)

		local var11_6 = var10_6:Find("value")

		if iter4_6.type == 1 then
			setText(var11_6, arg0_6.player[iter4_6.value])
		elseif iter4_6.type == 2 then
			local var12_6 = math.max(arg0_6.player[iter4_6.value[1]], 1)
			local var13_6 = math.max(arg0_6.player[iter4_6.value[2]], 0)

			setText(var11_6, string.format("%0.2f", var13_6 / var12_6 * 100) .. "%")
		elseif iter4_6.type == 3 then
			local var14_6 = arg0_6.player[iter4_6.value[1]] or 1

			setText(var11_6, string.format("%0.2f", var14_6 / getProxy(CollectionProxy):getCollectionTotal() * 100) .. "%")
		end
	end
end

function var0_0.willExit(arg0_9)
	if arg0_9.contextData.parent then
		-- block empty
	else
		pg.UIMgr.GetInstance():UnblurPanel(arg0_9._tf, pg.UIMgr.GetInstance().UIMain)
	end

	if arg0_9.circle.childCount > 0 then
		local var0_9 = arg0_9.circle:GetChild(0).gameObject

		PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var0_9.name, var0_9.name, var0_9)
	end
end

return var0_0
