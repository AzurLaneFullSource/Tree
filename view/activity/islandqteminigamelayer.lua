local var0_0 = class("IslandQTEMiniGameLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "IslandQTEGameUI"
end

function var0_0.init(arg0_2)
	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf)
	eachChild(arg0_2._tf, function(arg0_3)
		setActive(arg0_3, arg0_3.name == arg0_2.contextData.mark)

		if arg0_3.name == arg0_2.contextData.mark then
			arg0_2.rtGame = arg0_3
		end
	end)
end

function var0_0.didEnter(arg0_4)
	switch(arg0_4.contextData.mark, {
		Qgame1 = function()
			local var0_5 = arg0_4.rtGame:Find("content")
			local var1_5 = math.random(3, 7)
			local var2_5 = {}
			local var3_5 = {}

			for iter0_5 = var0_5.childCount, 1, -1 do
				table.insert(var3_5, iter0_5)
			end

			local var4_5 = arg0_4.rtGame:Find("res")

			for iter1_5 = 1, var1_5 do
				local var5_5 = table.remove(var3_5, math.random(#var3_5))

				table.insert(var2_5, var5_5)

				local var6_5 = cloneTplTo(var4_5:Find(math.random(var4_5.childCount)), var0_5:GetChild(var5_5 - 1))
				local var7_5 = var6_5:Find("Image")

				var7_5:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_6)
					var1_5 = var1_5 - 1

					table.removebyvalue(var2_5, var5_5)
					Destroy(var6_5)

					if var1_5 == 0 then
						if arg0_4.timer then
							arg0_4.timer:Stop()

							arg0_4.timer = nil
						end

						arg0_4:finishGame()
					end
				end)
				onButton(arg0_4, var7_5, function()
					SetCompomentEnabled(var7_5, typeof(Animator), true)
				end, SFX_PANEL)
			end

			setText(arg0_4.rtGame:Find("btn_hint/Text"), i18n("islandnode_tips2"))
			onButton(arg0_4, arg0_4.rtGame:Find("btn_hint"), function()
				local var0_8 = 10

				arg0_4.timer = Timer.New(function()
					if var0_8 == 0 then
						setText(arg0_4.rtGame:Find("btn_hint/Text"), i18n("islandnode_tips2"))
						setButtonEnabled(arg0_4.rtGame:Find("btn_hint"), true)

						arg0_4.timer = nil
					else
						setText(arg0_4.rtGame:Find("btn_hint/Text"), setColorStr(i18n("islandnode_tips2") .. string.format("(%ds)", var0_8), "#4E4E4EFF"))

						var0_8 = var0_8 - 1
					end
				end, 1, var0_8)

				arg0_4.timer.func()
				arg0_4.timer:Start()
				setButtonEnabled(arg0_4.rtGame:Find("btn_hint"), false)
				setActive(var0_5:GetChild(var2_5[1] - 1):GetChild(0):Find("light"), true)
			end, SFX_CONFIRM)
		end,
		Qgame2 = function()
			local var0_10 = 1
			local var1_10 = 0
			local var2_10 = arg0_4.rtGame:Find("char")
			local var3_10 = var2_10:GetChild(math.random(var2_10.childCount) - 1)

			eachChild(var2_10, function(arg0_11)
				setActive(arg0_11, arg0_11 == var3_10)
			end)

			local var4_10 = {
				arg0_4.rtGame:Find("vine"),
				arg0_4.rtGame:Find("vine_f"),
				var3_10
			}

			for iter0_10, iter1_10 in ipairs(var4_10) do
				SetActionCallback(iter1_10, function(arg0_12)
					if arg0_12 == "finish" and var0_10 == 3 then
						var1_10 = var1_10 - 1

						if var1_10 == 0 then
							arg0_4:finishGame(0)
						end
					end
				end)
			end

			local var5_10 = 0
			local var6_10 = 0

			local function var7_10()
				if (var5_10 - var6_10) * (var5_10 - var6_10) < 0.01 then
					var1_10 = var1_10 + 1

					if var1_10 >= 3 then
						setButtonEnabled(arg0_4.rtGame:Find("btn_l"), false)
						setButtonEnabled(arg0_4.rtGame:Find("btn_r"), false)

						var0_10 = 3

						for iter0_13, iter1_13 in ipairs(var4_10) do
							SetAction(iter1_13, "hd_action" .. var0_10)
						end
					end
				end
			end

			onButton(arg0_4, arg0_4.rtGame:Find("btn_l"), function()
				if var0_10 == 1 then
					var0_10 = 2

					for iter0_14, iter1_14 in ipairs(var4_10) do
						SetAction(iter1_14, "hd_action" .. var0_10)
					end
				end

				var5_10 = Time.realtimeSinceStartup

				var7_10()
			end, SFX_PANEL)
			onButton(arg0_4, arg0_4.rtGame:Find("btn_r"), function()
				if var0_10 == 1 then
					var0_10 = 2

					for iter0_15, iter1_15 in ipairs(var4_10) do
						SetAction(iter1_15, "hd_action" .. var0_10)
					end
				end

				var6_10 = Time.realtimeSinceStartup

				var7_10()
			end, SFX_PANEL)
			onButton(arg0_4, arg0_4.rtGame:Find("btn_back"), function()
				arg0_4:closeView()
			end, SFX_CANCEL)

			if IsUnityEditor and not arg0_4.handle then
				arg0_4.handle = UpdateBeat:CreateListener(function(arg0_17)
					if Input.GetKeyUp(KeyCode.F) and arg0_17.rtGame:Find("btn_l"):GetComponent(typeof(Button)).interactable then
						triggerButton(arg0_17.rtGame:Find("btn_l"))
					end

					if Input.GetKeyUp(KeyCode.J) and arg0_17.rtGame:Find("btn_r"):GetComponent(typeof(Button)).interactable then
						triggerButton(arg0_17.rtGame:Find("btn_r"))
					end
				end, arg0_4)

				UpdateBeat:AddListener(arg0_4.handle)
			end
		end,
		Qgame3 = function()
			local var0_18 = 0.5
			local var1_18 = {
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
			local var2_18 = math.random(3)
			local var3_18 = 3
			local var4_18 = 0
			local var5_18
			local var6_18 = 0
			local var7_18 = 1
			local var8_18
			local var9_18 = {}

			for iter0_18 = 1, 3 do
				table.insert(var9_18, arg0_4.rtGame:Find(iter0_18))
				onButton(arg0_4, var9_18[iter0_18]:Find("click"), function()
					if var8_18 then
						LeanTween.cancel(var8_18)
					end

					setCanvasGroupAlpha(arg0_4.rtGame:Find("Image"), 1)
					setActive(arg0_4.rtGame:Find("Text"), true)

					var5_18 = iter0_18

					if iter0_18 == var2_18 then
						SetAction(var9_18[iter0_18], "action3")
						setText(arg0_4.rtGame:Find("Text"), i18n("islandnode_tips4"))
					else
						SetAction(var9_18[iter0_18], "action4")
						setText(arg0_4.rtGame:Find("Text"), i18n("islandnode_tips5"))
					end

					for iter0_19, iter1_19 in ipairs(var9_18) do
						setButtonEnabled(iter1_19:Find("click"), false)
					end
				end, SFX_PANEL)
				setButtonEnabled(var9_18[iter0_18]:Find("click"), false)
				SetActionCallback(var9_18[iter0_18], function(arg0_20)
					if arg0_20 == "finish" then
						if iter0_18 == var5_18 then
							arg0_4:finishGame(var2_18 == var5_18 and 1 or 0)
						elseif var6_18 > 0 or var4_18 == 5 then
							return
						elseif var3_18 > 1 then
							var3_18 = var3_18 - 1
						else
							var4_18 = var4_18 + 1
							var3_18 = 3

							local function var0_20()
								local var0_21 = var7_18

								var7_18 = (var7_18 + math.random(#var1_18 - 1) - 1) % #var1_18 + 1

								for iter0_21, iter1_21 in ipairs(var1_18[var7_18]) do
									var6_18 = var6_18 + 1

									local var1_21 = {}

									if iter1_21 ~= var1_18[var0_21][iter0_21] then
										SetAction(var9_18[iter0_21], iter1_21 > var1_18[var0_21][iter0_21] and "move_right" or "move_left")
										table.insert(var1_21, function(arg0_22)
											LeanTween.moveX(var9_18[iter0_21], (iter1_21 - 2) * 350, var0_18):setOnComplete(System.Action(arg0_22))
										end)
									end

									seriesAsync(var1_21, function()
										SetAction(var9_18[iter0_21], "normal1")

										var6_18 = var6_18 - 1
									end)
								end
							end

							switch(var4_18, {
								function()
									for iter0_24 = 1, 3 do
										SetAction(var9_18[iter0_24], iter0_24 == var2_18 and "action1" or "action2", false)
									end
								end,
								var0_20,
								var0_20,
								var0_20,
								function()
									for iter0_25 = 1, 3 do
										setButtonEnabled(var9_18[iter0_25]:Find("click"), true)
									end

									var8_18 = LeanTween.alphaCanvas(arg0_4.rtGame:Find("Image"):GetComponent(typeof(CanvasGroup)), 1, 0.5).uniqueId
								end
							})
						end
					end
				end)
				SetAction(var9_18[iter0_18], iter0_18 == var2_18 and "normal2" or "normal1")
			end

			setText(arg0_4.rtGame:Find("Image/Text"), i18n("islandnode_tips3"))
			setCanvasGroupAlpha(arg0_4.rtGame:Find("Image"), 0)
			setActive(arg0_4.rtGame:Find("Text"), false)
		end,
		Qgame4 = function()
			local var0_26 = 5
			local var1_26 = 0
			local var2_26 = arg0_4.rtGame:Find("vine")
			local var3_26 = var2_26:GetChild(math.random(var2_26.childCount) - 1)

			eachChild(var2_26, function(arg0_27)
				setActive(arg0_27, arg0_27 == var3_26)
			end)
			SetAction(var3_26, "action1")
			SetActionCallback(var3_26, function(arg0_28)
				if arg0_28 == "finish" and var0_26 == 0 then
					arg0_4:finishGame(0)
				end
			end)
			onButton(arg0_4, arg0_4.rtGame:Find("btn"), function()
				local var0_29 = Time.realtimeSinceStartup

				if var0_29 - var1_26 < 1 then
					var0_26 = var0_26 - 1

					if var0_26 > 0 then
						-- block empty
					else
						setButtonEnabled(arg0_4.rtGame:Find("btn"), false)
						SetAction(var3_26, "action2")
					end
				else
					var0_26 = 4
				end

				var1_26 = var0_29
			end, SFX_PANEL)
		end,
		Qgame5 = function()
			local var0_30 = 10
			local var1_30 = 3
			local var2_30 = 30
			local var3_30 = 60

			setLocalEulerAngles(arg0_4.rtGame:Find("hitter/hit_prefect"), {
				z = var2_30 / 2
			})

			arg0_4.rtGame:Find("hitter/hit_prefect"):GetComponent(typeof(Image)).fillAmount = var2_30 / 360

			setLocalEulerAngles(arg0_4.rtGame:Find("hitter/hit_good"), {
				z = var3_30 / 2
			})

			arg0_4.rtGame:Find("hitter/hit_good"):GetComponent(typeof(Image)).fillAmount = var3_30 / 360

			local var4_30 = arg0_4.rtGame:Find("char")
			local var5_30 = var4_30:GetChild(math.random(var4_30.childCount) - 1)

			eachChild(var4_30, function(arg0_31)
				setActive(arg0_31, arg0_31 == var5_30)
			end)
			SetAction(var5_30, "kaorouaction1")

			local var6_30 = 3
			local var7_30 = {
				[0] = 0
			}

			for iter0_30 = 1, var6_30 do
				table.insert(var7_30, var7_30[iter0_30 - 1] + var0_30 / 3 - 0.1)
			end

			local var8_30 = arg0_4.rtGame:Find("Slider")
			local var9_30 = var8_30:Find("content")
			local var10_30 = var9_30.rect.width
			local var11_30 = UIItemList.New(var9_30, var9_30:Find("mark"))

			var11_30:make(function(arg0_32, arg1_32, arg2_32)
				arg1_32 = arg1_32 + 1

				if arg0_32 == UIItemList.EventUpdate then
					arg2_32.name = arg1_32

					setAnchoredPosition(arg2_32, {
						x = var10_30 * var7_30[arg1_32] / var0_30
					})
				end
			end)
			var11_30:align(#var7_30)

			local var12_30 = 0
			local var13_30
			local var14_30

			var13_30 = LeanTween.value(go(var5_30), 0, var0_30, var0_30):setOnUpdate(System.Action_float(function(arg0_33)
				setSlider(var8_30, 0, var0_30, arg0_33)

				if var7_30[1] and arg0_33 >= var7_30[1] then
					table.remove(var7_30, 1)
					LeanTween.pause(var13_30)

					local function var0_33(arg0_34)
						if var14_30 then
							LeanTween.cancel(var14_30)

							var14_30 = nil
						end

						setActive(arg0_4.rtGame:Find("hitter"), false)
						setActive(arg0_4.rtGame:Find("click"), false)

						var12_30 = var12_30 + arg0_34

						LeanTween.resume(var13_30)
					end

					setActive(arg0_4.rtGame:Find("hitter"), true)

					local var1_33 = arg0_4.rtGame:Find("hitter/pointer")

					var14_30 = LeanTween.value(go(var1_33), 73.44, -73.44, var1_30):setOnUpdate(System.Action_float(function(arg0_35)
						setLocalEulerAngles(var1_33, {
							z = arg0_35
						})
					end)):setOnComplete(System.Action(function()
						var0_33(0)
					end)).uniqueId

					setActive(arg0_4.rtGame:Find("click"), true)
					onButton(arg0_4, arg0_4.rtGame:Find("click"), function()
						local var0_37 = math.min(math.abs(var1_33.localEulerAngles.z), math.abs(var1_33.localEulerAngles.z - 360))

						if var0_37 > var3_30 / 2 then
							var0_33(0)
						elseif var0_37 > var2_30 / 2 then
							var0_33(1)
						else
							var0_33(2)
						end
					end, SFX_PANEL)
				end
			end)):setOnComplete(System.Action(function()
				local var0_38 = 2 * math.floor(var12_30 / (var6_30 + var6_30)) + (var12_30 % (var6_30 + var6_30) > 0 and 1 or 0)

				SetAction(var5_30, "kaorouaction" .. 4 - var0_38, false)
				SetActionCallback(var5_30, function(arg0_39)
					if arg0_39 == "finish" then
						arg0_4:finishGame(var0_38)
					end
				end)
			end)).uniqueId

			setActive(arg0_4.rtGame:Find("hitter"), false)
			setActive(arg0_4.rtGame:Find("click"), false)
		end
	})
end

function var0_0.finishGame(arg0_40, arg1_40)
	arg0_40:emit(IslandQTEMiniGameMediator.GAME_FINISH, arg1_40 or 0)
	arg0_40:closeView()
end

function var0_0.onBackPressed(arg0_41)
	return
end

function var0_0.willExit(arg0_42)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_42._tf)

	if arg0_42.handle then
		UpdateBeat:RemoveListener(arg0_42.handle)

		arg0_42.handle = nil
	end
end

return var0_0
