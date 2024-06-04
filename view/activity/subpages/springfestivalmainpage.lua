local var0 = class("SpringFestivalMainPage", import(".TemplatePage.PreviewTemplatePage"))
local var1 = {
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
local var2 = 1
local var3 = 3.5

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.rtPrint = arg0._tf:Find("AD/print")
	arg0.prints = {
		arg0.rtPrint:Find("front"),
		arg0.rtPrint:Find("back")
	}
end

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	onButton(arg0, arg0.btnList:Find("mountain"), function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SPRING_FESTIVAL_BACKHILL_2023)
	end, SFX_PANEL)

	arg0.printCount = 0

	setImageAlpha(arg0.prints[1], 0)
	setImageAlpha(arg0.prints[2], 0)
end

function var0.OnUpdateFlush(arg0)
	if arg0.LT then
		for iter0, iter1 in ipairs(arg0.LT) do
			LeanTween.resume(iter1)
		end
	else
		arg0.tempImg = nil

		local var0 = true
		local var1

		local function var2()
			arg0.LT = {}

			parallelAsync({
				function(arg0)
					arg0.printCount = arg0.printCount % #var1 + 1

					LoadSpriteAtlasAsync("clutter/springfestivalmainpage_" .. var1[arg0.printCount], nil, function(arg0)
						if IsNil(arg0.rtPrint) then
							return
						else
							arg0.tempImg = arg0

							arg0()
						end
					end)
				end,
				function(arg0)
					table.insert(arg0.LT, LeanTween.alpha(arg0.prints[1], 0, var2):setOnComplete(System.Action(arg0)):setDelay(var0 and 0 or var3).uniqueId)
				end,
				function(arg0)
					table.insert(arg0.LT, LeanTween.alpha(arg0.prints[2], 1, var2):setOnComplete(System.Action(arg0)):setDelay(var0 and 0 or var3).uniqueId)
				end
			}, function()
				var0 = false
				arg0.prints[2], arg0.prints[1] = arg0.prints[1], arg0.prints[2]

				setImageSprite(arg0.prints[2], arg0.tempImg, true)
				var2()
			end)
		end

		seriesAsync({
			function(arg0)
				arg0.printCount = arg0.printCount % #var1 + 1

				LoadSpriteAtlasAsync("clutter/springfestivalmainpage_" .. var1[arg0.printCount], nil, function(arg0)
					if IsNil(arg0.rtPrint) then
						return
					else
						setImageSprite(arg0.prints[2], arg0, true)
						arg0()
					end
				end)
			end
		}, var2)
	end
end

function var0.OnHideFlush(arg0)
	if arg0.LT then
		for iter0, iter1 in ipairs(arg0.LT) do
			LeanTween.pause(iter1)
		end
	end
end

function var0.OnDestroy(arg0)
	if arg0.LT then
		for iter0, iter1 in ipairs(arg0.LT) do
			LeanTween.cancel(iter1)
		end
	end
end

return var0
