local var0_0 = import(".MapBuilder")
local var1_0 = class("MapBuilderEscort", var0_0)

function var1_0.GetType(arg0_1)
	return var0_0.TYPEESCORT
end

function var1_0.getUIName(arg0_2)
	return "escort_levels"
end

function var1_0.OnInit(arg0_3)
	arg0_3.tpl = arg0_3._tf:Find("escort_level_tpl")
	arg0_3.itemHolder = arg0_3._tf:Find("items")
end

function var1_0.Update(arg0_4, arg1_4)
	arg0_4.map.pivot = Vector2(0.5, 0.5)
	arg0_4.float.pivot = Vector2(0.5, 0.5)

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

	local var3_4 = string.split(arg1_4:getConfig("name"), "||")

	setText(arg0_4.sceneParent.chapterName, var3_4[1])
	arg0_4.sceneParent.loader:GetSprite("chapterno", "chapterex", arg0_4.sceneParent.chapterNoTitle, true)
	var1_0.super.Update(arg0_4, arg1_4)
end

function var1_0.UpdateButtons(arg0_5)
	arg0_5.sceneParent:updateDifficultyBtns()
	arg0_5.sceneParent:updateActivityBtns()
end

function var1_0.UpdateEscortInfo(arg0_6)
	local var0_6 = getProxy(ChapterProxy)
	local var1_6 = var0_6:getMaxEscortChallengeTimes()

	setText(arg0_6.sceneParent.escortBar:Find("times/text"), var1_6 - var0_6.escortChallengeTimes .. "/" .. var1_6)
	onButton(arg0_6.sceneParent, arg0_6.sceneParent.mapHelpBtn, function()
		arg0_6:InvokeParent("HandleShowMsgBox", {
			type = MSGBOX_TYPE_HELP,
			helps = i18n("levelScene_escort_help_tip")
		})
	end, SFX_PANEL)
end

function var1_0.UpdateMapItems(arg0_8)
	var1_0.super.UpdateMapItems(arg0_8)
	arg0_8:UpdateEscortInfo()

	local var0_8 = arg0_8.data

	setActive(arg0_8.sceneParent.escortBar, true)
	setActive(arg0_8.sceneParent.mapHelpBtn, true)

	local var1_8 = getProxy(ChapterProxy)
	local var2_8 = getProxy(ChapterProxy):getEscortChapterIds()
	local var3_8 = _.filter(var0_8:getChapters(), function(arg0_9)
		return table.contains(var2_8, arg0_9.id)
	end)
	local var4_8 = UIItemList.New(arg0_8.itemHolder, arg0_8.tpl)

	var4_8:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			arg0_8:UpdateEscortItem(arg2_10, var3_8[arg1_10 + 1].id, var3_8[arg1_10 + 1])
		end
	end)
	var4_8:align(#var3_8)
end

function var1_0.UpdateEscortItem(arg0_11, arg1_11, arg2_11, arg3_11)
	local var0_11 = pg.escort_template[arg2_11]

	assert(var0_11, "escort template not exist: " .. arg2_11)

	local var1_11 = getProxy(ChapterProxy):getActiveChapter(true)

	arg1_11.name = "chapter_" .. arg3_11.id

	local var2_11 = arg0_11.map.rect

	arg1_11.anchoredPosition = Vector2(var2_11.width / arg0_11.scaleRatio * (tonumber(var0_11.pos_x) - 0.5), var2_11.height / arg0_11.scaleRatio * (tonumber(var0_11.pos_y) - 0.5))

	local var3_11 = arg1_11:Find("fighting")
	local var4_11 = var1_11 and var1_11.id == arg3_11.id

	setActive(var3_11, var4_11)
	arg0_11:DeleteTween("fighting" .. arg3_11.id)

	if var4_11 then
		setImageAlpha(var3_11, 1)
		arg0_11:RecordTween("fighting" .. arg3_11.id, LeanTween.alpha(var3_11, 0, 0.5):setEase(LeanTweenType.easeInOutSine):setLoopPingPong().uniqueId)
	end

	GetImageSpriteFromAtlasAsync("levelmap/mapquad/" .. var0_11.pic, "", arg1_11, true)

	local var5_11 = arg1_11:Find("anim")
	local var6_11 = getProxy(ChapterProxy):getEscortChapterIds()
	local var7_11 = table.indexof(var6_11, arg2_11)
	local var8_11 = ({
		Color.green,
		Color.yellow,
		Color.red
	})[var7_11 or 1]
	local var9_11 = var5_11:GetComponentsInChildren(typeof(Image))

	for iter0_11 = 0, var9_11.Length - 1 do
		var9_11[iter0_11].color = var8_11
	end

	setImageColor(arg1_11, var8_11)

	local var10_11 = arg3_11.id

	onButton(arg0_11.sceneParent, arg1_11, function()
		local var0_12 = getProxy(ChapterProxy):getChapterById(var10_11)

		arg0_11:InvokeParent("TrySwitchChapter", var0_12)
	end, SFX_PANEL)
end

function var1_0.OnShow(arg0_13)
	setActive(arg0_13.sceneParent.mainLayer:Find("title_chapter_lines"), true)
	setActive(arg0_13.sceneParent.topChapter:Find("title_chapter"), true)
	setActive(arg0_13.sceneParent.topChapter:Find("type_escort"), true)
end

function var1_0.OnHide(arg0_14)
	setActive(arg0_14.sceneParent.mainLayer:Find("title_chapter_lines"), false)
	setActive(arg0_14.sceneParent.topChapter:Find("title_chapter"), false)
	setActive(arg0_14.sceneParent.topChapter:Find("type_escort"), false)
	setActive(arg0_14.sceneParent.escortBar, false)
	setActive(arg0_14.sceneParent.mapHelpBtn, false)
end

return var1_0
