local var0_0 = class("MapBuilderEscort", import(".MapBuilderPermanent"))

function var0_0.GetType(arg0_1)
	return MapBuilder.TYPEESCORT
end

function var0_0.getUIName(arg0_2)
	return "escort_levels"
end

function var0_0.OnInit(arg0_3)
	arg0_3.tpl = arg0_3._tf:Find("escort_level_tpl")
	arg0_3.itemHolder = arg0_3._tf:Find("items")
end

function var0_0.UpdateView(arg0_4)
	local var0_4 = arg0_4.map.rect.width / arg0_4.map.rect.height
	local var1_4 = arg0_4._parentTf.rect.width / arg0_4._parentTf.rect.height
	local var2_4 = 1

	if var0_4 < var1_4 then
		var2_4 = arg0_4._parentTf.rect.width / 1280
		arg0_4._tf.localScale = Vector3(var2_4, var2_4, 1)
	else
		var2_4 = arg0_4._parentTf.rect.height / 720
		arg0_4._tf.localScale = Vector3(var2_4, var2_4, 1)
	end

	arg0_4.scaleRatio = var2_4

	local var3_4 = string.split(arg0_4.contextData.map:getConfig("name"), "||")

	setText(arg0_4.sceneParent.chapterName, var3_4[1])
	arg0_4.sceneParent.loader:GetSprite("chapterno", "chapterex", arg0_4.sceneParent.chapterNoTitle, true)
	var0_0.super.UpdateView(arg0_4)
end

function var0_0.UpdateEscortInfo(arg0_5)
	local var0_5 = getProxy(ChapterProxy)
	local var1_5 = var0_5:getMaxEscortChallengeTimes()

	setText(arg0_5.sceneParent.escortBar:Find("times/text"), var1_5 - var0_5.escortChallengeTimes .. "/" .. var1_5)
	onButton(arg0_5.sceneParent, arg0_5.sceneParent.mapHelpBtn, function()
		arg0_5.sceneParent:HandleShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("levelScene_escort_help_tip")
		})
	end, SFX_PANEL)
end

function var0_0.UpdateMapItems(arg0_7)
	var0_0.super.UpdateMapItems(arg0_7)
	arg0_7:UpdateEscortInfo()

	local var0_7 = arg0_7.data
	local var1_7 = getProxy(ChapterProxy):getEscortChapterIds()
	local var2_7 = _.filter(var0_7:getChapters(), function(arg0_8)
		return table.contains(var1_7, arg0_8.id)
	end)

	UIItemList.StaticAlign(arg0_7.itemHolder, arg0_7.tpl, #var2_7, function(arg0_9, arg1_9, arg2_9)
		if arg0_9 ~= UIItemList.EventUpdate then
			return
		end

		arg0_7:UpdateEscortItem(arg2_9, var2_7[arg1_9 + 1].id, var2_7[arg1_9 + 1])
	end)
end

function var0_0.UpdateEscortItem(arg0_10, arg1_10, arg2_10, arg3_10)
	local var0_10 = pg.escort_template[arg2_10]

	assert(var0_10, "escort template not exist: " .. arg2_10)

	local var1_10 = getProxy(ChapterProxy):getActiveChapter(true)

	arg1_10.name = "chapter_" .. arg3_10.id

	local var2_10 = arg0_10.map.rect

	arg1_10.anchoredPosition = Vector2(var2_10.width / arg0_10.scaleRatio * (tonumber(var0_10.pos_x) - 0.5), var2_10.height / arg0_10.scaleRatio * (tonumber(var0_10.pos_y) - 0.5))

	local var3_10 = arg1_10:Find("fighting")
	local var4_10 = var1_10 and var1_10.id == arg3_10.id

	setActive(var3_10, var4_10)
	arg0_10:DeleteTween("fighting" .. arg3_10.id)

	if var4_10 then
		setImageAlpha(var3_10, 1)
		arg0_10:RecordTween("fighting" .. arg3_10.id, LeanTween.alpha(var3_10, 0, 0.5):setEase(LeanTweenType.easeInOutSine):setLoopPingPong().uniqueId)
	end

	GetImageSpriteFromAtlasAsync("levelmap/mapquad/" .. var0_10.pic, "", arg1_10, true)

	local var5_10 = arg1_10:Find("anim")
	local var6_10 = getProxy(ChapterProxy):getEscortChapterIds()
	local var7_10 = table.indexof(var6_10, arg2_10)
	local var8_10 = ({
		Color.green,
		Color.yellow,
		Color.red
	})[var7_10 or 1]
	local var9_10 = var5_10:GetComponentsInChildren(typeof(Image))

	for iter0_10 = 0, var9_10.Length - 1 do
		var9_10[iter0_10].color = var8_10
	end

	setImageColor(arg1_10, var8_10)

	local var10_10 = arg3_10.id

	onButton(arg0_10, arg1_10, function()
		arg0_10:TryOpenChapterInfo(var10_10)
	end, SFX_PANEL)
end

function var0_0.OnShow(arg0_12)
	var0_0.super.OnShow(arg0_12)
	setActive(arg0_12.sceneParent.mainLayer:Find("title_chapter_lines"), true)
	setActive(arg0_12.sceneParent.topChapter:Find("title_chapter"), true)
	setActive(arg0_12.sceneParent.topChapter:Find("type_escort"), true)
	setActive(arg0_12.sceneParent.escortBar, true)
	setActive(arg0_12.sceneParent.mapHelpBtn, true)
end

function var0_0.OnHide(arg0_13)
	setActive(arg0_13.sceneParent.mainLayer:Find("title_chapter_lines"), false)
	setActive(arg0_13.sceneParent.topChapter:Find("title_chapter"), false)
	setActive(arg0_13.sceneParent.topChapter:Find("type_escort"), false)
	setActive(arg0_13.sceneParent.escortBar, false)
	setActive(arg0_13.sceneParent.mapHelpBtn, false)
	var0_0.super.OnHide(arg0_13)
end

function var0_0.HideFloat(arg0_14)
	setActive(arg0_14.itemHolder, false)
end

function var0_0.ShowFloat(arg0_15)
	setActive(arg0_15.itemHolder, true)
end

return var0_0
