local var0_0 = class("LevelInfoSPView", import(".LevelInfoView"))

function var0_0.getUIName(arg0_1)
	return "LevelInfoSPUI"
end

function var0_0.InitUI(arg0_2)
	var0_0.super.InitUI(arg0_2)

	arg0_2.levelBanner = arg0_2._tf:Find("panel/Level")
	arg0_2.btnSwitchNormal = arg0_2._tf:Find("panel/Difficulty/Normal")
	arg0_2.btnSwitchHard = arg0_2._tf:Find("panel/Difficulty/Hard")
end

function var0_0.SetChapterGroupInfo(arg0_3, arg1_3)
	arg0_3.groupInfo = arg1_3
end

function var0_0.set(arg0_4, arg1_4, arg2_4)
	var0_0.super.set(arg0_4, arg1_4, arg2_4)

	local var0_4 = getProxy(ChapterProxy):getChapterById(arg1_4, true)
	local var1_4 = arg0_4.groupInfo

	assert(var1_4)

	local var2_4 = {
		"Normal",
		"Hard"
	}
	local var3_4 = 1
	local var4_4

	if #var1_4 > 1 then
		local var5_4 = table.indexof(var1_4, arg1_4)

		var3_4 = var5_4
		var4_4 = var1_4[#var1_4 - var5_4 + 1]
	elseif var0_4:IsSpChapter() or var0_4:IsEXChapter() then
		var3_4 = 2
	end

	for iter0_4, iter1_4 in ipairs(var2_4) do
		setActive(arg0_4.titleBG:Find(iter1_4), iter0_4 == var3_4)
	end

	for iter2_4, iter3_4 in ipairs(var2_4) do
		setActive(arg0_4.levelBanner:Find(iter3_4), iter2_4 == var3_4)
	end

	setActive(arg0_4.btnSwitchNormal, #var1_4 > 1 and var3_4 == 1)
	setActive(arg0_4.btnSwitchHard, #var1_4 > 1 and var3_4 == 2)

	if #var1_4 > 1 then
		local var6_4 = var3_4 == 1 and arg0_4.btnSwitchNormal or arg0_4.btnSwitchHard

		for iter4_4 = 1, 2 do
			local var7_4 = var6_4:Find("Bonus" .. iter4_4)
			local var8_4 = getProxy(ChapterProxy):getChapterById(var1_4[iter4_4], true)
			local var9_4 = var8_4:GetDailyBonusQuota()

			setActive(var7_4, var9_4)

			if var9_4 then
				local var10_4 = getProxy(ChapterProxy):getMapById(var8_4:getConfig("map")):getConfig("type") == Map.ACTIVITY_HARD and "bonus_us_hard" or "bonus_us"

				arg0_4.loader:GetSprite("ui/levelmainscene_atlas", var10_4, var7_4:Find("Image"))
			end
		end
	end

	local var11_4 = var3_4 == 1 and Color.NewHex("FFDE38") or Color.white

	setTextColor(arg0_4:findTF("title_index", arg0_4.txTitle), var11_4)
	setTextColor(arg0_4:findTF("title", arg0_4.txTitle), var11_4)
	setTextColor(arg0_4:findTF("title_en", arg0_4.txTitle), var11_4)

	local var12_4 = var0_4:getConfig("boss_expedition_id")

	if var0_4:getPlayType() == ChapterConst.TypeMultiStageBoss then
		var12_4 = pg.chapter_model_multistageboss[var0_4.id].boss_expedition_id
	end

	local var13_4 = pg.expedition_data_template[var12_4[#var12_4]].level

	setText(arg0_4.levelBanner:Find("Text"), "LV " .. var13_4)
	onButton(arg0_4, arg0_4.btnSwitchNormal:Find("Switch"), function()
		arg0_4:emit(LevelUIConst.SWITCH_SPCHAPTER_DIFFICULTY, var4_4)
		arg0_4:set(var4_4)
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.btnSwitchHard:Find("Switch"), function()
		arg0_4:emit(LevelUIConst.SWITCH_SPCHAPTER_DIFFICULTY, var4_4)
		arg0_4:set(var4_4)
	end, SFX_PANEL)
	;(function()
		if IsUnityEditor and not ENABLE_GUIDE then
			return
		end

		if var3_4 ~= 1 or #var1_4 == 1 then
			return
		end

		local var0_7 = "NG0045"

		if pg.NewStoryMgr.GetInstance():IsPlayed(var0_7) then
			return
		end

		pg.SystemGuideMgr.GetInstance():PlayByGuideId(var0_7)
	end)()
end

return var0_0
