local var0_0 = {}
local var1_0 = {
	function()
		local var0_1 = class("Object")

		var0_1.colliderSize = nil

		function var0_1.Ctor(arg0_2, arg1_2, arg2_2, arg3_2)
			arg0_2.rt = arg1_2
			arg0_2.pos = arg2_2

			setAnchoredPosition(arg0_2.rt, arg0_2.pos)

			arg0_2.controller = arg3_2
			arg0_2.isTriggered = false

			arg0_2:Show("base")
		end

		function var0_1.UpdatePos(arg0_3, arg1_3)
			arg0_3.pos = arg0_3.pos + arg1_3

			setAnchoredPosition(arg0_3.rt, arg0_3.pos)
		end

		function var0_1.Show(arg0_4, arg1_4)
			arg0_4.state = arg1_4

			setActive(arg0_4.rt, true)
		end

		function var0_1.Trigger(arg0_5, arg1_5)
			arg0_5.isTriggered = true

			arg0_5:TriggerEffect(arg1_5)
		end

		function var0_1.TriggerEffect(arg0_6, arg1_6)
			arg1_6:TriggerEffect(arg0_6)
		end

		function var0_1.Clear(arg0_7)
			table.removebyvalue(arg0_7.controller.queue, arg0_7)
			Destroy(arg0_7.rt)
		end

		return var0_1
	end,
	function()
		return (class("StartMark", var0_0.Object))
	end,
	function()
		local var0_9 = class("Mire", var0_0.Object)

		var0_9.colliderSize = {
			{
				-100,
				100
			},
			{
				-114,
				114
			}
		}

		function var0_9.Trigger(arg0_10, arg1_10)
			arg0_10.isTriggered = true

			if arg1_10.invincibleTime then
				-- block empty
			else
				arg0_10:TriggerEffect(arg1_10)
			end
		end

		return var0_9
	end,
	function()
		local var0_11 = class("SpeedBumps", var0_0.Object)

		var0_11.colliderSize = {
			{
				-100,
				100
			},
			{
				-114,
				114
			}
		}

		function var0_11.Trigger(arg0_12, arg1_12)
			arg0_12.isTriggered = true

			if arg1_12.invincibleTime then
				-- block empty
			else
				arg0_12:TriggerEffect(arg1_12)
			end
		end

		return var0_11
	end,
	function()
		local var0_13 = class("Obstacle", var0_0.Object)

		var0_13.actionDic = {}

		function var0_13.Ctor(arg0_14, arg1_14, arg2_14, arg3_14)
			arg0_14.rt = arg1_14
			arg0_14.pos = arg2_14

			setAnchoredPosition(arg0_14.rt, arg0_14.pos)

			arg0_14.controller = arg3_14
			arg0_14.isTriggered = false
			arg0_14.comSpineAnim = arg1_14:Find("GameObject"):GetComponent("SpineAnimUI")

			arg0_14.comSpineAnim:SetActionCallBack(function(arg0_15)
				if arg0_15 == "finish" then
					arg0_14:ActionCallback()
				end
			end)
			arg0_14:Show("base")
		end

		function var0_13.ActionCallback(arg0_16)
			switch(arg0_16.state, {
				base = function()
					return
				end,
				trigger = function()
					arg0_16:Clear()
				end,
				broken = function()
					arg0_16:Clear()
				end
			})
		end

		function var0_13.Show(arg0_20, ...)
			var0_13.super.Show(arg0_20, ...)

			arg0_20.action = arg0_20.actionDic[arg0_20.state]

			arg0_20.comSpineAnim:SetAction(arg0_20.action, 0)
		end

		function var0_13.Trigger(arg0_21, arg1_21)
			arg0_21.isTriggered = true

			if arg1_21.invincibleTime then
				arg0_21:Show("broken")
				pg.CriMgr.GetInstance():PlaySoundEffect_V3("ui-crash")
			else
				arg0_21:Show("trigger")
				arg0_21:TriggerEffect(arg1_21)
			end
		end

		return var0_13
	end,
	function()
		local var0_22 = class("TrafficCone", var0_0.Obstacle)

		var0_22.colliderSize = {
			{
				-100,
				100
			},
			{
				-114,
				114
			}
		}
		var0_22.actionDic = {
			trigger = "roadblocks_vanish1",
			broken = "roadblocks_smash1",
			base = "roadblocks_normal1"
		}

		return var0_22
	end,
	function()
		local var0_23 = class("Roadblock", var0_0.Obstacle)

		var0_23.colliderSize = {
			{
				-100,
				100
			},
			{
				-114,
				114
			}
		}
		var0_23.actionDic = {
			trigger = "roadblocks_vanish2",
			broken = "roadblocks_smash2",
			base = "roadblocks_normal2"
		}

		return var0_23
	end,
	function()
		local var0_24 = class("Bomb", var0_0.Obstacle)

		var0_24.colliderSize = {
			{
				-100,
				100
			},
			{
				-114,
				114
			}
		}
		var0_24.actionDic = {
			trigger = "bomb",
			broken = "bombsmash",
			base = "bomb_normal"
		}

		function var0_24.Trigger(arg0_25, arg1_25)
			arg0_25.isTriggered = true

			if arg1_25.invincibleTime then
				arg0_25:Show("broken")
			else
				arg0_25:Show("trigger")

				arg0_25.rt:Find("GameObject"):GetComponent("SkeletonGraphic").color = Color.New(1, 1, 1, 0)

				setActive(arg0_25.rt:Find("GameObject/saiche_zhadan"), true)
				arg0_25:TriggerEffect(arg1_25)
			end

			pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/baozha1")
		end

		return var0_24
	end,
	function()
		local var0_26 = class("Item", var0_0.Object)

		var0_26.colliderSize = {
			{
				-100,
				100
			},
			{
				-114,
				114
			}
		}

		function var0_26.Trigger(arg0_27, arg1_27)
			arg0_27.isTriggered = true

			arg0_27:TriggerEffect(arg1_27)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/mini_perfect")
			arg0_27:Clear()
		end

		return var0_26
	end,
	function()
		return (class("MoreTime", var0_0.Item))
	end,
	function()
		return (class("Invincibility", var0_0.Item))
	end,
	function()
		local var0_30 = class("Motorcycle", var0_0.Object)

		var0_30.colliderSize = {
			{
				-100,
				100
			},
			{
				-114,
				114
			}
		}

		function var0_30.Ctor(arg0_31, arg1_31, arg2_31, arg3_31)
			arg0_31.rt = arg1_31
			arg0_31.pos = arg2_31

			setAnchoredPosition(arg0_31.rt, arg0_31.pos)

			arg0_31.controller = arg3_31
			arg0_31.isTriggered = false
			arg0_31.comSpineAnim = arg1_31:Find("GameObject"):GetComponent(typeof(SpineAnimUI))

			arg0_31.comSpineAnim:SetActionCallBack(function(arg0_32)
				if arg0_32 == "finish" then
					arg0_31:ActionCallback()
				end
			end)

			arg0_31.effectList = {}

			for iter0_31, iter1_31 in ipairs({
				"saiche_sudu_01",
				"saiche_sudu_02",
				"saiche_sudu_03",
				"saiche_sudu_04"
			}) do
				table.insert(arg0_31.effectList, arg0_31.rt:Find("GameObject/" .. iter1_31))
			end

			arg0_31:Show("base")
		end

		function var0_30.UpdatePos(arg0_33, arg1_33, arg2_33)
			arg0_33.pos = arg0_33.pos + arg1_33
			arg0_33.pos.y = math.clamp(arg0_33.pos.y, -arg2_33, arg2_33)

			setAnchoredPosition(arg0_33.rt, arg0_33.pos)
		end

		function var0_30.ActionCallback(arg0_34)
			switch(arg0_34.action, {
				ride = function()
					return
				end,
				accel = function()
					arg0_34.action = "ride"

					arg0_34.comSpineAnim:SetAction(arg0_34.action, 0)
				end,
				fall = function()
					arg0_34.isBlock = false

					arg0_34:Show("base")
				end,
				yunxuan = function()
					arg0_34.isVertigo = false

					setActive(arg0_34.rt:Find("GameObject/saiche_xuanyun"), false)
					setActive(arg0_34.rt:Find("GameObject/saiche_jiansu"), false)
					arg0_34:Show("accel")
				end
			})
		end

		function var0_30.Show(arg0_39, ...)
			var0_30.super.Show(arg0_39, ...)
			switch(arg0_39.state, {
				base = function()
					arg0_39.action = "stop"
				end,
				accel = function()
					if not arg0_39.afterFirstAccel then
						arg0_39.afterFirstAccel = true
						arg0_39.action = "accel"
					else
						arg0_39.action = "ride"
					end
				end,
				fall = function()
					arg0_39.action = "fall"
					arg0_39.isBlock = true
				end,
				yunxuan = function()
					arg0_39.action = "yunxuan"
					arg0_39.isVertigo = true

					setActive(arg0_39.rt:Find("GameObject/saiche_xuanyun"), true)
					setActive(arg0_39.rt:Find("GameObject/saiche_jiansu"), true)
					pg.CriMgr.GetInstance():PlaySoundEffect_V3("ui-yunxuan")
				end
			})
			arg0_39.comSpineAnim:SetAction(arg0_39.action, 0)
		end

		function var0_30.TriggerEffect(arg0_44, arg1_44)
			switch(arg1_44.__cname, {
				MoreTime = function()
					arg0_44.controller:AddTime(RacingMiniGameConfig.ITEM_ADD_TIME)
				end,
				Invincibility = function()
					arg0_44.invincibleTime = RacingMiniGameConfig.INVINCIBLE_TIME

					setActive(arg0_44.rt:Find("invincibility"), true)
				end,
				TrafficCone = function()
					arg0_44.controller:SetEnginePower(0)
					arg0_44:Show("fall")
					pg.CriMgr.GetInstance():PlaySoundEffect_V3("ui-fall")
				end,
				Roadblock = function()
					arg0_44.controller:SetEnginePower(0)
					arg0_44:Show("fall")
					pg.CriMgr.GetInstance():PlaySoundEffect_V3("ui-fall")
				end,
				Bomb = function()
					arg0_44.controller:SetEnginePower(0)
					arg0_44:Show("fall")
				end,
				Mire = function()
					arg0_44.controller:SetEnginePower(math.min(arg0_44.controller.enginePower, RacingMiniGameConfig.OBSTACLE_POWER_BLOCK))
					arg0_44:Show("yunxuan")
				end,
				SpeedBumps = function()
					arg0_44.controller:SetEnginePower(math.min(arg0_44.controller.enginePower, RacingMiniGameConfig.OBSTACLE_POWER_BLOCK))
					arg0_44:Show("yunxuan")
				end
			})
		end

		function var0_30.UpdateInvincibility(arg0_52, arg1_52)
			assert(arg0_52.invincibleTime)

			arg0_52.invincibleTime = arg0_52.invincibleTime - arg1_52

			if arg0_52.invincibleTime <= 0 then
				setActive(arg0_52.rt:Find("invincibility"), false)

				arg0_52.invincibleTime = nil
			else
				local var0_52 = arg0_52.invincibleTime < 2

				setActive(arg0_52.rt:Find("invincibility/saiche_wudihudun_xiaoshi"), var0_52)
				setActive(arg0_52.rt:Find("invincibility/saiche_wudihudun"), not var0_52)
			end
		end

		return var0_30
	end
}

for iter0_0, iter1_0 in ipairs(var1_0) do
	local var2_0 = iter1_0()

	var0_0[var2_0.__cname] = var2_0
end

return var0_0
