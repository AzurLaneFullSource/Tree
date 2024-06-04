local var0 = class("SenrankaguraMainPage", import(".TemplatePage.PreviewTemplatePage"))

var0.SWITCH_INTERVAL = 6
var0.SWITCH_TIME = 0.5
var0.SWITCH_WIDTH = 367
var0.TACHIE_DELAY = 0.03

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD/mask")
	arg0.btnList = arg0:findTF("btn_list", arg0.bg)
	arg0.main = arg0:findTF("main", arg0.bg)
	arg0.totalNum = arg0.main.childCount
	arg0.randomList = {}
	arg0.children = {}

	for iter0 = 1, arg0.totalNum do
		local var0 = arg0.main:GetChild(iter0 - 1)

		table.insert(arg0.children, var0)
		setActive(var0, false)

		if PLATFORM_CODE ~= PLATFORM_CH then
			local var1 = findTF(var0, "hx")

			if var1 then
				setActive(var1, false)
			end
		end
	end
end

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	onButton(arg0, arg0:findTF("mountain", arg0.btnList), function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SENRANKAGURA_BACKHILL)
	end, SFX_PANEL)

	for iter0 = 1, arg0.totalNum do
		table.insert(arg0.randomList, iter0)
	end

	shuffle(arg0.randomList)

	arg0.index = 1

	setActive(arg0.children[arg0.randomList[arg0.index]], true)

	arg0.LTList = {}

	function arg0.Interval()
		table.insert(arg0.LTList, LeanTween.delayedCall(go(arg0._tf), var0.SWITCH_INTERVAL, System.Action(arg0.FadeIn)).uniqueId)
	end

	function arg0.FadeIn()
		local var0 = arg0.children[arg0.randomList[arg0.index]]

		arg0.index = arg0.index % arg0.totalNum + 1

		local var1 = arg0.children[arg0.randomList[arg0.index]]
		local var2 = var0.SWITCH_WIDTH

		setActive(var1, true)

		local var3 = {
			findTF(var1, "bg"),
			findTF(var1, "tachie"),
			findTF(var1, "hx")
		}
		local var4 = {
			findTF(var0, "bg"),
			findTF(var0, "tachie"),
			findTF(var0, "hx")
		}
		local var5 = {
			0,
			var0.TACHIE_DELAY,
			var0.TACHIE_DELAY
		}

		table.insert(arg0.LTList, LeanTween.delayedCall(go(arg0._tf), var0.SWITCH_TIME + var0.TACHIE_DELAY, System.Action(arg0.Interval)).uniqueId)
		table.Foreach(var3, function(arg0, arg1)
			setImageAlpha(arg1, 0)

			local var0 = rtf(arg1).anchoredPosition.x

			setAnchoredPosition(arg1, {
				x = var2 + var0
			})

			local function var1()
				table.insert(arg0.LTList, LeanTween.alpha(arg1, 1, var0.SWITCH_TIME):setEase(LeanTweenType.easeOutSine).uniqueId)
				table.insert(arg0.LTList, LeanTween.moveX(rtf(arg1), 0 + var0, var0.SWITCH_TIME):setEase(LeanTweenType.easeOutSine).uniqueId)
			end

			if var5[arg0] > 0 then
				table.insert(arg0.LTList, LeanTween.delayedCall(go(arg1), var5[arg0], System.Action(var1)).uniqueId)
			else
				var1()
			end
		end)
		table.Foreach(var4, function(arg0, arg1)
			local var0 = rtf(arg1).anchoredPosition.x

			local function var1()
				setAnchoredPosition(arg1, {
					x = var0
				})
			end

			local var2 = function()
				table.insert(arg0.LTList, LeanTween.alpha(arg1, 0, var0.SWITCH_TIME):setEase(LeanTweenType.easeOutSine).uniqueId)
				table.insert(arg0.LTList, LeanTween.moveX(rtf(arg1), -var2 + var0, var0.SWITCH_TIME):setOnComplete(System.Action(var1)):setEase(LeanTweenType.easeOutSine).uniqueId)
			end

			if var5[arg0] > 0 then
				table.insert(arg0.LTList, LeanTween.delayedCall(go(arg1), var5[arg0], System.Action(var2)).uniqueId)
			else
				var2()
			end
		end)
	end

	arg0.Interval()
end

function var0.OnDestroy(arg0)
	for iter0, iter1 in ipairs(arg0.LTList or {}) do
		LeanTween.cancel(iter1)
	end
end

return var0
