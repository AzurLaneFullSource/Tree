local var0_0 = class("LevelInfoSPView", import(".LevelInfoView"))

function var0_0.getUIName(arg0_1)
	return "LevelInfoSPUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"ui/levelmainscene_atlas"
	}

	return table.insertto(var0_2, var0_0.super.getResource(arg0_2, arg1_2))
end

function var0_0.InitUI(arg0_3)
	var0_0.super.InitUI(arg0_3)

	arg0_3.levelBanner = arg0_3._tf:Find("panel/Level")
	arg0_3.btnSwitchNormal = arg0_3._tf:Find("panel/Difficulty/Normal")
	arg0_3.btnSwitchHard = arg0_3._tf:Find("panel/Difficulty/Hard")
	arg0_3.tfAnim = arg0_3._tf:GetComponent(typeof(Animation))
	arg0_3.tfAniEvent = arg0_3._tf:GetComponent(typeof(DftAniEvent))

	arg0_3.tfAniEvent:SetEndEvent(function()
		arg0_3:playSelectFX()
	end)

	arg0_3.diffBtn = arg0_3._tf:Find("panel/Difficulty")
	arg0_3.btnAnim = arg0_3._tf:Find("panel/Difficulty"):GetComponent(typeof(Animation))
	arg0_3.btnAniEvent = arg0_3._tf:Find("panel/Difficulty"):GetComponent(typeof(DftAniEvent))

	arg0_3.btnAniEvent:SetEndEvent(function()
		arg0_3:playButtonLoopFX()
	end)

	arg0_3.btnAnimNormal = arg0_3._tf:Find("panel/Difficulty/Mask_Normal")
	arg0_3.btnAnimHard = arg0_3._tf:Find("panel/Difficulty/Mask_Difficlty")
	arg0_3.btnAnimLoopNormal = arg0_3._tf:Find("panel/Difficulty/Normal/Mask_Normal_Loop/Image")
	arg0_3.btnAnimLoopHard = arg0_3._tf:Find("panel/Difficulty/Hard/Mask_Difficulty_Loop")
	arg0_3.doEaseIn = false
end

function var0_0.playSelectFX(arg0_6)
	local var0_6 = 1

	if #arg0_6.groupInfo > 1 then
		var0_6 = table.indexof(arg0_6.groupInfo, arg0_6.chapter.id)
	elseif arg0_6.chapter:IsSpChapter() or arg0_6.chapter:IsEXChapter() then
		var0_6 = 2
	end

	if #arg0_6.groupInfo > 1 then
		if var0_6 == 2 then
			setActive(arg0_6.btnAnimNormal, false)
			setActive(arg0_6.btnAnimLoopNormal, false)
			quickPlayAnimation(arg0_6.diffBtn, "Anim_LevelInfoSPUI_DifficultySelected")
		else
			setActive(arg0_6.btnAnimHard, false)
			setActive(arg0_6.btnAnimLoopHard, false)
			quickPlayAnimation(arg0_6.diffBtn, "Anim_LevelInfoSPUI_NormalSelected")
		end
	end
end

function var0_0.playButtonLoopFX(arg0_7)
	if arg0_7.btnAnim:IsPlaying("Anim_LevelInfoSPUI_DifficultySelected") then
		quickPlayAnimation(arg0_7.diffBtn, "Anim_LevelInfoSPUI_DifficultyInLoop")
	elseif arg0_7.btnAnim:IsPlaying("Anim_LevelInfoSPUI_NormalSelected") then
		quickPlayAnimation(arg0_7.diffBtn, "Anim_LevelInfoSPUI_NormalInLoop")
	end
end

function var0_0.SetChapterGroupInfo(arg0_8, arg1_8)
	arg0_8.groupInfo = arg1_8
end

function var0_0.Show(arg0_9)
	pg.UIMgr.GetInstance():BlurPanel(arg0_9._tf, {
		force = true
	})
	setActive(arg0_9._tf, true)
	quickPlayAnimation(arg0_9._tf, "Anim_LevelInfoSPUI_in")
end

function var0_0.setAfterResDownload(arg0_10, arg1_10, arg2_10, arg3_10)
	var0_0.super.setAfterResDownload(arg0_10, arg1_10, arg2_10, arg3_10)

	local var0_10 = arg0_10.groupInfo

	assert(var0_10)

	local var1_10 = {
		"Normal",
		"Hard"
	}
	local var2_10 = 1
	local var3_10

	if #var0_10 > 1 then
		local var4_10 = table.indexof(var0_10, arg1_10)

		var2_10 = var4_10
		var3_10 = var0_10[#var0_10 - var4_10 + 1]
	elseif arg3_10:IsSpChapter() or arg3_10:IsEXChapter() then
		var2_10 = 2
	end

	for iter0_10, iter1_10 in ipairs(var1_10) do
		setActive(arg0_10.titleBG:Find(iter1_10), iter0_10 == var2_10)
	end

	for iter2_10, iter3_10 in ipairs(var1_10) do
		setActive(arg0_10.levelBanner:Find(iter3_10), iter2_10 == var2_10)
	end

	setActive(arg0_10.btnSwitchNormal, #var0_10 > 1 and var2_10 == 1)
	setActive(arg0_10.btnSwitchHard, #var0_10 > 1 and var2_10 == 2)

	if #var0_10 > 1 then
		local var5_10 = var2_10 == 1 and arg0_10.btnSwitchNormal or arg0_10.btnSwitchHard

		for iter4_10 = 1, 2 do
			local var6_10 = var5_10:Find("Bonus" .. iter4_10)
			local var7_10 = getProxy(ChapterProxy):getChapterById(var0_10[iter4_10], true)
			local var8_10 = var7_10:GetDailyBonusQuota()

			setActive(var6_10, var8_10)

			if var8_10 then
				GetImageSpriteFromAtlasAsync("ui/levelmainscene_atlas", "bonusX" .. var7_10:GetDailyBonusRate(), var6_10:Find("Image"), true)

				local var9_10 = getProxy(ChapterProxy):getMapById(var7_10:getConfig("map"))
				local var10_10 = getProxy(ActivityProxy):getActivityById(var9_10:getConfig("on_activity"))
				local var11_10 = var10_10 and var10_10:GetConfigClientPTActivity() or nil
				local var12_10 = var11_10 and var11_10:GetPTDrop()

				GetImageSpriteFromAtlasAsync(var12_10:getIcon(), "", var6_10:Find("Image/icon"), true)
			end
		end
	end

	local var13_10 = var2_10 == 1 and Color.NewHex("FFDE38") or Color.white

	setTextColor(arg0_10.txTitle:Find("title_index"), var13_10)
	setTextColor(arg0_10.txTitle:Find("title"), var13_10)
	setTextColor(arg0_10.txTitle:Find("title_en"), var13_10)

	local var14_10 = arg3_10:getConfig("boss_expedition_id")

	if arg3_10:getPlayType() == ChapterConst.TypeMultiStageBoss then
		var14_10 = pg.chapter_model_multistageboss[arg3_10.id].boss_expedition_id
	end

	local var15_10 = pg.expedition_data_template[var14_10[#var14_10]].level

	setText(arg0_10.levelBanner:Find("Text"), "LV " .. var15_10)
	onButton(arg0_10, arg0_10.btnSwitchNormal:Find("Switch"), function()
		setActive(arg0_10.btnAnimNormal, false)
		setActive(arg0_10.btnAnimLoopNormal, false)
		quickPlayAnimation(arg0_10.diffBtn, "Anim_LevelInfoSPUI_DifficultySelected")
		arg0_10:emit(LevelUIConst.SWITCH_SPCHAPTER_DIFFICULTY, var3_10)
		arg0_10:set(var3_10)
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.btnSwitchHard:Find("Switch"), function()
		setActive(arg0_10.btnAnimHard, false)
		setActive(arg0_10.btnAnimLoopHard, false)
		quickPlayAnimation(arg0_10.diffBtn, "Anim_LevelInfoSPUI_NormalSelected")
		arg0_10:emit(LevelUIConst.SWITCH_SPCHAPTER_DIFFICULTY, var3_10)
		arg0_10:set(var3_10)
	end, SFX_PANEL)
	;(function()
		if IsUnityEditor and not ENABLE_GUIDE then
			return
		end

		if var2_10 ~= 1 or #var0_10 == 1 then
			return
		end

		local var0_13 = "NG0045"

		if pg.NewStoryMgr.GetInstance():IsPlayed(var0_13) then
			return
		end

		pg.SystemGuideMgr.GetInstance():PlayByGuideId(var0_13)
	end)()
end

return var0_0
