local var0_0 = class("SenrankaguraMainPage", import(".TemplatePage.PreviewTemplatePage"))

var0_0.SWITCH_INTERVAL = 6
var0_0.SWITCH_TIME = 0.5
var0_0.SWITCH_WIDTH = 367
var0_0.TACHIE_DELAY = 0.03

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD/mask")
	arg0_1.btnList = arg0_1:findTF("btn_list", arg0_1.bg)
	arg0_1.main = arg0_1:findTF("main", arg0_1.bg)
	arg0_1.totalNum = arg0_1.main.childCount
	arg0_1.randomList = {}
	arg0_1.children = {}

	for iter0_1 = 1, arg0_1.totalNum do
		local var0_1 = arg0_1.main:GetChild(iter0_1 - 1)

		table.insert(arg0_1.children, var0_1)
		setActive(var0_1, false)

		if PLATFORM_CODE ~= PLATFORM_CH then
			local var1_1 = findTF(var0_1, "hx")

			if var1_1 then
				setActive(var1_1, false)
			end
		end
	end
end

function var0_0.OnFirstFlush(arg0_2)
	var0_0.super.OnFirstFlush(arg0_2)
	onButton(arg0_2, arg0_2:findTF("mountain", arg0_2.btnList), function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SENRANKAGURA_BACKHILL)
	end, SFX_PANEL)

	for iter0_2 = 1, arg0_2.totalNum do
		table.insert(arg0_2.randomList, iter0_2)
	end

	shuffle(arg0_2.randomList)

	arg0_2.index = 1

	setActive(arg0_2.children[arg0_2.randomList[arg0_2.index]], true)

	arg0_2.LTList = {}

	function arg0_2.Interval()
		table.insert(arg0_2.LTList, LeanTween.delayedCall(go(arg0_2._tf), var0_0.SWITCH_INTERVAL, System.Action(arg0_2.FadeIn)).uniqueId)
	end

	function arg0_2.FadeIn()
		local var0_5 = arg0_2.children[arg0_2.randomList[arg0_2.index]]

		arg0_2.index = arg0_2.index % arg0_2.totalNum + 1

		local var1_5 = arg0_2.children[arg0_2.randomList[arg0_2.index]]
		local var2_5 = var0_0.SWITCH_WIDTH

		setActive(var1_5, true)

		local var3_5 = {
			findTF(var1_5, "bg"),
			findTF(var1_5, "tachie"),
			findTF(var1_5, "hx")
		}
		local var4_5 = {
			findTF(var0_5, "bg"),
			findTF(var0_5, "tachie"),
			findTF(var0_5, "hx")
		}
		local var5_5 = {
			0,
			var0_0.TACHIE_DELAY,
			var0_0.TACHIE_DELAY
		}

		table.insert(arg0_2.LTList, LeanTween.delayedCall(go(arg0_2._tf), var0_0.SWITCH_TIME + var0_0.TACHIE_DELAY, System.Action(arg0_2.Interval)).uniqueId)
		table.Foreach(var3_5, function(arg0_6, arg1_6)
			setImageAlpha(arg1_6, 0)

			local var0_6 = rtf(arg1_6).anchoredPosition.x

			setAnchoredPosition(arg1_6, {
				x = var2_5 + var0_6
			})

			local function var1_6()
				table.insert(arg0_2.LTList, LeanTween.alpha(arg1_6, 1, var0_0.SWITCH_TIME):setEase(LeanTweenType.easeOutSine).uniqueId)
				table.insert(arg0_2.LTList, LeanTween.moveX(rtf(arg1_6), 0 + var0_6, var0_0.SWITCH_TIME):setEase(LeanTweenType.easeOutSine).uniqueId)
			end

			if var5_5[arg0_6] > 0 then
				table.insert(arg0_2.LTList, LeanTween.delayedCall(go(arg1_6), var5_5[arg0_6], System.Action(var1_6)).uniqueId)
			else
				var1_6()
			end
		end)
		table.Foreach(var4_5, function(arg0_8, arg1_8)
			local var0_8 = rtf(arg1_8).anchoredPosition.x

			local function var1_8()
				setAnchoredPosition(arg1_8, {
					x = var0_8
				})
			end

			local function var2_8()
				table.insert(arg0_2.LTList, LeanTween.alpha(arg1_8, 0, var0_0.SWITCH_TIME):setEase(LeanTweenType.easeOutSine).uniqueId)
				table.insert(arg0_2.LTList, LeanTween.moveX(rtf(arg1_8), -var2_5 + var0_8, var0_0.SWITCH_TIME):setOnComplete(System.Action(var1_8)):setEase(LeanTweenType.easeOutSine).uniqueId)
			end

			if var5_5[arg0_8] > 0 then
				table.insert(arg0_2.LTList, LeanTween.delayedCall(go(arg1_8), var5_5[arg0_8], System.Action(var2_8)).uniqueId)
			else
				var2_8()
			end
		end)
	end

	arg0_2.Interval()
end

function var0_0.OnDestroy(arg0_11)
	for iter0_11, iter1_11 in ipairs(arg0_11.LTList or {}) do
		LeanTween.cancel(iter1_11)
	end
end

return var0_0
