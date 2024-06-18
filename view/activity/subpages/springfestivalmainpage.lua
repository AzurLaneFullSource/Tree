local var0_0 = class("SpringFestivalMainPage", import(".TemplatePage.PreviewTemplatePage"))
local var1_0 = {
	1,
	2,
	3,
	4,
	8,
	9,
	10,
	14,
	15,
	17,
	18,
	19
}
local var2_0 = 1
local var3_0 = 3.5

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.rtPrint = arg0_1._tf:Find("AD/print")
	arg0_1.prints = {
		arg0_1.rtPrint:Find("front"),
		arg0_1.rtPrint:Find("back")
	}
end

function var0_0.OnFirstFlush(arg0_2)
	var0_0.super.OnFirstFlush(arg0_2)
	onButton(arg0_2, arg0_2.btnList:Find("mountain"), function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SPRING_FESTIVAL_BACKHILL_2023)
	end, SFX_PANEL)

	arg0_2.printCount = 0

	setImageAlpha(arg0_2.prints[1], 0)
	setImageAlpha(arg0_2.prints[2], 0)
end

function var0_0.OnUpdateFlush(arg0_4)
	if arg0_4.LT then
		for iter0_4, iter1_4 in ipairs(arg0_4.LT) do
			LeanTween.resume(iter1_4)
		end
	else
		arg0_4.tempImg = nil

		local var0_4 = true
		local var1_4

		local function var2_4()
			arg0_4.LT = {}

			parallelAsync({
				function(arg0_6)
					arg0_4.printCount = arg0_4.printCount % #var1_0 + 1

					LoadSpriteAtlasAsync("clutter/springfestivalmainpage_" .. var1_0[arg0_4.printCount], nil, function(arg0_7)
						if IsNil(arg0_4.rtPrint) then
							return
						else
							arg0_4.tempImg = arg0_7

							arg0_6()
						end
					end)
				end,
				function(arg0_8)
					table.insert(arg0_4.LT, LeanTween.alpha(arg0_4.prints[1], 0, var2_0):setOnComplete(System.Action(arg0_8)):setDelay(var0_4 and 0 or var3_0).uniqueId)
				end,
				function(arg0_9)
					table.insert(arg0_4.LT, LeanTween.alpha(arg0_4.prints[2], 1, var2_0):setOnComplete(System.Action(arg0_9)):setDelay(var0_4 and 0 or var3_0).uniqueId)
				end
			}, function()
				var0_4 = false
				arg0_4.prints[2], arg0_4.prints[1] = arg0_4.prints[1], arg0_4.prints[2]

				setImageSprite(arg0_4.prints[2], arg0_4.tempImg, true)
				var2_4()
			end)
		end

		seriesAsync({
			function(arg0_11)
				arg0_4.printCount = arg0_4.printCount % #var1_0 + 1

				LoadSpriteAtlasAsync("clutter/springfestivalmainpage_" .. var1_0[arg0_4.printCount], nil, function(arg0_12)
					if IsNil(arg0_4.rtPrint) then
						return
					else
						setImageSprite(arg0_4.prints[2], arg0_12, true)
						arg0_11()
					end
				end)
			end
		}, var2_4)
	end
end

function var0_0.OnHideFlush(arg0_13)
	if arg0_13.LT then
		for iter0_13, iter1_13 in ipairs(arg0_13.LT) do
			LeanTween.pause(iter1_13)
		end
	end
end

function var0_0.OnDestroy(arg0_14)
	if arg0_14.LT then
		for iter0_14, iter1_14 in ipairs(arg0_14.LT) do
			LeanTween.cancel(iter1_14)
		end
	end
end

return var0_0
