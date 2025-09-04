local var0_0 = class("LevelInfoSPView", import(".LevelInfoView"))

function var0_0.getUIName(arg0_1)
	return "LevelInfoSPUI"
end

function var0_0.InitUI(arg0_2)
	var0_0.super.InitUI(arg0_2)

	arg0_2.levelBanner = arg0_2._tf:Find("panel/Level")
	arg0_2.btnSwitchNormal = arg0_2._tf:Find("panel/Difficulty/Normal")
	arg0_2.btnSwitchHard = arg0_2._tf:Find("panel/Difficulty/Hard")
	arg0_2.btnAnim = arg0_2._tf:GetComponent(typeof(Animation))
	arg0_2.btnAniEvent = arg0_2._tf:GetComponent(typeof(DftAniEvent))

	arg0_2.btnAniEvent:SetEndEvent(function()
		arg0_2:playButtonLoopFX()
	end)
end

function var0_0.playButtonLoopFX(arg0_4)
	if arg0_4.btnAnim:IsPlaying("Anim_LevelInfoSPUI_NormalSelected") then
		arg0_4.btnAnim:Play("Anim_LevelInfoSPUI_NormalInLoop")
	else
		arg0_4.btnAnim:Play("Anim_LevelInfoSPUI_DifficultyInLoop")
	end
end

function var0_0.SetChapterGroupInfo(arg0_5, arg1_5)
	arg0_5.groupInfo = arg1_5
end

function var0_0.set(arg0_6, arg1_6, arg2_6)
	var0_0.super.set(arg0_6, arg1_6, arg2_6)

	local var0_6 = getProxy(ChapterProxy):getChapterById(arg1_6, true)
	local var1_6 = arg0_6.groupInfo

	assert(var1_6)

	local var2_6 = {
		"Normal",
		"Hard"
	}
	local var3_6 = 1
	local var4_6

	if #var1_6 > 1 then
		local var5_6 = table.indexof(var1_6, arg1_6)

		var3_6 = var5_6
		var4_6 = var1_6[#var1_6 - var5_6 + 1]
	elseif var0_6:IsSpChapter() or var0_6:IsEXChapter() then
		var3_6 = 2
	end

	for iter0_6, iter1_6 in ipairs(var2_6) do
		setActive(arg0_6.titleBG:Find(iter1_6), iter0_6 == var3_6)
	end

	for iter2_6, iter3_6 in ipairs(var2_6) do
		setActive(arg0_6.levelBanner:Find(iter3_6), iter2_6 == var3_6)
	end

	if #var1_6 > 1 then
		setActive(arg0_6.btnSwitchNormal, var3_6 == 1)
		setActive(arg0_6.btnSwitchHard, var3_6 == 2)

		local var6_6 = var3_6 == 1 and "Normal" or "Difficulty"
		local var7_6 = "Anim_LevelInfoSPUI_" .. var6_6 .. "Selected"

		arg0_6.btnAnim:Play(var7_6)
	else
		setActive(arg0_6.btnSwitchNormal, false)
		setActive(arg0_6.btnSwitchNormal, false)
	end

	if #var1_6 > 1 then
		local var8_6 = var3_6 == 1 and arg0_6.btnSwitchNormal or arg0_6.btnSwitchHard

		for iter4_6 = 1, 2 do
			local var9_6 = var8_6:Find("Bonus" .. iter4_6)
			local var10_6 = getProxy(ChapterProxy):getChapterById(var1_6[iter4_6], true)
			local var11_6 = var10_6:GetDailyBonusQuota()

			setActive(var9_6, var11_6)

			if var11_6 then
				local var12_6 = getProxy(ChapterProxy):getMapById(var10_6:getConfig("map")):getConfig("type") == Map.ACTIVITY_HARD and "bonus_us_hard" or "bonus_us"

				arg0_6.loader:GetSprite("ui/levelmainscene_atlas", var12_6, var9_6:Find("Image"))
			end
		end
	end

	local var13_6 = var3_6 == 1 and Color.NewHex("FFDE38") or Color.white

	setTextColor(arg0_6:findTF("title_index", arg0_6.txTitle), var13_6)
	setTextColor(arg0_6:findTF("title", arg0_6.txTitle), var13_6)
	setTextColor(arg0_6:findTF("title_en", arg0_6.txTitle), var13_6)

	local var14_6 = var0_6:getConfig("boss_expedition_id")

	if var0_6:getPlayType() == ChapterConst.TypeMultiStageBoss then
		var14_6 = pg.chapter_model_multistageboss[var0_6.id].boss_expedition_id
	end

	local var15_6 = pg.expedition_data_template[var14_6[#var14_6]].level

	setText(arg0_6.levelBanner:Find("Text"), "LV " .. var15_6)
	onButton(arg0_6, arg0_6.btnSwitchNormal:Find("Switch"), function()
		arg0_6:emit(LevelUIConst.SWITCH_SPCHAPTER_DIFFICULTY, var4_6)
		arg0_6:set(var4_6)
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.btnSwitchHard:Find("Switch"), function()
		arg0_6:emit(LevelUIConst.SWITCH_SPCHAPTER_DIFFICULTY, var4_6)
		arg0_6:set(var4_6)
	end, SFX_PANEL)
	;(function()
		if IsUnityEditor and not ENABLE_GUIDE then
			return
		end

		if var3_6 ~= 1 or #var1_6 == 1 then
			return
		end

		local var0_9 = "NG0045"

		if pg.NewStoryMgr.GetInstance():IsPlayed(var0_9) then
			return
		end

		pg.SystemGuideMgr.GetInstance():PlayByGuideId(var0_9)
	end)()
end

return var0_0
