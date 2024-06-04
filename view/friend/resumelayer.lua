local var0 = class("resumeLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "resumeUI"
end

function var0.setPlayerVO(arg0, arg1)
	arg0.player = arg1
end

function var0.init(arg0)
	arg0.frame = arg0:findTF("frame")
	arg0.resumeIcon = arg0:findTF("frame/window/info/circle/head")
	arg0.resumeStars = arg0:findTF("frame/window/info/circle/head/stars")
	arg0.resumeStarTpl = arg0:findTF("frame/window/info/circle/head/star")
	arg0.resumeLv = arg0:findTF("frame/window/info/player_info/level_bg/level"):GetComponent(typeof(Text))
	arg0.resumeName = arg0:findTF("frame/window/info/player_info/name_bg/name"):GetComponent(typeof(Text))
	arg0.resumeInfo = arg0:findTF("frame/window/summary/content")
	arg0.resumeEmblem = arg0:findTF("frame/window/info/rank_bg/rank/Image")
	arg0.resumeEmblemLabel = arg0:findTF("frame/window/info/rank_bg/rank/label")
	arg0.resumeMedalList = arg0:findTF("frame/window/medalList/container")
	arg0.resumeMedalTpl = arg0:findTF("frame/window/medal_tpl")
	arg0.closeBtn = arg0:findTF("frame/window/title_bg/close_btn")
	arg0.circle = arg0:findTF("frame/window/info/circle/head/frame")
	arg0.titleText = arg0:findTF("frame/title/label_cn/text")

	local var0 = i18n("friend_resume_title_detail")

	if var0 then
		setText(arg0.titleText, var0)
	end
end

function var0.didEnter(arg0)
	arg0:display(arg0.player)
	onButton(arg0, arg0._tf, function()
		arg0:emit(var0.ON_CLOSE)
	end, SOUND_BACK)
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

function var0.display(arg0, arg1)
	if arg0.contextData.parent then
		setParent(arg0._tf, arg0.contextData.parent)
	else
		pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
			weight = LayerWeightConst.SECOND_LAYER
		})
	end

	local var0 = SeasonInfo.getMilitaryRank(arg1.score, arg1.rank)
	local var1 = SeasonInfo.getEmblem(arg1.score, arg1.rank)

	LoadImageSpriteAsync("emblem/" .. var1, arg0.resumeEmblem)
	LoadImageSpriteAsync("emblem/n_" .. var1, arg0.resumeEmblemLabel)

	arg0.resumeName.text = arg1.name
	arg0.resumeLv.text = "Lv." .. arg1.level

	LoadSpriteAsync("qicon/" .. arg1:getPainting(), function(arg0)
		if not IsNil(arg0.resumeIcon) then
			local var0 = arg0.resumeIcon:GetComponent(typeof(Image))

			var0.color = Color.white
			var0.sprite = arg0 or LoadSprite("heroicon/unknown")
		end
	end)

	local var2 = AttireFrame.attireFrameRes(arg1, arg1.id == getProxy(PlayerProxy):getRawData().id, AttireConst.TYPE_ICON_FRAME, arg1.propose)

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

	local var3 = pg.ship_data_statistics[arg1.icon]
	local var4 = Ship.New({
		configId = var3.id
	})
	local var5 = arg0.resumeStars.childCount
	local var6 = var4:getStar()

	for iter0 = var5, var6 - 1 do
		cloneTplTo(arg0.resumeStarTpl, arg0.resumeStars)
	end

	local var7 = arg0.resumeStars.childCount

	for iter1 = 0, var7 - 1 do
		arg0.resumeStars:GetChild(iter1).gameObject:SetActive(iter1 < var3.star)
	end

	removeAllChildren(arg0.resumeMedalList)

	for iter2 = 1, 5 do
		local var8 = cloneTplTo(arg0.resumeMedalTpl, arg0.resumeMedalList)

		setActive(arg0:findTF("empty", var8), iter2 > #arg1.displayTrophyList)

		if iter2 <= #arg1.displayTrophyList then
			setActive(arg0:findTF("icon", var8), true)

			local var9 = pg.medal_template[arg1.displayTrophyList[iter2]]

			LoadImageSpriteAsync("medal/" .. var9.icon, arg0:findTF("icon", var8), true)
		end
	end

	for iter3, iter4 in ipairs(var1) do
		local var10 = arg0.resumeInfo:GetChild(iter3 - 1)

		setText(var10:Find("tag"), iter4.tag)

		local var11 = var10:Find("value")

		if iter4.type == 1 then
			setText(var11, arg0.player[iter4.value])
		elseif iter4.type == 2 then
			local var12 = math.max(arg0.player[iter4.value[1]], 1)
			local var13 = math.max(arg0.player[iter4.value[2]], 0)

			setText(var11, string.format("%0.2f", var13 / var12 * 100) .. "%")
		elseif iter4.type == 3 then
			local var14 = arg0.player[iter4.value[1]] or 1

			setText(var11, string.format("%0.2f", var14 / getProxy(CollectionProxy):getCollectionTotal() * 100) .. "%")
		end
	end
end

function var0.willExit(arg0)
	if arg0.contextData.parent then
		-- block empty
	else
		pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, pg.UIMgr.GetInstance().UIMain)
	end

	if arg0.circle.childCount > 0 then
		local var0 = arg0.circle:GetChild(0).gameObject

		PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. var0.name, var0.name, var0)
	end
end

return var0
