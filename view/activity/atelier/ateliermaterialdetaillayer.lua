local var0 = class("AtelierMaterialDetailLayer", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "AtelierMaterialDetailUI"
end

function var0.init(arg0)
	arg0.layerItemDetail = arg0._tf
	arg0.loader = AutoLoader.New()
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.layerItemDetail:Find("BG"), function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0.layerItemDetail:Find("Window/Close"), function()
		arg0:closeView()
	end, SFX_CANCEL)
	arg0:UpdateItemDetail()
	pg.UIMgr.GetInstance():BlurPanel(arg0.layerItemDetail, nil, {
		weight = LayerWeightConst.SECOND_LAYER
	})
end

function var0.UpdateItemDetail(arg0)
	local var0 = arg0.contextData.material

	arg0:UpdateRyzaItem(arg0.layerItemDetail:Find("Window/IconBG"), var0)
	setText(arg0.layerItemDetail:Find("Window/Name"), var0:GetName())
	setText(arg0.layerItemDetail:Find("Window/Description/Text"), var0:GetDesc())

	local var1 = var0:GetSource()

	setText(arg0.layerItemDetail:Find("Window/Source"), var1[1])
	onButton(arg0, arg0.layerItemDetail:Find("Window/Go"), function()
		if var1.chapterid then
			local var0 = getProxy(ChapterProxy):getChapterById(var1.chapterid)
			local var1 = getProxy(ChapterProxy):getMapById(var0:getConfig("map"))
			local var2, var3 = var1:isUnlock()

			if not var2 then
				pg.TipsMgr.GetInstance():ShowTips(var3)

				return
			end

			if not var0:isUnlock() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("battle_levelScene_chapter_lock"))

				return
			end

			arg0:emit(GAME.GO_SCENE, SCENE.LEVEL, {
				openChapterId = var1.chapterid,
				chapterId = var1.chapterid,
				mapIdx = var1.id
			})
		elseif var1.recipeid then
			local var4 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

			if not var4 or var4:isEnd() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

				return
			end

			local var5 = var4:GetFormulas()[var1.recipeid]

			if var5:GetType() ~= AtelierFormula.TYPE.TOOL and not var4:IsCompleteAllTools() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ryza_tip_unlock_all_tools"))

				return
			end

			if not var5:IsAvaliable() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ryza_tip_composite_invalid"))

				return
			end

			arg0:emit(AtelierMaterialDetailMediator.GO_RECIPE, var1.recipeid)
		elseif var1.taskid then
			local var6 = getProxy(ActivityProxy):getActivityById(ActivityConst.RYZA_TASK)

			if not var6 or var6:isEnd() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

				return
			end

			arg0:emit(GAME.GO_SCENE, SCENE.RYZA_TASK, {
				task_id = var1.taskid
			})
		end
	end, SFX_PANEL)
end

local var1 = "ui/AtelierCommonUI_atlas"

function var0.UpdateRyzaItem(arg0, arg1, arg2, arg3)
	local var0 = "icon_frame_" .. arg2:GetRarity()

	if arg3 then
		var0 = var0 .. "_small"
	end

	arg0.loader:GetSpriteQuiet(var1, var0, arg1)
	arg0.loader:GetSpriteQuiet(arg2:GetIconPath(), "", arg1:Find("Icon"))

	if not IsNil(arg1:Find("Lv")) then
		setText(arg1:Find("Lv/Text"), arg2:GetLevel())
	end

	local var1 = arg2:GetProps()
	local var2 = CustomIndexLayer.Clone2Full(arg1:Find("List"), #var1)

	for iter0, iter1 in ipairs(var2) do
		arg0.loader:GetSpriteQuiet(var1, "element_" .. AtelierFormulaCircle.ELEMENT_NAME[var1[iter0]], iter1)
	end

	if not IsNil(arg1:Find("Text")) then
		setText(arg1:Find("Text"), arg2.count or "")
	end
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0.layerItemDetail, arg0._tf)
	arg0.loader:Clear()
end

return var0
