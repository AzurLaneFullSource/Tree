local var0_0 = class("LevelStageIMasFeverPanel", import("view.base.BaseSubPanel"))

function var0_0.getUIName(arg0_1)
	return "LevelStageIMasFeverPanel"
end

function var0_0.OnInit(arg0_2)
	arg0_2.fillImg = arg0_2._tf:Find("Fill")
	arg0_2.banner = arg0_2._tf:Find("Banner")

	setActive(arg0_2.banner, false)
end

local var1_0 = {
	[0] = 0,
	0.38,
	0.5471839,
	0.7228736,
	1
}
local var2_0 = {
	"Yellow",
	"Red",
	"Blue"
}

function var0_0.UpdateView(arg0_3, arg1_3, arg2_3)
	local var0_3 = getProxy(ChapterProxy):GetLastDefeatedEnemy(arg1_3.id)
	local var1_3 = arg1_3.defeatEnemies
	local var2_3 = pg.gameset.doa_fever_count.key_value
	local var3_3 = var1_0[Mathf.Min(var2_3, var1_3)]

	seriesAsync({
		function(arg0_4)
			LeanTween.cancel(go(arg0_3.fillImg))

			if not var0_3 or var1_3 > var2_3 then
				arg0_4()

				return
			end

			local var0_4 = math.max(var1_3 - 1, 0)
			local var1_4 = arg0_3.fillImg:GetComponent(typeof(Image))
			local var2_4 = var1_0[var0_4]

			LeanTween.value(go(arg0_3.fillImg), 0, 1, 1):setOnUpdate(System.Action_float(function(arg0_5)
				local var0_5 = Mathf.Lerp(var2_4, var3_3, arg0_5)

				var1_4.fillAmount = var0_5
			end)):setOnComplete(System.Action(arg0_4))
		end,
		function(arg0_6)
			arg0_3.fillImg:GetComponent(typeof(Image)).fillAmount = var3_3

			if var0_3 and var1_3 == var2_3 then
				arg0_3:ShowPanel(arg1_3)
			end

			existCall(arg2_3)
		end
	})
end

function var0_0.ShowPanel(arg0_7, arg1_7)
	arg0_7.viewParent:emit(LevelUIConst.FROZEN)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_7.banner)

	local var0_7 = var2_0[1]
	local var1_7 = arg1_7:GetBuffOfLinkAct()

	if var1_7 then
		local var2_7 = pg.gameset.doa_fever_buff.description

		var0_7 = var2_0[table.indexof(var2_7, var1_7)]
	end

	local var3_7 = arg0_7.banner:Find(var0_7)
	local var4_7 = var3_7:Find("Character")
	local var5_7 = var4_7:GetComponent(typeof(Image))
	local var6_7 = math.random(1, 7)

	setImageSprite(var4_7, LoadSprite("ui/LevelStageIMasFeverPanel_atlas", "character" .. tostring(var6_7)))
	setActive(arg0_7.banner, true)
	setActive(var3_7, true)

	var5_7.enabled = true

	local function var7_7()
		arg0_7:ClosePanel()
	end

	var3_7:GetComponent(typeof(DftAniEvent)):SetEndEvent(var7_7)
	onButton(arg0_7, arg0_7.banner, var7_7)

	arg0_7.showingPanel = true
end

function var0_0.ClosePanel(arg0_9)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_9.banner, arg0_9._tf)
	setActive(arg0_9.banner, false)
	arg0_9.viewParent:emit(LevelUIConst.UN_FROZEN)

	arg0_9.showingPanel = nil
end

function var0_0.OnDestroy(arg0_10)
	if arg0_10.showingPanel then
		arg0_10:ClosePanel()
	end
end

return var0_0
