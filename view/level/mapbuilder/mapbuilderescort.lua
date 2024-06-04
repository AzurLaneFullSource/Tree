local var0 = import(".MapBuilder")
local var1 = class("MapBuilderEscort", var0)

function var1.GetType(arg0)
	return var0.TYPEESCORT
end

function var1.getUIName(arg0)
	return "escort_levels"
end

function var1.OnInit(arg0)
	arg0.tpl = arg0._tf:Find("escort_level_tpl")
	arg0.itemHolder = arg0._tf:Find("items")
end

function var1.Update(arg0, arg1)
	arg0.map.pivot = Vector2(0.5, 0.5)
	arg0.float.pivot = Vector2(0.5, 0.5)

	local var0 = arg0.map.rect.width / arg0.map.rect.height
	local var1 = arg0._parentTf.rect.width / arg0._parentTf.rect.height
	local var2 = 1

	if var0 < var1 then
		var2 = arg0._parentTf.rect.width / 1280
		arg0._tf.localScale = Vector3(var2, var2, 1)
	else
		var2 = arg0._parentTf.rect.height / 720
		arg0._tf.localScale = Vector3(var2, var2, 1)
	end

	arg0.scaleRatio = var2

	local var3 = string.split(arg1:getConfig("name"), "||")

	setText(arg0.sceneParent.chapterName, var3[1])
	arg0.sceneParent.loader:GetSprite("chapterno", "chapterex", arg0.sceneParent.chapterNoTitle, true)
	var1.super.Update(arg0, arg1)
end

function var1.UpdateButtons(arg0)
	arg0.sceneParent:updateDifficultyBtns()
	arg0.sceneParent:updateActivityBtns()
end

function var1.UpdateEscortInfo(arg0)
	local var0 = getProxy(ChapterProxy)
	local var1 = var0:getMaxEscortChallengeTimes()

	setText(arg0.sceneParent.escortBar:Find("times/text"), var1 - var0.escortChallengeTimes .. "/" .. var1)
	onButton(arg0.sceneParent, arg0.sceneParent.mapHelpBtn, function()
		arg0:InvokeParent("HandleShowMsgBox", {
			type = MSGBOX_TYPE_HELP,
			helps = i18n("levelScene_escort_help_tip")
		})
	end, SFX_PANEL)
end

function var1.UpdateMapItems(arg0)
	var1.super.UpdateMapItems(arg0)
	arg0:UpdateEscortInfo()

	local var0 = arg0.data

	setActive(arg0.sceneParent.escortBar, true)
	setActive(arg0.sceneParent.mapHelpBtn, true)

	local var1 = getProxy(ChapterProxy)
	local var2 = getProxy(ChapterProxy):getEscortChapterIds()
	local var3 = _.filter(var0:getChapters(), function(arg0)
		return table.contains(var2, arg0.id)
	end)
	local var4 = UIItemList.New(arg0.itemHolder, arg0.tpl)

	var4:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:UpdateEscortItem(arg2, var3[arg1 + 1].id, var3[arg1 + 1])
		end
	end)
	var4:align(#var3)
end

function var1.UpdateEscortItem(arg0, arg1, arg2, arg3)
	local var0 = pg.escort_template[arg2]

	assert(var0, "escort template not exist: " .. arg2)

	local var1 = getProxy(ChapterProxy):getActiveChapter(true)

	arg1.name = "chapter_" .. arg3.id

	local var2 = arg0.map.rect

	arg1.anchoredPosition = Vector2(var2.width / arg0.scaleRatio * (tonumber(var0.pos_x) - 0.5), var2.height / arg0.scaleRatio * (tonumber(var0.pos_y) - 0.5))

	local var3 = arg1:Find("fighting")
	local var4 = var1 and var1.id == arg3.id

	setActive(var3, var4)
	arg0:DeleteTween("fighting" .. arg3.id)

	if var4 then
		setImageAlpha(var3, 1)
		arg0:RecordTween("fighting" .. arg3.id, LeanTween.alpha(var3, 0, 0.5):setEase(LeanTweenType.easeInOutSine):setLoopPingPong().uniqueId)
	end

	GetImageSpriteFromAtlasAsync("levelmap/mapquad/" .. var0.pic, "", arg1, true)

	local var5 = arg1:Find("anim")
	local var6 = getProxy(ChapterProxy):getEscortChapterIds()
	local var7 = table.indexof(var6, arg2)
	local var8 = ({
		Color.green,
		Color.yellow,
		Color.red
	})[var7 or 1]
	local var9 = var5:GetComponentsInChildren(typeof(Image))

	for iter0 = 0, var9.Length - 1 do
		var9[iter0].color = var8
	end

	setImageColor(arg1, var8)

	local var10 = arg3.id

	onButton(arg0.sceneParent, arg1, function()
		local var0 = getProxy(ChapterProxy):getChapterById(var10)

		arg0:InvokeParent("TrySwitchChapter", var0)
	end, SFX_PANEL)
end

function var1.OnShow(arg0)
	setActive(arg0.sceneParent.mainLayer:Find("title_chapter_lines"), true)
	setActive(arg0.sceneParent.topChapter:Find("title_chapter"), true)
	setActive(arg0.sceneParent.topChapter:Find("type_escort"), true)
end

function var1.OnHide(arg0)
	setActive(arg0.sceneParent.mainLayer:Find("title_chapter_lines"), false)
	setActive(arg0.sceneParent.topChapter:Find("title_chapter"), false)
	setActive(arg0.sceneParent.topChapter:Find("type_escort"), false)
	setActive(arg0.sceneParent.escortBar, false)
	setActive(arg0.sceneParent.mapHelpBtn, false)
end

return var1
