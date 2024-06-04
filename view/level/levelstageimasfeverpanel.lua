local var0 = class("LevelStageIMasFeverPanel", import("view.base.BaseSubPanel"))

function var0.getUIName(arg0)
	return "LevelStageIMasFeverPanel"
end

function var0.OnInit(arg0)
	arg0.fillImg = arg0._tf:Find("Fill")
	arg0.banner = arg0._tf:Find("Banner")

	setActive(arg0.banner, false)
end

local var1 = {
	[0] = 0,
	0.38,
	0.5471839,
	0.7228736,
	1
}
local var2 = {
	"Yellow",
	"Red",
	"Blue"
}

function var0.UpdateView(arg0, arg1, arg2)
	local var0 = getProxy(ChapterProxy):GetLastDefeatedEnemy(arg1.id)
	local var1 = arg1.defeatEnemies
	local var2 = pg.gameset.doa_fever_count.key_value
	local var3 = var1[Mathf.Min(var2, var1)]

	seriesAsync({
		function(arg0)
			LeanTween.cancel(go(arg0.fillImg))

			if not var0 or var1 > var2 then
				arg0()

				return
			end

			local var0 = math.max(var1 - 1, 0)
			local var1 = arg0.fillImg:GetComponent(typeof(Image))
			local var2 = var1[var0]

			LeanTween.value(go(arg0.fillImg), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0)
				local var0 = Mathf.Lerp(var2, var3, arg0)

				var1.fillAmount = var0
			end)):setOnComplete(System.Action(arg0))
		end,
		function(arg0)
			arg0.fillImg:GetComponent(typeof(Image)).fillAmount = var3

			if var0 and var1 == var2 then
				arg0:ShowPanel(arg1)
			end

			existCall(arg2)
		end
	})
end

function var0.ShowPanel(arg0, arg1)
	arg0.viewParent:emit(LevelUIConst.FROZEN)
	pg.UIMgr.GetInstance():OverlayPanel(arg0.banner)

	local var0 = var2[1]
	local var1 = arg1:GetBuffOfLinkAct()

	if var1 then
		local var2 = pg.gameset.doa_fever_buff.description

		var0 = var2[table.indexof(var2, var1)]
	end

	local var3 = arg0.banner:Find(var0)
	local var4 = var3:Find("Character")
	local var5 = var4:GetComponent(typeof(Image))
	local var6 = math.random(1, 7)

	setImageSprite(var4, LoadSprite("ui/LevelStageIMasFeverPanel_atlas", "character" .. tostring(var6)))
	setActive(arg0.banner, true)
	setActive(var3, true)

	var5.enabled = true

	local function var7()
		arg0:ClosePanel()
	end

	var3:GetComponent(typeof(DftAniEvent)):SetEndEvent(var7)
	onButton(arg0, arg0.banner, var7)

	arg0.showingPanel = true
end

function var0.ClosePanel(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.banner, arg0._tf)
	setActive(arg0.banner, false)
	arg0.viewParent:emit(LevelUIConst.UN_FROZEN)

	arg0.showingPanel = nil
end

function var0.OnDestroy(arg0)
	if arg0.showingPanel then
		arg0:ClosePanel()
	end
end

return var0
