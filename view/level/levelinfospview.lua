local var0_0 = class("LevelInfoSPView", import(".LevelInfoView"))

function var0_0.getUIName(arg0_1)
	return "LevelInfoSPUI"
end

function var0_0.InitUI(arg0_2)
	var0_0.super.InitUI(arg0_2)

	arg0_2.levelBanner = arg0_2._tf:Find("panel/Level")
	arg0_2.btnSwitchNormal = arg0_2._tf:Find("panel/Difficulty/Normal")
	arg0_2.btnSwitchHard = arg0_2._tf:Find("panel/Difficulty/Hard")
	arg0_2.tfAnim = arg0_2._tf:GetComponent(typeof(Animation))
	arg0_2.tfAniEvent = arg0_2._tf:GetComponent(typeof(DftAniEvent))

	arg0_2.tfAniEvent:SetEndEvent(function()
		arg0_2:playSelectFX()
	end)

	arg0_2.diffBtn = arg0_2._tf:Find("panel/Difficulty")
	arg0_2.btnAnim = arg0_2._tf:Find("panel/Difficulty"):GetComponent(typeof(Animation))
	arg0_2.btnAniEvent = arg0_2._tf:Find("panel/Difficulty"):GetComponent(typeof(DftAniEvent))

	arg0_2.btnAniEvent:SetEndEvent(function()
		arg0_2:playButtonLoopFX()
	end)

	arg0_2.btnAnimNormal = arg0_2._tf:Find("panel/Difficulty/Mask_Normal")
	arg0_2.btnAnimHard = arg0_2._tf:Find("panel/Difficulty/Mask_Difficlty")
	arg0_2.btnAnimLoopNormal = arg0_2._tf:Find("panel/Difficulty/Normal/Mask_Normal_Loop/Image")
	arg0_2.btnAnimLoopHard = arg0_2._tf:Find("panel/Difficulty/Hard/Mask_Difficulty_Loop")
	arg0_2.doEaseIn = false
end

function var0_0.playSelectFX(arg0_5)
	local var0_5 = 1

	if #arg0_5.groupInfo > 1 then
		var0_5 = table.indexof(arg0_5.groupInfo, arg0_5.chapter.id)
	elseif arg0_5.chapter:IsSpChapter() or arg0_5.chapter:IsEXChapter() then
		var0_5 = 2
	end

	if #arg0_5.groupInfo > 1 then
		if var0_5 == 2 then
			setActive(arg0_5.btnAnimNormal, false)
			setActive(arg0_5.btnAnimLoopNormal, false)
			quickPlayAnimation(arg0_5.diffBtn, "Anim_LevelInfoSPUI_DifficultySelected")
		else
			setActive(arg0_5.btnAnimHard, false)
			setActive(arg0_5.btnAnimLoopHard, false)
			quickPlayAnimation(arg0_5.diffBtn, "Anim_LevelInfoSPUI_NormalSelected")
		end
	end
end

function var0_0.playButtonLoopFX(arg0_6)
	if arg0_6.btnAnim:IsPlaying("Anim_LevelInfoSPUI_DifficultySelected") then
		quickPlayAnimation(arg0_6.diffBtn, "Anim_LevelInfoSPUI_DifficultyInLoop")
	elseif arg0_6.btnAnim:IsPlaying("Anim_LevelInfoSPUI_NormalSelected") then
		quickPlayAnimation(arg0_6.diffBtn, "Anim_LevelInfoSPUI_NormalInLoop")
	end
end

function var0_0.SetChapterGroupInfo(arg0_7, arg1_7)
	arg0_7.groupInfo = arg1_7
end

function var0_0.Show(arg0_8)
	pg.UIMgr.GetInstance():BlurPanel(arg0_8._tf, nil, {
		force = true
	})
	setActive(arg0_8._tf, true)
	quickPlayAnimation(arg0_8._tf, "Anim_LevelInfoSPUI_in")
end

function var0_0.set(arg0_9, arg1_9, arg2_9)
	var0_0.super.set(arg0_9, arg1_9, arg2_9)

	local var0_9 = getProxy(ChapterProxy):getChapterById(arg1_9, true)
	local var1_9 = arg0_9.groupInfo

	assert(var1_9)

	local var2_9 = {
		"Normal",
		"Hard"
	}
	local var3_9 = 1
	local var4_9

	if #var1_9 > 1 then
		local var5_9 = table.indexof(var1_9, arg1_9)

		var3_9 = var5_9
		var4_9 = var1_9[#var1_9 - var5_9 + 1]
	elseif var0_9:IsSpChapter() or var0_9:IsEXChapter() then
		var3_9 = 2
	end

	for iter0_9, iter1_9 in ipairs(var2_9) do
		setActive(arg0_9.titleBG:Find(iter1_9), iter0_9 == var3_9)
	end

	for iter2_9, iter3_9 in ipairs(var2_9) do
		setActive(arg0_9.levelBanner:Find(iter3_9), iter2_9 == var3_9)
	end

	setActive(arg0_9.btnSwitchNormal, #var1_9 > 1 and var3_9 == 1)
	setActive(arg0_9.btnSwitchHard, #var1_9 > 1 and var3_9 == 2)

	if #var1_9 > 1 then
		local var6_9 = var3_9 == 1 and arg0_9.btnSwitchNormal or arg0_9.btnSwitchHard

		for iter4_9 = 1, 2 do
			local var7_9 = var6_9:Find("Bonus" .. iter4_9)
			local var8_9 = getProxy(ChapterProxy):getChapterById(var1_9[iter4_9], true)
			local var9_9 = var8_9:GetDailyBonusQuota()

			setActive(var7_9, var9_9)

			if var9_9 then
				local var10_9 = getProxy(ChapterProxy):getMapById(var8_9:getConfig("map")):getConfig("type") == Map.ACTIVITY_HARD and "bonus_us_hard" or "bonus_us"

				arg0_9.loader:GetSprite("ui/levelmainscene_atlas", var10_9, var7_9:Find("Image"))
			end
		end
	end

	local var11_9 = var3_9 == 1 and Color.NewHex("FFDE38") or Color.white

	setTextColor(arg0_9:findTF("title_index", arg0_9.txTitle), var11_9)
	setTextColor(arg0_9:findTF("title", arg0_9.txTitle), var11_9)
	setTextColor(arg0_9:findTF("title_en", arg0_9.txTitle), var11_9)

	local var12_9 = var0_9:getConfig("boss_expedition_id")

	if var0_9:getPlayType() == ChapterConst.TypeMultiStageBoss then
		var12_9 = pg.chapter_model_multistageboss[var0_9.id].boss_expedition_id
	end

	local var13_9 = pg.expedition_data_template[var12_9[#var12_9]].level

	setText(arg0_9.levelBanner:Find("Text"), "LV " .. var13_9)
	onButton(arg0_9, arg0_9.btnSwitchNormal:Find("Switch"), function()
		setActive(arg0_9.btnAnimNormal, false)
		setActive(arg0_9.btnAnimLoopNormal, false)
		quickPlayAnimation(arg0_9.diffBtn, "Anim_LevelInfoSPUI_DifficultySelected")
		arg0_9:emit(LevelUIConst.SWITCH_SPCHAPTER_DIFFICULTY, var4_9)
		arg0_9:set(var4_9)
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.btnSwitchHard:Find("Switch"), function()
		setActive(arg0_9.btnAnimHard, false)
		setActive(arg0_9.btnAnimLoopHard, false)
		quickPlayAnimation(arg0_9.diffBtn, "Anim_LevelInfoSPUI_NormalSelected")
		arg0_9:emit(LevelUIConst.SWITCH_SPCHAPTER_DIFFICULTY, var4_9)
		arg0_9:set(var4_9)
	end, SFX_PANEL)
	;(function()
		if IsUnityEditor and not ENABLE_GUIDE then
			return
		end

		if var3_9 ~= 1 or #var1_9 == 1 then
			return
		end

		local var0_12 = "NG0045"

		if pg.NewStoryMgr.GetInstance():IsPlayed(var0_12) then
			return
		end

		pg.SystemGuideMgr.GetInstance():PlayByGuideId(var0_12)
	end)()
end

return var0_0
