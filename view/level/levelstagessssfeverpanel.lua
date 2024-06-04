local var0 = class("LevelStageSSSSFeverPanel", import("view.base.BaseSubPanel"))

function var0.getUIName(arg0)
	return "LevelStageSSSSFeverPanel"
end

var0.stepCount = 10
var0.enemyCount = 4

local var1 = {
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
local var2 = {
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

function var0.OnInit(arg0)
	arg0.barGroup1 = arg0:GetBarTFGroup(arg0._tf:Find("Bar1"))
	arg0.barGroup2 = arg0:GetBarTFGroup(arg0._tf:Find("Bar2"))
	arg0.banner = arg0._tf:Find("Banner")

	setActive(arg0.banner, false)

	arg0.buff2Character = {}

	for iter0, iter1 in pairs(var1) do
		for iter2, iter3 in ipairs(iter1) do
			arg0.buff2Character[iter3] = iter0
		end
	end

	arg0.buff2Enemy = {}

	for iter4, iter5 in pairs(var2) do
		for iter6, iter7 in ipairs(iter5) do
			arg0.buff2Enemy[iter7] = iter4
		end
	end

	arg0.loader = AutoLoader.New()
	arg0.animations = AsyncExcutionRequestPackage.New({})
	arg0.PanelAnimations = AsyncExcutionRequestPackage.New({})
	arg0.cleanActions = {}
end

function var0.GetIcon(arg0, arg1, arg2)
	local var0 = arg1.buff_list
	local var1 = arg2 and arg0.buff2Character or arg0.buff2Enemy

	for iter0, iter1 in ipairs(var0) do
		if var1[iter1] then
			return var1[iter1]
		end
	end

	return ""
end

function var0.GetBarTFGroup(arg0, arg1)
	return {
		main = arg1,
		fillImg = arg1:Find("Fill"),
		ratioText = arg1:Find("Text"),
		iconImg = arg1:Find("Icon")
	}
end

local var3 = {
	1590001,
	1590051
}

function var0.UpdateView(arg0, arg1, arg2)
	if table.contains(var3, arg1.id) then
		arg0:Hide()
		existCall(arg2)

		return
	end

	arg0:UpdateKaijuBar(arg1)
	arg0:UpdateSyberSquadBar(arg1)
	arg0.animations:Resume()
	arg0.PanelAnimations:Insert(function(arg0)
		existCall(arg2)
		arg0()
	end)
	arg0.PanelAnimations:Resume()
end

function var0.UpdateKaijuBar(arg0, arg1)
	local var0 = getProxy(ChapterProxy):GetExtendChapterData(arg1.id, "FleetMoveDistance")
	local var1 = arg1.moveStep
	local var2 = arg1:isLoop() and 0 or var0.stepCount
	local var3 = math.min(var1 / var2, 1)
	local var4 = arg0.barGroup1.fillImg
	local var5 = var4:GetComponent(typeof(Image))
	local var6 = arg0.barGroup1.ratioText

	if var0 and var1 <= var2 then
		arg0.animations:Insert(function(arg0)
			local var0 = var1 - var0
			local var1 = var0 / var2
			local var2 = math.min(var0, var2 - var0)

			LeanTween.value(go(var4), 0, 1, var2):setOnUpdate(System.Action_float(function(arg0)
				local var0 = Mathf.Lerp(var1, var3, arg0)

				var5.fillAmount = var0

				setText(var6, string.format("%02d%%", math.floor(var0 * 100)))
			end)):setOnComplete(System.Action(arg0))
		end)
	end

	local var7 = arg0:GetIcon(arg1, false)

	arg0.animations:Insert(function(arg0)
		var5.fillAmount = var3

		setText(var6, string.format("%02d%%", math.floor(var3 * 100)))

		if var3 >= 1 then
			arg0.loader:GetSpriteQuiet("ui/LevelStageSSSSFeverPanel_atlas", "icon_" .. var7, arg0.barGroup1.iconImg, true)
		end

		arg0()
	end)

	if var0 and var2 > var1 - var0 and var2 <= var1 then
		arg0.PanelAnimations:Insert(function(arg0)
			arg0:ShowPanel(var7, "Kaiju", arg0, var7 == "he" and "" or "2")
		end)
	end
end

function var0.UpdateSyberSquadBar(arg0, arg1)
	local var0 = getProxy(ChapterProxy):GetLastDefeatedEnemy(arg1.id)
	local var1 = arg1.defeatEnemies
	local var2 = arg1:isLoop() and 0 or var0.enemyCount
	local var3 = math.min(var1 / var2, 1)
	local var4 = arg0.barGroup2.fillImg
	local var5 = var4:GetComponent(typeof(Image))
	local var6 = arg0.barGroup2.ratioText

	if var0 and var1 <= var2 then
		arg0.animations:Insert(function(arg0)
			local var0 = math.max(var1 - 1, 0) / var2

			LeanTween.value(go(var4), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0)
				local var0 = Mathf.Lerp(var0, var3, arg0)

				var5.fillAmount = var0

				setText(var6, string.format("%02d%%", math.floor(var0 * 100)))
			end)):setOnComplete(System.Action(arg0))
		end)
	end

	local var7 = arg0:GetIcon(arg1, true)

	arg0.animations:Insert(function(arg0)
		var5.fillAmount = var3

		setText(var6, string.format("%02d%%", math.floor(var3 * 100)))

		if var3 >= 1 then
			arg0.loader:GetSpriteQuiet("ui/LevelStageSSSSFeverPanel_atlas", "icon_" .. var7, arg0.barGroup2.iconImg, true)
		end

		arg0()
	end)

	if var0 and var1 == var2 then
		arg0.PanelAnimations:Insert(function(arg0)
			arg0:ShowPanel(var7, "SyberSquad", arg0)
		end)
	end
end

function var0.ShowPanel(arg0, arg1, arg2, arg3, arg4)
	arg0:emit(LevelUIConst.FROZEN)
	pg.UIMgr.GetInstance():BlurPanel(arg0.banner)

	local var0 = arg0.banner:Find(arg2)
	local var1 = var0:Find("Character")
	local var2 = var1:GetComponent(typeof(Image))

	arg0.loader:GetSpriteQuiet("ui/LevelStageSSSSFeverPanel_atlas", arg1, var1, true)
	setActive(arg0.banner, true)
	setAnchoredPosition(var0, {
		x = 2436
	})
	setActive(var0, true)

	var2.enabled = true

	if arg4 ~= nil then
		setActive(var0:Find("Word"), false)
		setActive(var0:Find("Word2"), false)
		setActive(var0:Find("Word" .. arg4), true)
	end

	local var3 = var0:GetComponent(typeof(DftAniEvent))
	local var4

	local function var5()
		table.removebyvalue(arg0.cleanActions, var5)
		var3:SetEndEvent(nil)

		var2.enabled = false
		var2.sprite = nil

		pg.UIMgr.GetInstance():UnblurPanel(arg0.banner, arg0._tf)
		setActive(arg0.banner, false)
		setActive(var0, false)
		arg0:emit(LevelUIConst.UN_FROZEN)
	end

	local function var6()
		var5()
		existCall(arg3)
	end

	var3:SetEndEvent(var6)
	onButton(arg0, arg0.banner, var6)
	table.insert(arg0.cleanActions, var5)
end

function var0.CloseActions(arg0)
	if arg0.animations and not arg0.animations.stopped then
		arg0.animations:Stop()
	end

	arg0.animations = nil

	if arg0.PanelAnimations and not arg0.PanelAnimations.stopped then
		arg0.PanelAnimations:Stop()
	end

	arg0.PanelAnimations = nil

	if arg0.cleanActions then
		_.each(arg0.cleanActions, function(arg0)
			arg0()
		end)
	end

	arg0.cleanActions = nil

	arg0.loader:ClearRequests()
end

function var0.OnHide(arg0)
	arg0:CloseActions()
end

return var0
