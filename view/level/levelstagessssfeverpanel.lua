local var0_0 = class("LevelStageSSSSFeverPanel", import("view.base.BaseSubPanel"))

function var0_0.getUIName(arg0_1)
	return "LevelStageSSSSFeverPanel"
end

var0_0.stepCount = 10
var0_0.enemyCount = 4

local var1_0 = {
	liuhua = {
		9401,
		9403,
		9406,
		9409,
		9412,
		9415
	},
	mengya = {
		9421,
		9423,
		9426,
		9429,
		9432,
		9435
	},
	qianlai = {
		9441,
		9443,
		9446,
		9449,
		9452,
		9455
	}
}
local var2_0 = {
	qian = {
		9461,
		9463,
		9466,
		9469,
		9472,
		9475
	},
	he = {
		9481,
		9483,
		9486,
		9489,
		9492,
		9495
	}
}

function var0_0.OnInit(arg0_2)
	arg0_2.barGroup1 = arg0_2:GetBarTFGroup(arg0_2._tf:Find("Bar1"))
	arg0_2.barGroup2 = arg0_2:GetBarTFGroup(arg0_2._tf:Find("Bar2"))
	arg0_2.banner = arg0_2._tf:Find("Banner")

	setActive(arg0_2.banner, false)

	arg0_2.buff2Character = {}

	for iter0_2, iter1_2 in pairs(var1_0) do
		for iter2_2, iter3_2 in ipairs(iter1_2) do
			arg0_2.buff2Character[iter3_2] = iter0_2
		end
	end

	arg0_2.buff2Enemy = {}

	for iter4_2, iter5_2 in pairs(var2_0) do
		for iter6_2, iter7_2 in ipairs(iter5_2) do
			arg0_2.buff2Enemy[iter7_2] = iter4_2
		end
	end

	arg0_2.loader = AutoLoader.New()
	arg0_2.animations = AsyncExcutionRequestPackage.New({})
	arg0_2.PanelAnimations = AsyncExcutionRequestPackage.New({})
	arg0_2.cleanActions = {}
end

function var0_0.GetIcon(arg0_3, arg1_3, arg2_3)
	local var0_3 = arg1_3.buff_list
	local var1_3 = arg2_3 and arg0_3.buff2Character or arg0_3.buff2Enemy

	for iter0_3, iter1_3 in ipairs(var0_3) do
		if var1_3[iter1_3] then
			return var1_3[iter1_3]
		end
	end

	return ""
end

function var0_0.GetBarTFGroup(arg0_4, arg1_4)
	return {
		main = arg1_4,
		fillImg = arg1_4:Find("Fill"),
		ratioText = arg1_4:Find("Text"),
		iconImg = arg1_4:Find("Icon")
	}
end

local var3_0 = {
	1590001,
	1590051
}

function var0_0.UpdateView(arg0_5, arg1_5, arg2_5)
	if table.contains(var3_0, arg1_5.id) then
		arg0_5:Hide()
		existCall(arg2_5)

		return
	end

	arg0_5:UpdateKaijuBar(arg1_5)
	arg0_5:UpdateSyberSquadBar(arg1_5)
	arg0_5.animations:Resume()
	arg0_5.PanelAnimations:Insert(function(arg0_6)
		existCall(arg2_5)
		arg0_6()
	end)
	arg0_5.PanelAnimations:Resume()
end

function var0_0.UpdateKaijuBar(arg0_7, arg1_7)
	local var0_7 = getProxy(ChapterProxy):GetExtendChapterData(arg1_7.id, "FleetMoveDistance")
	local var1_7 = arg1_7.moveStep
	local var2_7 = arg1_7:isLoop() and 0 or var0_0.stepCount
	local var3_7 = math.min(var1_7 / var2_7, 1)
	local var4_7 = arg0_7.barGroup1.fillImg
	local var5_7 = var4_7:GetComponent(typeof(Image))
	local var6_7 = arg0_7.barGroup1.ratioText

	if var0_7 and var1_7 <= var2_7 then
		arg0_7.animations:Insert(function(arg0_8)
			local var0_8 = var1_7 - var0_7
			local var1_8 = var0_8 / var2_7
			local var2_8 = math.min(var0_7, var2_7 - var0_8)

			LeanTween.value(go(var4_7), 0, 1, var2_8):setOnUpdate(System.Action_float(function(arg0_9)
				local var0_9 = Mathf.Lerp(var1_8, var3_7, arg0_9)

				var5_7.fillAmount = var0_9

				setText(var6_7, string.format("%02d%%", math.floor(var0_9 * 100)))
			end)):setOnComplete(System.Action(arg0_8))
		end)
	end

	local var7_7 = arg0_7:GetIcon(arg1_7, false)

	arg0_7.animations:Insert(function(arg0_10)
		var5_7.fillAmount = var3_7

		setText(var6_7, string.format("%02d%%", math.floor(var3_7 * 100)))

		if var3_7 >= 1 then
			arg0_7.loader:GetSpriteQuiet("ui/LevelStageSSSSFeverPanel_atlas", "icon_" .. var7_7, arg0_7.barGroup1.iconImg, true)
		end

		arg0_10()
	end)

	if var0_7 and var2_7 > var1_7 - var0_7 and var2_7 <= var1_7 then
		arg0_7.PanelAnimations:Insert(function(arg0_11)
			arg0_7:ShowPanel(var7_7, "Kaiju", arg0_11, var7_7 == "he" and "" or "2")
		end)
	end
end

function var0_0.UpdateSyberSquadBar(arg0_12, arg1_12)
	local var0_12 = getProxy(ChapterProxy):GetLastDefeatedEnemy(arg1_12.id)
	local var1_12 = arg1_12.defeatEnemies
	local var2_12 = arg1_12:isLoop() and 0 or var0_0.enemyCount
	local var3_12 = math.min(var1_12 / var2_12, 1)
	local var4_12 = arg0_12.barGroup2.fillImg
	local var5_12 = var4_12:GetComponent(typeof(Image))
	local var6_12 = arg0_12.barGroup2.ratioText

	if var0_12 and var1_12 <= var2_12 then
		arg0_12.animations:Insert(function(arg0_13)
			local var0_13 = math.max(var1_12 - 1, 0) / var2_12

			LeanTween.value(go(var4_12), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0_14)
				local var0_14 = Mathf.Lerp(var0_13, var3_12, arg0_14)

				var5_12.fillAmount = var0_14

				setText(var6_12, string.format("%02d%%", math.floor(var0_14 * 100)))
			end)):setOnComplete(System.Action(arg0_13))
		end)
	end

	local var7_12 = arg0_12:GetIcon(arg1_12, true)

	arg0_12.animations:Insert(function(arg0_15)
		var5_12.fillAmount = var3_12

		setText(var6_12, string.format("%02d%%", math.floor(var3_12 * 100)))

		if var3_12 >= 1 then
			arg0_12.loader:GetSpriteQuiet("ui/LevelStageSSSSFeverPanel_atlas", "icon_" .. var7_12, arg0_12.barGroup2.iconImg, true)
		end

		arg0_15()
	end)

	if var0_12 and var1_12 == var2_12 then
		arg0_12.PanelAnimations:Insert(function(arg0_16)
			arg0_12:ShowPanel(var7_12, "SyberSquad", arg0_16)
		end)
	end
end

function var0_0.ShowPanel(arg0_17, arg1_17, arg2_17, arg3_17, arg4_17)
	arg0_17:emit(LevelUIConst.FROZEN)
	pg.UIMgr.GetInstance():BlurPanel(arg0_17.banner)

	local var0_17 = arg0_17.banner:Find(arg2_17)
	local var1_17 = var0_17:Find("Character")
	local var2_17 = var1_17:GetComponent(typeof(Image))

	arg0_17.loader:GetSpriteQuiet("ui/LevelStageSSSSFeverPanel_atlas", arg1_17, var1_17, true)
	setActive(arg0_17.banner, true)
	setAnchoredPosition(var0_17, {
		x = 2436
	})
	setActive(var0_17, true)

	var2_17.enabled = true

	if arg4_17 ~= nil then
		setActive(var0_17:Find("Word"), false)
		setActive(var0_17:Find("Word2"), false)
		setActive(var0_17:Find("Word" .. arg4_17), true)
	end

	local var3_17 = var0_17:GetComponent(typeof(DftAniEvent))
	local var4_17

	local function var5_17()
		table.removebyvalue(arg0_17.cleanActions, var5_17)
		var3_17:SetEndEvent(nil)

		var2_17.enabled = false
		var2_17.sprite = nil

		pg.UIMgr.GetInstance():UnblurPanel(arg0_17.banner, arg0_17._tf)
		setActive(arg0_17.banner, false)
		setActive(var0_17, false)
		arg0_17:emit(LevelUIConst.UN_FROZEN)
	end

	local function var6_17()
		var5_17()
		existCall(arg3_17)
	end

	var3_17:SetEndEvent(var6_17)
	onButton(arg0_17, arg0_17.banner, var6_17)
	table.insert(arg0_17.cleanActions, var5_17)
end

function var0_0.CloseActions(arg0_20)
	if arg0_20.animations and not arg0_20.animations.stopped then
		arg0_20.animations:Stop()
	end

	arg0_20.animations = nil

	if arg0_20.PanelAnimations and not arg0_20.PanelAnimations.stopped then
		arg0_20.PanelAnimations:Stop()
	end

	arg0_20.PanelAnimations = nil

	if arg0_20.cleanActions then
		_.each(arg0_20.cleanActions, function(arg0_21)
			arg0_21()
		end)
	end

	arg0_20.cleanActions = nil

	arg0_20.loader:ClearRequests()
end

function var0_0.OnHide(arg0_22)
	arg0_22:CloseActions()
end

return var0_0
