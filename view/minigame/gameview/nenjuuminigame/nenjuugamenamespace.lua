local var0_0 = {}
local var1_0 = {
	TargetObject = function()
		local var0_1 = class("TargetObject")

		function var0_1.GetSize(arg0_2)
			return arg0_2.size
		end

		function var0_1.InTimeLine(arg0_3)
			return false
		end

		function var0_1.Moveable(arg0_4)
			return false
		end

		function var0_1.BreakMoveable(arg0_5)
			return false
		end

		function var0_1.GetBaseOrder(arg0_6)
			return 3
		end

		function var0_1.Ctor(arg0_7, arg1_7, arg2_7, arg3_7)
			arg0_7._tf = arg2_7
			arg0_7.controller = arg1_7

			arg0_7:Init(arg3_7)
		end

		function var0_1.Init(arg0_8, arg1_8)
			arg0_8.name = arg1_8.name
			arg0_8.size = arg1_8.size or NewPos(1, 1)
			arg0_8.canHide = arg1_8.hide

			setCanvasOverrideSorting(arg0_8._tf, true)
			arg0_8:UpdatePos(arg1_8.pos - NewPos(0, arg0_8:GetSize().y - 1))

			arg0_8.realPos = arg1_8.realPos or arg0_8.pos

			arg0_8:UpdatePosition()
			arg0_8:InitUI(arg1_8)
		end

		function var0_1.InitUI(arg0_9, arg1_9)
			return
		end

		function var0_1.UpdatePos(arg0_10, arg1_10)
			arg0_10._tf:GetComponent(typeof(Canvas)).sortingOrder = (arg1_10.y + arg0_10:GetSize().y) * 10 + arg0_10:GetBaseOrder()

			arg0_10.controller:UpdateTargetPos(arg0_10, arg0_10.pos, arg1_10)

			arg0_10.pos = arg1_10
		end

		function var0_1.UpdatePosition(arg0_11)
			setAnchoredPosition(arg0_11._tf, {
				x = arg0_11.realPos.x * 32,
				y = arg0_11.realPos.y * -32
			})
		end

		function var0_1.PlayAnim(arg0_12, arg1_12)
			if arg0_12.status ~= arg1_12 then
				arg0_12.status = arg1_12

				arg0_12.mainTarget:GetComponent(typeof(Animator)):Play(arg1_12, -1, 0)
			end
		end

		return var0_1
	end,
	TargetIce = function()
		local var0_13 = class("TargetIce", var0_0.TargetObject)

		function var0_13.BreakMoveable(arg0_14)
			return true
		end

		function var0_13.InitUI(arg0_15, arg1_15)
			arg0_15.mainTarget = arg0_15._tf:Find("scale/Image")

			arg0_15.mainTarget:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
				arg0_15.controller:DestoryTarget(arg0_15)
			end)

			if arg1_15.create then
				if arg0_15.controller:CheckMelt(arg0_15.pos) then
					arg0_15.isLost = true

					arg0_15:PlayAnim("Ice_Spawn_Melt")
				else
					arg0_15:PlayAnim("Ice_Spawn")
				end
			end
		end

		function var0_13.Break(arg0_17)
			if arg0_17.isLost then
				return
			else
				arg0_17.isLost = true

				arg0_17:PlayAnim("Ice_Break")
			end
		end

		return var0_13
	end,
	TargetItem = function()
		local var0_18 = class("TargetItem", var0_0.TargetObject)

		function var0_18.Moveable(arg0_19)
			return true
		end

		function var0_18.GetBaseOrder(arg0_20)
			return 2
		end

		function var0_18.InitUI(arg0_21, arg1_21)
			arg0_21.point = arg1_21.point

			eachChild(arg0_21._tf:Find("scale/type"), function(arg0_22)
				setActive(arg0_22, arg0_22.name == arg0_21.name)
			end)
		end

		return var0_18
	end,
	TargetArbor = function()
		local var0_23 = class("TargetArbor", var0_0.TargetObject)

		function var0_23.InitUI(arg0_24, arg1_24)
			local var0_24 = string.split(arg0_24.name, "_")

			eachChild(arg0_24._tf:Find("scale/Image"), function(arg0_25)
				setActive(arg0_25, arg0_25.name == var0_24[#var0_24])
			end)
		end

		return var0_23
	end,
	TargetMove = function()
		local var0_26 = class("TargetMove", var0_0.TargetObject)

		function var0_26.InTimeLine(arg0_27)
			return true
		end

		function var0_26.GetBaseOrder(arg0_28)
			return 4
		end

		function var0_26.InitUI(arg0_29, arg1_29)
			arg0_29.rtScale = arg0_29._tf:Find("scale")
			arg0_29.mainTarget = arg0_29.rtScale:Find("main")

			local var0_29 = arg0_29.mainTarget:GetComponent(typeof(DftAniEvent))

			var0_29:SetStartEvent(function()
				arg0_29:EventAnim("start")
			end)
			var0_29:SetTriggerEvent(function()
				arg0_29:EventAnim("trigger")
			end)
			var0_29:SetEndEvent(function()
				arg0_29.inLock = false

				arg0_29:EventAnim("end")
			end)
			arg0_29:PlayIdle()
		end

		function var0_26.EventAnim(arg0_33, arg1_33)
			return
		end

		function var0_26.RushCheck(arg0_34)
			return
		end

		function var0_26.PlayIdle(arg0_35, arg1_35)
			arg0_35:PlayAnim(string.format("Idle_%s%s", arg1_35 or arg0_35:GetDirMark(), arg0_35.inLantern and "_Lantern" or ""))
		end

		function var0_26.PlayMove(arg0_36, arg1_36)
			arg0_36:PlayAnim(string.format("Move_%s%s", arg1_36 or arg0_36:GetDirMark(), arg0_36.inLantern and "_Lantern" or ""))
		end

		local var1_26 = {
			E = {
				1,
				0
			},
			S = {
				0,
				1
			},
			W = {
				-1,
				0
			},
			N = {
				0,
				-1
			}
		}

		function var0_26.GetDirMark(arg0_37, arg1_37)
			if arg1_37 then
				for iter0_37, iter1_37 in pairs(var1_26) do
					if iter1_37[1] == arg1_37.x and iter1_37[2] == arg1_37.y then
						return iter0_37
					end
				end
			else
				local var0_37 = string.split(arg0_37.status, "_")[2]

				return var1_26[var0_37] and var0_37 or "S"
			end
		end

		function var0_26.GetDirPos(arg0_38, arg1_38)
			return NewPos(unpack(var1_26[arg1_38 or arg0_38:GetDirMark()]))
		end

		function var0_26.GetStatusMark(arg0_39, arg1_39)
			return string.split(arg1_39 or arg0_39.status, "_")[1]
		end

		function var0_26.OnTimerUpdate(arg0_40, arg1_40)
			return
		end

		var0_26.loopAnimDic = {
			Fear = true,
			Idle = true,
			Move = true
		}

		function var0_26.PlayAnim(arg0_41, arg1_41)
			local var0_41 = tobool(arg0_41.loopAnimDic[arg0_41:GetStatusMark(arg1_41)])

			if var0_41 and arg0_41.status == arg1_41 then
				-- block empty
			else
				arg0_41.inLock = not var0_41
				arg0_41.status = arg1_41

				arg0_41.mainTarget:GetComponent(typeof(Animator)):Play(arg1_41, -1, 0)
				arg0_41:RushCheck()
			end
		end

		return var0_26
	end,
	TargetFuShun = function()
		local var0_42 = class("TargetFuShun", var0_0.TargetMove)

		function var0_42.GetSpeed(arg0_43)
			return arg0_43.speed * (arg0_43.controller:GetEnemyEffect("gravity") and 0.85 or 1) * (arg0_43.inRush and NenjuuGameConfig.GetSkillParam("rush", arg0_43.level.rush)[2] or 1) * (arg0_43.controller:InBlackHoleRange(arg0_43.pos) and 0.75 or 1) * (NenjuuGameConfig.GetSkillParam("blessing", arg0_43.level.blessing) or 1)
		end

		local var1_42 = 0.1
		local var2_42 = 0.1
		local var3_42 = 5
		local var4_42 = {
			ice = 1,
			flash = 30,
			item = 0,
			rush = 20
		}

		function var0_42.CheckSkill(arg0_44, arg1_44)
			if arg1_44 == "item" then
				return arg0_44.itemType and arg0_44.itemCount > 0
			else
				return arg0_44.level[arg1_44] > 0 and arg0_44.skillCDs[arg1_44] <= 0
			end
		end

		function var0_42.ReloadSkill(arg0_45, arg1_45)
			arg0_45.skillCDs[arg1_45] = (arg1_45 == "flash" and NenjuuGameConfig.GetSkillParam("flash", arg0_45.level.flash) or var4_42[arg1_45]) * (arg0_45.controller:GetEnemyEffect("delay") and 1.2 or 1)
		end

		function var0_42.InitUI(arg0_46, arg1_46)
			var0_42.super.InitUI(arg0_46, arg1_46)

			arg0_46.level = arg1_46.level
			arg0_46.skillCDs = {
				ice = 0,
				flash = 0,
				item = 0,
				rush = 0
			}
			arg0_46.itemType = arg1_46.itemType
			arg0_46.speed = 4.5
			arg0_46.icePower = NenjuuGameConfig.GetSkillParam("ice", arg0_46.level.ice)
			arg0_46.flashPower = 4
			arg0_46.decoyCount = arg0_46.level.decoy
			arg0_46.rushTime = checkExist(NenjuuGameConfig.GetSkillParam("rush", arg0_46.level.rush), {
				1
			})
			arg0_46.itemCount = 1
		end

		function var0_42.CalcSkillCDs(arg0_47)
			local var0_47 = {}

			for iter0_47, iter1_47 in ipairs({
				"ice",
				"flash",
				"rush",
				"item"
			}) do
				local var1_47 = arg0_47.skillCDs[iter1_47]
				local var2_47 = (iter1_47 == "flash" and NenjuuGameConfig.GetSkillParam("flash", arg0_47.level.flash) or var4_42[iter1_47]) * (arg0_47.controller:GetEnemyEffect("delay") and 1.2 or 1)

				if iter1_47 == "item" then
					if not arg0_47.itemType then
						table.insert(var0_47, {})
					elseif arg0_47.itemCount > 0 then
						table.insert(var0_47, {
							cd = var1_47,
							icon = arg0_47.itemType
						})
					else
						table.insert(var0_47, {
							cd = true,
							icon = arg0_47.itemType
						})
					end
				elseif arg0_47.level[iter1_47] > 0 then
					table.insert(var0_47, {
						cd = var1_47,
						rate = var2_47 == 0 and 0 or var1_47 / var2_47,
						icon = iter1_47 == "ice" and arg0_47.controller:CheckIce(arg0_47.pos + arg0_47:GetDirPos()) and "attack" or iter1_47
					})
				else
					table.insert(var0_47, {})
				end
			end

			return var0_47
		end

		function var0_42.EventAnim(arg0_48, arg1_48)
			local var0_48 = arg0_48:GetDirMark()

			if arg1_48 == "start" then
				-- block empty
			elseif arg1_48 == "trigger" then
				switch(arg0_48.status, {
					["Freeze_" .. var0_48 .. "_3_Shot"] = function()
						arg0_48.controller:CreateTarget({
							name = "EF_bk_Freeze",
							parent = arg0_48.rtScale:Find("bk")
						})
						arg0_48.controller:BuildIce({
							pos = arg0_48.pos,
							dirPos = arg0_48:GetDirPos(),
							power = arg0_48.icePower
						})
					end,
					["Attack_" .. var0_48] = function()
						switch(var0_48, {
							N = function()
								arg0_48.controller:CreateTarget({
									name = "EF_Attack_Hit_" .. var0_48,
									parent = arg0_48.rtScale:Find("bk")
								})
							end,
							S = function()
								arg0_48.controller:CreateTarget({
									name = "EF_Attack_Hit_" .. var0_48,
									parent = arg0_48.rtScale:Find("fr")
								})
							end
						}, function()
							arg0_48.controller:CreateTarget({
								name = "EF_Attack_Hit_" .. var0_48 .. "_fr",
								parent = arg0_48.rtScale:Find("fr")
							})
							arg0_48.controller:CreateTarget({
								name = "EF_Attack_Hit_" .. var0_48 .. "_bk",
								parent = arg0_48.rtScale:Find("bk")
							})
						end)
						arg0_48.controller:BreakIce({
							pos = arg0_48.pos,
							dir = arg0_48:GetDirMark(),
							dirPos = arg0_48:GetDirPos()
						})
					end,
					Lantern_Activate = function()
						arg0_48:ReloadSkill("item")

						arg0_48.itemCount = arg0_48.itemCount - 1
						arg0_48.inLantern = var3_42
						arg0_48.effectLantern = arg0_48.controller:CreateTarget({
							name = "EF_bk_overlay_Lantern",
							parent = arg0_48.rtScale:Find("bk"),
							time = var3_42
						})
					end
				})
			elseif arg1_48 == "end" then
				switch(arg0_48.status, {
					["Bomb_" .. var0_48 .. "_1_Start"] = function()
						arg0_48:ReloadSkill("item")

						arg0_48.itemCount = arg0_48.itemCount - 1

						arg0_48:PlayAnim("Bomb_" .. var0_48 .. "_3_End")
						arg0_48.controller:BuildBomb({
							pos = arg0_48.pos,
							dir = var0_48
						})
					end,
					Dead = function()
						if arg0_48.isDead then
							arg0_48.controller:EndGame()
						end
					end
				})
			else
				assert(false)
			end
		end

		local var5_42 = {
			E = {
				"EF_Ghost_E_bk"
			},
			N = {
				"EF_Ghost_N_bk",
				"EF_Ghost_N_fr"
			},
			S = {
				"EF_Ghost_S_bk"
			},
			W = {
				"EF_Ghost_W_bk"
			}
		}

		function var0_42.RushCheck(arg0_57)
			if arg0_57.rushEffects then
				for iter0_57, iter1_57 in ipairs(arg0_57.rushEffects) do
					iter1_57:Remove()
				end

				arg0_57.rushEffects = nil
			end

			if arg0_57.inRush and arg0_57.loopAnimDic[arg0_57:GetStatusMark(arg0_57.status)] then
				arg0_57.rushEffects = {}

				for iter2_57, iter3_57 in ipairs(var5_42[arg0_57:GetDirMark()]) do
					local var0_57 = string.split(iter3_57, "_")

					table.insert(arg0_57.rushEffects, arg0_57.controller:CreateTarget({
						name = iter3_57,
						parent = arg0_57.rtScale:Find(var0_57[#var0_57])
					}))
				end
			end
		end

		function var0_42.OnTimerUpdate(arg0_58, arg1_58)
			for iter0_58, iter1_58 in pairs(arg0_58.skillCDs) do
				arg0_58.skillCDs[iter0_58] = iter1_58 - arg1_58
			end

			if arg0_58.inRush then
				arg0_58.inRush = arg0_58.inRush - arg1_58

				if arg0_58.inRush <= 0 then
					arg0_58.inRush = nil
				end
			end

			if arg0_58.inLantern then
				arg0_58.inLantern = arg0_58.inLantern - arg1_58
			end

			if arg0_58.inShock then
				arg0_58.inShock = arg0_58.inShock - arg1_58

				if arg0_58.inShock <= 0 then
					arg0_58.inShock = nil
				end

				return
			end

			if arg0_58.inCharge then
				arg0_58.inCharge = arg0_58.inCharge + arg1_58

				if arg0_58.inCharge > var2_42 then
					arg0_58.inCharge = nil

					arg0_58:PlayAnim(string.format("Freeze_%s_3_Shot", arg0_58:GetDirMark()))
				end
			elseif arg0_58.inMove then
				arg0_58.inMove = arg0_58.inMove - arg1_58 * arg0_58:GetSpeed()

				if arg0_58.inMove > 0 then
					arg0_58.realPos = arg0_58.pos - arg0_58:GetDirPos() * arg0_58.inMove
				else
					arg0_58.inMove = nil
					arg0_58.realPos = arg0_58.pos
				end

				arg0_58:UpdatePosition()
			elseif arg0_58.inLock then
				return
			elseif arg0_58.controller:InBlackHoleRange(arg0_58.pos, true) then
				arg0_58.inShock = 1

				arg0_58:PlayAnim("Dead")
			elseif arg0_58.inLantern and arg0_58.inLantern <= 0 then
				arg0_58.inLantern = nil

				arg0_58.effectLantern:PlayAnim("EF_bk_overlay_Lantern_Finish")

				arg0_58.effectLantern = nil
			elseif arg0_58:CheckSkill("ice") and arg0_58.controller:GetPressInput("Skill_0") then
				arg0_58:ReloadSkill("ice")

				if arg0_58.controller:CheckIce(arg0_58.pos + arg0_58:GetDirPos()) then
					arg0_58:PlayAnim(string.format("Attack_%s", arg0_58:GetDirMark()))
				else
					arg0_58.inCharge = 0

					arg0_58:PlayAnim(string.format("Freeze_%s_1_Start", arg0_58:GetDirMark()))
				end
			elseif arg0_58:CheckSkill("flash") and arg0_58.controller:GetPressInput("Skill_1") then
				arg0_58:ReloadSkill("flash")

				local var0_58 = arg0_58:GetDirPos()

				for iter2_58 = arg0_58.flashPower, 0, -1 do
					if arg0_58.controller:Moveable(arg0_58.pos + var0_58 * iter2_58) then
						arg0_58.controller:CreateTarget({
							name = "EF_bk_Flash_Jump",
							pos = arg0_58.pos
						})
						arg0_58:UpdatePos(arg0_58.pos + var0_58 * iter2_58)

						arg0_58.realPos = arg0_58.pos

						arg0_58:UpdatePosition()
						arg0_58.controller:CreateTarget({
							name = "EF_bk_Flash_Land",
							parent = arg0_58.rtScale:Find("bk")
						})
						arg0_58:PlayAnim(string.format("Flash_%s", arg0_58:GetDirMark()))

						break
					end
				end
			elseif arg0_58:CheckSkill("rush") and arg0_58.controller:GetPressInput("Skill_2") then
				arg0_58:ReloadSkill("rush")

				arg0_58.inRush = arg0_58.rushTime

				arg0_58:RushCheck()
			elseif arg0_58.itemType and arg0_58:CheckSkill("item") and arg0_58.controller:GetPressInput("Skill_3") and (arg0_58.itemType ~= "lantern" or not arg0_58.inLantern) then
				if arg0_58.itemType == "lantern" then
					arg0_58:PlayAnim("Lantern_Activate")
				elseif arg0_58.itemType == "bomb" then
					arg0_58:PlayAnim(string.format("Bomb_%s_1_Start", arg0_58:GetDirMark()))
				else
					assert(false)
				end
			else
				local var1_58 = arg0_58.controller:GetCacheInput()

				if not var1_58 then
					arg0_58.idleTime = defaultValue(arg0_58.idleTime, 0) - arg1_58

					arg0_58:PlayIdle()
				elseif arg0_58:GetStatusMark() == "Move" then
					if arg0_58.controller:Moveable(arg0_58.pos + arg0_58:GetDirPos(var1_58)) then
						arg0_58.inMove = 1

						arg0_58:UpdatePos(arg0_58.pos + arg0_58:GetDirPos(var1_58))
						arg0_58:PlayMove(var1_58)
					else
						arg0_58:PlayIdle(var1_58)
					end
				elseif var1_58 == arg0_58:GetDirMark() then
					if defaultValue(arg0_58.idleTime, 0) <= 0 and arg0_58.controller:Moveable(arg0_58.pos + arg0_58:GetDirPos()) then
						arg0_58.inMove = 1

						arg0_58:UpdatePos(arg0_58.pos + arg0_58:GetDirPos())
						arg0_58:PlayMove()
					else
						arg0_58.idleTime = defaultValue(arg0_58.idleTime, 0) - arg1_58

						arg0_58:PlayIdle()
					end
				else
					arg0_58.idleTime = var1_42

					arg0_58:PlayIdle(var1_58)
				end
			end
		end

		function var0_42.PopPoint(arg0_59, arg1_59)
			local var0_59 = arg0_59._tf:Find("top/pop")

			setText(var0_59:Find("Text"), "+" .. arg1_59)
			setActive(var0_59, false)
			setActive(var0_59, true)
		end

		function var0_42.EnemyHit(arg0_60, arg1_60)
			if arg0_60.isDead then
				return
			end

			if arg0_60.decoyCount > 0 then
				arg0_60.decoyCount = arg0_60.decoyCount - 1
				arg0_60.inCharge = nil
				arg0_60.inMove = nil

				arg0_60.controller:BuildDecoy(arg0_60.pos)

				local var0_60 = arg0_60.controller:GetDecoyPos(arg0_60.pos, arg1_60)

				arg0_60:UpdatePos(var0_60)

				arg0_60.realPos = arg0_60.pos

				arg0_60:UpdatePosition()
				arg0_60:PlayAnim("Decoy_2")
			else
				arg0_60.isDead = true
				arg0_60.inCharge = nil
				arg0_60.inMove = nil

				arg0_60:PlayAnim("Dead")
			end
		end

		function var0_42.UpdatePosition(arg0_61)
			var0_42.super.UpdatePosition(arg0_61)
			arg0_61.controller:WindowFocrus(arg0_61._tf.localPosition)

			if arg0_61.realPos == arg0_61.pos then
				arg0_61.controller:EatItem(arg0_61.pos)
			end
		end

		return var0_42
	end,
	TargetNenjuu = function()
		local var0_62 = class("TargetNenjuu", var0_0.TargetMove)

		function var0_62.GetSpeed(arg0_63)
			return arg0_63.speed * (arg0_63:CheckAbility("rush") and 1.2 or 1) * (arg0_63.inStealth and 1.3 or 1) * (arg0_63.isDoppel and 0.8 or 1)
		end

		local var1_62 = 1.5
		local var2_62 = 5
		local var3_62 = 5
		local var4_62 = 12
		local var5_62 = {
			gravity = 0,
			teleport = 7,
			doppelgangers = 0,
			delay = 0,
			blackhole = 20,
			stealth = 10,
			rush = 0,
			attack = 2,
			breakpassable = 0
		}

		function var0_62.CheckAbility(arg0_64, arg1_64)
			return arg0_64.featuresAbility[arg1_64] and arg0_64.abilityCDs[arg1_64] <= 0
		end

		function var0_62.ReloadAbility(arg0_65, arg1_65)
			arg0_65.abilityCDs[arg1_65] = var5_62[arg1_65]
		end

		function var0_62.InitUI(arg0_66, arg1_66)
			var0_62.super.InitUI(arg0_66, arg1_66)

			arg0_66.isDoppel = arg1_66.isDoppel
			arg0_66.speed = 1.5
			arg0_66.featuresAbility = {
				attack = true
			}

			for iter0_66, iter1_66 in ipairs(NenjuuGameConfig.ABILITY_LIST) do
				arg0_66.featuresAbility[iter1_66] = tobool(arg1_66.abilitys[iter1_66])
			end

			arg0_66.abilityCDs = {
				gravity = 0,
				teleport = 10,
				doppelgangers = 0,
				delay = 0,
				blackhole = 0,
				stealth = 0,
				rush = 0,
				attack = 0,
				breakpassable = 0
			}
		end

		function var0_62.EventAnim(arg0_67, arg1_67)
			local var0_67 = arg0_67:GetDirMark()

			if arg1_67 == "start" then
				-- block empty
			elseif arg1_67 == "trigger" then
				switch(arg0_67.status, {
					["Attack_" .. var0_67] = function()
						arg0_67.controller:CreateTarget({
							name = "EF_Attack_" .. var0_67,
							parent = arg0_67.rtScale:Find(var0_67 == "N" and "bk" or "fr")
						})

						if not arg0_67.isDoppel then
							arg0_67.controller:BreakIce({
								pos = arg0_67.pos,
								dir = arg0_67:GetDirMark(),
								dirPos = arg0_67:GetDirPos(),
								power = arg0_67:CheckAbility("breakpassable") and 3 or 1
							})
						end

						arg0_67.controller:EnemyAttack({
							pos = arg0_67.pos,
							dirPos = arg0_67:GetDirPos()
						})
					end
				})
			elseif arg1_67 == "end" then
				switch(arg0_67.status, {
					Warp_1_Jump = function()
						arg0_67:UpdatePos(arg0_67.telePos)

						arg0_67.realPos = arg0_67.pos

						arg0_67:UpdatePosition()

						arg0_67.telePos = nil

						arg0_67:PlayAnim("Warp_2_Land")
						arg0_67.controller:OnlyBreakIce(arg0_67.pos)
					end
				})
			else
				assert(false)
			end
		end

		local var6_62 = {
			E = {
				"EF_Nenjuu_Ghost_E_bk"
			},
			N = {
				"EF_Nenjuu_Ghost_N_bk",
				"EF_Nenjuu_Ghost_N_fr"
			},
			S = {
				"EF_Nenjuu_Ghost_S_bk"
			},
			W = {
				"EF_Nenjuu_Ghost_W_bk"
			}
		}

		function var0_62.RushCheck(arg0_70)
			if arg0_70.rushEffects then
				for iter0_70, iter1_70 in ipairs(arg0_70.rushEffects) do
					iter1_70:Remove()
				end

				arg0_70.rushEffects = nil
			end

			if arg0_70.inStealth and arg0_70.loopAnimDic[arg0_70:GetStatusMark(arg0_70.status)] then
				arg0_70.rushEffects = {}

				for iter2_70, iter3_70 in ipairs(var6_62[arg0_70:GetDirMark()]) do
					local var0_70 = string.split(iter3_70, "_")

					table.insert(arg0_70.rushEffects, arg0_70.controller:CreateTarget({
						name = iter3_70,
						parent = arg0_70.rtScale:Find(var0_70[#var0_70])
					}))
				end
			end
		end

		function var0_62.OnTimerUpdate(arg0_71, arg1_71)
			for iter0_71, iter1_71 in pairs(arg0_71.featuresAbility) do
				if iter1_71 and var5_62[iter0_71] > 0 then
					arg0_71.abilityCDs[iter0_71] = arg0_71.abilityCDs[iter0_71] - arg1_71
				end
			end

			if arg0_71.inStealth then
				arg0_71.inStealth = arg0_71.inStealth - arg1_71

				if arg0_71.inStealth <= 0 then
					arg0_71.inStealth = nil
				end
			end

			if arg0_71.inScare then
				arg0_71.inScare = arg0_71.inScare - arg1_71

				if arg0_71.inScare <= 0 then
					arg0_71.inScare = nil
				end
			end

			if arg0_71:CheckAbility("doppelgangers") and not arg0_71.isSummon then
				arg0_71.isSummon = true

				arg0_71.controller:BuildDoppelgangers(arg0_71.pos)
			end

			if arg0_71.inCharge then
				arg0_71.inCharge = arg0_71.inCharge + arg1_71

				if arg0_71.inCharge > var1_62 then
					arg0_71.inCharge = nil

					arg0_71:PlayAnim("Warp_1_Jump")
				end
			elseif arg0_71.inMove then
				arg0_71.inMove = arg0_71.inMove - arg1_71 * arg0_71:GetSpeed()

				if arg0_71.inMove > 0 then
					arg0_71.realPos = arg0_71.pos - arg0_71:GetDirPos() * arg0_71.inMove
				else
					arg0_71.inMove = nil
					arg0_71.realPos = arg0_71.pos
				end

				arg0_71:UpdatePosition()
			elseif arg0_71.inLock then
				return
			else
				if arg0_71:CheckAbility("blackhole") then
					arg0_71:ReloadAbility("blackhole")
					arg0_71.controller:BuildBlackHole()
				end

				if arg0_71:CheckAbility("stealth") and arg0_71.controller:StealthCheck(arg0_71.pos) and not arg0_71.inScare then
					arg0_71:ReloadAbility("stealth")

					arg0_71.inStealth = var2_62

					arg0_71:RushCheck()
				end

				if arg0_71:CheckAbility("attack") and not arg0_71.inScare then
					for iter2_71, iter3_71 in ipairs({
						"E",
						"S",
						"W",
						"N"
					}) do
						if arg0_71.controller:AttackCheck({
							pos = arg0_71.pos,
							dirPos = arg0_71:GetDirPos(iter3_71)
						}) then
							arg0_71:DoAttack(iter3_71)

							return
						end
					end
				end

				local var0_71 = arg0_71.controller:GetWayfindingMap(arg0_71.pos, tobool(arg0_71.isDoppel))
				local var1_71 = arg0_71.pos

				for iter4_71, iter5_71 in ipairs({
					"E",
					"S",
					"W",
					"N"
				}) do
					local var2_71 = var0_71[tostring(arg0_71.pos + arg0_71:GetDirPos(iter5_71))]

					if var2_71 then
						local var3_71 = var0_71[tostring(var1_71)]

						if arg0_71.inScare then
							if not var3_71 or var3_71.value < var2_71.value then
								var1_71 = arg0_71.pos + arg0_71:GetDirPos(iter5_71)
							end
						elseif not var3_71 or (var3_71.lightValue or var3_71.value) > (var2_71.lightValue or var2_71.value) then
							var1_71 = arg0_71.pos + arg0_71:GetDirPos(iter5_71)
						end
					end
				end

				if arg0_71:CheckAbility("teleport") and not arg0_71.inScare then
					if var1_71 == arg0_71.pos then
						if not arg0_71.lostTime then
							arg0_71.lostTime = 3 - arg1_71
						elseif arg1_71 >= arg0_71.lostTime and arg0_71.controller.timeCount > 5 then
							arg0_71.lostTime = nil

							arg0_71:DoTeleport(var0_71)
						else
							arg0_71.lostTime = arg0_71.lostTime - arg1_71
						end

						arg0_71:PlayIdle()

						return
					else
						arg0_71.lostTime = nil

						if var0_71[tostring(var1_71)] and var0_71[tostring(var1_71)].value > var4_62 then
							arg0_71:DoTeleport(var0_71)
							arg0_71:PlayIdle()

							return
						end
					end
				end

				if not arg0_71.isDoppel and arg0_71:CheckAbility("attack") and arg0_71.controller:CheckIce(var1_71) then
					arg0_71:DoAttack(arg0_71:GetDirMark(var1_71 - arg0_71.pos))
				elseif arg0_71.controller:Moveable(var1_71) then
					local var4_71 = arg0_71:GetDirMark(var1_71 - arg0_71.pos)

					arg0_71.inMove = 1

					arg0_71:UpdatePos(var1_71)

					if arg0_71.inScare then
						arg0_71:PlayAnim("Fear_" .. var4_71)
					else
						arg0_71:PlayMove(var4_71)
					end
				elseif arg0_71.inScare then
					arg0_71:PlayAnim("Fear_" .. arg0_71:GetDirMark())
				else
					arg0_71:PlayIdle()
				end
			end
		end

		function var0_62.DoAttack(arg0_72, arg1_72)
			if arg0_72.inStealth then
				arg0_72.inStealth = nil
			end

			arg0_72:ReloadAbility("attack")
			arg0_72:PlayAnim(string.format("Attack_%s", arg1_72))
		end

		function var0_62.DoTeleport(arg0_73, arg1_73)
			if arg0_73.inStealth then
				arg0_73.inStealth = nil
			end

			arg0_73:ReloadAbility("teleport")

			arg0_73.inCharge = 0
			arg0_73.telePos = arg0_73.controller:GetTeleportTargetPos(arg1_73, arg0_73.pos)

			arg0_73.controller:BuildTeleportSign({
				pos = arg0_73.telePos,
				time = var1_62
			})
		end

		function var0_62.BeScare(arg0_74)
			arg0_74.inCharge = nil
			arg0_74.inStealth = nil
			arg0_74.inScare = var3_62

			if not arg0_74.inMove then
				arg0_74:PlayIdle()
			end
		end

		return var0_62
	end,
	TargetEffect = function()
		local var0_75 = class("TargetEffect", var0_0.TargetObject)

		function var0_75.Moveable(arg0_76)
			return true
		end

		function var0_75.GetBaseOrder(arg0_77)
			return 5
		end

		function var0_75.InitUI(arg0_78, arg1_78)
			arg0_78.mainTarget = arg0_78._tf:Find("scale/Image")

			arg0_78.mainTarget:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
				arg0_78.controller:DestoryTarget(arg0_78)
			end)
		end

		return var0_75
	end,
	TargetBomb = function()
		local var0_80 = class("TargetBomb", var0_0.TargetEffect)

		function var0_80.InTimeLine(arg0_81)
			return true
		end

		function var0_80.GetBaseOrder(arg0_82)
			return 1
		end

		function var0_80.OnTimerUpdate(arg0_83, arg1_83)
			arg0_83.controller:ScareEnemy({
				range = 1,
				pos = arg0_83.pos
			})
		end

		return var0_80
	end,
	TargetTimeEffect = function()
		local var0_84 = class("TargetTimeEffect", var0_0.TargetEffect)

		function var0_84.GetBaseOrder(arg0_85)
			return 1
		end

		function var0_84.InTimeLine(arg0_86)
			return true
		end

		function var0_84.InitUI(arg0_87, arg1_87)
			arg0_87.time = arg1_87.time
		end

		function var0_84.OnTimerUpdate(arg0_88, arg1_88)
			if arg1_88 < arg0_88.time then
				arg0_88.time = arg0_88.time - arg1_88
			else
				arg0_88.controller:DestoryTarget(arg0_88)
			end
		end

		return var0_84
	end,
	TargetBlackHole = function()
		local var0_89 = class("TargetBlackHole", var0_0.TargetEffect)

		function var0_89.InTimeLine(arg0_90)
			return true
		end

		function var0_89.GetBaseOrder(arg0_91)
			return 3
		end

		function var0_89.InitUI(arg0_92, arg1_92)
			var0_89.super.InitUI(arg0_92, arg1_92)

			arg0_92.time = arg1_92.time
		end

		function var0_89.OnTimerUpdate(arg0_93, arg1_93)
			if arg0_93.isLost then
				return
			end

			arg0_93.controller:OnlyBreakIce(arg0_93.pos)

			if arg1_93 < arg0_93.time then
				arg0_93.time = arg0_93.time - arg1_93
			else
				arg0_93.isLost = true

				arg0_93:PlayAnim("BlackHole_3_Despawn")
			end
		end

		function var0_89.BeTrigger(arg0_94)
			if arg0_94.isLost then
				return
			else
				arg0_94.isLost = true

				arg0_94:PlayAnim("BlackHole_3_Despawn")
			end
		end

		return var0_89
	end,
	TargetSubEffect = function()
		local var0_95 = class("TargetSubEffect", var0_0.TargetObject)

		function var0_95.Init(arg0_96, arg1_96)
			arg0_96.name = arg1_96.name

			arg0_96:InitUI(arg1_96)
		end

		function var0_95.InitUI(arg0_97, arg1_97)
			arg0_97.mainTarget = arg0_97._tf:Find("scale/Image")

			arg0_97.mainTarget:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
				Destroy(arg0_97._tf)
			end)
		end

		return var0_95
	end,
	TargetRushEffect = function()
		local var0_99 = class("TargetRushEffect", var0_0.TargetSubEffect)

		function var0_99.InTimeLine(arg0_100)
			return true
		end

		function var0_99.InitUI(arg0_101, arg1_101)
			arg0_101.rtScale = arg0_101._tf:Find("scale")

			GetOrAddComponent(arg0_101.rtScale, typeof(CanvasGroup))

			arg0_101.alpha = 0

			setCanvasGroupAlpha(arg0_101.rtScale, arg0_101.alpha)
		end

		local var1_99 = 0.01

		function var0_99.OnTimerUpdate(arg0_102, arg1_102)
			if arg0_102.inRemove then
				arg0_102.alpha = arg0_102.alpha - arg1_102 / var1_99

				if arg0_102.alpha <= 0 then
					table.removebyvalue(arg0_102.controller.timeFlow, arg0_102)
					Destroy(arg0_102._tf)
				end
			elseif arg0_102.alpha < 1 then
				arg0_102.alpha = math.max(1, arg0_102.alpha + arg1_102 / var1_99)

				setCanvasGroupAlpha(arg0_102.rtScale, arg0_102.alpha)
			end
		end

		function var0_99.Remove(arg0_103)
			arg0_103.inRemove = true
		end

		return var0_99
	end
}

for iter0_0, iter1_0 in ipairs({
	"TargetObject",
	"TargetIce",
	"TargetMove",
	"TargetFuShun",
	"TargetNenjuu",
	"TargetEffect",
	"TargetBomb",
	"TargetTimeEffect",
	"TargetBlackHole",
	"TargetSubEffect",
	"TargetItem",
	"TargetRushEffect",
	"TargetArbor"
}) do
	var0_0[iter1_0] = var1_0[iter1_0]()
end

return var0_0
