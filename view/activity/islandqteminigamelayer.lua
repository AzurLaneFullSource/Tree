local var0 = class("IslandQTEMiniGameLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "IslandQTEGameUI"
end

function var0.init(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	eachChild(arg0._tf, function(arg0)
		setActive(arg0, arg0.name == arg0.contextData.mark)

		if arg0.name == arg0.contextData.mark then
			arg0.rtGame = arg0
		end
	end)
end

function var0.didEnter(arg0)
	switch(arg0.contextData.mark, {
		Qgame1 = function()
			local var0 = arg0.rtGame:Find("content")
			local var1 = math.random(3, 7)
			local var2 = {}
			local var3 = {}

			for iter0 = var0.childCount, 1, -1 do
				table.insert(var3, iter0)
			end

			local var4 = arg0.rtGame:Find("res")

			for iter1 = 1, var1 do
				local var5 = table.remove(var3, math.random(#var3))

				table.insert(var2, var5)

				local var6 = cloneTplTo(var4:Find(math.random(var4.childCount)), var0:GetChild(var5 - 1))
				local var7 = var6:Find("Image")

				var7:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0)
					var1 = var1 - 1

					table.removebyvalue(var2, var5)
					Destroy(var6)

					if var1 == 0 then
						if arg0.timer then
							arg0.timer:Stop()

							arg0.timer = nil
						end

						arg0:finishGame()
					end
				end)
				onButton(arg0, var7, function()
					SetCompomentEnabled(var7, typeof(Animator), true)
				end, SFX_PANEL)
			end

			setText(arg0.rtGame:Find("btn_hint/Text"), i18n("islandnode_tips2"))
			onButton(arg0, arg0.rtGame:Find("btn_hint"), function()
				local var0 = 10

				arg0.timer = Timer.New(function()
					if var0 == 0 then
						setText(arg0.rtGame:Find("btn_hint/Text"), i18n("islandnode_tips2"))
						setButtonEnabled(arg0.rtGame:Find("btn_hint"), true)

						arg0.timer = nil
					else
						setText(arg0.rtGame:Find("btn_hint/Text"), setColorStr(i18n("islandnode_tips2") .. string.format("(%ds)", var0), "#4E4E4EFF"))

						var0 = var0 - 1
					end
				end, 1, var0)

				arg0.timer.func()
				arg0.timer:Start()
				setButtonEnabled(arg0.rtGame:Find("btn_hint"), false)
				setActive(var0:GetChild(var2[1] - 1):GetChild(0):Find("light"), true)
			end, SFX_CONFIRM)
		end,
		Qgame2 = function()
			local var0 = 1
			local var1 = 0
			local var2 = arg0.rtGame:Find("char")
			local var3 = var2:GetChild(math.random(var2.childCount) - 1)

			eachChild(var2, function(arg0)
				setActive(arg0, arg0 == var3)
			end)

			local var4 = {
				arg0.rtGame:Find("vine"),
				arg0.rtGame:Find("vine_f"),
				var3
			}

			for iter0, iter1 in ipairs(var4) do
				SetActionCallback(iter1, function(arg0)
					if arg0 == "finish" and var0 == 3 then
						var1 = var1 - 1

						if var1 == 0 then
							arg0:finishGame(0)
						end
					end
				end)
			end

			local var5 = 0
			local var6 = 0

			local function var7()
				if (var5 - var6) * (var5 - var6) < 0.01 then
					var1 = var1 + 1

					if var1 >= 3 then
						setButtonEnabled(arg0.rtGame:Find("btn_l"), false)
						setButtonEnabled(arg0.rtGame:Find("btn_r"), false)

						var0 = 3

						for iter0, iter1 in ipairs(var4) do
							SetAction(iter1, "hd_action" .. var0)
						end
					end
				end
			end

			onButton(arg0, arg0.rtGame:Find("btn_l"), function()
				if var0 == 1 then
					var0 = 2

					for iter0, iter1 in ipairs(var4) do
						SetAction(iter1, "hd_action" .. var0)
					end
				end

				var5 = Time.realtimeSinceStartup

				var7()
			end, SFX_PANEL)
			onButton(arg0, arg0.rtGame:Find("btn_r"), function()
				if var0 == 1 then
					var0 = 2

					for iter0, iter1 in ipairs(var4) do
						SetAction(iter1, "hd_action" .. var0)
					end
				end

				var6 = Time.realtimeSinceStartup

				var7()
			end, SFX_PANEL)
			onButton(arg0, arg0.rtGame:Find("btn_back"), function()
				arg0:closeView()
			end, SFX_CANCEL)

			if IsUnityEditor and not arg0.handle then
				arg0.handle = UpdateBeat:CreateListener(function(arg0)
					if Input.GetKeyUp(KeyCode.F) and arg0.rtGame:Find("btn_l"):GetComponent(typeof(Button)).interactable then
						triggerButton(arg0.rtGame:Find("btn_l"))
					end

					if Input.GetKeyUp(KeyCode.J) and arg0.rtGame:Find("btn_r"):GetComponent(typeof(Button)).interactable then
						triggerButton(arg0.rtGame:Find("btn_r"))
					end
				end, arg0)

				UpdateBeat:AddListener(arg0.handle)
			end
		end,
		Qgame3 = function()
			local var0 = 0.5
			local var1 = {
				{
					1,
					2,
					3
				},
				{
					1,
					3,
					2
				},
				{
					2,
					1,
					3
				},
				{
					2,
					3,
					1
				},
				{
					3,
					1,
					2
				},
				{
					3,
					2,
					1
				}
			}
			local var2 = math.random(3)
			local var3 = 3
			local var4 = 0
			local var5
			local var6 = 0
			local var7 = 1
			local var8
			local var9 = {}

			for iter0 = 1, 3 do
				table.insert(var9, arg0.rtGame:Find(iter0))
				onButton(arg0, var9[iter0]:Find("click"), function()
					if var8 then
						LeanTween.cancel(var8)
					end

					setCanvasGroupAlpha(arg0.rtGame:Find("Image"), 1)
					setActive(arg0.rtGame:Find("Text"), true)

					var5 = iter0

					if iter0 == var2 then
						SetAction(var9[iter0], "action3")
						setText(arg0.rtGame:Find("Text"), i18n("islandnode_tips4"))
					else
						SetAction(var9[iter0], "action4")
						setText(arg0.rtGame:Find("Text"), i18n("islandnode_tips5"))
					end

					for iter0, iter1 in ipairs(var9) do
						setButtonEnabled(iter1:Find("click"), false)
					end
				end, SFX_PANEL)
				setButtonEnabled(var9[iter0]:Find("click"), false)
				SetActionCallback(var9[iter0], function(arg0)
					if arg0 == "finish" then
						if iter0 == var5 then
							arg0:finishGame(var2 == var5 and 1 or 0)
						elseif var6 > 0 or var4 == 5 then
							return
						elseif var3 > 1 then
							var3 = var3 - 1
						else
							var4 = var4 + 1
							var3 = 3

							local var0 = function()
								local var0 = var7

								var7 = (var7 + math.random(#var1 - 1) - 1) % #var1 + 1

								for iter0, iter1 in ipairs(var1[var7]) do
									var6 = var6 + 1

									local var1 = {}

									if iter1 ~= var1[var0][iter0] then
										SetAction(var9[iter0], iter1 > var1[var0][iter0] and "move_right" or "move_left")
										table.insert(var1, function(arg0)
											LeanTween.moveX(var9[iter0], (iter1 - 2) * 350, var0):setOnComplete(System.Action(arg0))
										end)
									end

									seriesAsync(var1, function()
										SetAction(var9[iter0], "normal1")

										var6 = var6 - 1
									end)
								end
							end

							switch(var4, {
								function()
									for iter0 = 1, 3 do
										SetAction(var9[iter0], iter0 == var2 and "action1" or "action2", false)
									end
								end,
								var0,
								var0,
								var0,
								function()
									for iter0 = 1, 3 do
										setButtonEnabled(var9[iter0]:Find("click"), true)
									end

									var8 = LeanTween.alphaCanvas(arg0.rtGame:Find("Image"):GetComponent(typeof(CanvasGroup)), 1, 0.5).uniqueId
								end
							})
						end
					end
				end)
				SetAction(var9[iter0], iter0 == var2 and "normal2" or "normal1")
			end

			setText(arg0.rtGame:Find("Image/Text"), i18n("islandnode_tips3"))
			setCanvasGroupAlpha(arg0.rtGame:Find("Image"), 0)
			setActive(arg0.rtGame:Find("Text"), false)
		end,
		Qgame4 = function()
			local var0 = 5
			local var1 = 0
			local var2 = arg0.rtGame:Find("vine")
			local var3 = var2:GetChild(math.random(var2.childCount) - 1)

			eachChild(var2, function(arg0)
				setActive(arg0, arg0 == var3)
			end)
			SetAction(var3, "action1")
			SetActionCallback(var3, function(arg0)
				if arg0 == "finish" and var0 == 0 then
					arg0:finishGame(0)
				end
			end)
			onButton(arg0, arg0.rtGame:Find("btn"), function()
				local var0 = Time.realtimeSinceStartup

				if var0 - var1 < 1 then
					var0 = var0 - 1

					if var0 > 0 then
						-- block empty
					else
						setButtonEnabled(arg0.rtGame:Find("btn"), false)
						SetAction(var3, "action2")
					end
				else
					var0 = 4
				end

				var1 = var0
			end, SFX_PANEL)
		end,
		Qgame5 = function()
			local var0 = 10
			local var1 = 3
			local var2 = 30
			local var3 = 60

			setLocalEulerAngles(arg0.rtGame:Find("hitter/hit_prefect"), {
				z = var2 / 2
			})

			arg0.rtGame:Find("hitter/hit_prefect"):GetComponent(typeof(Image)).fillAmount = var2 / 360

			setLocalEulerAngles(arg0.rtGame:Find("hitter/hit_good"), {
				z = var3 / 2
			})

			arg0.rtGame:Find("hitter/hit_good"):GetComponent(typeof(Image)).fillAmount = var3 / 360

			local var4 = arg0.rtGame:Find("char")
			local var5 = var4:GetChild(math.random(var4.childCount) - 1)

			eachChild(var4, function(arg0)
				setActive(arg0, arg0 == var5)
			end)
			SetAction(var5, "kaorouaction1")

			local var6 = 3
			local var7 = {
				[0] = 0
			}

			for iter0 = 1, var6 do
				table.insert(var7, var7[iter0 - 1] + var0 / 3 - 0.1)
			end

			local var8 = arg0.rtGame:Find("Slider")
			local var9 = var8:Find("content")
			local var10 = var9.rect.width
			local var11 = UIItemList.New(var9, var9:Find("mark"))

			var11:make(function(arg0, arg1, arg2)
				arg1 = arg1 + 1

				if arg0 == UIItemList.EventUpdate then
					arg2.name = arg1

					setAnchoredPosition(arg2, {
						x = var10 * var7[arg1] / var0
					})
				end
			end)
			var11:align(#var7)

			local var12 = 0
			local var13
			local var14

			var13 = LeanTween.value(go(var5), 0, var0, var0):setOnUpdate(System.Action_float(function(arg0)
				setSlider(var8, 0, var0, arg0)

				if var7[1] and arg0 >= var7[1] then
					table.remove(var7, 1)
					LeanTween.pause(var13)

					local function var0(arg0)
						if var14 then
							LeanTween.cancel(var14)

							var14 = nil
						end

						setActive(arg0.rtGame:Find("hitter"), false)
						setActive(arg0.rtGame:Find("click"), false)

						var12 = var12 + arg0

						LeanTween.resume(var13)
					end

					setActive(arg0.rtGame:Find("hitter"), true)

					local var1 = arg0.rtGame:Find("hitter/pointer")

					var14 = LeanTween.value(go(var1), 73.44, -73.44, var1):setOnUpdate(System.Action_float(function(arg0)
						setLocalEulerAngles(var1, {
							z = arg0
						})
					end)):setOnComplete(System.Action(function()
						var0(0)
					end)).uniqueId

					setActive(arg0.rtGame:Find("click"), true)
					onButton(arg0, arg0.rtGame:Find("click"), function()
						local var0 = math.min(math.abs(var1.localEulerAngles.z), math.abs(var1.localEulerAngles.z - 360))

						if var0 > var3 / 2 then
							var0(0)
						elseif var0 > var2 / 2 then
							var0(1)
						else
							var0(2)
						end
					end, SFX_PANEL)
				end
			end)):setOnComplete(System.Action(function()
				local var0 = 2 * math.floor(var12 / (var6 + var6)) + (var12 % (var6 + var6) > 0 and 1 or 0)

				SetAction(var5, "kaorouaction" .. 4 - var0, false)
				SetActionCallback(var5, function(arg0)
					if arg0 == "finish" then
						arg0:finishGame(var0)
					end
				end)
			end)).uniqueId

			setActive(arg0.rtGame:Find("hitter"), false)
			setActive(arg0.rtGame:Find("click"), false)
		end
	})
end

function var0.finishGame(arg0, arg1)
	arg0:emit(IslandQTEMiniGameMediator.GAME_FINISH, arg1 or 0)
	arg0:closeView()
end

function var0.onBackPressed(arg0)
	return
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)

	if arg0.handle then
		UpdateBeat:RemoveListener(arg0.handle)

		arg0.handle = nil
	end
end

return var0
