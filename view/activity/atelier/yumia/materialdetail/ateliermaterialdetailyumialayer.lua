local var0_0 = class("AtelierMaterialDetailYumiaLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "AtelierMaterialYumiaDetailUI"
end

function var0_0.init(arg0_2)
	arg0_2:InitCustom()
end

function var0_0.InitCustom(arg0_3)
	setText(arg0_3:findTF("Window/Text"), i18n("yumia_atelier_tip13"))
	setText(arg0_3:findTF("Window/titleBg/Name"), i18n("yumia_atelier_tip14"))
end

function var0_0.didEnter(arg0_4)
	onButton(arg0_4, arg0_4:findTF("BG"), function()
		arg0_4:PlayCloseAni()
	end, SFX_CANCEL)
	onButton(arg0_4, arg0_4:findTF("Window/titleBg/closeBtn"), function()
		arg0_4:PlayCloseAni()
	end, SFX_CANCEL)
	arg0_4:UpdateItemDetail()
	pg.UIMgr.GetInstance():BlurPanel(arg0_4._tf)
end

function var0_0.PlayCloseAni(arg0_7)
	local var0_7 = GetComponent(arg0_7._tf, typeof(Animation))

	var0_7:Play("Anim_AtelierMaterialYumiaDetailUI_Out")
	pg.UIMgr.GetInstance():LoadingOn(false)

	arg0_7.closeTimer = FrameTimer.New(function()
		if not var0_7:IsPlaying("Anim_AtelierMaterialYumiaDetailUI_Out") then
			arg0_7:StopCloseTimer()
			pg.UIMgr.GetInstance():LoadingOff()
			arg0_7:closeView()
		end
	end, 1, -1)

	arg0_7.closeTimer:Start()
end

function var0_0.StopCloseTimer(arg0_9)
	if arg0_9.closeTimer then
		arg0_9.closeTimer:Stop()

		arg0_9.closeTimer = nil
	end
end

function var0_0.UpdateItemDetail(arg0_10)
	local var0_10 = arg0_10.contextData.material

	arg0_10:UpdateRyzaItem(arg0_10:findTF("Window/AtelierCommonYumiaItem"), var0_10)
	setText(arg0_10:findTF("Window/nameBg/Name"), var0_10:GetName())
	setText(arg0_10:findTF("Window/Description/Text"), var0_10:GetDesc())

	local var1_10 = var0_10:GetSource()

	setScrollText(arg0_10:findTF("Window/sourceBg/mask/sourceText"), var1_10[1])
	onButton(arg0_10, arg0_10:findTF("Window/Go"), function()
		if var1_10.chapterid then
			local var0_11 = getProxy(ChapterProxy):getChapterById(var1_10.chapterid)
			local var1_11 = getProxy(ChapterProxy):getMapById(var0_11:getConfig("map"))
			local var2_11 = getProxy(ActivityProxy):getActivityByType(var1_11:getConfig("on_activity"))

			if not var2_11 or var2_11:isEnd() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

				return
			end

			local var3_11, var4_11 = var1_11:isUnlock()

			if not var3_11 then
				pg.TipsMgr.GetInstance():ShowTips(var4_11)

				return
			end

			if not var0_11:isUnlock() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("battle_levelScene_chapter_lock"))

				return
			end

			arg0_10:emit(GAME.GO_SCENE, SCENE.LEVEL, {
				openChapterId = var1_10.chapterid,
				chapterId = var1_10.chapterid,
				mapIdx = var1_11.id
			})
		elseif var1_10.recipeid then
			local var5_11 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ATELIER_LINK)

			if not var5_11 or var5_11:isEnd() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

				return
			end

			local var6_11 = var5_11:GetFormulas()[var1_10.recipeid]

			if var6_11:GetType() ~= AtelierFormula.TYPE.TOOL and not var5_11:IsCompleteAllTools(var6_11:getConfig("version")) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ryza_tip_unlock_all_tools"))

				return
			end

			if not var6_11:IsAvaliable() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ryza_tip_composite_invalid"))

				return
			end

			arg0_10:emit(AtelierMaterialDetailMediator.GO_RECIPE, var1_10.recipeid)
		elseif var1_10.taskid then
			if not getProxy(TaskProxy):getTaskVO(var1_10.taskid) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

				return
			end

			arg0_10:emit(GAME.GO_SCENE, SCENE.TASK, {
				targetId = var1_10.taskid
			})
		elseif var1_10.strongholdid then
			local var7_11 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_STRONGHOLD)

			if not var7_11 or var7_11:isEnd() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

				return
			end

			local var8_11 = getProxy(ContextProxy):getCurrentContext()

			pg.m02:retrieveMediator(var8_11.mediator.__cname):addSubLayers(Context.New({
				mediator = YoumiyaStrongholdMediator,
				viewComponent = YoumiyaStrongholdLayer
			}))
		end
	end, SFX_PANEL)
end

function var0_0.UpdateRyzaItem(arg0_12, arg1_12, arg2_12)
	AtelierTools.UpdateYumiaItem(arg1_12, arg2_12)
end

function var0_0.willExit(arg0_13)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_13._tf)
end

return var0_0
