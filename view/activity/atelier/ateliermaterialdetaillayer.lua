local var0_0 = class("AtelierMaterialDetailLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "AtelierMaterialDetailUI"
end

function var0_0.init(arg0_2)
	arg0_2.layerItemDetail = arg0_2._tf
	arg0_2.loader = AutoLoader.New()
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3.layerItemDetail:Find("BG"), function()
		arg0_3:closeView()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.layerItemDetail:Find("Window/Close"), function()
		arg0_3:closeView()
	end, SFX_CANCEL)
	arg0_3:UpdateItemDetail()
	pg.UIMgr.GetInstance():BlurPanel(arg0_3.layerItemDetail, nil, {
		weight = LayerWeightConst.SECOND_LAYER
	})
end

function var0_0.UpdateItemDetail(arg0_6)
	local var0_6 = arg0_6.contextData.material

	arg0_6:UpdateRyzaItem(arg0_6.layerItemDetail:Find("Window/IconBG"), var0_6)
	setText(arg0_6.layerItemDetail:Find("Window/Name"), var0_6:GetName())
	setText(arg0_6.layerItemDetail:Find("Window/Description/Text"), var0_6:GetDesc())

	local var1_6 = var0_6:GetSource()

	setText(arg0_6.layerItemDetail:Find("Window/Source"), var1_6[1])
	onButton(arg0_6, arg0_6.layerItemDetail:Find("Window/Go"), function()
		if var1_6.chapterid then
			local var0_7 = getProxy(ChapterProxy):getChapterById(var1_6.chapterid)
			local var1_7 = getProxy(ChapterProxy):getMapById(var0_7:getConfig("map"))
			local var2_7, var3_7 = var1_7:isUnlock()

			if not var2_7 then
				pg.TipsMgr.GetInstance():ShowTips(var3_7)

				return
			end

			if not var0_7:isUnlock() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("battle_levelScene_chapter_lock"))

				return
			end

			arg0_6:emit(GAME.GO_SCENE, SCENE.LEVEL, {
				openChapterId = var1_6.chapterid,
				chapterId = var1_6.chapterid,
				mapIdx = var1_7.id
			})
		elseif var1_6.recipeid then
			local var4_7 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

			if not var4_7 or var4_7:isEnd() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

				return
			end

			local var5_7 = var4_7:GetFormulas()[var1_6.recipeid]

			if var5_7:GetType() ~= AtelierFormula.TYPE.TOOL and not var4_7:IsCompleteAllTools() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ryza_tip_unlock_all_tools"))

				return
			end

			if not var5_7:IsAvaliable() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ryza_tip_composite_invalid"))

				return
			end

			arg0_6:emit(AtelierMaterialDetailMediator.GO_RECIPE, var1_6.recipeid)
		elseif var1_6.taskid then
			local var6_7 = getProxy(ActivityProxy):getActivityById(ActivityConst.RYZA_TASK)

			if not var6_7 or var6_7:isEnd() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

				return
			end

			arg0_6:emit(GAME.GO_SCENE, SCENE.RYZA_TASK, {
				task_id = var1_6.taskid
			})
		end
	end, SFX_PANEL)
end

local var1_0 = "ui/AtelierCommonUI_atlas"

function var0_0.UpdateRyzaItem(arg0_8, arg1_8, arg2_8, arg3_8)
	local var0_8 = "icon_frame_" .. arg2_8:GetRarity()

	if arg3_8 then
		var0_8 = var0_8 .. "_small"
	end

	arg0_8.loader:GetSpriteQuiet(var1_0, var0_8, arg1_8)
	arg0_8.loader:GetSpriteQuiet(arg2_8:GetIconPath(), "", arg1_8:Find("Icon"))

	if not IsNil(arg1_8:Find("Lv")) then
		setText(arg1_8:Find("Lv/Text"), arg2_8:GetLevel())
	end

	local var1_8 = arg2_8:GetProps()
	local var2_8 = CustomIndexLayer.Clone2Full(arg1_8:Find("List"), #var1_8)

	for iter0_8, iter1_8 in ipairs(var2_8) do
		arg0_8.loader:GetSpriteQuiet(var1_0, "element_" .. AtelierFormulaCircle.ELEMENT_NAME[var1_8[iter0_8]], iter1_8)
	end

	if not IsNil(arg1_8:Find("Text")) then
		setText(arg1_8:Find("Text"), arg2_8.count or "")
	end
end

function var0_0.willExit(arg0_9)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_9.layerItemDetail, arg0_9._tf)
	arg0_9.loader:Clear()
end

return var0_0
