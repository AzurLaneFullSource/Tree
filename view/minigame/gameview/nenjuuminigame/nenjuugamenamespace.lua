local var0 = {}
local var1 = {
	TargetObject = function()
		local var0 = class("TargetObject")

		function var0.GetSize(arg0)
			return arg0.size
		end

		function var0.InTimeLine(arg0)
			return false
		end

		function var0.Moveable(arg0)
			return false
		end

		function var0.BreakMoveable(arg0)
			return false
		end

		function var0.GetBaseOrder(arg0)
			return 3
		end

		function var0.Ctor(arg0, arg1, arg2, arg3)
			arg0._tf = arg2
			arg0.controller = arg1

			arg0:Init(arg3)
		end

		function var0.Init(arg0, arg1)
			arg0.name = arg1.name
			arg0.size = arg1.size or NewPos(1, 1)
			arg0.canHide = arg1.hide

			setCanvasOverrideSorting(arg0._tf, true)
			arg0:UpdatePos(arg1.pos - NewPos(0, arg0:GetSize().y - 1))

			arg0.realPos = arg1.realPos or arg0.pos

			arg0:UpdatePosition()
			arg0:InitUI(arg1)
		end

		function var0.InitUI(arg0, arg1)
			return
		end

		function var0.UpdatePos(arg0, arg1)
			arg0._tf:GetComponent(typeof(Canvas)).sortingOrder = (arg1.y + arg0:GetSize().y) * 10 + arg0:GetBaseOrder()

			arg0.controller:UpdateTargetPos(arg0, arg0.pos, arg1)

			arg0.pos = arg1
		end

		function var0.UpdatePosition(arg0)
			setAnchoredPosition(arg0._tf, {
				x = arg0.realPos.x * 32,
				y = arg0.realPos.y * -32
			})
		end

		function var0.PlayAnim(arg0, arg1)
			if arg0.status ~= arg1 then
				arg0.status = arg1

				arg0.mainTarget:GetComponent(typeof(Animator)):Play(arg1, -1, 0)
			end
		end

		return var0
	end,
	TargetIce = function()
		local var0 = class("TargetIce", var0.TargetObject)

		function var0.BreakMoveable(arg0)
			return true
		end

		function var0.InitUI(arg0, arg1)
			arg0.mainTarget = arg0._tf:Find("scale/Image")

			arg0.mainTarget:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
				arg0.controller:DestoryTarget(arg0)
			end)

			if arg1.create then
				if arg0.controller:CheckMelt(arg0.pos) then
					arg0.isLost = true

					arg0:PlayAnim("Ice_Spawn_Melt")
				else
					arg0:PlayAnim("Ice_Spawn")
				end
			end
		end

		function var0.Break(arg0)
			if arg0.isLost then
				return
			else
				arg0.isLost = true

				arg0:PlayAnim("Ice_Break")
			end
		end

		return var0
	end,
	TargetItem = function()
		local var0 = class("TargetItem", var0.TargetObject)

		function var0.Moveable(arg0)
			return true
		end

		function var0.GetBaseOrder(arg0)
			return 2
		end

		function var0.InitUI(arg0, arg1)
			arg0.point = arg1.point

			eachChild(arg0._tf:Find("scale/type"), function(arg0)
				setActive(arg0, arg0.name == arg0.name)
			end)
		end

		return var0
	end,
	TargetArbor = function()
		local var0 = class("TargetArbor", var0.TargetObject)

		function var0.InitUI(arg0, arg1)
			local var0 = string.split(arg0.name, "_")

			eachChild(arg0._tf:Find("scale/Image"), function(arg0)
				setActive(arg0, arg0.name == var0[#var0])
			end)
		end

		return var0
	end,
	TargetMove = function()
		local var0 = class("TargetMove", var0.TargetObject)

		function var0.InTimeLine(arg0)
			return true
		end

		function var0.GetBaseOrder(arg0)
			return 4
		end

		function var0.InitUI(arg0, arg1)
			arg0.rtScale = arg0._tf:Find("scale")
			arg0.mainTarget = arg0.rtScale:Find("main")

			local var0 = arg0.mainTarget:GetComponent(typeof(DftAniEvent))

			var0:SetStartEvent(function()
				arg0:EventAnim("start")
			end)
			var0:SetTriggerEvent(function()
				arg0:EventAnim("trigger")
			end)
			var0:SetEndEvent(function()
				arg0.inLock = false

				arg0:EventAnim("end")
			end)
			arg0:PlayIdle()
		end

		function var0.EventAnim(arg0, arg1)
			return
		end

		function var0.RushCheck(arg0)
			return
		end

		function var0.PlayIdle(arg0, arg1)
			arg0:PlayAnim(string.format("Idle_%s%s", arg1 or arg0:GetDirMark(), arg0.inLantern and "_Lantern" or ""))
		end

		function var0.PlayMove(arg0, arg1)
			arg0:PlayAnim(string.format("Move_%s%s", arg1 or arg0:GetDirMark(), arg0.inLantern and "_Lantern" or ""))
		end

		local var1 = {
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

		function var0.GetDirMark(arg0, arg1)
			if arg1 then
				for iter0, iter1 in pairs(var1) do
					if iter1[1] == arg1.x and iter1[2] == arg1.y then
						return iter0
					end
				end
			else
				local var0 = string.split(arg0.status, "_")[2]

				return var1[var0] and var0 or "S"
			end
		end

		function var0.GetDirPos(arg0, arg1)
			return NewPos(unpack(var1[arg1 or arg0:GetDirMark()]))
		end

		function var0.GetStatusMark(arg0, arg1)
			return string.split(arg1 or arg0.status, "_")[1]
		end

		function var0.OnTimerUpdate(arg0, arg1)
			return
		end

		var0.loopAnimDic = {
			Fear = true,
			Idle = true,
			Move = true
		}

		function var0.PlayAnim(arg0, arg1)
			local var0 = tobool(arg0.loopAnimDic[arg0:GetStatusMark(arg1)])

			if var0 and arg0.status == arg1 then
				-- block empty
			else
				arg0.inLock = not var0
				arg0.status = arg1

				arg0.mainTarget:GetComponent(typeof(Animator)):Play(arg1, -1, 0)
				arg0:RushCheck()
			end
		end

		return var0
	end,
	TargetFuShun = function()
		local var0 = class("TargetFuShun", var0.TargetMove)

		function var0.GetSpeed(arg0)
			return arg0.speed * (arg0.controller:GetEnemyEffect("gravity") and 0.85 or 1) * (arg0.inRush and NenjuuGameConfig.GetSkillParam("rush", arg0.level.rush)[2] or 1) * (arg0.controller:InBlackHoleRange(arg0.pos) and 0.75 or 1) * (NenjuuGameConfig.GetSkillParam("blessing", arg0.level.blessing) or 1)
		end

		local var1 = 0.1
		local var2 = 0.1
		local var3 = 5
		local var4 = {
			ice = 1,
			flash = 30,
			item = 0,
			rush = 20
		}

		function var0.CheckSkill(arg0, arg1)
			if arg1 == "item" then
				return arg0.itemType and arg0.itemCount > 0
			else
				return arg0.level[arg1] > 0 and arg0.skillCDs[arg1] <= 0
			end
		end

		function var0.ReloadSkill(arg0, arg1)
			arg0.skillCDs[arg1] = (arg1 == "flash" and NenjuuGameConfig.GetSkillParam("flash", arg0.level.flash) or var4[arg1]) * (arg0.controller:GetEnemyEffect("delay") and 1.2 or 1)
		end

		function var0.InitUI(arg0, arg1)
			var0.super.InitUI(arg0, arg1)

			arg0.level = arg1.level
			arg0.skillCDs = {
				ice = 0,
				flash = 0,
				item = 0,
				rush = 0
			}
			arg0.itemType = arg1.itemType
			arg0.speed = 4.5
			arg0.icePower = NenjuuGameConfig.GetSkillParam("ice", arg0.level.ice)
			arg0.flashPower = 4
			arg0.decoyCount = arg0.level.decoy
			arg0.rushTime = checkExist(NenjuuGameConfig.GetSkillParam("rush", arg0.level.rush), {
				1
			})
			arg0.itemCount = 1
		end

		function var0.CalcSkillCDs(arg0)
			local var0 = {}

			for iter0, iter1 in ipairs({
				"ice",
				"flash",
				"rush",
				"item"
			}) do
				local var1 = arg0.skillCDs[iter1]
				local var2 = (iter1 == "flash" and NenjuuGameConfig.GetSkillParam("flash", arg0.level.flash) or var4[iter1]) * (arg0.controller:GetEnemyEffect("delay") and 1.2 or 1)

				if iter1 == "item" then
					if not arg0.itemType then
						table.insert(var0, {})
					elseif arg0.itemCount > 0 then
						table.insert(var0, {
							cd = var1,
							icon = arg0.itemType
						})
					else
						table.insert(var0, {
							cd = true,
							icon = arg0.itemType
						})
					end
				elseif arg0.level[iter1] > 0 then
					table.insert(var0, {
						cd = var1,
						rate = var2 == 0 and 0 or var1 / var2,
						icon = iter1 == "ice" and arg0.controller:CheckIce(arg0.pos + arg0:GetDirPos()) and "attack" or iter1
					})
				else
					table.insert(var0, {})
				end
			end

			return var0
		end

		function var0.EventAnim(arg0, arg1)
			local var0 = arg0:GetDirMark()

			if arg1 == "start" then
				-- block empty
			elseif arg1 == "trigger" then
				switch(arg0.status, {
					["Freeze_" .. var0 .. "_3_Shot"] = function()
						arg0.controller:CreateTarget({
							name = "EF_bk_Freeze",
							parent = arg0.rtScale:Find("bk")
						})
						arg0.controller:BuildIce({
							pos = arg0.pos,
							dirPos = arg0:GetDirPos(),
							power = arg0.icePower
						})
					end,
					["Attack_" .. var0] = function()
						switch(var0, {
							N = function()
								arg0.controller:CreateTarget({
									name = "EF_Attack_Hit_" .. var0,
									parent = arg0.rtScale:Find("bk")
								})
							end,
							S = function()
								arg0.controller:CreateTarget({
									name = "EF_Attack_Hit_" .. var0,
									parent = arg0.rtScale:Find("fr")
								})
							end
						}, function()
							arg0.controller:CreateTarget({
								name = "EF_Attack_Hit_" .. var0 .. "_fr",
								parent = arg0.rtScale:Find("fr")
							})
							arg0.controller:CreateTarget({
								name = "EF_Attack_Hit_" .. var0 .. "_bk",
								parent = arg0.rtScale:Find("bk")
							})
						end)
						arg0.controller:BreakIce({
							pos = arg0.pos,
							dir = arg0:GetDirMark(),
							dirPos = arg0:GetDirPos()
						})
					end,
					Lantern_Activate = function()
						arg0:ReloadSkill("item")

						arg0.itemCount = arg0.itemCount - 1
						arg0.inLantern = var3
						arg0.effectLantern = arg0.controller:CreateTarget({
							name = "EF_bk_overlay_Lantern",
							parent = arg0.rtScale:Find("bk"),
							time = var3
						})
					end
				})
			elseif arg1 == "end" then
				switch(arg0.status, {
					["Bomb_" .. var0 .. "_1_Start"] = function()
						arg0:ReloadSkill("item")

						arg0.itemCount = arg0.itemCount - 1

						arg0:PlayAnim("Bomb_" .. var0 .. "_3_End")
						arg0.controller:BuildBomb({
							pos = arg0.pos,
							dir = var0
						})
					end,
					Dead = function()
						if arg0.isDead then
							arg0.controller:EndGame()
						end
					end
				})
			else
				assert(false)
			end
		end

		local var5 = {
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

		function var0.RushCheck(arg0)
			if arg0.rushEffects then
				for iter0, iter1 in ipairs(arg0.rushEffects) do
					iter1:Remove()
				end

				arg0.rushEffects = nil
			end

			if arg0.inRush and arg0.loopAnimDic[arg0:GetStatusMark(arg0.status)] then
				arg0.rushEffects = {}

				for iter2, iter3 in ipairs(var5[arg0:GetDirMark()]) do
					local var0 = string.split(iter3, "_")

					table.insert(arg0.rushEffects, arg0.controller:CreateTarget({
						name = iter3,
						parent = arg0.rtScale:Find(var0[#var0])
					}))
				end
			end
		end

		function var0.OnTimerUpdate(arg0, arg1)
			for iter0, iter1 in pairs(arg0.skillCDs) do
				arg0.skillCDs[iter0] = iter1 - arg1
			end

			if arg0.inRush then
				arg0.inRush = arg0.inRush - arg1

				if arg0.inRush <= 0 then
					arg0.inRush = nil
				end
			end

			if arg0.inLantern then
				arg0.inLantern = arg0.inLantern - arg1
			end

			if arg0.inShock then
				arg0.inShock = arg0.inShock - arg1

				if arg0.inShock <= 0 then
					arg0.inShock = nil
				end

				return
			end

			if arg0.inCharge then
				arg0.inCharge = arg0.inCharge + arg1

				if arg0.inCharge > var2 then
					arg0.inCharge = nil

					arg0:PlayAnim(string.format("Freeze_%s_3_Shot", arg0:GetDirMark()))
				end
			elseif arg0.inMove then
				arg0.inMove = arg0.inMove - arg1 * arg0:GetSpeed()

				if arg0.inMove > 0 then
					arg0.realPos = arg0.pos - arg0:GetDirPos() * arg0.inMove
				else
					arg0.inMove = nil
					arg0.realPos = arg0.pos
				end

				arg0:UpdatePosition()
			elseif arg0.inLock then
				return
			elseif arg0.controller:InBlackHoleRange(arg0.pos, true) then
				arg0.inShock = 1

				arg0:PlayAnim("Dead")
			elseif arg0.inLantern and arg0.inLantern <= 0 then
				arg0.inLantern = nil

				arg0.effectLantern:PlayAnim("EF_bk_overlay_Lantern_Finish")

				arg0.effectLantern = nil
			elseif arg0:CheckSkill("ice") and arg0.controller:GetPressInput("Skill_0") then
				arg0:ReloadSkill("ice")

				if arg0.controller:CheckIce(arg0.pos + arg0:GetDirPos()) then
					arg0:PlayAnim(string.format("Attack_%s", arg0:GetDirMark()))
				else
					arg0.inCharge = 0

					arg0:PlayAnim(string.format("Freeze_%s_1_Start", arg0:GetDirMark()))
				end
			elseif arg0:CheckSkill("flash") and arg0.controller:GetPressInput("Skill_1") then
				arg0:ReloadSkill("flash")

				local var0 = arg0:GetDirPos()

				for iter2 = arg0.flashPower, 0, -1 do
					if arg0.controller:Moveable(arg0.pos + var0 * iter2) then
						arg0.controller:CreateTarget({
							name = "EF_bk_Flash_Jump",
							pos = arg0.pos
						})
						arg0:UpdatePos(arg0.pos + var0 * iter2)

						arg0.realPos = arg0.pos

						arg0:UpdatePosition()
						arg0.controller:CreateTarget({
							name = "EF_bk_Flash_Land",
							parent = arg0.rtScale:Find("bk")
						})
						arg0:PlayAnim(string.format("Flash_%s", arg0:GetDirMark()))

						break
					end
				end
			elseif arg0:CheckSkill("rush") and arg0.controller:GetPressInput("Skill_2") then
				arg0:ReloadSkill("rush")

				arg0.inRush = arg0.rushTime

				arg0:RushCheck()
			elseif arg0.itemType and arg0:CheckSkill("item") and arg0.controller:GetPressInput("Skill_3") and (arg0.itemType ~= "lantern" or not arg0.inLantern) then
				if arg0.itemType == "lantern" then
					arg0:PlayAnim("Lantern_Activate")
				elseif arg0.itemType == "bomb" then
					arg0:PlayAnim(string.format("Bomb_%s_1_Start", arg0:GetDirMark()))
				else
					assert(false)
				end
			else
				local var1 = arg0.controller:GetCacheInput()

				if not var1 then
					arg0.idleTime = defaultValue(arg0.idleTime, 0) - arg1

					arg0:PlayIdle()
				elseif arg0:GetStatusMark() == "Move" then
					if arg0.controller:Moveable(arg0.pos + arg0:GetDirPos(var1)) then
						arg0.inMove = 1

						arg0:UpdatePos(arg0.pos + arg0:GetDirPos(var1))
						arg0:PlayMove(var1)
					else
						arg0:PlayIdle(var1)
					end
				elseif var1 == arg0:GetDirMark() then
					if defaultValue(arg0.idleTime, 0) <= 0 and arg0.controller:Moveable(arg0.pos + arg0:GetDirPos()) then
						arg0.inMove = 1

						arg0:UpdatePos(arg0.pos + arg0:GetDirPos())
						arg0:PlayMove()
					else
						arg0.idleTime = defaultValue(arg0.idleTime, 0) - arg1

						arg0:PlayIdle()
					end
				else
					arg0.idleTime = var1

					arg0:PlayIdle(var1)
				end
			end
		end

		function var0.PopPoint(arg0, arg1)
			local var0 = arg0._tf:Find("top/pop")

			setText(var0:Find("Text"), "+" .. arg1)
			setActive(var0, false)
			setActive(var0, true)
		end

		function var0.EnemyHit(arg0, arg1)
			if arg0.isDead then
				return
			end

			if arg0.decoyCount > 0 then
				arg0.decoyCount = arg0.decoyCount - 1
				arg0.inCharge = nil
				arg0.inMove = nil

				arg0.controller:BuildDecoy(arg0.pos)

				local var0 = arg0.controller:GetDecoyPos(arg0.pos, arg1)

				arg0:UpdatePos(var0)

				arg0.realPos = arg0.pos

				arg0:UpdatePosition()
				arg0:PlayAnim("Decoy_2")
			else
				arg0.isDead = true
				arg0.inCharge = nil
				arg0.inMove = nil

				arg0:PlayAnim("Dead")
			end
		end

		function var0.UpdatePosition(arg0)
			var0.super.UpdatePosition(arg0)
			arg0.controller:WindowFocrus(arg0._tf.localPosition)

			if arg0.realPos == arg0.pos then
				arg0.controller:EatItem(arg0.pos)
			end
		end

		return var0
	end,
	TargetNenjuu = function()
		local var0 = class("TargetNenjuu", var0.TargetMove)

		function var0.GetSpeed(arg0)
			return arg0.speed * (arg0:CheckAbility("rush") and 1.2 or 1) * (arg0.inStealth and 1.3 or 1) * (arg0.isDoppel and 0.8 or 1)
		end

		local var1 = 1.5
		local var2 = 5
		local var3 = 5
		local var4 = 12
		local var5 = {
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

		function var0.CheckAbility(arg0, arg1)
			return arg0.featuresAbility[arg1] and arg0.abilityCDs[arg1] <= 0
		end

		function var0.ReloadAbility(arg0, arg1)
			arg0.abilityCDs[arg1] = var5[arg1]
		end

		function var0.InitUI(arg0, arg1)
			var0.super.InitUI(arg0, arg1)

			arg0.isDoppel = arg1.isDoppel
			arg0.speed = 1.5
			arg0.featuresAbility = {
				attack = true
			}

			for iter0, iter1 in ipairs(NenjuuGameConfig.ABILITY_LIST) do
				arg0.featuresAbility[iter1] = tobool(arg1.abilitys[iter1])
			end

			arg0.abilityCDs = {
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

		function var0.EventAnim(arg0, arg1)
			local var0 = arg0:GetDirMark()

			if arg1 == "start" then
				-- block empty
			elseif arg1 == "trigger" then
				switch(arg0.status, {
					["Attack_" .. var0] = function()
						arg0.controller:CreateTarget({
							name = "EF_Attack_" .. var0,
							parent = arg0.rtScale:Find(var0 == "N" and "bk" or "fr")
						})

						if not arg0.isDoppel then
							arg0.controller:BreakIce({
								pos = arg0.pos,
								dir = arg0:GetDirMark(),
								dirPos = arg0:GetDirPos(),
								power = arg0:CheckAbility("breakpassable") and 3 or 1
							})
						end

						arg0.controller:EnemyAttack({
							pos = arg0.pos,
							dirPos = arg0:GetDirPos()
						})
					end
				})
			elseif arg1 == "end" then
				switch(arg0.status, {
					Warp_1_Jump = function()
						arg0:UpdatePos(arg0.telePos)

						arg0.realPos = arg0.pos

						arg0:UpdatePosition()

						arg0.telePos = nil

						arg0:PlayAnim("Warp_2_Land")
						arg0.controller:OnlyBreakIce(arg0.pos)
					end
				})
			else
				assert(false)
			end
		end

		local var6 = {
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

		function var0.RushCheck(arg0)
			if arg0.rushEffects then
				for iter0, iter1 in ipairs(arg0.rushEffects) do
					iter1:Remove()
				end

				arg0.rushEffects = nil
			end

			if arg0.inStealth and arg0.loopAnimDic[arg0:GetStatusMark(arg0.status)] then
				arg0.rushEffects = {}

				for iter2, iter3 in ipairs(var6[arg0:GetDirMark()]) do
					local var0 = string.split(iter3, "_")

					table.insert(arg0.rushEffects, arg0.controller:CreateTarget({
						name = iter3,
						parent = arg0.rtScale:Find(var0[#var0])
					}))
				end
			end
		end

		function var0.OnTimerUpdate(arg0, arg1)
			for iter0, iter1 in pairs(arg0.featuresAbility) do
				if iter1 and var5[iter0] > 0 then
					arg0.abilityCDs[iter0] = arg0.abilityCDs[iter0] - arg1
				end
			end

			if arg0.inStealth then
				arg0.inStealth = arg0.inStealth - arg1

				if arg0.inStealth <= 0 then
					arg0.inStealth = nil
				end
			end

			if arg0.inScare then
				arg0.inScare = arg0.inScare - arg1

				if arg0.inScare <= 0 then
					arg0.inScare = nil
				end
			end

			if arg0:CheckAbility("doppelgangers") and not arg0.isSummon then
				arg0.isSummon = true

				arg0.controller:BuildDoppelgangers(arg0.pos)
			end

			if arg0.inCharge then
				arg0.inCharge = arg0.inCharge + arg1

				if arg0.inCharge > var1 then
					arg0.inCharge = nil

					arg0:PlayAnim("Warp_1_Jump")
				end
			elseif arg0.inMove then
				arg0.inMove = arg0.inMove - arg1 * arg0:GetSpeed()

				if arg0.inMove > 0 then
					arg0.realPos = arg0.pos - arg0:GetDirPos() * arg0.inMove
				else
					arg0.inMove = nil
					arg0.realPos = arg0.pos
				end

				arg0:UpdatePosition()
			elseif arg0.inLock then
				return
			else
				if arg0:CheckAbility("blackhole") then
					arg0:ReloadAbility("blackhole")
					arg0.controller:BuildBlackHole()
				end

				if arg0:CheckAbility("stealth") and arg0.controller:StealthCheck(arg0.pos) and not arg0.inScare then
					arg0:ReloadAbility("stealth")

					arg0.inStealth = var2

					arg0:RushCheck()
				end

				if arg0:CheckAbility("attack") and not arg0.inScare then
					for iter2, iter3 in ipairs({
						"E",
						"S",
						"W",
						"N"
					}) do
						if arg0.controller:AttackCheck({
							pos = arg0.pos,
							dirPos = arg0:GetDirPos(iter3)
						}) then
							arg0:DoAttack(iter3)

							return
						end
					end
				end

				local var0 = arg0.controller:GetWayfindingMap(arg0.pos, tobool(arg0.isDoppel))
				local var1 = arg0.pos

				for iter4, iter5 in ipairs({
					"E",
					"S",
					"W",
					"N"
				}) do
					local var2 = var0[tostring(arg0.pos + arg0:GetDirPos(iter5))]

					if var2 then
						local var3 = var0[tostring(var1)]

						if arg0.inScare then
							if not var3 or var3.value < var2.value then
								var1 = arg0.pos + arg0:GetDirPos(iter5)
							end
						elseif not var3 or (var3.lightValue or var3.value) > (var2.lightValue or var2.value) then
							var1 = arg0.pos + arg0:GetDirPos(iter5)
						end
					end
				end

				if arg0:CheckAbility("teleport") and not arg0.inScare then
					if var1 == arg0.pos then
						if not arg0.lostTime then
							arg0.lostTime = 3 - arg1
						elseif arg1 >= arg0.lostTime and arg0.controller.timeCount > 5 then
							arg0.lostTime = nil

							arg0:DoTeleport(var0)
						else
							arg0.lostTime = arg0.lostTime - arg1
						end

						arg0:PlayIdle()

						return
					else
						arg0.lostTime = nil

						if var0[tostring(var1)] and var0[tostring(var1)].value > var4 then
							arg0:DoTeleport(var0)
							arg0:PlayIdle()

							return
						end
					end
				end

				if not arg0.isDoppel and arg0:CheckAbility("attack") and arg0.controller:CheckIce(var1) then
					arg0:DoAttack(arg0:GetDirMark(var1 - arg0.pos))
				elseif arg0.controller:Moveable(var1) then
					local var4 = arg0:GetDirMark(var1 - arg0.pos)

					arg0.inMove = 1

					arg0:UpdatePos(var1)

					if arg0.inScare then
						arg0:PlayAnim("Fear_" .. var4)
					else
						arg0:PlayMove(var4)
					end
				elseif arg0.inScare then
					arg0:PlayAnim("Fear_" .. arg0:GetDirMark())
				else
					arg0:PlayIdle()
				end
			end
		end

		function var0.DoAttack(arg0, arg1)
			if arg0.inStealth then
				arg0.inStealth = nil
			end

			arg0:ReloadAbility("attack")
			arg0:PlayAnim(string.format("Attack_%s", arg1))
		end

		function var0.DoTeleport(arg0, arg1)
			if arg0.inStealth then
				arg0.inStealth = nil
			end

			arg0:ReloadAbility("teleport")

			arg0.inCharge = 0
			arg0.telePos = arg0.controller:GetTeleportTargetPos(arg1, arg0.pos)

			arg0.controller:BuildTeleportSign({
				pos = arg0.telePos,
				time = var1
			})
		end

		function var0.BeScare(arg0)
			arg0.inCharge = nil
			arg0.inStealth = nil
			arg0.inScare = var3

			if not arg0.inMove then
				arg0:PlayIdle()
			end
		end

		return var0
	end,
	TargetEffect = function()
		local var0 = class("TargetEffect", var0.TargetObject)

		function var0.Moveable(arg0)
			return true
		end

		function var0.GetBaseOrder(arg0)
			return 5
		end

		function var0.InitUI(arg0, arg1)
			arg0.mainTarget = arg0._tf:Find("scale/Image")

			arg0.mainTarget:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
				arg0.controller:DestoryTarget(arg0)
			end)
		end

		return var0
	end,
	TargetBomb = function()
		local var0 = class("TargetBomb", var0.TargetEffect)

		function var0.InTimeLine(arg0)
			return true
		end

		function var0.GetBaseOrder(arg0)
			return 1
		end

		function var0.OnTimerUpdate(arg0, arg1)
			arg0.controller:ScareEnemy({
				range = 1,
				pos = arg0.pos
			})
		end

		return var0
	end,
	TargetTimeEffect = function()
		local var0 = class("TargetTimeEffect", var0.TargetEffect)

		function var0.GetBaseOrder(arg0)
			return 1
		end

		function var0.InTimeLine(arg0)
			return true
		end

		function var0.InitUI(arg0, arg1)
			arg0.time = arg1.time
		end

		function var0.OnTimerUpdate(arg0, arg1)
			if arg1 < arg0.time then
				arg0.time = arg0.time - arg1
			else
				arg0.controller:DestoryTarget(arg0)
			end
		end

		return var0
	end,
	TargetBlackHole = function()
		local var0 = class("TargetBlackHole", var0.TargetEffect)

		function var0.InTimeLine(arg0)
			return true
		end

		function var0.GetBaseOrder(arg0)
			return 3
		end

		function var0.InitUI(arg0, arg1)
			var0.super.InitUI(arg0, arg1)

			arg0.time = arg1.time
		end

		function var0.OnTimerUpdate(arg0, arg1)
			if arg0.isLost then
				return
			end

			arg0.controller:OnlyBreakIce(arg0.pos)

			if arg1 < arg0.time then
				arg0.time = arg0.time - arg1
			else
				arg0.isLost = true

				arg0:PlayAnim("BlackHole_3_Despawn")
			end
		end

		function var0.BeTrigger(arg0)
			if arg0.isLost then
				return
			else
				arg0.isLost = true

				arg0:PlayAnim("BlackHole_3_Despawn")
			end
		end

		return var0
	end,
	TargetSubEffect = function()
		local var0 = class("TargetSubEffect", var0.TargetObject)

		function var0.Init(arg0, arg1)
			arg0.name = arg1.name

			arg0:InitUI(arg1)
		end

		function var0.InitUI(arg0, arg1)
			arg0.mainTarget = arg0._tf:Find("scale/Image")

			arg0.mainTarget:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
				Destroy(arg0._tf)
			end)
		end

		return var0
	end,
	TargetRushEffect = function()
		local var0 = class("TargetRushEffect", var0.TargetSubEffect)

		function var0.InTimeLine(arg0)
			return true
		end

		function var0.InitUI(arg0, arg1)
			arg0.rtScale = arg0._tf:Find("scale")

			GetOrAddComponent(arg0.rtScale, typeof(CanvasGroup))

			arg0.alpha = 0

			setCanvasGroupAlpha(arg0.rtScale, arg0.alpha)
		end

		local var1 = 0.01

		function var0.OnTimerUpdate(arg0, arg1)
			if arg0.inRemove then
				arg0.alpha = arg0.alpha - arg1 / var1

				if arg0.alpha <= 0 then
					table.removebyvalue(arg0.controller.timeFlow, arg0)
					Destroy(arg0._tf)
				end
			elseif arg0.alpha < 1 then
				arg0.alpha = math.max(1, arg0.alpha + arg1 / var1)

				setCanvasGroupAlpha(arg0.rtScale, arg0.alpha)
			end
		end

		function var0.Remove(arg0)
			arg0.inRemove = true
		end

		return var0
	end
}

for iter0, iter1 in ipairs({
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
	var0[iter1] = var1[iter1]()
end

return var0
